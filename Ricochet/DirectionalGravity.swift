//
//  DirectionalGravity.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class DirectionalGravity: LevelEffect {
    
    var xMagnitude: Double = 0.0
    var yMagnitude: Double = 0.0
    
    init(x: Double, y: Double) {
        /*
        super.init(effectID: 0)
        */
        self.xMagnitude = x
        self.yMagnitude = y
        
    }
    
    override func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: SKShapeNode) {
        
        ball.xSpeed += CGFloat(xMagnitude * timeSinceLastUpdate)
        ball.ySpeed += CGFloat(yMagnitude * timeSinceLastUpdate)
        
    }
    
}