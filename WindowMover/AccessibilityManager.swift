//
//  AccessibilityManager.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 31.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//


//Working example

/**
 let app: NSRunningApplication? = NSWorkspace.shared.frontmostApplication
 let appElement: AXUIElement = AXUIElementCreateApplication((app?.processIdentifier)!)
 var windowElement: AnyObject?
 AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &windowElement)

 if(windowElement != nil){
    //Get attribute value
    var value: AnyObject?
    AXUIElementCopyAttributeValue(windowElement as! AXUIElement, kAXPositionAttribute as CFString, &value)
    print(value as Any)

    var rect: CGRect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let sizeRef : AXValue = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!, &rect.origin)!
    AXUIElementSetAttributeValue(windowElement as! AXUIElement, kAXPositionAttribute as CFString, sizeRef)
 }
*/

import Foundation
import AppKit
import ApplicationServices

class AccessibilityManager{
    
    var foregroundApplication: NSRunningApplication?
    var foregroundWindowElement: AnyObject?
    var mouseDownHandler : GlobalEventMonitor?

    
    init(){
        mouseDownHandler = GlobalEventMonitor(mask: .leftMouseDown, handler: { (mouseEvent: NSEvent?) in
            self.setForegroundApplication()
        })
    }
    
    func setForegroundApplication(){
        if(foregroundApplication == nil || !((foregroundApplication?.isEqual(NSWorkspace.shared.frontmostApplication)) ?? false)){
            foregroundApplication = NSWorkspace.shared.frontmostApplication
            setFrontWindowElement()
        }
    }
    
    func setFrontWindowElement(){
        let appElement: AXUIElement = AXUIElementCreateApplication((foregroundApplication?.processIdentifier)!)
        checkForError(error: AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &foregroundWindowElement))
    }
    
    func setAccessibilityAttribute(type: UInt32, attribute: String, value: UnsafeRawPointer){
        if(foregroundWindowElement != nil){
            let attributeValue : AXValue = AXValueCreate(AXValueType(rawValue: type)!, value)!
            checkForError(error: AXUIElementSetAttributeValue(foregroundWindowElement as! AXUIElement, attribute as CFString, attributeValue))
        }
    }
    
    func getAccessibilityAttribute(attribute: String) -> AnyObject?{
        var value: AnyObject?
        if(foregroundWindowElement != nil){
            checkForError(error: AXUIElementCopyAttributeValue(foregroundWindowElement as! AXUIElement, attribute as CFString, &value))
        }
        return value
    }
    
    func setFrontWindowPosition(x: Int, y: Int){
        //stub
    }
    
    func getFrontWindowPosition() -> (x: Int, y: Int){
        //stub
        return (0, 0)
    }
    
    func setFrontWindowSize(width: Int, height: Int){
        //stub
    }
    
    func getFrontWindowSize() -> (width: Int, height: Int){
        //stub
        return (0, 0)
    }
    
    
    func checkForError(error: AXError){
        switch error {
        case AXError.actionUnsupported:
            print("AXError: \(error.rawValue) actionUnsupported")
        case AXError.apiDisabled:
            print("AXError: \(error.rawValue) apiDisabled")
        case AXError.attributeUnsupported:
            print("AXError: \(error.rawValue) attributeUnsupported")
        case AXError.cannotComplete:
            print("AXError: \(error.rawValue) cannotComplete")
        case AXError.failure:
            print("AXError: \(error.rawValue) failure")
        case AXError.illegalArgument:
            print("AXError: \(error.rawValue) illegalArgument")
        case AXError.invalidUIElement:
            print("AXError: \(error.rawValue) invalidUIElement")
        case AXError.invalidUIElementObserver:
            print("AXError: \(error.rawValue) invalidUIElementObserver")
        case AXError.notEnoughPrecision:
            print("AXError: \(error.rawValue) notEnoughPrecision")
        case AXError.notificationAlreadyRegistered:
            print("AXError: \(error.rawValue) notificationAlreadyRegistered")
        case AXError.notificationNotRegistered:
            print("AXError: \(error.rawValue) notificationNotRegistered")
        case AXError.notificationUnsupported:
            print("AXError: \(error.rawValue) notificationUnsupported")
        case AXError.notImplemented:
            print("AXError: \(error.rawValue) notImplemented")
        case AXError.noValue:
            print("AXError: \(error.rawValue) noValue")
        case AXError.parameterizedAttributeUnsupported:
            print("AXError: \(error.rawValue) parameterizedAttributeUnsupported")
        case AXError.success:
            print()
        }
    }
}


