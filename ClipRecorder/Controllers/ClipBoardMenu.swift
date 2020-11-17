//
//  ClipBoardMenu.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa
import KeyboardShortcuts

class ClipBoardMenu: NSMenu {
    
    let CBManager = ClipManager.general
    let shortCutManager = ShortCutManager.shared
    
    private var firstOption : NSMenuItem!
    
    private var clipboardString : String {
        return self.CBManager.readCurrentElement() ?? ""
    }
    
    
    
    private var storedStrings : [String] = [String]()
    
    
    private var didSaveNewValue : Bool = false

    override init(title: String) {
        super.init(title: title)
        self.setInitialOptions()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setInitialOptions()
    }
    

    
    private func setInitialOptions(){
        self.delegate = MenuDelegate.delegate
        
        
       // Here logic to add hardcoded shortcuts
        
        self.createShortCutMenuItems(self.shortCutManager.getShortcuts())
        
        self.addItem(NSMenuItem.separator())
        
        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(displayPreferences(_:)), keyEquivalent: "")
        preferencesItem.target = self
        preferencesItem.tag = 2
        self.addItem(preferencesItem)
        
        let exitOptionItem = NSMenuItem(title: "Exit", action: #selector(exitApp(_:)), keyEquivalent: "")
        exitOptionItem.target = self
        exitOptionItem.tag = 3
        self.addItem(exitOptionItem)
                
        
    }
    
    fileprivate func createShortCutMenuItems(_ shortcuts:[KeyboardShortcuts.Name]){
        for shortcut in shortcuts{
            let menuItem = NSMenuItem(title: "No String", action: #selector(setCurrentValue(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.tag = 1
            menuItem.setShortcut(for: shortcut)
            self.addItem(menuItem)
        }
    }
    

    fileprivate func refreshItems(){

        let storedStrings = self.CBManager.getStoredStrings()
        
        for (index,cbString) in storedStrings.enumerated() {
            guard let item = self.item(at: index) else {return}
            
            item.title = cbString.truncate(length: 20)
        }
        
        
    }
    @objc func displayPreferences(_ sender: NSMenuItem){
        print("displaying personlization options")
    }
    

    @objc func setCurrentValue(_ sender: NSMenuItem){
        let title = sender.title
        print("Setting title \(title)")
        CBManager.setCurrentValue(string: title)
        
    }
    @objc func exitApp(_ sender: NSMenuItem){
        NSApplication.shared.terminate(self)
    }
}

class MenuDelegate :NSObject, NSMenuDelegate{
    static fileprivate let delegate = MenuDelegate()
    
    fileprivate override init() {
        
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        print("Refreshing")
        guard let menu = menu as? ClipBoardMenu else {return}
        menu.refreshItems()
    }
}
