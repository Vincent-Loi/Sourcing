//
//  Copyright (C) 2016 Lukas Schmidt.
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
//
//  DataProviding.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 02.08.16.
//

import Foundation

/**
 `DataProviding` provides the data in a way which is related to `UITableViewDataSource` or `UICollectionViewDataSource`. It is generic over Object, which is the kind of data it provides.
 */
public protocol DataProviding: class {
    /**
     Object is the kind of data `DataProviding` provides.
     */
    associatedtype Object
    
    /**
     Returns the object for a given indexPath.
     
     - parameter indexPath: the indexPath
     */
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object
    
    /**
     Returns number of items for a given section.
     
     - return: number of items
     */
    func numberOfItemsInSection(section: Int) -> Int
    
    /**
     Returns number of sections
     
     - return: number of sections
     */
    func numberOfSections() -> Int
    
    /**
     Section Index Titles for `UITableView`. Related to `UITableViewDataSource` method `sectionIndexTitlesForTableView`
     */
    var sectionIndexTitles: Array<String>? { get }
}

extension DataProviding where Object: Equatable {
    
    /**
     Returns the indexPath for a given object.
     
     - parameter object: the object you want the indexPath for.
     - return: the indexPath of the object, if available.
     */
    public func indexPathForObject(object: Object) -> NSIndexPath? {
        for section in  0..<numberOfSections() {
            for item in 0..<numberOfItemsInSection(section) {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let o = objectAtIndexPath(indexPath)
                if o == object {
                    return indexPath
                }
            }
        }
        
        return nil
    }
}
