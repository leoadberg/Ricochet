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
    
    func initialize(_ ball: inout Ball, _ obstacle: inout Obstacle) {}
    
    func update(_ timeSinceLastUpdate: Double, _ ball: inout Ball, _ obstacle: inout Obstacle) {}
    
    func getID() -> Int {return 0}
    func getArg1() -> CGFloat {return 0}
    func getArg2() -> CGFloat {return 0}
    func getArg3() -> CGFloat {return 0}
    
    var visualEffect: SKNode = SKNode()
    
}
