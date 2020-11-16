//
//  ClipBoardMenu.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa
import KeyboardShortcuts

class ClipBoardMenu: NSMenu {
    
    private let CBManager = ClipManager()
    private var firstOption : NSMenuItem!
    
    private var clipboardString : String {
        return self.CBManager.readCurrentElement() ?? ""
    }
    
    private var currentString = "" //Only to compare the displayed string
    private var lastSavedString = "" //Only to know if we stored a new value
    
    
    private var storedStrings : [String] = [String]()
    
    private var storedStringInitialIndex = 2
    
    
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
        self.firstOption = NSMenuItem(title: "Save \"\(clipboardString.truncate(length:30))\"", action: #selector(saveCurrentValue), keyEquivalent: "")

        self.firstOption.target = self
        self.firstOption.tag = 0
        self.addItem(firstOption)
        self.addItem(NSMenuItem.separator())
        
        self.addItem(NSMenuItem.separator())
        
        let preferencesItem = NSMenuItem(title: "Preferences", action: #selector(displayPreferences(_:)), keyEquivalent: "")
        preferencesItem.target = self
        preferencesItem.tag = 2
        self.addItem(preferencesItem)
        self.addItem(NSMenuItem.separator())
        
        let exitOptionItem = NSMenuItem(title: "Exit", action: #selector(exitApp(_:)), keyEquivalent: "")
        exitOptionItem.target = self
        exitOptionItem.tag = 3
        self.addItem(exitOptionItem)
        
        self.currentString = clipboardString
        
        let testShortcutItem = NSMenuItem()
        testShortcutItem.title = "test"
        testShortcutItem.action = #selector(testAction(_:))
        testShortcutItem.setShortcut(for: .testMode)
        testShortcutItem.target = self
        self.addItem(testShortcutItem)
        
        
    }
    
    @objc func testAction(_ sender: NSMenuItem){
        print("test shortcut")
    }
    fileprivate func refreshItems(){
        if self.currentString != clipboardString {
            self.currentString = clipboardString
            self.firstOption.title = "Save \"\(clipboardString.truncate(length: 30))\""
        }
        
        guard didSaveNewValue else {return}
        
        for (index,storedString) in storedStrings.enumerated() {
            guard let item = self.item(at: index + storedStringInitialIndex) else {return}
            
            if item.tag == 1{ //The string menu option has already been created
                item.title = storedString.truncate(length: 30)
            } else {
                let newItem = NSMenuItem(title:storedString.truncate(length: 30), action:#selector(setCurrentValue(_:)), keyEquivalent: "\(index + 1)")
                newItem.keyEquivalentModifierMask = NSEvent.ModifierFlags(arrayLiteral: [.option,.shift])
                newItem.target = self
                newItem.tag = 1
                self.insertItem(newItem, at: index + storedStringInitialIndex)
            }
            
        }
        
        didSaveNewValue = false
    }
    @objc func displayPreferences(_ sender: NSMenuItem){
        print("displaying personlization options")
    }
    
    @objc func saveCurrentValue(_ sender: NSMenuItem){
    
        if self.storedStrings.contains(clipboardString) {return}
        self.didSaveNewValue = true
        self.lastSavedString = clipboardString
        self.storedStrings.push(newElement: clipboardString, maxTail: 4)
        print(self.storedStrings)
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
