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
    
    let maxEventCount = 100;
    
    private var windowMoving: Bool
    private var dragEventCount: Int
    
    private var lastWindowPositionX, lastWindowPositionY: CGFloat
    
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
            (lastWindowPositionX, lastWindowPositionY) = AccessibilityAccessor.shared.getFrontWindowPosition()
            dragEventCount = 1
            windowMoving = false
        }else if(dragEventCount <= maxEventCount){
            let (windowPositionX, windowPositionY) = AccessibilityAccessor.shared.getFrontWindowPosition()
            if(windowPositionX != lastWindowPositionX || windowPositionY != lastWindowPositionY){
                windowMoving = true
                dragEventCount = maxEventCount + 1
            }else{
                windowMoving = false
            }
            dragEventCount+=1
        }
    }
}
