//
//  ResizingObstacle.swift
//  Ricochet
//
//  Created by Brandon on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class ResizingObstacle: LevelEffect {
    
    var rate: Double = 0.0
    var maxScale: Double = -1.0
    var minScale: Double = -1.0
    var scale: Double = 1.0
	
	convenience override init() {
		self.init(["EffectID": 3 as AnyObject, "Resize Rate": 1.0 as AnyObject, "Max Scale": 1.0 as AnyObject, "Min Scale": 1.0 as AnyObject])
	}
    
    init(_ dict: NSDictionary) {
        self.rate = dict["Resize Rate"] as! Double
        self.maxScale = dict["Max Scale"] as! Double
        self.minScale = dict["Min Scale"] as! Double
    }
	
	override func getDict() -> NSMutableDictionary {
		let ret = NSMutableDictionary()
		ret.setValue(self.getID(), forKey: "EffectID")
		ret.setValue(getArg1(), forKey: "Resize Rate")
		ret.setValue(getArg2(), forKey: "Max Scale")
		ret.setValue(getArg3(), forKey: "Min Scale")
		return ret
	}
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        scale += self.rate * timeSinceLastUpdate
        obstacle.setScale(CGFloat(self.scale))
        obstacle.lineWidth = 4 / CGFloat(self.scale)
        
        if (rate > 0 && self.scale > self.maxScale || rate < 0 && self.scale < self.minScale) {
            rate *= -1
        }
        
    }
    
    override func getID() -> Int {
        return 3
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(rate)
    }
    override func getArg2() -> CGFloat {
        return CGFloat(maxScale)
    }
    override func getArg3() -> CGFloat {
        return CGFloat(minScale)
    }
	
	override func getSliders() -> [Slider] {
		return [Slider("Speed", 0.1, 5, 0.01, getArg1()),
				Slider("Min size", 0.1, 5, 0.01, getArg2()),
				Slider("Max size", 0.1, 5, 0.01, getArg3())]
	}
	
	override func updateWithSliders(_ sliders: [Slider]) {
		rate = Double(sliders[0].sliderValue)
		maxScale = Double(sliders[1].sliderValue)
		minScale = Double(sliders[2].sliderValue)
	}
	
	override func name() -> String {
		return "Resizing Obstacle"
	}
    
}
