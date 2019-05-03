//
//  LimitedObstacles.swift
//  Ricochet
//
//  Created by Brandon on 4/4/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class LimitedObstacles: LevelEffect {
    
    var numPerSecond: Double = 0.0
    var timeSinceLastAddition: Double = 0.0
    
    var startingNum: Int = 0
    var numPerBounce: Int = 0
	
	convenience override init() {
		self.init(["EffectID": 4 as AnyObject, "Obstacles per second": 1.0 as AnyObject, "Obstacles per bounce": 1.0 as AnyObject, "Starting Obstacles": 1.0 as AnyObject])
	}
	
    init(_ dict: NSDictionary) {
        self.numPerSecond = dict["Obstacles per second"] as! Double
        self.numPerBounce = dict["Obstacles per bounce"] as! Int
        self.startingNum = dict["Starting Obstacles"] as! Int
    }
	
	override func getDict() -> NSMutableDictionary {
		let ret = NSMutableDictionary()
		ret.setValue(self.getID(), forKey: "EffectID")
		ret.setValue(getArg1(), forKey: "Obstacles per second")
		ret.setValue(getArg2(), forKey: "Obstacles per bounce")
		ret.setValue(getArg3(), forKey: "Starting Obstacles")
		return ret
	}
    
    override func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        timeSinceLastAddition += timeSinceLastUpdate
        
        if (timeSinceLastAddition * numPerSecond > 1) {
            
            obstacle.numAvailable += 1
            timeSinceLastAddition -= 1 / numPerSecond
            
        }
        
    }
    
    override func initialize( _ ball: inout Ball, _ obstacle: inout Obstacle) {
        
        obstacle.limited = true
        obstacle.numPerBounce = self.numPerBounce
        obstacle.numAvailable = self.startingNum
        
    }
    
    override func getID() -> Int {
        return 4
    }
    
    override func getArg1() -> CGFloat {
        return CGFloat(numPerSecond)
    }
    override func getArg2() -> CGFloat {
        return CGFloat(numPerBounce)
    }
    override func getArg3() -> CGFloat {
        return CGFloat(startingNum)
    }
	
	override func getSliders() -> [Slider] {
		return [Slider("Num / sec", 0, 5, 1, getArg1(), int: true),
				Slider("Num / bounce", 0, 5, 1, getArg2(), int: true),
				Slider("Starting num", 0, 10, 1, getArg3(), int: true)]
	}
	
	override func updateWithSliders(_ sliders: [Slider]) {
		numPerSecond = Double(sliders[0].sliderValue)
		numPerBounce = Int(sliders[1].sliderValue)
		startingNum = Int(sliders[2].sliderValue)
	}
	
	override func name() -> String {
		return "Limited Obstacles"
	}
    
}

