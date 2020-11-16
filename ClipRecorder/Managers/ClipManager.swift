//
//  ClipManager.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Foundation
import AppKit


/// Reads and writes new value to the system general pasteboard.
class ClipManager {
    private var generalClipboard : NSPasteboard
    
    static let general = ClipManager()
    
    private init() {
        self.generalClipboard = NSPasteboard.general
    }
    
    private var storedStrings : [String] = [String]()
    
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
    
    func setCurrentValue(string: String){
        self.generalClipboard.prepareForNewContents(with: .currentHostOnly)
        if self.generalClipboard.setString(string, forType: NSPasteboard.PasteboardType.string) {
            print("done")
        } else {
            print("error")
        }
    }
    func setValue(byIndex index:Int){
        self.generalClipboard.prepareForNewContents(with: .currentHostOnly)
        let string = self.storedStrings[index]
        if self.generalClipboard.setString(string, forType: NSPasteboard.PasteboardType.string) {
            print("done")
            print("set \(string)")
        } else {
            print("error")
        }
        
    }
    
    func pushNewString(_ string:String){
        self.storedStrings.push(newElement: string, maxTail: 4)
    }
}
