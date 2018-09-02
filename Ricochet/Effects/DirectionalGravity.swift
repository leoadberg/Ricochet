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
        gravityLabel.verticalAlignmentMode = .center
        gravityLabel.fontColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        gravityLabel.fontSize = SCREEN_WIDTH / 6
        gravityLabel.zRotation = atan2(-CGFloat(x),CGFloat(y)) + CGFloat(Double.pi / 2)
        visualEffect.addChild(gravityLabel)
        visualEffect.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 5)
        visualEffect.zPosition = -2
        
    }
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        ball.xSpeed += CGFloat(xMagnitude * timeSinceLastUpdate)
        ball.ySpeed += CGFloat(yMagnitude * timeSinceLastUpdate)
        
    }
    
    override func getID() -> Int {
        return 0
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(xMagnitude)
    }
    override func getArg2() -> CGFloat {
        return CGFloat(yMagnitude)
    }
    
}
