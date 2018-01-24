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
        
        leftHalf = HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.command, .option, .shift]))
        leftQuarter = HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.option, .shift]))
        leftGibbous = HotKey(keyCombo: KeyCombo(key: .leftArrow, modifiers: [.control, .shift]))
        rightHalf = HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.command, .option, .shift]))
        rightQuarter = HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.option, .shift]))
        rightGibbous = HotKey(keyCombo: KeyCombo(key: .rightArrow, modifiers: [.control, .shift]))
        full = HotKey(keyCombo: KeyCombo(key: .f, modifiers: [.command, .option, .shift]))
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    private var leftHalf: HotKey? {
        didSet {
            guard let leftHalf = leftHalf else {
                return
            }
            leftHalf.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width / 2), height: (Int)(NSScreen.main!.frame.height))
            }
        }
    }
    
    private var leftQuarter: HotKey? {
        didSet {
            guard let leftQuarter = leftQuarter else {
                return
            }
            leftQuarter.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width / 4), height: (Int)(NSScreen.main!.frame.height))
            }
        }
    }
    
    private var leftGibbous: HotKey? {
        didSet {
            guard let leftGibbous = leftGibbous else {
                return
            }
            leftGibbous.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width * 3/4), height: (Int)(NSScreen.main!.frame.height))
            }
        }
    }
    
    private var rightHalf: HotKey? {
        didSet {
            guard let rightHalf = rightHalf else {
                return
            }
            rightHalf.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width / 2), height: (Int)(NSScreen.main!.frame.height), x: (Int)(NSScreen.main!.frame.width / 2))
            }
        }
    }
    
    private var rightQuarter: HotKey? {
        didSet {
            guard let rightQuarter = rightQuarter else {
                return
            }
            rightQuarter.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width / 4), height: (Int)(NSScreen.main!.frame.height), x: (Int)(NSScreen.main!.frame.width * 3/4))
            }
        }
    }
    
    private var rightGibbous: HotKey? {
        didSet {
            guard let rightGibbous = rightGibbous else {
                return
            }
            rightGibbous.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width * 3/4), height: (Int)(NSScreen.main!.frame.height), x: (Int)(NSScreen.main!.frame.width / 4))
            }
        }
    }
    
    private var full: HotKey? {
        didSet {
            guard let full = full else {
                return
            }
            full.keyDownHandler = {
                self.runScript(width: (Int)(NSScreen.main!.frame.width), height: (Int)(NSScreen.main!.frame.height))
            }
        }
    }
    
    func runScript(width: Int, height: Int, x:Int = 0, y:Int = 0){
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["\(String(describing: Bundle.main.path(forResource: "set_window_size", ofType: "scpt")!))",
            "\(width)", "\(height)", "\(x)", "\(y)"]
        task.launch()
    }
    
}
