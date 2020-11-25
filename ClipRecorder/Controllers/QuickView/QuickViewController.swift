//
//  ViewController.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa
import KeyboardShortcuts

class QuickViewController: NSViewController {
    
    @IBOutlet var tableView : NSTableView!

    var dataPerShortcut : [[Any]]?
    private var tableViewDelegate : QuickTableViewDelegate?
    private var tableViewDataSource : QuickTableViewDataSource?
    
    
    
    static let cellHeight : CGFloat = 17.0
    static let viewWIdth : CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataPerShortcut = self.dataPerShortcut{
            tableViewDelegate = QuickTableViewDelegate(tableView: self.tableView, data:dataPerShortcut)
            tableViewDataSource = QuickTableViewDataSource(tableView: self.tableView, data:dataPerShortcut)
        }
        // Do any additional setup after loading the view.
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 18
        
    }
}
