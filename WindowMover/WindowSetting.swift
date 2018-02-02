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
    
    init(width: CGFloat, height: CGFloat, orientation: Orientation) {
        self.orientation = orientation
        switch orientation {
        case .bottomLeft:
            self.rect = CGRect(x: WindowSetting.usableFrame.origin.x, y: WindowSetting.titelBarHeight + WindowSetting.usableFrame.height - height, width: width, height: height)
        case .topLeft:
            self.rect = CGRect(x: WindowSetting.usableFrame.origin.x, y: WindowSetting.titelBarHeight, width: width, height: height)
        case .bottomRight:
            self.rect = CGRect(x: WindowSetting.usableFrame.origin.x + WindowSetting.usableFrame.width - width, y: WindowSetting.titelBarHeight + WindowSetting.usableFrame.height - height,  width: width, height: height)
        case .topRight:
            self.rect = CGRect(x:  WindowSetting.usableFrame.origin.x + WindowSetting.usableFrame.width - width, y: WindowSetting.titelBarHeight, width: width, height: height)
        }
    }
    
    func setHotKey(hotkey: HotKey){
        self.hotkey = hotkey
    }
    
    func attributesToFrontWindow(){
        AccessibilityAccessor.shared.setFrontWindowPosition(x: self.rect.origin.x, y: self.rect.origin.y)
        AccessibilityAccessor.shared.setFrontWindowSize(width: self.rect.width, height: self.rect.height)
    }
    
    @available(*, deprecated)
    static func setWindowForegroundAttributes(width: CGFloat, height: CGFloat, x:CGFloat = 0, y:CGFloat = 0){
        AccessibilityAccessor.shared.setFrontWindowPosition(x: x, y: y)
        AccessibilityAccessor.shared.setFrontWindowSize(width: width, height: height)
    }
}
