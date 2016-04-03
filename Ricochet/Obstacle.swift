//
//  self.swift
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
    var rotateSpeed: CGFloat = 0.0
    var resizeSpeed: CGFloat = 0.0
    var minScale: Double = -1.0
    var maxScale: Double = -1.0
    
    init(shapeID: Int = -1, length: CGFloat = SCREEN_WIDTH / 5, rotateSpeed: CGFloat = 0.0, resizeSpeed: CGFloat = 0.0, minScale: Double = -1.0, maxScale: Double = -1.0) {
        
        super.init()
        
        self.shapeID = shapeID
        self.length = shapeID == 0 ? SCREEN_HEIGHT : length
        self.rotateSpeed = rotateSpeed
        self.resizeSpeed = resizeSpeed
        self.minScale = minScale
        self.maxScale = maxScale
        
        super.position = CGPoint(x: self.length * -3, y: self.length * -3)
        super.zPosition = 1
        super.fillColor = COLOR_FADED_RED
        super.lineWidth = 4
        
    }
    
    func draw() {
        
        switch(shapeID) {
            
        case 0,
             1:
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length / 3, y: -length / 3), size: CGSize(width: length, height: length)), nil)
            
        case 2:
            super.path = CGPathCreateWithEllipseInRect(CGRectMake(-length / 2, -length / 2, length, length), nil)
            
        default:
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length * 3, y: -length * 3), size: CGSize(width: length, height: length)), nil)
            
        }
    }
    
    func update(timeSinceLastUpdate: Double, inout _ ball: Ball) -> Int {
        
        var plus: Int = 0
        
        switch (self.shapeID) {
            
        case 0,
             1:
            if (abs(ball.position.y - super.position.y) < (self.length / 2 + ball.radius) && abs(ball.position.x - super.position.x) < (self.length / 2 + ball.radius)){
                if (!ball.colliding){
                    if (abs(ball.position.y - super.position.y) > abs(ball.position.x - super.position.x)){
                        ball.ySpeed = ball.position.y >= super.position.y ? abs(ball.ySpeed) : abs(ball.ySpeed) * -1
                    }
                    else {
                        ball.xSpeed = ball.position.x >= super.position.x ? abs(ball.xSpeed) : abs(ball.xSpeed) * -1
                    }
                    
                    ball.updatePolar()
                    ball.speedUp()
                    plus = 1
                }
                ball.colliding = true
            }
            else {
                ball.colliding = false
            }
        
        case 2:
            if (pow(Double(ball.position.y - super.position.y), 2.0) + pow(Double(ball.position.x - super.position.x),2.0) < pow(Double(self.length / 2 + ball.radius),2.0)){
                if (!ball.colliding){
                    let nx = Double(ball.position.x - super.position.x)
                    let ny = Double(ball.position.y - super.position.y)
                    let mxy = (Double(ball.xSpeed) * nx + Double(ball.ySpeed) * ny)
                    let dxy = (nx * nx + ny * ny)
                    let mdxy = mxy / dxy
                    let ux = mdxy * nx
                    let uy = mdxy * ny
                    let wx = Double(ball.xSpeed) - ux
                    let wy = Double(ball.ySpeed) - uy
                    ball.xSpeed = CGFloat(wx - ux)
                    ball.ySpeed = CGFloat(wy - uy)
                
                    ball.updatePolar()
                    ball.speedUp()
                    plus = 1
                }
                ball.colliding = true
            }
            else {
                ball.colliding = false
            }
        
        default:
            return 0
        }
        
        return plus
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}