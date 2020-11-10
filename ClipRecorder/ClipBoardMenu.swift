//
//  ClipBoardMenu.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa

class ClipBoardMenu: NSMenu {
    
    private let CBManager = ClipManager()
    private var firstOption : NSMenuItem!
    
    private var clipboardString : String {
        return self.CBManager.readCurrentElement() ?? ""
    }
    
    private var currentString = "" //Only to compare the displayed string
    private var lastSavedString = "" //Only to know if we stored a new value
    
    private var customizableCurrentIndex = 1
    
    private var savedItemsPerIndex : [String:Int] = [String:Int]()
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
        self.firstOption = NSMenuItem(title: "Save \"\(clipboardString.truncate(length:30))\"", action: #selector(saveCurrentValue), keyEquivalent: "1")

        self.firstOption.keyEquivalentModifierMask = NSEvent.ModifierFlags(arrayLiteral: [.option,.shift])
        self.firstOption.target = self
        self.addItem(firstOption)
        self.addItem(NSMenuItem.separator())
        
//        self.addItem(NSMenuItem.separator())
//        self.addItem(withTitle: "Personalize", action: nil, keyEquivalent: "")
        
        self.addItem(NSMenuItem.separator())
        let exitOptionItem = NSMenuItem(title: "Exit", action: #selector(exitApp(_:)), keyEquivalent: "")
        exitOptionItem.target = self
        self.addItem(exitOptionItem)
        
        self.currentString = clipboardString
        
    }
    fileprivate func refreshItems(){
        if self.currentString != clipboardString {
            self.currentString = clipboardString
            self.firstOption.title = "Save \"\(clipboardString.truncate(length: 30))\""
        }
        
        guard didSaveNewValue else {return}
        
        let index = savedItemsPerIndex[lastSavedString]!
        
        let item = NSMenuItem(title: lastSavedString, action: #selector(setCurrentValue(_:)), keyEquivalent: "")
        item.target = self
        self.insertItem(item, at: index)
        
        
        didSaveNewValue = false
    }
    @objc func displayPersonalizacion(_ sender: NSMenuItem){
        print("displaying personlization options")
    }
    
    @objc func saveCurrentValue(_ sender: NSMenuItem){
        
        self.CBManager.storeNewValue(string: clipboardString)
        if let _ = self.savedItemsPerIndex[clipboardString] {return}
        self.customizableCurrentIndex += 1
        self.savedItemsPerIndex.updateValue(customizableCurrentIndex, forKey: clipboardString)
        self.didSaveNewValue = true
        self.lastSavedString = clipboardString
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
