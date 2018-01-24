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
                WindowSetting.runScript(width: self.width, height: self.height, x: self.x, y: self.y)
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
    
    static func runScript(width: Int, height: Int, x:Int = 0, y:Int = 0){
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["\(String(describing: Bundle.main.path(forResource: "set_window_size", ofType: "scpt")!))",
            "\(width)", "\(height)", "\(x)", "\(y)"]
        task.launch()
    }
}
