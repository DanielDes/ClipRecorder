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
    private var storedStrings : [String]
    
    private init() {
        self.generalClipboard = NSPasteboard.general
        self.storedStrings = Array.init(repeating: "", count: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleShortCutEvent(_:)), name: .userDidSetString, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unsetString(_:)), name: .userDidUnsetString, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func handleShortCutEvent(_ notification: NSNotification){
        guard let index = notification.userInfo?[UserInfoKeys.index] as? Int else {return}
        print("pressed index \(index)")
        guard let current = self.readCurrentElement() else {return}
        
        if self.storedStrings.contains(current) {
            self.setCurrentValue(string: self.storedStrings[index])
        } else {
            self.storedStrings[index] = current
        }
    }
    
    
    @objc func unsetString(_ notification: NSNotification){
        guard let index = notification.userInfo?[UserInfoKeys.index] as? Int else {return}
        print("unsetting index \(index)")
        self.storedStrings[index] = ""
    }
    func getStoredStrings() -> [String] {
        return self.storedStrings
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
    
    func setCurrentValue(string: String){
        self.generalClipboard.prepareForNewContents(with: .currentHostOnly)
        if self.generalClipboard.setString(string, forType: NSPasteboard.PasteboardType.string) {
            print("done")
        } else {
            print("error")
        }
    }

    
    func pushNewString(_ string:String, tail: Int = 4){
        self.storedStrings.push(newElement: string, maxTail: tail)
    }
}
