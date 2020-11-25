//
//  ShortCuts.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 16/11/20.
//

import KeyboardShortcuts


extension KeyboardShortcuts.Name {
    
    static let default1 = Self("default1",default: Shortcut(.one ,modifiers:ModifierCases.value(for: .set)))
    static let default2 = Self("default2",default: Shortcut(.two,modifiers:ModifierCases.value(for: .set)))
    static let default3 = Self("default3",default: Shortcut(.three,modifiers:ModifierCases.value(for: .set)))
    static let default4 = Self("default4",default: Shortcut(.four,modifiers:ModifierCases.value(for: .set)))
    
    static let unset1 = Self("unset1",default: Shortcut(.one,modifiers: ModifierCases.value(for: .unset)))
    static let unset2 = Self("unset2",default: Shortcut(.two,modifiers: ModifierCases.value(for: .unset)))
    static let unset3 = Self("unset3",default: Shortcut(.three,modifiers: ModifierCases.value(for: .unset)))
    static let unset4 = Self("unset4",default: Shortcut(.four,modifiers: ModifierCases.value(for: .unset)))
    
    static let quickView = Self("quicView",default: Shortcut(.zero,modifiers: ModifierCases.value(for: .set)))
           
}

private enum ModifierCases {
    
    case set
    case unset
}
extension ModifierCases {
    var value : NSEvent.ModifierFlags {
        switch self{
        case  .set:
            return NSEvent.ModifierFlags([.shift,.option])
        case .unset:
            return NSEvent.ModifierFlags([.command,.shift,.option])
        }
        
    }
    
    static func value(for val: ModifierCases) -> NSEvent.ModifierFlags{
        return val.value
    }
}

enum UserInfoKeys{
    case didSetData
    case index
    case displayQuickView
    case data
}

class ShortCutManager {
//    static let shared = ShortCutManager()
    private let shortcutValue : [KeyboardShortcuts.Name] = [.default1,
                                                            .default2,
                                                            .default3,
                                                            .default4]
    private let unsetShortcuts : [KeyboardShortcuts.Name] = [.unset1,
                                                             .unset2,
                                                             .unset3,
                                                             .unset4]
    private let stringKeys : [String]
    private let clipboardManager : ClipManager
    
    init(clipboardManager: ClipManager){
        self.clipboardManager = clipboardManager
        self.stringKeys = shortcutValue.map { (name) -> String in
            guard let shortcut = KeyboardShortcuts.getShortcut(for: name) else {return ""}
            return shortcut.description
            
        }
    }

    

    func setAllShortcuts(){
        for (index,shortcut) in shortcutValue.enumerated() {
            KeyboardShortcuts.onKeyDown(for: shortcut) {
                guard let newString = self.clipboardManager.checkCurrentPasteboardValueIn(index: index) else {return}
                
                
                let infoDict : [UserInfoKeys: Any] = [.didSetData: true,
                                                      .index: index,
                                                      .data: newString]
                NotificationCenter.default.post(name: .dataShortcutPressed, object: nil, userInfo: infoDict)
            }
        }
        
        for (index,shortcut) in unsetShortcuts.enumerated() {
            KeyboardShortcuts.onKeyDown(for: shortcut) {
                self.clipboardManager.unsetString(at: index)
                let infoDict : [UserInfoKeys: Any] = [.didSetData: false,
                                                      .index: index]
                NotificationCenter.default.post(name: .dataShortcutPressed,object: nil, userInfo: infoDict)
            }
        }
        
        KeyboardShortcuts.onKeyDown(for: KeyboardShortcuts.Name.quickView){
            let storedData = self.clipboardManager.getStoredStrings()
            //Carefull with that reference
            let stringShortCut = self.stringKeys
            let data = [[Any]](arrayLiteral: stringShortCut,storedData)
            
            
            
            let infoDict : [UserInfoKeys: Any] = [.displayQuickView: true,
                                                  .data: data]
            NotificationCenter.default.post(name: .quickViewShortcutStateChanged, object: nil, userInfo: infoDict)
        }
        
        KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name.quickView){
            let infoDict : [UserInfoKeys: Any] = [.displayQuickView: false]
            NotificationCenter.default.post(name: .quickViewShortcutStateChanged, object: nil, userInfo: infoDict)
        }
    }
    func getShortcuts() -> [KeyboardShortcuts.Name]{
        return self.shortcutValue
    }
    //TO be removed
    func getAllShortcutsKey() -> [String]{
        return self.shortcutValue.map { (name) -> String in
            return self.getShortcutKeybinding(name: name)!
            
        }
    }
    
    func getShortcutKeybinding(name: KeyboardShortcuts.Name) -> String?{
        guard let shortcut = KeyboardShortcuts.getShortcut(for: name) else {return nil}
        return shortcut.description
    }
    func getNumberShortcuts() -> Int {
        return self.shortcutValue.count
    }
}
