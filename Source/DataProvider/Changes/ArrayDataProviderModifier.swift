//
//  Copyright (C) DB Systel GmbH.
//
//  Permission is hereby granted, free of charge, to any person obtaining a 
//  copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation 
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the 
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//

import Foundation

/**
Wrapps an `ArrayDataProvider` and handles changes to manipulate the content of the provider.
 
- seealso: `DataModifying`
*/
public final class ArrayDataProviderModifier<Element>: DataModifying {
    /// Flag if items can be moved by the data source.
    public var canMoveItems: Bool = false
    
    /// Flag if items can be deleted by the data source.
    public var canDeleteItems: Bool = false
    
    private let dataProvider: ArrayDataProvider<Element>
    
    /// Creates an `ArrayDataProvider` instace.
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider which should be modiefiable
    ///   - canMoveItems: Flag if items can be moved by the data source.
    ///   - canDeleteItems: Flag if items can be deleted by the data source.
    public init(dataProvider: ArrayDataProvider<Element>, canMoveItems: Bool = false, canDeleteItems: Bool = false) {
        self.dataProvider = dataProvider
        self.canMoveItems = canMoveItems
        self.canDeleteItems = canDeleteItems
    }
    
    /// Checks whether item at an indexPath can be moved
    ///
    /// - Parameter indexPath: the indexPath to check for if it can be moved
    /// - Returns: if the item can be moved
    public func canMoveItem(at indexPath: IndexPath) -> Bool {
        return canMoveItems
    }
    
    /// Moves item from sourceIndexPath to destinationIndexPath
    ///
    /// - Parameters:
    ///   - sourceIndexPath: Source's IndexPath
    ///   - destinationIndexPath: Destination's IndexPath
    ///   - updateView: determins if the view should be updated.
    ///                 Pass `false` if someone else take care of updating the change into the view
    public func moveItemAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, updateView: Bool = true) {
        let soureElement = dataProvider.object(at: sourceIndexPath)
        var content = dataProvider.content
        content[sourceIndexPath.section].remove(at: sourceIndexPath.item)
        content[destinationIndexPath.section].insert(soureElement, at: destinationIndexPath.item)
        let update = DataProviderChange.Change.move(sourceIndexPath, destinationIndexPath)
        let changes: DataProviderChange = updateView ? .changes([update]) : .viewUnrelatedChanges([update])
        dataProvider.reconfigure(with: content, change: changes)
    }
    
    /// Checks wethere item at an indexPath can be deleted
    ///
    /// - Parameter indexPath: the indexPath to check for if it can be deleted
    /// - Returns: if the item can be deleted
    public func canDeleteItem(at indexPath: IndexPath) -> Bool {
        return canDeleteItems
    }
    
    /// Deleted item at a given indexPath
    ///
    /// - Parameters:
    ///   - indexPath: the indexPath you want to delete
    public func deleteItem(at indexPath: IndexPath) {
        var content = dataProvider.content
        content[indexPath.section].remove(at: indexPath.item)
        dataProvider.reconfigure(with: content, change: .changes([.delete(indexPath)]))
    }
}
