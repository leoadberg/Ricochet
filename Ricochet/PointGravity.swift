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
    
        let xDist = abs(self.xLocation * Double(SCREEN_WIDTH) - Double(ball.position.x)) * 1 + 10
        let yDist = abs(self.yLocation * Double(SCREEN_HEIGHT) - Double(ball.position.y)) * 1 + 10
        
        var gravityForce : Double = 0
        if (abs(xDist) + abs(yDist) > 30) {
            gravityForce = self.strength / (pow(xDist, 2) + pow(yDist, 2))
        }

        var deltaXSpeed = CGFloat(gravityForce * (self.xLocation * Double(SCREEN_WIDTH) - Double(ball.position.x)))
        
        deltaXSpeed = deltaXSpeed / CGFloat(xDist + yDist)
        ball.xSpeed += deltaXSpeed
        let deltaYSpeed = CGFloat(gravityForce * (self.yLocation * Double(SCREEN_HEIGHT) - Double(ball.position.y)) / (xDist + yDist))
        ball.ySpeed += deltaYSpeed
        
    }
    
}