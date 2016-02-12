//
//  AnimatableCircleView.swift
//
//  Created by Bruno Scheele on 26/01/16.
//  Copyright © 2016 Noodlewerk Apps. All rights reserved.
//
// Inspiration from:
// http://ronnqvi.st/controlling-animation-timing/
// https://developer.apple.com/library/ios/qa/qa1673/_index.html#//apple_ref/doc/uid/DTS40010053

import UIKit

class FillAnimationCircleView : CircleView {
    
    let maximumDuration = 0.5
    
    var startPath: AnyObject? = nil
    var endPath: AnyObject? = nil
    var startTime: CFTimeInterval = 0.0

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
    
    func constructFillShapeLayer() -> CAShapeLayer {
        startPath = CGPathCreateWithEllipseInRect(CGRect.circleFrame(withCenter: bounds.center, radius: 0), nil)
        endPath = CGPathCreateWithEllipseInRect(bounds, nil)
        
        let shape = CAShapeLayer()
        layer.addSublayer(shape)
        
        return shape
    }
    
    func setAnimation(layer: CAShapeLayer, startPath: AnyObject, endPath: AnyObject, duration: Double)
    {
        // Always create a new animation.
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        
        if let currentAnimation = layer.animationForKey("animation") as? CABasicAnimation {
            // If an animation exists, reverse it.
            animation.fromValue = currentAnimation.toValue
            animation.toValue = currentAnimation.fromValue
            
            let pauseTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
            // For the timeSinceStart, we take the minimum from the duration or the time passed. 
            // If not, holding the animation longer than its duration would cause a delay in the reverse animation.
            let timeSinceStart = min(pauseTime - startTime, currentAnimation.duration)
            
            // Now convert for the reverse animation.
            let reversePauseTime = currentAnimation.duration - timeSinceStart
            animation.beginTime = pauseTime - reversePauseTime
            
            // Remove the old animation
            layer.removeAnimationForKey("animation")
            // Reset startTime, to be when the reverse WOULD HAVE started.
            startTime = animation.beginTime
        }
        else {
            // This happens when there is no current animation.
            startTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
            
            animation.fromValue = startPath
            animation.toValue = endPath
        }
        
        animation.duration = duration
        animation.fillMode = kCAFillModeForwards // These lines are important to keep the animation at its final frame.
        animation.removedOnCompletion = false    // If not, the animation would remove itself before showing a reverse.
        
        layer.addAnimation(animation, forKey: "animation")
    }
    
    func beginAnimation() {
        print("Begin animation")
        if fillShapeLayer == nil {
            fillShapeLayer = constructFillShapeLayer()
        }
        setAnimation(fillShapeLayer!, startPath: startPath!, endPath: endPath!, duration: maximumDuration)
    }
    
    func reverseAnimation() {
        print("Reverse animation")
        setAnimation(fillShapeLayer!, startPath: startPath!, endPath: endPath!, duration: maximumDuration)
    }
}
