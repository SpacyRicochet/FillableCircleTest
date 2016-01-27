//
//  RoundedView.swift
//  app-thermo-ios-swift
//
//  Created by Bruno Scheele on 18/08/15.
//  Copyright (c) 2015 Noodlewerk Apps. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView
{
    var defaultColor:   UIColor = UIColor.whiteColor() {
        didSet {
            backgroundColor = defaultColor
        }
    }
    var activeColor:    UIColor = UIColor.whiteColor()

    override func layoutSubviews() {
        let smallestSide: CGFloat = min(bounds.width, bounds.height)
        let cornerRadius = smallestSide / 2.0
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        super.layoutSubviews()
    }
    
}
