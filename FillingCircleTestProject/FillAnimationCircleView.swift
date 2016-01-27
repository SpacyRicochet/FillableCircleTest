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
        
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.fromValue = startPath
        basicAnimation.toValue = endPath
        basicAnimation.duration = 5.0
        basicAnimation.removedOnCompletion = false
        
        let shape = CAShapeLayer()
        shape.speed = 0
        shape.timeOffset = 0
        shape.addAnimation(basicAnimation, forKey: "animation")
        
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
        guard let fillAnimationLayer = fillAnimationLayer, let _ = fillAnimationLayer.animationForKey("animation") else {
            print("Animation not found")
            return
        }
        
        let pausedTime = fillAnimationLayer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        fillAnimationLayer.speed = 0
        layer.timeOffset = pausedTime
    }
}
