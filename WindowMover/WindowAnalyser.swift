//
//  WindowAnalyser.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 30.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Foundation
import AppKit

class WindowAnalyser{
    
    let maxEventCount = 3;
    
    private var windowMoving: Bool
    private var dragEventCount: Int
    
    private var lastWindowPositionX, lastWindowPositionY: Int
    
    init() {
        windowMoving = false
        lastWindowPositionX = 0
        lastWindowPositionY = 0
        dragEventCount = 0
    }
    
    public func isWindowMoving() -> Bool{
        return windowMoving
    }
    
    public func mouseDragged(firstDrag: Bool){
        if(firstDrag){
            (lastWindowPositionX, lastWindowPositionY) = getForegroundWindowPosition()
            dragEventCount = 1
            windowMoving = false
        }else if(dragEventCount <= maxEventCount){
            let (windowPositionX, windowPositionY) = getForegroundWindowPosition()
            if(windowPositionX != lastWindowPositionX || windowPositionY != lastWindowPositionY){
                windowMoving = true
                dragEventCount = maxEventCount + 1
            }else{
                windowMoving = false
            }
            dragEventCount+=1
        }
    }
    
    private func getForegroundWindowPosition() -> (Int, Int) {
        var x, y: Int
        var error: NSDictionary?
        var scriptError: AutoreleasingUnsafeMutablePointer<NSDictionary?>?
        
        let url = Bundle.main.url(forResource: "get_frontapp_position", withExtension: "scpt")
        
        if let scriptObject = NSAppleScript(contentsOf: url!, error: scriptError) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)

            if let _x = output.atIndex(1) {
                x = Int(_x.int32Value)
            }else{
                x = 0
            }
            
            if let _y = output.atIndex(2) {
                y = Int(_y.int32Value)
            }else{
                y = 0
            }
        }else{
            x = 0
            y = 0
        }
        print((x, y))
        return (x, y)
    }
}
