//
//  GlobalEventMonitor.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 29.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import Foundation
import AppKit

public class GlobalEventMonitor {
    
    private var monitor: AnyObject?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> ()
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
