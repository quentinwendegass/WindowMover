//
//  DragManager.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 02.02.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Foundation
import AppKit

class DragManager {
    
    static let shared = DragManager()
    
    var mouseUpHandler: GlobalEventMonitor?
    var mouseDraggedHandler: GlobalEventMonitor?
    
    let overlayWindow: MarkingOverlay
    let windowAnalyser: WindowAnalyser

    
    var leftSetting: WindowSetting?
    var topLeftSetting: WindowSetting?
    var bottomLeftSetting: WindowSetting?
    var rightSetting: WindowSetting?
    var topRightSetting: WindowSetting?
    var bottomRightSetting: WindowSetting?
    var topSetting: WindowSetting?
    var bottomSetting: WindowSetting?
    
    var dragged: Bool
    
    let leftArea = CGRect(x: 0, y: 40, width: 40, height: WindowSetting.fullFrame.height - 80)
    let rightArea = CGRect(x: WindowSetting.fullFrame.width - 40, y: 40, width: 40, height: WindowSetting.fullFrame.height - 80)
    

    init() {
        overlayWindow = MarkingOverlay()
        windowAnalyser = WindowAnalyser()
        dragged = false

        mouseUpHandler = GlobalEventMonitor(mask: .leftMouseUp, handler: { (mouseEvent: NSEvent?) in
            self.overlayWindow.window?.setIsVisible(false);
            
            if(self.leftSetting != nil && self.layoutAreaMouseUp(windowSetting: self.leftSetting!, area: self.leftArea)){}
            else if(self.rightSetting != nil && self.layoutAreaMouseUp(windowSetting: self.rightSetting!, area: self.rightArea)){}
            else{
                self.overlayWindow.window?.setIsVisible(false);
            }
            self.dragged = false
        })
        mouseUpHandler?.start()
        
        mouseDraggedHandler = GlobalEventMonitor(mask: .leftMouseDragged, handler: { (mouseEvent: NSEvent?) in
            self.windowAnalyser.mouseDragged(firstDrag: !self.dragged)
            
            if(self.leftSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.leftSetting!, area: self.leftArea)){}
            else if(self.rightSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.rightSetting!, area: self.rightArea)){}
            else{
                self.overlayWindow.window?.setIsVisible(false);
            }
            
            if(!self.dragged){
                self.dragged = true
            }
        })
        mouseDraggedHandler?.start()
    }
    
    func layoutAreaMouseUp(windowSetting: WindowSetting, area: CGRect) ->Bool{
        if(self.isMouseInRect(rect: area) && self.windowAnalyser.isWindowMoving() && self.dragged){
            windowSetting.attributesToFrontWindow()
            return true
        }
        return false
    }
    
    func layoutAreaMouseDragged(windowSetting: WindowSetting, area: CGRect) -> Bool{
        if(self.isMouseInRect(rect: area) && self.windowAnalyser.isWindowMoving()){
            self.overlayWindow.window?.setIsVisible(true);
            self.overlayWindow.window?.setFrame(CGRect(x: windowSetting.rect.origin.x, y: WindowSetting.fullFrame.height - windowSetting.rect.origin.y - windowSetting.rect.height, width: windowSetting.rect.width, height:  windowSetting.rect.height), display: true)
            return true
        }
        return false
    }
        
    func isMouseInRect(rect area: CGRect) -> Bool{
        if(NSEvent.mouseLocation.x >= area.origin.x && NSEvent.mouseLocation.x <= area.origin.x + area.width && NSEvent.mouseLocation.y >= area.origin.y && NSEvent.mouseLocation.y <= area.origin.y + area.height){
            return true
        }
        return false
    }
}
