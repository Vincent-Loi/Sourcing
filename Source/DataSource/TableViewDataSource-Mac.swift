//
//  Copyright (C) 2018 Vincent Loi.
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

#if os(OSX)
import AppKit

/// `TableViewDataSource` uses data provider and provides the data as a `NSTableViewDataSource`.
///
/// - SeeAlso: `NSTableViewDataSource`
public final class TableViewDataSource<Object>: NSObject, NSTableViewDataSource {
    /// The data provider which provides the data to the data source.
    public let dataProvider: AnyDataProvider<Object>
    
    /// Data modificator can be used to modify the data providers content.
    public let dataModificator: DataModifying?
    
    private let cellConfiguration: AnyReusableViewConfiguring<NSTableCellView, Object>
    
    /// Creates an instance with a data provider and cell configuration
    /// which will be displayed in the table view.
    ///
    /// - SeeAlso: `DataProvider`
    /// - SeeAlso: `ReusableViewConfiguring`
    ///
    /// - Parameters:
    ///   - dataProvider: the data provider which provides data to the data source.
    ///   - cellConfiguration: the cell configuration for the table view cell.
    ///   - dataModificator: data modifier to modify the data. Defaults to `nil`.
    ///   - sectionTitleProvider: provides section header titles and section index titles. Defaults to `nil`.
    public init<Cell: ReusableViewConfiguring, DataProviderType: DataProvider>(dataProvider: DataProviderType,
                                                                               cellConfiguration: Cell,
                                                                               dataModificator: DataModifying? = nil,
                                                                               sectionMetaData: SectionMetaData? = nil)
        where DataProviderType.Element == Object, Cell.Object == Object, Cell.View: NSTableCellView {
            self.dataProvider = AnyDataProvider(dataProvider)
            self.dataModificator = dataModificator
            self.cellConfiguration = AnyReusableViewConfiguring(cellConfiguration)
            super.init()
    }
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return dataProvider.numberOfItems(inSection: 0)
    }
    
}

#endif
