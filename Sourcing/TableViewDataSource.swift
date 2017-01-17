//
//  ExperimentalTableCollectionViewDataSource.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 23.12.16.
//  Copyright © 2016 Lukas Schmidt. All rights reserved.
//

import Foundation

/// Generic DataSoruce providing data to a tableview.
final public class TableViewDataSource<Object>: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    public let dataProvider: AnyDataProvider<Object>
    public var tableView: TableViewRepresenting {
        didSet {
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    private let cells: Array<CellDequeable>
    private let canMoveItemAtIndexPath: (IndexPath) -> Bool
    
    public init<TypedDataProvider: DataProviding>(tableView: TableViewRepresenting, dataProvider: TypedDataProvider,
                anyCells: Array<CellDequeable>, canMoveItemAtIndexPath: @escaping (IndexPath) -> Bool = { _ in return false }) where TypedDataProvider.Object == Object {
        self.tableView = tableView
        self.dataProvider = AnyDataProvider(dataProvider: dataProvider)
        self.cells = anyCells
        self.canMoveItemAtIndexPath = canMoveItemAtIndexPath
        super.init()
        register(cells: cells)
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.prefetchDataSource = self
        }
        tableView.reloadData()
    }
    
    func update(_ cell: UITableViewCell, with object: Object) {
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Could not update Cell")
        }
        cellDequeable.configure(cell, with: object)
    }
    
    private func register(cells: Array<CellDequeable>) {
        for cell in cells where cell.nib != nil {
            tableView.registerNib(cell.nib, forCellReuseIdentifier: cell.cellIdentifier)
        }
    }
    
    private func cellDequeableForIndexPath(_ object: Object) -> CellDequeable? {
        for cell in cells where cell.canConfigureCell(with: object) {
            return cell
        }
        
        return nil
    }
    
    public func process(updates: [DataProviderUpdate<Object>]?) {
        guard let updates = updates else {
            return tableView.reloadData()
        }
        tableView.beginUpdates()
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
            case .update(let indexPath, let object):
                guard let cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
                    fatalError("Could not update Cell")
                }
                self.update(cell, with: object)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .fade)
            case .delete(let indexPath):
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .fade)
            case .insertSection(let sectionIndex):
                tableView.insertSections(IndexSet(integer: sectionIndex), withRowAnimation: .fade)
            case .deleteSection(let sectionIndex):
                tableView.deleteSections(IndexSet(integer: sectionIndex), withRowAnimation: .fade)
            }
        }
        tableView.endUpdates()
    }
    
    public var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        return dataProvider.object(at: indexPath)
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItems(inSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        guard let cellDequeable = cellDequeableForIndexPath(object) else {
            fatalError("Unexpected cell type at \(indexPath) for object of type")
        }
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellDequeable.cellIdentifier, forIndexPath: indexPath)
        cellDequeable.configure(cell, with: object)
        
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataProvider.sectionIndexTitles
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveItemAtIndexPath(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataProvider.moveItemAt(sourceIndexPath: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        dataProvider.prefetchItems(at: indexPaths)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        dataProvider.cancelPrefetchingForItems(at: indexPaths)
    }

}

// MARK: Typesafe initializers

public extension TableViewDataSource {
    convenience init<CellConfig: StaticCellDequeable, TypedDataProvider: DataProviding>(tableView: TableViewRepresenting,
                     dataProvider: TypedDataProvider, cell: CellConfig)
        where TypedDataProvider.Object == Object, CellConfig.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider: dataProvider)
            self.init(tableView: tableView, dataProvider: typeErasedDataProvider, anyCells: [cell])
    }
    
    convenience init<CellConfig: StaticCellDequeable, TypedDataProvider: DataProviding>(tableView: TableViewRepresenting,
                     dataProvider: TypedDataProvider, cells: Array<CellConfig>)
        where TypedDataProvider.Object == Object, CellConfig.Cell: UITableViewCell {
            let typeErasedDataProvider = AnyDataProvider(dataProvider: dataProvider)
            self.init(tableView: tableView, dataProvider: typeErasedDataProvider, anyCells: cells)
    }
}
