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
    
    func initialize(inout ball: Ball, inout _ obstacle: Obstacle) {}
    
    func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: Obstacle) {}
    
    var visualEffect: SKNode = SKNode()
    
}