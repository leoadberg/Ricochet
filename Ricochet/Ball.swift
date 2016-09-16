//
//  Ball.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKShapeNode {
    
    // Ball Speed in unitLength / second
    var radius: CGFloat = 0.0
    var spd: CGFloat = 0.0
    var angle: Double = 0.0
    var xSpeed: CGFloat = 0.0
    var ySpeed: CGFloat = 0.0
    var maxSpeed: CGFloat = 0.0
    var speedMult: CGFloat = 0.0
    
    var colliding: Bool = false
    
    init(radius: CGFloat = SWOVER12, maxSpeed: CGFloat = SCREEN_WIDTH * 6, speedMult: CGFloat = 0.01, initialSpeed: CGFloat = 1, initialAngle: Double = M_PI / 4) {
        
        super.init()
        
        self.radius = radius
        self.spd = initialSpeed
        self.angle = initialAngle
        self.maxSpeed = maxSpeed
        self.speedMult = speedMult
        
    }
    
    func draw() {
        super.path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2), transform: nil)
    }
    
    func update(timeSinceLastUpdate: Double) {
        super.position.x += CGFloat(Double(self.xSpeed) * timeSinceLastUpdate)
        super.position.y += CGFloat(Double(self.ySpeed) * timeSinceLastUpdate)
    }
    
    func updateCartesian() {
        self.xSpeed = self.spd * CGFloat(cos(self.angle))
        self.ySpeed = self.spd * CGFloat(sin(self.angle))
    }
    
    func updatePolar() {
        self.spd = sqrt(self.xSpeed * self.xSpeed + self.ySpeed * self.ySpeed)
        self.angle = atan2(Double(self.ySpeed), Double(self.xSpeed))
    }
    
    func speedUp() {
        let deltaMax: Double = Double(self.maxSpeed) - Double(self.spd)
        self.spd += CGFloat(deltaMax * Double(self.speedMult))
        
        self.updateCartesian()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
