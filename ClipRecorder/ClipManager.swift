//
//  ClipManager.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Foundation
import AppKit


class ClipManager {
    private var generalClipboard : NSPasteboard
    private var storedStrings : [String] = [String]()
    
    init() {
        self.generalClipboard = NSPasteboard.general
        
    }
    
    func readCurrentElement() -> String?{
        
        guard let items = generalClipboard.pasteboardItems else {
            print("Could not read elements")
            return nil}
        guard let current = items[0].string(forType: NSPasteboard.PasteboardType.string) else {
             print("Not string value!")
            return nil
        }
        return current
    }
    
    func storeNewValue(string: String){
        self.storedStrings.append(string)
    }
    
    func setCurrentValue(string: String){
        self.generalClipboard.prepareForNewContents(with: .currentHostOnly)
        if self.generalClipboard.setString(string, forType: NSPasteboard.PasteboardType.string) {
            print("done")
        } else {
            print("error")
        }
        
    }
    
    
    
}
