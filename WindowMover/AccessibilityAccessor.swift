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

class AccessibilityAccessor{
    
    static let shared = AccessibilityAccessor()

    var foregroundApplication: NSRunningApplication?
    var frontWindowElement: AnyObject?
    var windowElements: AnyObject?
    var mouseDownHandler : GlobalEventMonitor?
    
    init(){            
        mouseDownHandler = GlobalEventMonitor(mask: .leftMouseDown, handler: { (mouseEvent: NSEvent?) in
            self.setForegroundApplication()
        })
        mouseDownHandler?.start()
    }
    
    func changeFrontWindow(){
        if(windowElements != nil && windowElements!.lastObject != nil){
            if(checkForError(AXUIElementPerformAction(windowElements!.lastObject as! AXUIElement,kAXRaiseAction as CFString))){
                 print("Error at changeFrontWindow()")
            }
            setWindowElements()
        }
    }
    
    func changeToLastFrontWindow(){
        if(windowElements != nil && windowElements!.count > 1){
            if(checkForError(AXUIElementPerformAction(windowElements!.object(at: 1) as! AXUIElement,kAXRaiseAction as CFString))){
                print("Error at changeToLastFrontWindow()")
            }
            setWindowElements()
        }
    }
    
    func setForegroundApplication(){
        if(foregroundApplication != NSWorkspace.shared.frontmostApplication){
            foregroundApplication = NSWorkspace.shared.frontmostApplication
        }
        setWindowElements()
    }
    
    func setWindowElements(){
        let appElement: AXUIElement = AXUIElementCreateApplication((foregroundApplication?.processIdentifier)!)
        if(checkForError(AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowElements))){
            print("Error at setWindowElements()")
        }
        frontWindowElement = windowElements?.firstObject as AnyObject
    }
    
    @available(*, deprecated)
    func setFrontWindowElement(){
        let appElement: AXUIElement = AXUIElementCreateApplication((foregroundApplication?.processIdentifier)!)
        if(checkForError(AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &frontWindowElement))){
            print("Error at setFrontWindowElement()")
        }
    }
    
    func setAccessibilityAttribute(type: UInt32, attribute: String, value: UnsafeRawPointer){
        if(frontWindowElement != nil){
            let attributeValue : AXValue = AXValueCreate(AXValueType(rawValue: type)!, value)!
            if(checkForError( AXUIElementSetAttributeValue(frontWindowElement as! AXUIElement, attribute as CFString, attributeValue))){
                print("Error at setAccessibilityAttribute()")
            }
        }
    }
    
    func getAccessibilityAttribute(attribute: String) -> AnyObject?{
        var value: AnyObject?
        if(frontWindowElement != nil){
            if(checkForError( AXUIElementCopyAttributeValue(frontWindowElement as! AXUIElement, attribute as CFString, &value))){
                print("Error at getAccessibilityAttribute()")
            }
        }
        return value
    }
    
    func setFrontWindowPosition(x: CGFloat, y: CGFloat){
        var position = CGPoint(x: x, y: y)
        setAccessibilityAttribute(type: kAXValueCGPointType, attribute: kAXPositionAttribute, value: &position)
    }
    
    func getFrontWindowPosition() -> (x: CGFloat, y: CGFloat){
        let value: AnyObject? = getAccessibilityAttribute(attribute: kAXPositionAttribute)
        var pointer: CGPoint?
        
        if(value != nil){
            AXValueGetValue(value as! AXValue, AXValueType(rawValue: kAXValueCGPointType)!, &pointer)
        }
        let point: CGPoint = getPointerValue(address: &pointer, as: CGPoint.self)

        return (point.x , point.y)
    }
    
    func setFrontWindowSize(width: CGFloat, height: CGFloat) -> Bool{
        var size = CGSize(width: width, height: height)
        setAccessibilityAttribute(type: kAXValueCGSizeType, attribute: kAXSizeAttribute, value: &size)
        
        if(getFrontWindowSize() != (width, height)){
            return false
        }
        return true
    }
    
    func getFrontWindowSize() -> (width: CGFloat, height: CGFloat){
        let value: AnyObject? = getAccessibilityAttribute(attribute: kAXSizeAttribute)
        var pointer: CGSize?
        
        if(value != nil){
            AXValueGetValue(value as! AXValue, AXValueType(rawValue: kAXValueCGSizeType)!, &pointer)
        }
        let size: CGSize = getPointerValue(address: &pointer, as: CGSize.self)
        
        return (size.width, size.height)
    }
    
    func getPointerValue<T>(address p: UnsafeMutableRawPointer, as type: T.Type) -> T {
        let value = p.load(as: type)
        return value
    }
    
    func checkForError(_ error: AXError) -> Bool{
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


