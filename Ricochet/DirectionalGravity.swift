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
        super.init()
        self.xMagnitude = x
        self.yMagnitude = y
        
        let gravityLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
        gravityLabel.text = "→"
        gravityLabel.verticalAlignmentMode = .Center
        gravityLabel.fontColor = SKColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        gravityLabel.fontSize = SCREEN_WIDTH / 6
        gravityLabel.zRotation = atan2(-CGFloat(x),CGFloat(y)) + CGFloat(M_PI / 2)
        visualEffect.addChild(gravityLabel)
        visualEffect.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 5)
        visualEffect.zPosition = -2
        
    }
    
    override func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: Obstacle) {
        
        ball.xSpeed += CGFloat(xMagnitude * timeSinceLastUpdate)
        ball.ySpeed += CGFloat(yMagnitude * timeSinceLastUpdate)
        
    }
    
}