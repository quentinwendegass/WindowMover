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
    
    private var width, height, x, y: Int
    
    private var hotkey: HotKey? {
        didSet {
            guard let hotkey = hotkey else {
                return
            }
            hotkey.keyDownHandler = {
                WindowSetting.setWindowForegroundAttributes(width: self.width, height: self.height, x: self.x, y: self.y)
            }
        }
    }
    
    init(width: Int, height: Int, x: Int, y: Int) {
        self.width = width
        self.height = height
        self.x = x
        self.y = y
    }
    
    func setHotKey(hotkey: HotKey){
        self.hotkey = hotkey
    }
    
    static func setWindowForegroundAttributes(width: Int, height: Int, x:Int = 0, y:Int = 0){
        AccessibilityManager.sharedInstance.setFrontWindowPosition(x: x, y: x)
        AccessibilityManager.sharedInstance.setFrontWindowSize(width: width, height: height)
    }
}
