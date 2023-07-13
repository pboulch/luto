//
//  LutoApp.swift
//  Luto
//
//  Created by Pierre Boulc'h on 04/07/2023.
//

import SwiftUI

@main
struct LutoApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup(id: "MainWindow") {
            MainView(taskTitle: "", taskDescription: "", listTask: [])
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
        
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
                
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "brain", accessibilityDescription: "Chart Line")
            statusButton.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 500, height: 500)
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: MainView(taskTitle: "", taskDescription: "", listTask: [])
)
    }
    
    @objc func togglePopover() {
        
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
        
    }
    
}
