//
//  NSTimer+Bubbl.swift
//
//  Created by Bruno Scheele on 18/11/15.
//  Copyright © 2015 Noodlewerk Apps. All rights reserved.
//
//  Inspiration from: http://blog.fivelakesstudio.com/2015/11/nstimer-and-blocks-closures.html
//               and: https://gist.github.com/radex/41a1e75bb1290fb5d559

import Foundation

private class TimerBlockContainer {
    private var timerBlock: (Void -> Void)
    
    required init(block: Void -> Void) {
        timerBlock = block
    }
    
    dynamic func fire() {
        timerBlock()
    }
}

extension NSTimer {
    class func schedule(interval interval: NSTimeInterval, block: Void -> Void) -> NSTimer {
        return schedule(interval: interval, repeats: false, block: block)
    }
    
    class func schedule(interval interval: NSTimeInterval, repeats: Bool, block: Void -> Void) -> NSTimer {
        let blockContainer = TimerBlockContainer(block: block)
        return scheduledTimerWithTimeInterval(interval, target: blockContainer, selector: "fire", userInfo: nil, repeats: repeats)
    }
}

