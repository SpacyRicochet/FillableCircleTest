//
//  AnimatableCircleView.swift
//
//  Created by Bruno Scheele on 26/01/16.
//  Copyright © 2016 Noodlewerk Apps. All rights reserved.
//

import UIKit

class FillAnimationCircleView : CircleView {
    
    let maximumDuration = 5.0
    var _startPath: AnyObject? = nil
    var _endPath: AnyObject? = nil
    
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
        _startPath = CGPathCreateWithEllipseInRect(CGRect.circleFrame(withCenter: bounds.center, radius: 10), nil)
        _endPath = CGPathCreateWithEllipseInRect(bounds, nil)
        
        let shape = CAShapeLayer()
//        shape.speed = 0
//        shape.timeOffset = 0
        layer.addSublayer(shape)
        
        return shape
    }
    
    func setAnimation(layer: CAShapeLayer, startPath: AnyObject, endPath: AnyObject, duration: Double, timeOffset: Double)
    {
        let time = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        let begintime = layer.beginTime
        var diff = 0.0
        if begintime > 0
        {
            diff = begintime - time
        }
        if let animation = layer.animationForKey("animation")
        {
            print(animation)
            layer.removeAnimationForKey("amimation")
        }
        let basicAnimation = CABasicAnimation(keyPath: "path")
        basicAnimation.fromValue = startPath
        basicAnimation.toValue = endPath
        basicAnimation.duration = maximumDuration
        basicAnimation.removedOnCompletion = false
        basicAnimation.delegate = self
        basicAnimation.beginTime = diff
        basicAnimation.speed = 1.0
        layer.addAnimation(basicAnimation, forKey: "animation")
    }
    
    override func animationDidStart(anim: CAAnimation) {
        print("Started animation \(anim)")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("Stopped animation \(anim) with finished \(flag)")
    }
    
    
    func beginAnimation() {
        print("Begin animation")
        if fillShapeLayer == nil {
            fillShapeLayer = constructFillShapeLayer()
        }
        
        let offset = fillShapeLayer!.timeOffset
//        let reverse = maximumDuration - offset

        setAnimation(fillShapeLayer!, startPath: _startPath!, endPath: _endPath!, duration: maximumDuration, timeOffset: offset)
    }
    
    func reverseAnimation() {
        print("Reverse animation")
        let offset = fillShapeLayer!.convertTime(CACurrentMediaTime(), fromLayer: nil)
        let reverse = maximumDuration - offset
        
        setAnimation(fillShapeLayer!, startPath: _endPath!, endPath: _startPath!, duration: maximumDuration, timeOffset: reverse)
    }
    
}
