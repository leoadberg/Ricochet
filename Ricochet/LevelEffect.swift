//
//  LevelEffect.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class LevelEffect: Hashable, Equatable {
    
    var hashValue = -1
    
    init(effectID: Int) {
        self.hashValue = effectID
    }
    
    func update(timeSinceLastUpdate: Double, inout _ ball: Ball, inout _ obstacle: SKShapeNode) {}
    
}

func == (lhs: LevelEffect, rhs: LevelEffect) -> Bool {
    return lhs.hashValue == rhs.hashValue
}