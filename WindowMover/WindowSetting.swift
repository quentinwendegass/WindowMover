//
//  WindowSetting.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 24.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Foundation
import HotKey

class WindowSetting {
    
    enum Orientation {
        case topLeft
        case bottomLeft
        case topRight
        case bottomRight
    }
    
    static let usableFrame = NSScreen.main!.visibleFrame
    static let fullFrame = NSScreen.main!.frame
    static let titelBarHeight = WindowSetting.fullFrame.height - WindowSetting.usableFrame.height - (WindowSetting.usableFrame.origin.y - WindowSetting.fullFrame.origin.y)

    
    var name: String
    var orientation: Orientation
    var rect: CGRect
    var hotkey: HotKey? {
        didSet {
            guard let hotkey = hotkey else {
                return
            }
            hotkey.keyDownHandler = {
                self.attributesToFrontWindow()
            }
        }
    }
    
    var carbonKeyCode, carbonModifierCode: UInt32?
    var carbonKeyChar: String?
    
    init(width: CGFloat, height: CGFloat, orientation: Orientation, name: String) {
        self.orientation = orientation
        self.name = name
        switch orientation {
        case .bottomLeft:
            self.rect = CGRect(x: WindowSetting.usableFrame.origin.x, y: WindowSetting.titelBarHeight + WindowSetting.usableFrame.height - height - 1, width: width, height: height)
        case .topLeft:
            self.rect = CGRect(x: WindowSetting.usableFrame.origin.x, y: WindowSetting.titelBarHeight, width: width, height: height)
        case .bottomRight:
            self.rect = CGRect(x: WindowSetting.usableFrame.origin.x + WindowSetting.usableFrame.width - width, y: WindowSetting.titelBarHeight + WindowSetting.usableFrame.height - height - 1,  width: width, height: height)
        case .topRight:
            self.rect = CGRect(x:  WindowSetting.usableFrame.origin.x + WindowSetting.usableFrame.width - width, y: WindowSetting.titelBarHeight, width: width, height: height)
        }
        
        updateHotkey()
    }
    
    func updateHotkey() {
        self.hotkey = HotKey(keyCombo: KeyCombo(carbonKeyCode: UInt32(UserDefaults.standard.integer(forKey: self.name + "Key")), carbonModifiers: UInt32(UserDefaults.standard.integer(forKey: self.name + "Modifier"))))
        self.carbonKeyCode = hotkey?.keyCombo.carbonKeyCode;
        self.carbonModifierCode = hotkey?.keyCombo.carbonModifiers;
        self.carbonKeyChar = UserDefaults.standard.string(forKey: self.name + "KeyChar")
    }
    
    func attributesToFrontWindow(){
        let secFrame = AccessibilityAccessor.shared.getSecondApplicationFrame()
        if(secFrame != nil && AccessibilityAccessor.shared.isSecondApplicationOrientated(orientation: orientation) && false){
            if(orientation == .topLeft || orientation == .bottomLeft){
                AccessibilityAccessor.shared.setFrontWindowPosition(x: 0, y: self.rect.origin.y)
                print(secFrame?.origin.x)
                AccessibilityAccessor.shared.setFrontWindowSize(width: secFrame!.origin.x, height: self.rect.height)
                print(AccessibilityAccessor.shared.getFrontWindowSize())
                print(AccessibilityAccessor.shared.getFrontWindowSize())

            }else{
                AccessibilityAccessor.shared.setFrontWindowSize(width: WindowSetting.usableFrame.width - secFrame!.width, height: self.rect.height)
                AccessibilityAccessor.shared.setFrontWindowPosition(x: secFrame!.width, y: self.rect.origin.y)
            }
        }
        else{
            AccessibilityAccessor.shared.setFrontWindowPosition(x: self.rect.origin.x, y: self.rect.origin.y)
            if(!AccessibilityAccessor.shared.setFrontWindowSize(width: self.rect.width, height: self.rect.height)){
                if(orientation == .bottomRight || orientation == .topRight){
                    let newSize = AccessibilityAccessor.shared.getFrontWindowSize()
                    AccessibilityAccessor.shared.setFrontWindowPosition(x: self.rect.origin.x - (newSize.width - self.rect.width), y: self.rect.origin.y)
                }
            }
        }
    }
    
    @available(*, deprecated)
    static func setWindowForegroundAttributes(width: CGFloat, height: CGFloat, x:CGFloat = 0, y:CGFloat = 0){
        AccessibilityAccessor.shared.setFrontWindowPosition(x: x, y: y)
        AccessibilityAccessor.shared.setFrontWindowSize(width: width, height: height)
    }
}
