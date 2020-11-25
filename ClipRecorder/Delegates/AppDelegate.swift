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
    
    private var shortcutManager : ShortCutManager!
    private let clipManager : ClipManager = ClipManager()
    
    fileprivate var windowTopLeftCoordinate: CGPoint {
        guard let window = window, let barButton = statusItem.button else { return .zero }
        let rectInWindow = barButton.convert(barButton.bounds, to: nil)
        let screenRect = barButton.window?.convertToScreen(rectInWindow) ?? .zero
        
        let xCoordinate = NSScreen.main!.frame.maxX - window.frame.size.width - 10
        return CGPoint(x: xCoordinate, y: screenRect.origin.y)
        
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        shortcutManager = ShortCutManager(clipboardManager: clipManager)
        
        self.statusItem.button!.image = NSImage(named: NSImage.Name("clipy_filled"))
        shortcutManager.setAllShortcuts()
        self.statusItem.menu = ClipBoardMenu(title: "CB",
                                             cbManager: clipManager,
                                             shortCutManager: shortcutManager,
                                             preferenceDelegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(handleQuickViewEvent(_:)), name: .quickViewShortcutStateChanged, object: nil)
       

        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleQuickViewEvent(_ sender: NSNotification){
        guard let info = sender.userInfo,
              let displayState = info[UserInfoKeys.displayQuickView] as? Bool else {return}
        
        if displayState{
            guard let data = info[UserInfoKeys.data] as? [[Any]] else {
                return
            }
            self.dislpayQuickView(data: data)
        } else {
            self.dismissQuickView()
        }
    }
    

    @objc func dislpayQuickView(data: [[Any]]){

        self.previousRunningApp = NSWorkspace.shared.frontmostApplication
        let value =  NSRunningApplication.current.activate(options: [.activateIgnoringOtherApps,.activateAllWindows])
        print(value)
        if let _ = self.window {return}
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "QuickPopoverVC") as? QuickViewController else {return}
        vc.dataPerShortcut = data
        self.window = NSWindow(contentViewController: vc)
        self.window.setFrameTopLeftPoint(self.windowTopLeftCoordinate)
        let height = CGFloat(QuickViewController.cellHeight * (CGFloat(shortcutManager.getNumberShortcuts()) + 2.0))
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
    @objc func dismissQuickView(){
        

        guard let _ = self.window else {return}
        
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.2
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

extension AppDelegate : PreferencesLauncherDelegate {
    func launchPreferences() -> Bool {
        print("Launching preferences")
        return false
    }
}
