//
//  DirectionalGravity.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class DirectionalGravity: LevelEffect {
    
    var xMagnitude: Double = 0.0
    var yMagnitude: Double = 0.0
	
	convenience override init() {
		self.init(["EffectID": 0 as AnyObject, "Gravity X": -0.2 as AnyObject, "Gravity Y": 0.0 as AnyObject])
	}
    
    init(_ dict: NSDictionary) {
        super.init()
		let x = dict["Gravity X"] as! Double
		let y = dict["Gravity Y"] as! Double
        self.xMagnitude = x
        self.yMagnitude = y
        
        let gravityLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
        gravityLabel.text = "→"
        gravityLabel.verticalAlignmentMode = .center
        gravityLabel.fontColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        gravityLabel.fontSize = SCREEN_WIDTH / 6
        gravityLabel.zRotation = atan2(-CGFloat(x),CGFloat(y)) + CGFloat(Double.pi / 2)
        visualEffect.addChild(gravityLabel)
        visualEffect.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 5)
        visualEffect.zPosition = -2
        
    }
	
	override func getDict() -> NSMutableDictionary {
		let ret = NSMutableDictionary()
		ret.setValue(self.getID(), forKey: "EffectID")
		ret.setValue(getArg1(), forKey: "Gravity X")
		ret.setValue(getArg2(), forKey: "Gravity Y")
		return ret
	}
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        ball.xSpeed += CGFloat(xMagnitude * timeSinceLastUpdate)
        ball.ySpeed += CGFloat(yMagnitude * timeSinceLastUpdate)
        
    }
    
    override func getID() -> Int {
        return 0
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(xMagnitude)
    }
    override func getArg2() -> CGFloat {
        return CGFloat(yMagnitude)
    }
	
	override func getSliders() -> [Slider] {
		return [Slider("X strength", -1, 1, 0.01, getArg1()),
				Slider("Y strength", -1, 1, 0.01, getArg2())]
	}
	
	override func updateWithSliders(_ sliders: [Slider]) {
		xMagnitude = Double(sliders[0].sliderValue)
		yMagnitude = Double(sliders[1].sliderValue)
	}
	
	override func name() -> String {
		return "Directional Gravity"
	}
    
}
