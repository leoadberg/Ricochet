//
//  Wall.swift
//  Ricochet
//
//  Created by Leo Adberg on 9/1/18.
//  Copyright © 2018 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class WallObstacle: Obstacle {
	override func draw() {
		super.path = CGPath(rect: CGRect(origin: CGPoint(x: -SWOVER2, y: -length / 2), size: CGSize(width: SCREEN_WIDTH, height: length)), transform: nil)
	}
	
	override func move(_ touch: CGPoint, _ currentLevel: inout Level) {
		
		if (limited && self.numAvailable < 1) {
			return
		}
		
		self.numAvailable -= 1
		
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
			
		default: // Off screen
			super.position = CGPoint(x: -3 * self.length, y: -3 * self.length)
			
		}
	}
	
	override func checkBallCollision(_ timeSinceLastUpdate: Double, _ ball: inout Ball) -> Int {
		
		var plus: Int = 0
		
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
		
		return plus
	}
}
