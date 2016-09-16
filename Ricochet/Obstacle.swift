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
        
        switch(shapeID) {
            
        case 0:
            super.path = CGPath(rect: CGRect(origin: CGPoint(x: -SWOVER2, y: -length / 2), size: CGSize(width: SCREEN_WIDTH, height: length)), transform: nil)
            
        case 1:
            super.path = CGPath(rect: CGRect(origin: CGPoint(x: -length / 2, y: -length / 2), size: CGSize(width: length, height: length)), transform: nil)
            
        case 2:
            super.path = CGPath(ellipseIn: CGRect(x: -length / 2, y: -length / 2, width: length, height: length), transform: nil)
            
        default:
            super.path = CGPath(rect: CGRect(origin: CGPoint(x: -length * 3, y: -length * 3), size: CGSize(width: length, height: length)), transform: nil)
            
        }
    }
    
    func move(_ touch: CGPoint, _ currentLevel: inout Level) {
        
        if (limited && self.numAvailable < 1) {
            return
        }
        
        self.numAvailable -= 1
        
        switch (shapeID) {
            
        case 0:
            let touchLoc: [CGFloat] = [touch.x, touch.y]
            
            let newActiveWall = minimum(distanceBetween(touchLoc, TOP_CENTER),
                                        distanceBetween(touchLoc, RIGHT_CENTER),
                                        distanceBetween(touchLoc, BOTTOM_CENTER),
                                        distanceBetween(touchLoc, LEFT_CENTER))
            
            currentLevel.activeWalls = [false, false, false, false]
            currentLevel.activeWalls[newActiveWall] = true
            
            switch (newActiveWall) {
                
            case Wall.Top.rawValue:
                super.position = CGPoint(x: SWOVER2, y: self.length * 1.5 - wallThickness)
                
            case Wall.Right.rawValue:
                super.position = CGPoint(x: SCREEN_WIDTH * 3 / 2 - wallThickness, y: self.length / 2)
                
            case Wall.Bottom.rawValue:
                super.position = CGPoint(x: SWOVER2, y: self.length / -2 + wallThickness)
                
            case Wall.Left.rawValue:
                super.position = CGPoint(x: SCREEN_WIDTH / -2 + wallThickness, y: self.length / 2)
                
            default:
                super.position = CGPoint(x: -3 * self.length, y: -3 * self.length)
                
            }
            
        case 1,
             2:
            super.position = CGPoint(x: touch.x, y: touch.y)
            
        default:
            return
            
        }
        
    }
    
    func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball) -> Int {
        
        return self.checkBallCollision(timeSinceLastUpdate, &ball)
        
    }
    
    func checkBallCollision(_ timeSinceLastUpdate: Double, _ ball: inout Ball) -> Int {
        
        var plus: Int = 0
        
        switch (self.shapeID) {
            
        case 0:
            
            if (abs(ball.position.y - super.position.y) < (self.length / 2 + ball.radius) && abs(ball.position.x - super.position.x) < (SCREEN_WIDTH / 2 + ball.radius)) {
                if (!ball.colliding) {
                    if (abs(ball.position.y - super.position.y) > abs(ball.position.x - super.position.x) * SCREEN_RATIO){
                        ball.ySpeed = ball.position.y >= super.position.y ? abs(ball.ySpeed) : abs(ball.ySpeed) * -1
                    }
                    else {
                        ball.xSpeed = ball.position.x >= super.position.x ? abs(ball.xSpeed) : abs(ball.xSpeed) * -1
                    }
                    
                    ball.updatePolar()
                    ball.speedUp()
                    plus = 1
                    
                    self.numAvailable += numPerBounce
                }
                
                ball.colliding = true
                
            }
            else {
                
                ball.colliding = false
                
            }
            
        case 1:
            
            let dist: CGFloat = distanceBetween([ball.position.x, ball.position.y], [self.position.x, self.position.y])
            let angle: CGFloat = atan2(ball.position.y - self.position.y, ball.position.x - self.position.x)
            
            let ballPseudoX: CGFloat = self.position.x + dist * cos(angle - self.zRotation)
            let ballPseudoY: CGFloat = self.position.y + dist * sin(angle - self.zRotation)
            
            var closestX: CGFloat = 0.0
            if (ballPseudoX < (super.position.x - (self.length / 2))) {
                closestX = super.position.x - (self.length / 2)
            }
            else if (ballPseudoX > (super.position.x + (self.length / 2))) {
                closestX = super.position.x + (self.length / 2)
            }
            else {
                closestX = ballPseudoX
            }
            
            var closestY: CGFloat = 0.0
            if (ballPseudoY < (super.position.y - (self.length / 2))) {
                closestY = super.position.y - (self.length / 2)
            }
            else if (ballPseudoY > (super.position.y + (self.length / 2))) {
                closestY = super.position.y + (self.length / 2)
            }
            else {
                closestY = ballPseudoY
            }
            
            if (distanceBetween([ballPseudoX, ballPseudoY], [closestX, closestY]) < ball.radius) {
                
                if (!ball.colliding){
                    
                    var ballPseudoXSpeed: Double = Double(ball.speed * cos(CGFloat(ball.angle) - self.zRotation))
                    var ballPseudoYSpeed: Double = Double(ball.speed * sin(CGFloat(ball.angle) - self.zRotation))
                    
                    if (abs(ballPseudoY - super.position.y) > abs(ballPseudoX - super.position.x)){
                        ballPseudoYSpeed = ballPseudoY >= super.position.y ? abs(ballPseudoYSpeed) : abs(ballPseudoYSpeed) * -1
                    }
                    else {
                        ballPseudoXSpeed = ballPseudoX >= super.position.x ? abs(ballPseudoXSpeed) : abs(ballPseudoXSpeed) * -1
                    }
                    
                    ball.speed = CGFloat(sqrt(ballPseudoXSpeed * ballPseudoXSpeed + ballPseudoYSpeed * ballPseudoYSpeed))
                    ball.angle = atan2(ballPseudoYSpeed, ballPseudoXSpeed) + Double(self.zRotation)
                    
                    ball.updateCartesian()
                    ball.speedUp()
                    plus = 1
                    
                    self.numAvailable += numPerBounce
                }
                
                ball.colliding = true
                
            }
            else {
                
                ball.colliding = false
                
            }
            
        case 2:
            
            if (pow(Double(ball.position.y - super.position.y), 2.0) + pow(Double(ball.position.x - super.position.x),2.0) < pow(Double(self.length / 2 + ball.radius),2.0)){
                if (!ball.colliding){
                    let nx: Double = Double(ball.position.x - super.position.x)
                    let ny: Double = Double(ball.position.y - super.position.y)
                    let mxy: Double = (Double(ball.xSpeed) * nx + Double(ball.ySpeed) * ny)
                    let dxy: Double = (nx * nx + ny * ny)
                    let mdxy: Double = mxy / dxy
                    let ux: Double = mdxy * nx
                    let uy: Double = mdxy * ny
                    let wx: Double = Double(ball.xSpeed) - ux
                    let wy: Double = Double(ball.ySpeed) - uy
                    ball.xSpeed = CGFloat(wx - ux)
                    ball.ySpeed = CGFloat(wy - uy)
                    
                    ball.updatePolar()
                    ball.speedUp()
                    plus = 1
                    
                    self.numAvailable += numPerBounce
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
