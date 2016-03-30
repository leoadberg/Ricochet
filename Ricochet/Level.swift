//
//  Level.swift
//  Ricochet
//
//  Created by Tigersushi on 3/28/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKShapeNode {
    init(level: Int) {
        super.init()
        super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 9, y: -SCREEN_WIDTH / 9), size: CGSize(width: SCREEN_WIDTH * 2 / 9, height: SCREEN_WIDTH * 2 / 9)), nil)
        super.fillColor = COLOR_FADED_RED
        super.lineWidth = 4
        let label = SKLabelNode(fontNamed:"DINAlternate-Bold")
        label.fontSize = SCREEN_WIDTH / 6;
        label.text = String(level)
        label.position.x = super.position.x
        label.position.y = super.position.y - SCREEN_WIDTH / 16
        super.addChild(label)
        super.name = "Level"+String(level)
        levelNumber = level
    }
    
    var levelNumber = 0
    var scoreRequired = 0
    var locked = false
    var ballRadiusModifier : CGFloat = 1
    var ballMaxSpeedModifier : CGFloat = 1
    var ballSpeedMultModifier : CGFloat = 1
    var obsLengthModifier : CGFloat = 1
    var ballStartSpeedModifier : CGFloat = 1
    var mode = MODE_CIRCLE
    var activeWalls: [Bool] = [false, false, false, false] // [Top, Right, Bottom, Left]
    var wallThicknessMultiplier = 0.025
    var gravityMode: Int = 0 //0 = none, 1 = constant acceleration of <x,y>, 2 = gravity at point (x% of screen width,y% of screen height) of strength gravityStrenth
    var gravityX: CGFloat = 0
    var gravityY: CGFloat = 0
    var gravityStrength: CGFloat = 0
    
    
    func unlock() {
        locked = false
        super.fillColor = COLOR_FADED_RED
    }
    
    func lock() {
        locked = true
        super.fillColor = COLOR_GREY
    }
    
    func select() {
        if !locked {
            super.fillColor = COLOR_FADED_RED_DARKER
        }
    }
    
    func deselect() {
        if !locked {
            super.fillColor = COLOR_FADED_RED
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}