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
    
//    static let general = ClipManager()
    private var storedStrings : [String]
    
    init() {
        self.generalClipboard = NSPasteboard.general
        self.storedStrings = Array.init(repeating: "", count: 4)
        

    }
    deinit {
        
    }
    
    
    
    
    /// Sets the current value in Pasteboard in the provided index
    /// - Parameter index: Index of the current value of the pasteboard
    /// - Returns: Returns the current value if it did not existed ont the array, if the value is already in the array the value is written to the pasteboard
    func checkCurrentPasteboardValueIn(index: Int) -> String?{
        
        guard let current = self.readCurrentElement() else {return nil}
        
        //On this option the user typed the shortcut to set the string into the keyboard
        if self.storedStrings.contains(current){
            self.setCurrentValue(string:current)
            return nil
        } else { //The user is setting a new string
            self.storedStrings[index] = current
            return current
        }
    }
    
    
    func unsetString(at index: Int){
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
