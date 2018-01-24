//
//  StatusMenuController.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 23.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Cocoa
import HotKey
import Foundation

class StatusMenuController: NSObject, NSTextFieldDelegate{
    @IBOutlet weak var statusMenu: NSMenu!

    var preferencesWindow: Preferences!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        preferencesWindow = Preferences()
        
        let leftHalf = WindowSetting(width: (Int)(NSScreen.main!.frame.width / 2), height: (Int)(NSScreen.main!.frame.height), x: 0, y: 0)
        leftHalf.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.command, .option, .shift])))
        
        let leftQuarter = WindowSetting(width: (Int)(NSScreen.main!.frame.width / 4), height: (Int)(NSScreen.main!.frame.height), x: 0, y: 0)
        leftQuarter.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.option, .shift])))

        let leftGibbous = WindowSetting(width: (Int)(NSScreen.main!.frame.width * 3/4), height: (Int)(NSScreen.main!.frame.height), x: 0, y: 0)
        leftGibbous.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.control, .shift])))
        
        let rightHalf = WindowSetting(width: (Int)(NSScreen.main!.frame.width / 2), height: (Int)(NSScreen.main!.frame.height), x: (Int)(NSScreen.main!.frame.width / 2), y: 0)
        rightHalf.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.command, .option, .shift])))
        
        let rightQuarter = WindowSetting(width: (Int)(NSScreen.main!.frame.width / 4), height: (Int)(NSScreen.main!.frame.height), x: (Int)(NSScreen.main!.frame.width * 3/4), y: 0)
        rightQuarter.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.option, .shift])))
        
        let rightGibbous = WindowSetting(width: (Int)(NSScreen.main!.frame.width * 3/4), height: (Int)(NSScreen.main!.frame.height), x: (Int)(NSScreen.main!.frame.width / 4), y: 0)
        rightGibbous.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.control, .shift])))
        
        let full = WindowSetting(width: (Int)(NSScreen.main!.frame.width), height: (Int)(NSScreen.main!.frame.height), x: 0, y: 0)
        full.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .f, modifiers: [.command, .option, .shift])))
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
