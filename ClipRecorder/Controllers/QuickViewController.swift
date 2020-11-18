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
    private lazy var shortcutsRegistered : [String] = {
        return ShortCutManager.shared.getAllShortcutsKey()
    }()
    private lazy var stringRegistered : [String] = {
        return ClipManager.general.getStoredStrings()
    }()
    static let cellHeight : CGFloat = 17.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }


    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


extension QuickViewController : NSTableViewDelegate,NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        print(self.shortcutsRegistered.count)
        return self.shortcutsRegistered.count
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return QuickViewController.cellHeight
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        print(3)
        guard let vw = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else {return nil}
        print(2)
        if tableColumn?.title == "Data"{
            vw.textField?.stringValue = self.stringRegistered[row]
        } else {
            vw.textField?.stringValue = self.shortcutsRegistered[row]
        }
        return vw
        
    }
}
