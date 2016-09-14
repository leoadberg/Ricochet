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
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        obstacle.zRotation += CGFloat(self.rate * timeSinceLastUpdate)
        
    }
    
    override func getID() -> Int {
        return 2
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(rate)
    }
    
}
