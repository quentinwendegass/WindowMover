//
//  MarkingOverlay.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 30.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Cocoa

class MarkingOverlay: NSWindowController {

    override var windowNibName : NSNib.Name? {
        return NSNib.Name(rawValue: "MarkingOverlay")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
                
        self.window?.center()
        self.window?.ignoresMouseEvents = true
        self.window?.level = .floating
        self.window?.isOpaque = false
        self.window?.hasShadow = false
        self.window?.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
}
