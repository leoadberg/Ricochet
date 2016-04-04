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
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 2, y: -length / 2), size: CGSize(width: SCREEN_WIDTH, height: length)), nil)
            
        case 1:
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length / 2, y: -length / 2), size: CGSize(width: length, height: length)), nil)
            
        case 2:
            super.path = CGPathCreateWithEllipseInRect(CGRectMake(-length / 2, -length / 2, length, length), nil)
            
        default:
            super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -length * 3, y: -length * 3), size: CGSize(width: length, height: length)), nil)
            
        }
    }
    
    func move(touch: CGPoint, inout _ currentLevel: Level) {
        
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
                super.position = CGPoint(x: SCREEN_WIDTH / 2, y: self.length * 1.5 - wallThickness)
                
            case Wall.Right.rawValue:
                super.position = CGPoint(x: SCREEN_WIDTH * 3 / 2 - wallThickness, y: self.length / 2)
                
            case Wall.Bottom.rawValue:
                super.position = CGPoint(x: SCREEN_WIDTH / 2, y: self.length / -2 + wallThickness)
                
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
    
    func update(timeSinceLastUpdate: Double, inout _ ball: Ball) -> Int {
        
        return self.checkBallCollision(timeSinceLastUpdate, &ball)
        
    }
    
    func checkBallCollision(timeSinceLastUpdate: Double, inout _ ball: Ball) -> Int {
        
        var plus: Int = 0
        
        switch (self.shapeID) {
            
        case 0:
            if (abs(ball.position.y - super.position.y) < (self.length / 2 + ball.radius) && abs(ball.position.x - super.position.x) < (SCREEN_WIDTH / 2 + ball.radius)) {
                if (!ball.colliding) {
                    if (abs(ball.position.y - super.position.y) > abs(ball.position.x - super.position.x) * SCREEN_HEIGHT / SCREEN_WIDTH){
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
        case 1:
            
            let dist = distanceBetween([ball.position.x, ball.position.y], [self.position.x, self.position.y])
            let angle = atan2(ball.position.y - self.position.y, ball.position.x - self.position.x)
            
            let ballPseudoX = self.position.x + dist * cos(angle - self.zRotation)
            let ballPseudoY = self.position.y + dist * sin(angle - self.zRotation)
            
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
                }
                
                ball.colliding = true
                
            }
            else {
                
                ball.colliding = false
                
            }
            /*
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
            */
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