//
//  LimitedObstacles.swift
//  Ricochet
//
//  Created by Brandon on 4/4/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class LimitedObstacles: LevelEffect {
    
    var numPerSecond: Double = 0.0
    var timeSinceLastAddition: Double = 0.0
    
    var startingNum: Int = 0
    var numPerBounce: Int = 0
    
    init(numPerSecond: Double = 0.0, numPerBounce: Int = 0, startingNum: Int = 0) {
        
        self.numPerSecond = numPerSecond
        self.numPerBounce = numPerBounce
        self.startingNum = startingNum
        
    }
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        timeSinceLastAddition += timeSinceLastUpdate
        
        if (timeSinceLastAddition * numPerSecond > 1) {
            
            obstacle.numAvailable += 1
            timeSinceLastAddition -= 1 / numPerSecond
            
        }
        
    }
    
    override func initialize( _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        obstacle.limited = true
        obstacle.numPerBounce = self.numPerBounce
        obstacle.numAvailable = self.startingNum
        
    }
    
    override func getID() -> Int {
        return 4
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(numPerSecond)
    }
    override func getArg2() -> CGFloat {
        return CGFloat(numPerBounce)
    }
    override func getArg3() -> CGFloat {
        return CGFloat(startingNum)
    }
    
}

