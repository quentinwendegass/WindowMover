//
//  Preferences.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 23.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Cocoa
import Carbon
import HotKey

class Preferences: NSWindowController {
    
    override var windowNibName : NSNib.Name? {
        return NSNib.Name(rawValue: "Preferences")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override func keyDown(with event: NSEvent) {
        
        let key = HotKey(carbonKeyCode: UInt32(event.keyCode), carbonModifiers: event.modifierFlags.carbonFlags)

        print(event.charactersIgnoringModifiers)
        print(event.keyCode)

    }
    
}
