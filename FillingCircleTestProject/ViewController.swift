//
//  ViewController.swift
//  FillingCircleTestProject
//
//  Created by Bruno Scheele on 27/01/16.
//  Copyright © 2016 Bruno Scheele. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var circle: FillAnimationCircleView!
    
    @IBAction func pressed(longPress: UILongPressGestureRecognizer) {
        let location = longPress.locationInView(view)
        
        switch longPress.state {
        case .Possible:
            beginActiveAnimation(withLocation: location)
        case .Began:
            beginActiveAnimation(withLocation: location)
        case .Changed:
            continueActiveAnimation(withLocation: location)
        case .Ended:
            endActiveAnimation()
        case .Cancelled:
            endActiveAnimation()
        case .Failed:
            endActiveAnimation()
        }
    }
    
    // MARK: - Animations
    
    private func beginActiveAnimation(withLocation location: CGPoint) {
        circle.beginAnimation()
    }
    
    private func continueActiveAnimation(withLocation location: CGPoint) {
    }
    
    private func endActiveAnimation() {
        circle.reverseAnimation()
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        circle.animationTimeOffsetToPercentage(Double(sender.value))
    }
}

