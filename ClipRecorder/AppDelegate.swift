//
//  AppDelegate.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.statusItem.button?.title = "CB Recorder!"
        self.statusItem.menu = ClipBoardMenu(title: "CB")
        self.statusItem.menu?.addItem(withTitle: "Test", action: #selector(test), keyEquivalent: "")
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func test(_ sender: NSMenuItem){
        print("Test")
    }


}

