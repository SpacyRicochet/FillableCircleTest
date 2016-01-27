//
//  CGRect+NWA.swift
//
//
//  Created by Bruno Scheele on 19/11/15.
//  Copyright © 2015 Noodlewerk Apps. All rights reserved.
//

import UIKit

/// Extends CGRect to provide some default calculations, useful for multiple applications.
extension CGRect {
    
    /// Returns the center of the rectangle.
    var center: CGPoint {
        return CGPoint(x: size.width / 2.0 + origin.x, y: size.height / 2.0 + origin.y)
    }
}

/// Extends CGRect to provide Bubbl-specific calculations that are useful in multiple classes.
extension CGRect {
    /// Returns the frame for a circle with the given radius and center.
    static func circleFrame(withCenter center: CGPoint, radius: CGFloat) -> CGRect {
        let x = center.x - radius
        let y = center.y - radius
        let length = 2.0 * radius
        let result = CGRect(x: x, y: y, width: length, height: length)
        return result
    }
}
