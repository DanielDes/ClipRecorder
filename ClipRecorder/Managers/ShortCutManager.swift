//
//  ShortCuts.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 16/11/20.
//

import KeyboardShortcuts


extension KeyboardShortcuts.Name {
    static let testMode = Self("testMode",default: Shortcut(.t,modifiers: [.shift,.option]))
    static let default1 = Self("default1",default: Shortcut(.one ,modifiers:[.shift,.option]))
    static let default2 = Self("default2",default: Shortcut(.two,modifiers:[.shift,.option]))
    static let default3 = Self("default3",default: Shortcut(.three,modifiers:[.shift,.option]))
    static let default4 = Self("default4",default: Shortcut(.four,modifiers:[.shift,.option]))
           
}

class ShortCutManager {
    static let shared = ShortCutManager()
    private let shortcutValue : [Int: KeyboardShortcuts.Name] = [ 0: .default1,
                                                                    1: .default2,
                                                                   2: .default3,
                                                                   3: .default4]
    
    private init(){
        
    }
    
    func setUpShortcut(_ index: Int){
        guard let shortcut = shortcutValue[index] else {return}
        KeyboardShortcuts.onKeyDown(for: shortcut) {
            ClipManager.general.setValue(byIndex: index)
        }

    }
    
}
