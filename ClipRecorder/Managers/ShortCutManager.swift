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

class ShortCutManager {
    static let shared = ShortCutManager()
    private let shortcutValue : [KeyboardShortcuts.Name] = [.default1,
                                                            .default2,
                                                            .default3,
                                                            .default4]
    private let unsetShortcuts : [KeyboardShortcuts.Name] = [.unset1,
                                                             .unset2,
                                                             .unset3,
                                                             .unset4]
    
    private init(){
        
    }

    
    func setUpShortcut(_ index: Int){
        let shortcut = shortcutValue[index]
        KeyboardShortcuts.onKeyDown(for: shortcut) {
            
            NotificationCenter.default.post(name: .userDidSetString, object: nil, userInfo: ["index" : index])
        }

    }
    
    func setAllShortcuts(){
        for (value,shortcut) in shortcutValue.enumerated() {
            KeyboardShortcuts.onKeyDown(for: shortcut) {
    
                NotificationCenter.default.post(name: .userDidSetString, object: nil, userInfo: ["index" : value])
            }
        }
        
        for (index,shortcut) in unsetShortcuts.enumerated() {
            KeyboardShortcuts.onKeyDown(for: shortcut) {
                NotificationCenter.default.post(name: .userDidUnsetString,object: nil, userInfo: ["index":index])
            }
        }
    }
    
    func getShortcuts() -> [KeyboardShortcuts.Name]{
        return shortcutValue
    }
    
}
