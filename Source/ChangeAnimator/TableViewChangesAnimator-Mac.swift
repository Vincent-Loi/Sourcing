//
//  TableViewChangesAnimator-Mac.swift
//  Sourcing
//
//  Created by Vincent Loi on 15/11/2018.
//  Copyright © 2018 Lukas Schmidt. All rights reserved.
//

import Foundation

#if os(OSX)
import AppKit

/**
 A listener that observes changes of a data provider. It creates animations to make changes visible in the view by using
 `NSTableView`s APIs to animate cells. You can configure your animations as needed for each change.
 */
public final class TableViewChangesAnimator {
    
    private let observable: DataProviderObservable
    private let cellReconfigurationAtIndexPath: ((IndexPath) -> Void)?
    
    private var dataProviderObserver: NSObjectProtocol!
    private let tableView: NSTableView
    private let configuration: Configuration
    
    public struct Configuration {
        let insert: NSTableView.AnimationOptions
        let update: NSTableView.AnimationOptions
        let move: NSTableView.AnimationOptions
        let delete: NSTableView.AnimationOptions
        let insertSection: NSTableView.AnimationOptions
        let updateSection: NSTableView.AnimationOptions
        let deleteSection: NSTableView.AnimationOptions
        
        public init(insert: NSTableView.AnimationOptions = .effectFade, update: NSTableView.AnimationOptions = .effectFade,
                    move: NSTableView.AnimationOptions = .effectFade, delete: NSTableView.AnimationOptions = .effectFade,
                    insertSection: NSTableView.AnimationOptions = .effectFade, updateSection: NSTableView.AnimationOptions = .effectFade,
                    deleteSection: NSTableView.AnimationOptions = .effectFade) {
            self.insert = insert
            self.update = update
            self.move = move
            self.delete = delete
            self.insertSection = insertSection
            self.deleteSection = deleteSection
            self.updateSection = updateSection
        }
    }
    
    /// Creates an instance and starts listening for changes to animate them into the table view.
    ///
    /// - Parameters:
    ///   - tableView: the table view which should be animated
    ///   - observable: observable for listing to changes of a data provider
    ///   - configuration: configure animations for table view change actions.
    public convenience init(tableView: NSTableView,
                            observable: DataProviderObservable,
                            configuration: Configuration = Configuration()) {
        self.init(tableView: tableView,
                  observable: observable,
                  configuration: configuration,
                  cellReconfigurationAtIndexPath: nil)
    }
    
    /// Creates an instance and starts listening for changes to animate them into the table view.
    ///
    /// - Parameters:
    ///   - tableView: the table view which should be animated
    ///   - dataProvider: data provider which should be observed for changes.
    ///   - configuration: configure animations for table view change actions.
    public convenience init<D: DataProvider>(tableView: NSTableView,
                                             dataProvider: D,
                                             configuration: Configuration = Configuration()) {
        self.init(tableView: tableView,
                  observable: dataProvider.observable,
                  configuration: configuration)
    }
    
    /// Creates an instance and starts listening for changes to animate them into the table view.
    /// Use this initializer if you want to reconfigure cells on update instead of reload the cell.
    ///
    /// - Parameters:
    ///   - tableView: the table view which should be animated
    ///   - dataProvider: data provider for listing to changes & reconfiguring cells
    ///   - cellConfiguration: reusable view onfiguration to reconfigure views on update.
    ///   - configuration: configure animations for table view change actions.
    public convenience init<DataProvide: DataProvider, ReusableViewConfig: ReusableViewConfiguring>(tableView: NSTableView,
                                                                                                    dataProvider: DataProvide,
                                                                                                    cellConfiguration: ReusableViewConfig,
                                                                                                    configuration: Configuration = Configuration())
        where DataProvide.Element == ReusableViewConfig.Object {
            self.init(tableView: tableView,
                      observable: dataProvider.observable,
                      configuration: configuration,
                      cellReconfigurationAtIndexPath: { indexPath in
                        guard let cell = tableView.rowView(atRow: indexPath.item, makeIfNecessary: false) as? ReusableViewConfig.View else {
                            return
                        }
                        let object = dataProvider.object(at: indexPath)
                        cellConfiguration.configure(cell, at: indexPath, with: object)
            })
    }
    
    private init(tableView: NSTableView,
                 observable: DataProviderObservable,
                 configuration: Configuration,
                 cellReconfigurationAtIndexPath: ((IndexPath) -> Void)?) {
        self.tableView = tableView
        self.observable = observable
        self.configuration = configuration
        self.cellReconfigurationAtIndexPath = cellReconfigurationAtIndexPath
        dataProviderObserver = observable.addObserver(observer: { [weak self] update in
            self?.dataProviderDidChange(with: update)
        })
    }
    
    deinit {
        observable.removeObserver(observer: dataProviderObserver)
    }
    
    private func dataProviderDidChange(with change: DataProviderChange) {
        switch change {
        case .viewUnrelatedChanges:
        return // Do noting. TableView was already animated by user interaction.
        case .unknown:
            tableView.reloadData()
        case .changes(let updates):
            process(updates: updates)
        }
    }
    
    private func process(update: DataProviderChange.Change) {
        switch update {
        case .insert(let indexPath):
            tableView.insertRows(at: IndexSet(integer: indexPath.item), withAnimation: configuration.insert)
        case .update(let indexPath):
            if let specificCellUpdate = cellReconfigurationAtIndexPath {
                specificCellUpdate(indexPath)
            } else {
                tableView.reloadData(forRowIndexes: IndexSet(integer: indexPath.item), columnIndexes: IndexSet(integer: indexPath.section))
            }
        case .move(let indexPath, let newIndexPath):
            tableView.moveRow(at: indexPath.item, to: newIndexPath.item)
        case .delete(let indexPath):
            tableView.removeRows(at: IndexSet(integer: indexPath.item), withAnimation: configuration.delete)
        case .insertSection(let sectionIndex):
            return
        case .updateSection(let sectionIndex):
            return
        case .deleteSection(let sectionIndex):
            return
        case .moveSection(let indexPath, let newIndexPath):
            return
        }
    }
    
    /// Execute updates on your TableView. TableView will do a matching animation for each update
    ///
    /// - Parameter updates: list of updates to execute
    private func process(updates: [DataProviderChange.Change]) {
        tableView.beginUpdates()
        updates.forEach(process)
        tableView.endUpdates()
    }
}
#endif
