//
//  CircleObstacle.swift
//  Ricochet
//
//  Created by Leo Adberg on 9/1/18.
//  Copyright © 2018 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class CircleObstacle: Obstacle {
	override func draw() {
		super.path = CGPath(ellipseIn: CGRect(x: -length / 2, y: -length / 2, width: length, height: length), transform: nil)
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
		
		return plus
	}
}
