//
//  SquareObstacle.swift
//  Ricochet
//
//  Created by Leo Adberg on 9/1/18.
//  Copyright © 2018 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class SquareObstacle: Obstacle {
	override func draw() {
		super.path = CGPath(rect: CGRect(origin: CGPoint(x: -length / 2, y: -length / 2), size: CGSize(width: length, height: length)), transform: nil)
	}
	
	override func move(_ touch: CGPoint, _ currentLevel: inout Level) {
		
		if (limited && self.numAvailable < 1) {
			return
		}
		
		self.numAvailable -= 1
		
		super.position = CGPoint(x: touch.x, y: touch.y)
	}
	
	override func checkBallCollision(_ timeSinceLastUpdate: Double, _ ball: inout Ball) -> Int {
		
		var plus: Int = 0
		
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
		
		return plus
	}
}
