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
import Carbon

class WindowLayoutController: NSObject, NSTextFieldDelegate{
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    var preferencesWindow: Preferences!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var leftHalf, rightHalf, leftGibbous, rightGibbous, leftQuarter, rightQuarter, full: WindowSetting?
    
    var windowForeward: HotKey? {
        didSet {
            guard let hotkey = windowForeward else {
                return
            }
            hotkey.keyDownHandler = {
                AccessibilityAccessor.shared.changeFrontWindowForeward()
            }
        }
    }
    
    var windowBackward: HotKey? {
        didSet {
            guard let hotkey = windowBackward else {
                return
            }
            hotkey.keyDownHandler = {
                AccessibilityAccessor.shared.changeFrontWindowBackward()
            }
        }
    }
    
    override func awakeFromNib() {
        
        UserDefaults.standard.removeObject(forKey: "firstStart")

        if UserDefaults.standard.string(forKey: "firstStart") == nil {
            firstStart()
        }


        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
    
        preferencesWindow = Preferences()
        
        windowForeward = HotKey(keyCombo: KeyCombo(carbonKeyCode: 10, carbonModifiers: 256))
        windowBackward = HotKey(keyCombo: KeyCombo(carbonKeyCode: 10, carbonModifiers: 768))
        
    
        
        full = WindowSetting(width: NSScreen.main!.visibleFrame.width, height: NSScreen.main!.visibleFrame.height - 1, orientation: .bottomRight, name: "full")
        
        leftHalf = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height - 1, orientation: .topLeft, name: "leftHalf")
        
        rightHalf = WindowSetting(width: NSScreen.main!.visibleFrame.width / 2, height: NSScreen.main!.visibleFrame.height - 1, orientation: .topRight, name: "rightHalf")

        leftQuarter = WindowSetting(width: NSScreen.main!.visibleFrame.width / 4, height: NSScreen.main!.visibleFrame.height - 1, orientation: .bottomLeft, name: "leftQuarter")

        rightQuarter = WindowSetting(width: NSScreen.main!.visibleFrame.width / 4, height: NSScreen.main!.visibleFrame.height - 1, orientation: .bottomRight, name: "rightQuarter")

        leftGibbous = WindowSetting(width: NSScreen.main!.visibleFrame.width * 3/4, height: NSScreen.main!.visibleFrame.height - 1, orientation: .bottomLeft, name: "leftGibbous")
    
        rightGibbous = WindowSetting(width: NSScreen.main!.visibleFrame.width * 3/4, height: NSScreen.main!.visibleFrame.height - 1, orientation: .bottomRight, name: "rightGibbous")
        
        
        //statusItem.menu?.items[2].keyEquivalent = (full?.carbonKeyCode)!
        
       // let str = String(describing: 3.deusing: String.Decod.utf8))

        
        setStatusMenuKeyEquivalent(index: 2, setting: full!)
        setStatusMenuKeyEquivalent(index: 3, setting: leftHalf!)
        setStatusMenuKeyEquivalent(index: 4, setting: rightHalf!)
        setStatusMenuKeyEquivalent(index: 5, setting: leftQuarter!)
        setStatusMenuKeyEquivalent(index: 6, setting: rightQuarter!)
        setStatusMenuKeyEquivalent(index: 7, setting: leftGibbous!)
        setStatusMenuKeyEquivalent(index: 8, setting: rightGibbous!)

        
        let dragManager = DragManager()
        dragManager.leftSetting = leftHalf
        dragManager.rightSetting = rightHalf
        dragManager.topLeftSetting = leftGibbous
        dragManager.bottomLeftSetting = leftQuarter
        dragManager.topRightSetting = rightGibbous
        dragManager.bottomRightSetting = rightQuarter
        dragManager.bottomSetting = full
        dragManager.topSetting = full
        
    }
    
    func setStatusMenuKeyEquivalent(index: Int, setting: WindowSetting) {
        statusItem.menu?.items[index].keyEquivalent = setting.carbonKeyChar!
        statusItem.menu?.items[index].keyEquivalentModifierMask = NSEvent.ModifierFlags(carbonFlags: setting.carbonModifierCode!)
    }
    
    func firstStart(){
        UserDefaults.standard.set(Key.f.carbonKeyCode, forKey: "fullKey")
        UserDefaults.standard.set(Key.leftArrow.carbonKeyCode, forKey: "leftHalfKey")
        UserDefaults.standard.set(Key.rightArrow.carbonKeyCode, forKey: "rightHalfKey")
        UserDefaults.standard.set(Key.leftArrow.carbonKeyCode, forKey: "leftQuarterKey")
        UserDefaults.standard.set(Key.rightArrow.carbonKeyCode, forKey: "rightQuarterKey")
        UserDefaults.standard.set(Key.leftArrow.carbonKeyCode, forKey: "leftGibbousKey")
        UserDefaults.standard.set(Key.rightArrow.carbonKeyCode, forKey: "rightGibbousKey")
        
        UserDefaults.standard.set("F", forKey: "fullKeyChar")
        UserDefaults.standard.set("←", forKey: "leftHalfKeyChar")
        UserDefaults.standard.set("→", forKey: "rightHalfKeyChar")
        UserDefaults.standard.set("←", forKey: "leftQuarterKeyChar")
        UserDefaults.standard.set("→", forKey: "rightQuarterKeyChar")
        UserDefaults.standard.set("←", forKey: "leftGibbousKeyChar")
        UserDefaults.standard.set("→", forKey: "rightGibbousKeyChar")
        
        let command = NSEvent.ModifierFlags.command.carbonFlags
        let shift = NSEvent.ModifierFlags.shift.carbonFlags
        let option = NSEvent.ModifierFlags.option.carbonFlags
        let controll = NSEvent.ModifierFlags.control.carbonFlags
        
        UserDefaults.standard.set(Int(command + option + shift), forKey: "fullModifier")
        UserDefaults.standard.set(Int(command + option + shift), forKey: "leftHalfModifier")
        UserDefaults.standard.set(Int(command + option + shift), forKey: "rightHalfModifier")
        UserDefaults.standard.set(Int(option + shift), forKey: "leftQuarterModifier")
        UserDefaults.standard.set(Int(option + shift), forKey: "rightQuarterModifier")
        UserDefaults.standard.set(Int(controll + shift), forKey: "leftGibbousModifier")
        UserDefaults.standard.set(Int(controll + shift), forKey: "rightGibbousModifier")
        
        UserDefaults.standard.set("true", forKey: "firstStart")
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApp.terminate(self)
    }
    
    @IBAction func fullClicked(_ sender: NSMenuItem) {
        full?.attributesToFrontWindow()
    }
    
    @IBAction func leftHalfClicked(_ sender: NSMenuItem) {
        leftHalf?.attributesToFrontWindow()
    }
    
    @IBAction func rightHalfClicked(_ sender: NSMenuItem) {
        rightHalf?.attributesToFrontWindow()
    }
    
    @IBAction func leftQuarterClicked(_ sender: NSMenuItem) {
        leftQuarter?.attributesToFrontWindow()
    }
    
    @IBAction func rightQuarterClicked(_ sender: NSMenuItem) {
        rightQuarter?.attributesToFrontWindow()
    }
    
    @IBAction func leftGibbousClicked(_ sender: NSMenuItem) {
        leftGibbous?.attributesToFrontWindow()
    }
    
    @IBAction func rightGibbousClicked(_ sender: NSMenuItem) {
        rightGibbous?.attributesToFrontWindow()
    }
}
