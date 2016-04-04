//
//  ResizingObstacle.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class ResizingObstacle: LevelEffect {
    
    var rate: Double = 0.0
    var maxScale: Double = -1.0
    var minScale: Double = -1.0
    var scale: Double = 1.0
    
    init(rate: Double, maxScale: Double, minScale: Double) {
        
        self.rate = rate
        self.maxScale = maxScale
        self.minScale = minScale
        
    }
    
    override func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: Obstacle) {
        
        scale += self.rate * timeSinceLastUpdate
        obstacle.setScale(CGFloat(self.scale))
        obstacle.lineWidth = 4 / CGFloat(self.scale)
        
        if (rate > 0 && self.scale > self.maxScale || rate < 0 && self.scale < self.minScale) {
            rate *= -1
        }
        
    }
    
}
