//
//  ClipBoardMenu.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa
import KeyboardShortcuts

class ClipBoardMenu: NSMenu {
    
    private var CBManager : ClipManager!
    private var shortCutManager : ShortCutManager!
    
    private var firstOption : NSMenuItem!
    
    private var clipboardString : String {
        return self.CBManager.readCurrentElement() ?? ""
    }
    
    
    
    private var storedStrings : [String] = [String]()
    
    
    private var didSaveNewValue : Bool = false
    
    init (title: String, cbManager: ClipManager, shortCutManager: ShortCutManager){
        super.init(title: title)
        self.CBManager = cbManager
        self.shortCutManager = shortCutManager
        self.setInitialOptions()
        self.regisrteObserver()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setInitialOptions()
        self.regisrteObserver()
    }
    
    
    deinit {
        self.unregisterObserver()
    }

    
    private func setInitialOptions(){
        
        
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
    
    private func regisrteObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateMenuItemStatus(_:)), name: .dataShortcutPressed, object: nil)
        
    }
    private func unregisterObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
    fileprivate func createShortCutMenuItems(_ shortcuts:[KeyboardShortcuts.Name]){
        for shortcut in shortcuts{
            let menuItem = NSMenuItem(title: "", action: #selector(setCurrentValue(_:)), keyEquivalent: "")
            menuItem.target = self
            menuItem.tag = 1
            menuItem.setShortcut(for: shortcut)
            menuItem.isEnabled = false
            self.addItem(menuItem)
        }
    }
    


    
    @objc func updateMenuItemStatus(_ notification: NSNotification){
        guard let index = notification.userInfo?[UserInfoKeys.index] as? Int,
              let didSetData = notification.userInfo?[UserInfoKeys.didSetData] as? Bool
        else {return}
        
        if didSetData{
            guard let newString = notification.userInfo?[UserInfoKeys.data] as? String,
                  let item = self.item(at:index) else {return}
            item.title = newString.truncate(length: 20)
            
        } else {
            guard let item = self.item(at: index) else {return}
            item.title = ""
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



