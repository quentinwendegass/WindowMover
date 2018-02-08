//
//  MarkingOverlay.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 30.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Cocoa

class MarkingOverlay: NSWindowController {

    var rectFrameLayer = CALayer()
    var setting: WindowSetting?
    
    override var windowNibName : NSNib.Name? {
        return NSNib.Name(rawValue: "MarkingOverlay")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.ignoresMouseEvents = true
        self.window?.level = .floating
        self.window?.isOpaque = false
        self.window?.hasShadow = false
        self.window?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func show(setting: WindowSetting){
        if(!(self.window?.isVisible)! || !((self.setting?.rect.equalTo(setting.rect)) ?? false)){
            self.window?.setFrame(CGRect(x: setting.rect.origin.x, y: WindowSetting.fullFrame.height - setting.rect.origin.y - setting.rect.height, width: setting.rect.width, height:  setting.rect.height), display: true)
            initializeRectangleLayer()
            self.window?.setIsVisible(true)
            self.setting = setting
        }
    }
    
    func hide(){
        self.window?.setIsVisible(false)
    }
    
    func initializeRectangleLayer(){
        rectFrameLayer.removeAllAnimations()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        rectFrameLayer.bounds = CGRect(x: 0, y: 0, width: (self.window?.frame.width)! / 2, height: (self.window?.frame.height)! / 2)
        rectFrameLayer.position = CGPoint(x: ((self.window?.frame.width)! / 2), y: ((self.window?.frame.height)! / 2))
        rectFrameLayer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        rectFrameLayer.cornerRadius = 25.0
        rectFrameLayer.borderColor = CGColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.5)
        rectFrameLayer.borderWidth = 5
        rectFrameLayer.shadowColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        rectFrameLayer.shadowRadius = 30
        rectFrameLayer.shadowOpacity = 0.5
        CATransaction.commit()
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2.0, 2.0, 1))
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.duration = 0.2

        rectFrameLayer.add(scaleAnimation, forKey: "transform.scale")
        
        self.window?.contentView?.layer?.addSublayer(rectFrameLayer)
    }
    
}
