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
    
    //This only if i take the ns window aproach
    private var window : NSWindow!
    private var previousRunningApp : NSRunningApplication!
    
    fileprivate var windowTopLeftCoordinate: CGPoint {
        guard let window = window, let barButton = statusItem.button else { return .zero }
        let rectInWindow = barButton.convert(barButton.bounds, to: nil)
        let screenRect = barButton.window?.convertToScreen(rectInWindow) ?? .zero
        
        let xCoordinate = NSScreen.main!.frame.maxX - window.frame.size.width - 10
        return CGPoint(x: xCoordinate, y: screenRect.origin.y)
        
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        
        self.statusItem.button!.image = NSImage(named: NSImage.Name("clipy_filled"))
        self.statusItem.menu = ClipBoardMenu(title: "CB")
        ShortCutManager.shared.setAllShortcuts()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dislpayQuickView(_:)), name: .willShowQuickView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissQuickView(_:)), name: .willDismissQuicView, object: nil)

        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NotificationCenter.default.removeObserver(self)
    }
    

    @objc func dislpayQuickView(_ sender: NSMenuItem){

        self.previousRunningApp = NSWorkspace.shared.frontmostApplication
        let value =  NSRunningApplication.current.activate(options: [.activateIgnoringOtherApps,.activateAllWindows])
        print(value)
        if let _ = self.window {return}
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "QuickPopoverVC") as? QuickViewController else {return}
        self.window = NSWindow(contentViewController: vc)
        self.window.setFrameTopLeftPoint(self.windowTopLeftCoordinate)
        let height = CGFloat(QuickViewController.cellHeight * (CGFloat(ShortCutManager.shared.getNumberShortcuts()) + 2.0))
        self.window.setContentSize(NSSize(width: self.window.frame.width,
                                          height: height))
        self.window.styleMask = [.fullSizeContentView]
        self.window.makeKeyAndOrderFront(nil)
        self.window.alphaValue = 0
        self.window.backgroundColor = .clear


        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.3
            window.animator().alphaValue = 1
        }
        
        
        
    }
    @objc func dismissQuickView(_ sender: NSMenuItem){
        

        guard let _ = self.window else {return}
        
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.1
            window.animator().alphaValue = 0
        } completionHandler: {
            self.window.close()
            self.window = nil
            if let previousApp = self.previousRunningApp {
                previousApp.activate(options: [.activateIgnoringOtherApps,.activateAllWindows])
                self.previousRunningApp = nil
            }
        }

        
        
    }

    

}


