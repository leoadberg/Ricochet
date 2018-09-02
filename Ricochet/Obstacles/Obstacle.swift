//
//  Obstacle.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKShapeNode {
    
    var shapeID: Int = -1
    var length: CGFloat = 0.0
    var startLength: CGFloat = 0.0
    var limited: Bool = false
    var numAvailable: Int = -1
    var numPerBounce: Int = 0
    
    init(shapeID: Int = -1, length: CGFloat = SCREEN_WIDTH / 5) {
        
        super.init()
        
        self.shapeID = shapeID
        self.length = length
        self.startLength = self.length
        
        super.position = CGPoint(x: SCREEN_HEIGHT * -3, y: SCREEN_HEIGHT * -3)
        super.zPosition = 1
        super.fillColor = COLOR_FADED_RED
        super.lineWidth = 4
        
    }
    
    func draw() {
        fatalError("draw has not been implemented")
    }
    
    func move(_ touch: CGPoint, _ currentLevel: inout Level) {
        fatalError("move has not been implemented")
    }
    
    func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball) -> Int {
        
        return self.checkBallCollision(timeSinceLastUpdate, &ball)
        
    }
    
    func checkBallCollision(_ timeSinceLastUpdate: Double, _ ball: inout Ball) -> Int {
        fatalError("checkBallCollision has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
