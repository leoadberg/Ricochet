//
//  PointGravity.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class PointGravity: LevelEffect {
    
    var xLocation: Double = 0.0
    var yLocation: Double = 0.0
    var strength : Double = 0.0
    
    init(x: Double, y: Double, str: Double) {
        
        self.xLocation = x
        self.yLocation = y
        self.strength = str
        
    }
    
    override func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: SKShapeNode) {
    
        let xDist = abs(self.xLocation * Double(SCREEN_WIDTH) - ball.position.x) * 1 + 10
        let yDist = abs(self.yLocation * Double(SCREEN_HEIGHT) - ball.position.y) * 1 + 10
        
        var gravityForce : CGFloat = 0
        if (abs(xDist) + abs(yDist) > 30) {
            gravityForce = self.strength / (pow(xDist, 2) + pow(yDist, 2))
        }

        ball.xSpeed += CGFloat(gravityForce * (self.xLocation * Double(SCREEN_WIDTH) - ball.position.x) / (xDist + yDist))
        ball.ySpeed += CGFloat(gravityForce * (self.yLocation * Double(SCREEN_HEIGHT) - ball.position.y) / (xDist + yDist))
        
    }
    
}