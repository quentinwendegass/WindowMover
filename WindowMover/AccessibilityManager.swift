//
//  AccessibilityManager.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 31.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//


import Foundation
import AppKit
import ApplicationServices

class AccessibilityManager{
    
    static let sharedInstance = AccessibilityManager()
    
    var foregroundApplication: NSRunningApplication?
    var frontWindowElement: AnyObject?
    var mouseDownHandler : GlobalEventMonitor?

    
    init(){
        mouseDownHandler = GlobalEventMonitor(mask: .leftMouseDown, handler: { (mouseEvent: NSEvent?) in
            self.setForegroundApplication()
        })
        mouseDownHandler?.start()
    }
    
    func setForegroundApplication(){
        if(foregroundApplication == nil || !((foregroundApplication?.isEqual(NSWorkspace.shared.frontmostApplication)) ?? false)){
            foregroundApplication = NSWorkspace.shared.frontmostApplication
            setFrontWindowElement()
        }
    }
    
    func setFrontWindowElement(){
        let appElement: AXUIElement = AXUIElementCreateApplication((foregroundApplication?.processIdentifier)!)
        if(checkForError(error: AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &frontWindowElement))){
            print("Error at setFrontWindowElement")
        }
    }
    
    func setAccessibilityAttribute(type: UInt32, attribute: String, value: UnsafeRawPointer){
        if(frontWindowElement != nil){
            let attributeValue : AXValue = AXValueCreate(AXValueType(rawValue: type)!, value)!
            if(checkForError(error: AXUIElementSetAttributeValue(frontWindowElement as! AXUIElement, attribute as CFString, attributeValue))){
                print("Error at setAccessibilityAttribute")
            }
        }
    }
    
    func getAccessibilityAttribute(attribute: String) -> AnyObject?{
        var value: AnyObject?
        if(frontWindowElement != nil){
            if(checkForError(error: AXUIElementCopyAttributeValue(frontWindowElement as! AXUIElement, attribute as CFString, &value))){
                print("Error at getAccessibilityAttribute")
            }
        }
        return value
    }
    
    func setFrontWindowPosition(x: Int, y: Int){
        var position = CGPoint(x: x, y: y)
        setAccessibilityAttribute(type: kAXValueCGPointType, attribute: kAXPositionAttribute, value: &position)
    }
    
    func getFrontWindowPosition() -> (x: Int, y: Int){
        let value: AnyObject? = getAccessibilityAttribute(attribute: kAXPositionAttribute)
        var pointer: CGPoint?
        
        if(value != nil){
            AXValueGetValue(value as! AXValue, AXValueType(rawValue: kAXValueCGPointType)!, &pointer)
        }
        let point: CGPoint = getPointerValue(address: &pointer, as: CGPoint.self)

        return (Int(point.x) ,Int(point.y))
    }
    
    func getPointerValue<T>(address p: UnsafeMutableRawPointer, as type: T.Type) -> T {
        let value = p.load(as: type)
        return value
    }
    
    func setFrontWindowSize(width: Int, height: Int){
        var size = CGSize(width: width, height: height)
        setAccessibilityAttribute(type: kAXValueCGSizeType, attribute: kAXSizeAttribute, value: &size)
    }
    
    func getFrontWindowSize() -> (width: Int, height: Int){
        let value: AnyObject? = getAccessibilityAttribute(attribute: kAXSizeAttribute)
        var pointer: CGSize?
        
        if(value != nil){
            AXValueGetValue(value as! AXValue, AXValueType(rawValue: kAXValueCGSizeType)!, &pointer)
        }
        let size: CGSize = getPointerValue(address: &pointer, as: CGSize.self)
        
        return (Int(size.width) ,Int(size.height))
    }
    
    func checkForError(error: AXError) -> Bool{
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
            return false
        }
        return true
    }
}


