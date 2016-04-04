//
//  RotatingObstacle.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class RotatingObstacle: LevelEffect {
    
    var rate: Double = 0.0
    
    init(rate: Double) {
        
        self.rate = rate
        
    }
    
    override func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: Obstacle) {
        
        obstacle.zRotation += CGFloat(self.rate * timeSinceLastUpdate)
        
    }
    
}
