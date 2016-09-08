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
//  TableViewRepresenting.swift
//  Sourcing
//
//  Created by Lukas Schmidt on 09.08.16.
//

import Foundation

/**
 Protocol abstraction for UITableView
 */
public protocol TableViewRepresenting: class {
    var dataSource: UITableViewDataSource? { get set }
    var indexPathForSelectedRow: IndexPath? { get }
    
    func reloadData()
    
    func registerNib(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    
    func dequeueReusableCellWithIdentifier(_ identifier: String, forIndexPath indexPath: IndexPath) -> UITableViewCell
    
    func beginUpdates()
    func endUpdates()
    
    func insertRowsAtIndexPaths(_ indexPaths: Array<IndexPath>, withRowAnimation: UITableViewRowAnimation)
    func deleteRowsAtIndexPaths(_ indexPaths: Array<IndexPath>, withRowAnimation: UITableViewRowAnimation)
    
    func deleteSections(_ sections: IndexSet, withRowAnimation: UITableViewRowAnimation)
    func insertSections(_ sections: IndexSet, withRowAnimation: UITableViewRowAnimation)
    
    
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell?
    
}

extension UITableView: TableViewRepresenting { }
