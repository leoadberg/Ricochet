//
//  LevelEffect.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation

class LevelEffect: Hashable, Equatable {
    
    var hashValue = -1
    
    init(effectID: Int) {
        self.hashValue = effectID
    }
    
    func update(scene: UnsafeMutablePointer<GameScene>, _ timeSinceLastUpdate: Double) {}
    
}

func == (lhs: LevelEffect, rhs: LevelEffect) -> Bool {
    return lhs.hashValue == rhs.hashValue
}