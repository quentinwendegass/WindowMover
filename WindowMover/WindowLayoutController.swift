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
import ApplicationServices

class WindowLayoutController: NSObject, NSTextFieldDelegate{
    @IBOutlet weak var statusMenu: NSMenu!
    
    var preferencesWindow: Preferences!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        preferencesWindow = Preferences()
        
        
        let leftHalf = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height, orientation: .topLeft)
        leftHalf.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.command, .option, .shift])))
        
        let leftQuarter = WindowSetting(width: NSScreen.main!.visibleFrame.width / 4, height: NSScreen.main!.visibleFrame.height, orientation: .bottomLeft)
        leftQuarter.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.option, .shift])))

        let leftGibbous = WindowSetting(width: NSScreen.main!.visibleFrame.width * 3/4, height: NSScreen.main!.visibleFrame.height, orientation: .bottomLeft)
        leftGibbous.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.control, .shift])))
        
        let rightHalf = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height, orientation: .topRight)
        rightHalf.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.command, .option, .shift])))
        
        let rightQuarter = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height, orientation: .bottomRight)
        rightQuarter.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.option, .shift])))
        
        let rightGibbous = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height, orientation: .bottomRight)
        rightGibbous.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.control, .shift])))
        
        let full = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height, orientation: .bottomRight)
        full.setHotKey(hotkey: HotKey(keyCombo: KeyCombo(key: .f, modifiers: [.command, .option, .shift])))
 
        let dragManager = DragManager()
        dragManager.leftSetting = leftHalf
        dragManager.rightSetting = rightHalf

    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
}
