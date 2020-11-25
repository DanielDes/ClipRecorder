//
//  QuickTableViewDelegate.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 24/11/20.
//

import AppKit

class QuickTableViewDelegate: NSObject {
    let data : [[Any]]

    init(tableView: NSTableView,data : [[Any]]){
        self.data = data
        super.init()
        tableView.delegate = self
        
    }
}

extension QuickTableViewDelegate : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return QuickViewController.cellHeight
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {return nil}
        let shortcut = data[0]
        let value = data[1]
        
        if tableColumn?.title == "Data"{
            vw.textField?.stringValue = value[row] as? String ?? ""
        } else {
            vw.textField?.stringValue = shortcut[row] as? String ?? ""
        }
        return vw
        
    }
}
