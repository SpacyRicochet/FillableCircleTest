//
//  AnimatableCircleView.swift
//
//  Created by Bruno Scheele on 26/01/16.
//  Copyright © 2016 Noodlewerk Apps. All rights reserved.
//

import UIKit

class FillAnimationCircleView : CircleView {
    
    let maximumDuration = 5.0
    
    override var activeColor: UIColor {
        didSet {
            guard let fillShapeLayer = fillShapeLayer else { return }
            fillShapeLayer.fillColor = activeColor.CGColor
        }
    }
    override var bounds: CGRect {
        didSet {
            fillShapeLayer?.removeFromSuperlayer()
            fillShapeLayer = nil
        }
    }
    
    // MARK: - Animation
    
    var fillShapeLayer: CAShapeLayer?
    var fillAnimation:  CAAnimation?
    
    // Inspiration from:
    // https://github.com/mattneub/Programming-iOS-Book-Examples/blob/master/bk2ch04p160frozenAnimation/FrozenAnimationTest/ViewController.swift
    func constructFillShapeLayer() -> CAShapeLayer {
        let startPath = CGPathCreateWithEllipseInRect(CGRect.circleFrame(withCenter: bounds.center, radius: 10), nil)
        let endPath = CGPathCreateWithEllipseInRect(bounds, nil)
        
        let shape = CAShapeLayer()
        shape.speed = 0
        shape.timeOffset = 0
        layer.addSublayer(shape)
        
        
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.fromValue = startPath
        basicAnimation.toValue = endPath
        basicAnimation.duration = maximumDuration
        basicAnimation.removedOnCompletion = false
        basicAnimation.delegate = self
        shape.addAnimation(basicAnimation, forKey: "animation")
        
        return shape
    }
    
    override func animationDidStart(anim: CAAnimation) {
        print("Started animation \(anim)")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("Stopped animation \(anim) with finished \(flag)")
    }
    
    var animationTimer: NSTimer? = nil
    
    func beginAnimation() {
        print("Begin animation")
        if fillShapeLayer == nil {
            fillShapeLayer = constructFillShapeLayer()
        }
        
        animationTimer?.invalidate()
        animationTimer = NSTimer.schedule(interval: 0.1, repeats: true, block: { [unowned self] () -> Void in
            if self.layer.timeOffset >= 1.0 {
                self.layer.timeOffset = self.maximumDuration
            }
            else {
                self.layer.timeOffset += 0.1
            }
        })
    }
    
    func reverseAnimation() {
        print("Reverse animation")
        guard let fillAnimationLayer = fillShapeLayer, let _ = fillAnimationLayer.animationForKey("animation") else {
            print("Animation not found")
            return
        }
        
        animationTimer?.invalidate()
        animationTimer = NSTimer.schedule(interval: 0.1, repeats: true, block: { [unowned self] () -> Void in
            if self.layer.timeOffset <= 0.0 {
                self.layer.timeOffset = 0.0
            }
            else {
                self.layer.timeOffset -= 0.1
            }
        })
    }
    
    func animationTimeOffsetToPercentage(percentage: Double) {
        if fillShapeLayer == nil {
            fillShapeLayer = constructFillShapeLayer()
        }
        
        guard let fillAnimationLayer = fillShapeLayer, let _ = fillAnimationLayer.animationForKey("animation") else {
            print("Animation not found")
            return
        }
        
        animationTimer?.invalidate()
        animationTimer = nil
        
        let timeOffset = maximumDuration * percentage
        print("Set animation to percentage \(percentage) with timeOffset: \(timeOffset)")
        
        fillAnimationLayer.timeOffset = timeOffset
    }
}
