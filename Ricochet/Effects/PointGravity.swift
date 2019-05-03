//
//  PointGravity.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class PointGravity: LevelEffect {
    
    var xLocation: Double = 0.0
    var yLocation: Double = 0.0
    var strength : Double = 0.0
	
	convenience override init() {
		self.init(["EffectID": 1 as AnyObject, "Gravity X": 0.5 as AnyObject, "Gravity Y": 0.5 as AnyObject, "Gravity Strength": 1.0 as AnyObject])
	}
    
    init(_ dict: NSDictionary) {
        super.init()
		
		let x = dict["Gravity X"] as! Double
		let y = dict["Gravity Y"] as! Double
		let str = dict["Gravity Strength"] as! Double
        
        self.xLocation = x
        self.yLocation = y
        self.strength = str
        
        let gravityLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
        gravityLabel.verticalAlignmentMode = .center
        if (str > 0) {
            gravityLabel.text = "→◎←"
        }
        else if (str < 0) {
            gravityLabel.text = "←◎→"
        }
        gravityLabel.fontColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        gravityLabel.fontSize = SCREEN_WIDTH / 8
        let gravityLabel2 = gravityLabel.copy() as! SKLabelNode
        gravityLabel2.zRotation = CGFloat(Double.pi) / 2.0
        visualEffect.addChild(gravityLabel)
        visualEffect.addChild(gravityLabel2)
        visualEffect.position = CGPoint(x: CGFloat(x) * SCREEN_WIDTH, y: CGFloat(y) * SCREEN_HEIGHT)
        visualEffect.zPosition = -2
    }
	
	override func getDict() -> NSMutableDictionary {
		let ret = NSMutableDictionary()
		ret.setValue(self.getID(), forKey: "EffectID")
		ret.setValue(getArg1(), forKey: "Gravity X")
		ret.setValue(getArg2(), forKey: "Gravity Y")
		ret.setValue(getArg3(), forKey: "Gravity Strength")
		return ret
	}
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
    
        let xDist: Double = abs(self.xLocation * Double(SCREEN_WIDTH) - Double(ball.position.x)) * 1 + 10
        let yDist: Double = abs(self.yLocation * Double(SCREEN_HEIGHT) - Double(ball.position.y)) * 1 + 10
        let xyDist: Double = xDist + yDist
        
        var gravityForce : Double = 0
        if (abs(xDist) + abs(yDist) > 30) {
            gravityForce = self.strength / (pow(xDist, 2) + pow(yDist, 2))
        }

        var deltaXSpeed = CGFloat(gravityForce * (self.xLocation * Double(SCREEN_WIDTH) - Double(ball.position.x)))
        
        deltaXSpeed = deltaXSpeed / CGFloat(xyDist)
        ball.xSpeed += deltaXSpeed
        let deltaYSpeed = CGFloat(gravityForce * (self.yLocation * Double(SCREEN_HEIGHT) - Double(ball.position.y)) / (xyDist))
        ball.ySpeed += deltaYSpeed
        
    }
    
    override func getID() -> Int {
        return 1
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(xLocation)
    }
    override func getArg2() -> CGFloat {
        return CGFloat(yLocation)
    }
	override func getArg3() -> CGFloat {
		return CGFloat(strength)
	}
	
	override func getSliders() -> [Slider] {
		return [Slider("X pos", 0, 1, 0.01, getArg1()),
				Slider("Y pos", 0, 1, 0.01, getArg2()),
				Slider("Strength", 0, 1, 0.01, getArg3())]
	}
	
	override func updateWithSliders(_ sliders: [Slider]) {
		xLocation = Double(sliders[0].sliderValue)
		yLocation = Double(sliders[1].sliderValue)
		strength = Double(sliders[2].sliderValue)
	}
	
	override func name() -> String {
		return "Point Gravity"
	}
    
}
