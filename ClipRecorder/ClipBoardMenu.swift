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

    override init(title: String) {
        super.init(title: title)
        self.setInitialOptions()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setInitialOptions()
    }
    
    private func setInitialOptions(){
        
        
        self.firstOption = NSMenuItem(title: "Save \"\(clipboardString)\"", action: #selector(saveCurrentValue), keyEquivalent: "")
        self.firstOption.target = self
        self.addItem(firstOption)
        self.addItem(NSMenuItem.separator())
        self.addItem(withTitle: "Personalize", action: nil, keyEquivalent: "")
        self.addItem(NSMenuItem.separator())
        
    }
    @objc func displayPersonalizacion(_ sender: NSMenuItem){
        print("displaying personlization options")
    }
    
    @objc func saveCurrentValue(_ sender: NSMenuItem){
        self.CBManager.storeNewValue(string: clipboardString)
        self.addItem(withTitle: clipboardString, action: nil, keyEquivalent: "")
    }
}
