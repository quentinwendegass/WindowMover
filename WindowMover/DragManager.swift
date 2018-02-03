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
    
    static let showOverlayWidth: CGFloat = 5
    
    let leftArea = CGRect(x: 0, y: showOverlayWidth, width: showOverlayWidth, height: WindowSetting.fullFrame.height - showOverlayWidth*2)
    let topLeftArea = CGRect(x: 0, y: WindowSetting.fullFrame.height - showOverlayWidth, width: showOverlayWidth, height: showOverlayWidth)
    let bottomLeftArea = CGRect(x: 0, y: 0, width: showOverlayWidth, height: showOverlayWidth)
    let rightArea = CGRect(x: WindowSetting.fullFrame.width - showOverlayWidth, y: showOverlayWidth, width: showOverlayWidth, height: WindowSetting.fullFrame.height - showOverlayWidth*2)
    let topRightArea = CGRect(x: WindowSetting.fullFrame.width - showOverlayWidth, y: WindowSetting.fullFrame.height - showOverlayWidth, width: showOverlayWidth, height: showOverlayWidth)
    let bottomRightArea = CGRect(x: WindowSetting.fullFrame.width - showOverlayWidth, y: 0, width: showOverlayWidth, height: showOverlayWidth)
    let topArea = CGRect(x: showOverlayWidth, y: WindowSetting.fullFrame.height - showOverlayWidth, width: WindowSetting.fullFrame.width - showOverlayWidth*2, height: showOverlayWidth)
    let bottomArea = CGRect(x: showOverlayWidth, y: 0, width: WindowSetting.fullFrame.width - showOverlayWidth*2, height: showOverlayWidth)
    

    init() {
        overlayWindow = MarkingOverlay()
        windowAnalyser = WindowAnalyser()
        dragged = false

        mouseUpHandler = GlobalEventMonitor(mask: .leftMouseUp, handler: { (mouseEvent: NSEvent?) in
            self.overlayWindow.window?.setIsVisible(false);
            
            if(self.leftSetting != nil && self.layoutAreaMouseUp(windowSetting: self.leftSetting!, area: self.leftArea)){}
            else if(self.rightSetting != nil && self.layoutAreaMouseUp(windowSetting: self.rightSetting!, area: self.rightArea)){}
            else if(self.bottomSetting != nil && self.layoutAreaMouseUp(windowSetting: self.bottomSetting!, area: self.bottomArea)){}
            else if(self.topSetting != nil && self.layoutAreaMouseUp(windowSetting: self.topSetting!, area: self.topArea)){}
            else if(self.topLeftSetting != nil && self.layoutAreaMouseUp(windowSetting: self.topLeftSetting!, area: self.topLeftArea)){}
            else if(self.bottomLeftSetting != nil && self.layoutAreaMouseUp(windowSetting: self.bottomLeftSetting!, area: self.bottomLeftArea)){}
            else if(self.topRightSetting != nil && self.layoutAreaMouseUp(windowSetting: self.topRightSetting!, area: self.topRightArea)){}
            else if(self.bottomRightSetting != nil && self.layoutAreaMouseUp(windowSetting: self.bottomRightSetting!, area: self.bottomRightArea)){}
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
            else if(self.bottomSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.bottomSetting!, area: self.bottomArea)){}
            else if(self.topSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.topSetting!, area: self.topArea)){}
            else if(self.topLeftSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.topLeftSetting!, area: self.topLeftArea)){}
            else if(self.bottomLeftSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.bottomLeftSetting!, area: self.bottomLeftArea)){}
            else if(self.topRightSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.topRightSetting!, area: self.topRightArea)){}
            else if(self.bottomRightSetting != nil && self.layoutAreaMouseDragged(windowSetting: self.bottomRightSetting!, area: self.bottomRightArea)){}
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
