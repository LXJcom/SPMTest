//
//  NSViewCatagory.swift
//  MBMacKit
//
//  Created by xiaojie li on 2024/8/10.
//

import AppKit
extension NSView {
    func mbAddArea ( options : NSTrackingArea.Options? = nil , owner : Any? = nil) {
        let areas = self.trackingAreas
        let _ = areas.map { [weak self] area in
            self?.removeTrackingArea(area)
        }
        let trackingArea = NSTrackingArea(rect: bounds, options: options == nil ?  [.mouseEnteredAndExited , .activeAlways] : options! , owner: owner == nil ? self : owner!)
        self.addTrackingArea(trackingArea)
    }
    func removeAllConstraint() {
        let constraints = self.constraints
        for constraint in constraints {
            self.removeConstraint(constraint)
        }
    }
}
