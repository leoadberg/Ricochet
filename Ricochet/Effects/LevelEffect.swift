//
//  LevelEffect.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class LevelEffect {
    
    init(){}
    
    func initialize(_ ball: inout Ball, _ obstacle: inout Obstacle) { }
    
    func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {
		fatalError("update() not implemented")
	}
    
    func getID() -> Int {
		fatalError("getID() not implemented")
	}
	
    func getArg1() -> CGFloat {
		fatalError("getArg1() not implemented")
	}
    func getArg2() -> CGFloat {
		fatalError("getArg2() not implemented")
	}
    func getArg3() -> CGFloat {
		fatalError("getArg3() not implemented")
	}
	func getSliders() -> [Slider] {
		fatalError("getSliders() not implemented")
	}
	
	func name() -> String {
		fatalError("name() not implemented")
	}
	
	func getDict() -> NSMutableDictionary {
		fatalError("getDict() not implemented")
	}
	
	func updateWithSliders(_ sliders: [Slider]) {
		fatalError("updateWithSliders() not implemented")
	}
    
    var visualEffect: SKNode = SKNode()
    
}
