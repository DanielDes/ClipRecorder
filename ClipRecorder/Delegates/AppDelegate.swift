//
//  AppDelegate.swift
//  ClipRecorder
//
//  Created by L Daniel De San Pedro on 09/11/20.
//

import Cocoa
import KeyboardShortcuts


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var quickViewPopover : NSPopover!
    
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.statusItem.button?.title = "CB Recorder!"
        self.statusItem.menu = ClipBoardMenu(title: "CB")
        ShortCutManager.shared.setAllShortcuts()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dislpayQuickView(_:)), name: .willShowQuickView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissQuickView(_:)), name: .willDismissQuicView, object: nil)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func test(_ sender: NSMenuItem){
        print("Test")
    }
    @objc func dislpayQuickView(_ sender: NSMenuItem){
        if let _ = self.quickViewPopover {return}
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "QuickPopoverVC") as? QuickViewController else {return}
        
        let height = CGFloat(QuickViewController.cellHeight * (CGFloat(ShortCutManager.shared.getNumberShortcuts()) + 2.0))
        vc.preferredContentSize = NSSize(width: 300,
                                         height: height)
        self.quickViewPopover = NSPopover()
        self.quickViewPopover.behavior = .transient
        self.quickViewPopover.contentViewController = vc
        quickViewPopover.show(relativeTo: self.statusItem.button!.bounds,
                              of: self.statusItem.button!, preferredEdge: .minY)
        
        
    }
    @objc func dismissQuickView(_ sender: NSMenuItem){
        print("Closing")
        guard let quickView = self.quickViewPopover else {return}
        
        print("Done")
        self.quickViewPopover.performClose(nil)
        self.quickViewPopover = nil
        
        
    }
    

}


