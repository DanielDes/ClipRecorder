//
//  QuickTableViewDataSource.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 24/11/20.
//

import AppKit

class QuickTableViewDataSource: NSObject {
    let data : [[Any]]
    
    init(tableView: NSTableView, data: [[Any]]) {
        self.data = data
        super.init()
        tableView.dataSource = self
    }
}

extension QuickTableViewDataSource: NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data[0].count
    }
    
}
