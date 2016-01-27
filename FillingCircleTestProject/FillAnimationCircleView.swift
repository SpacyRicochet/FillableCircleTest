//
//  AnimatableCircleView.swift
//
//  Created by Bruno Scheele on 26/01/16.
//  Copyright © 2016 Noodlewerk Apps. All rights reserved.
//

import UIKit

class FillAnimationCircleView : CircleView {
    
    override var activeColor: UIColor {
        didSet {
            guard let fillAnimationLayer = fillAnimationLayer else { return }
            fillAnimationLayer.fillColor = activeColor.CGColor
        }
    }
    override var bounds: CGRect {
        didSet {
            fillAnimationLayer?.removeFromSuperlayer()
            fillAnimationLayer = nil
        }
    }
    
    // MARK: - Animation
    
    var fillAnimationLayer: CAShapeLayer?
    
    // Inspiration from:
    // https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch04p160frozenAnimation/FrozenAnimationTest/ViewController.swift
    func constructFillAnimationLayer() -> CAShapeLayer {
        let startPath = CGPathCreateWithEllipseInRect(CGRect.circleFrame(withCenter: bounds.center, radius: 2), nil)
        let endPath = CGPathCreateWithEllipseInRect(bounds, nil)
        
        let emptyAnimation = CABasicAnimation(keyPath: "path")
        emptyAnimation.fromValue = startPath
        emptyAnimation.toValue = endPath
        
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.values = [startPath, endPath, startPath]
        animation.keyTimes = [NSNumber(double: 0.0), NSNumber(double: 0.5), NSNumber(double: 1.0)]
        animation.duration = 2.0
        animation.removedOnCompletion = false
        
        let shape = CAShapeLayer()
        shape.speed = 0
        shape.timeOffset = 0
        shape.addAnimation(animation, forKey: "animation")
        
        layer.addSublayer(shape)
        
        return shape
    }
    
    var animationTimer: NSTimer? = nil
    func beginAnimation() {
        if fillAnimationLayer == nil {
            fillAnimationLayer = constructFillAnimationLayer()
        }
        fillAnimationLayer?.speed = 1
    }
    
    func reverseAnimation() {
        self.fillAnimationLayer?.speed = -1.0
    }
}
