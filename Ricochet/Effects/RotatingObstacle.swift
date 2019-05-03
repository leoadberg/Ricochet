//
//  RotatingObstacle.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class RotatingObstacle: LevelEffect {
	
    var rate: Double = 0.0
	
	convenience override init() {
		self.init(["EffectID": 2 as AnyObject, "Rotation Rate": 1 as AnyObject])
	}
	
	init(_ dict: NSDictionary) {
        self.rate = dict["Rotation Rate"] as! Double
    }
	
	override func getDict() -> NSMutableDictionary {
		let ret = NSMutableDictionary()
		ret.setValue(self.getID(), forKey: "EffectID")
		ret.setValue(getArg1(), forKey: "Rotation Rate")
		return ret
	}
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        obstacle.zRotation += CGFloat(self.rate * timeSinceLastUpdate)
    }
    
    override func getID() -> Int {
        return 2
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(rate)
    }
	
	override func getSliders() -> [Slider] {
		return [Slider("Speed", 0.1, 5, 0.01, getArg1())]
	}
	
	override func updateWithSliders(_ sliders: [Slider]) {
		rate = Double(sliders[0].sliderValue)
	}
	
	override func name() -> String {
		return "Rotating Obstacle"
	}
    
}
