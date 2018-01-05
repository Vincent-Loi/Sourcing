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
//  ArrayDataProviding.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 29.08.16.
//

import Foundation

/**
 `ArrayDataProvider` provides interface for data provides which rely on Array as internal data structure.
 */
public protocol ArrayDataProviding: DataProviding {
    /// The content which is provided by the data provider
    var content: [[Element]] { get }
}

public extension ArrayDataProviding {
    /**
     Returns the object for a given indexPath.
     
     - parameter indexPath: the indexPath
     */
    public func object(at indexPath: IndexPath) -> Element {
        return content[indexPath.section][indexPath.item]
    }
    
    /**
     Returns number of items for a given section.
     
     - return: number of items
     */
    public func numberOfItems(inSection section: Int) -> Int {
        return content[section].count
    }
    
    /**
     Returns number of sections
     
     - return: number of sections
     */
    public func numberOfSections() -> Int {
        return content.count
    }
}