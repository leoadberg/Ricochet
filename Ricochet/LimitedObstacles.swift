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
    
    init(numPerSecond: Double) {
        
        self.numPerSecond = numPerSecond
        
    }
    
    override func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: Obstacle) {
        
        timeSinceLastAddition += timeSinceLastUpdate
        
        if (timeSinceLastAddition * numPerSecond > 1) {
            
            obstacle.numAvailable += 1
            timeSinceLastAddition -= 1 / numPerSecond
            
        }
        
    }
    
}

