//
//  DirectionalGravity.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation

class DirectionalGravity: LevelEffect {
    
    var xMagnitude: Double = 0.0
    var yMagnitude: Double = 0.0
    
    init(x: Double, y: Double) {
        
        super.init(effectID: 0)
        
        self.xMagnitude = x
        self.yMagnitude = y
        
    }
    
    override func update(scene: UnsafeMutablePointer<GameScene>, _ timeSinceLastUpdate: Double) {
        
        scene.memory.ball_xSpeed += Double(xMagnitude) * timeSinceLastUpdate
        scene.memory.ball_ySpeed += Double(yMagnitude) * timeSinceLastUpdate
        
    }
    
}