//
//  Level.swift
//  Ball Game
//
//  Created by Leo Adberg on 3/28/16.
//  Copyright © 2016 Leo Adberg. All rights reserved.
//

import Foundation
import SpriteKit

class Level: SKShapeNode {
    init(level: Int){
        super.init()
        self.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 9, y: -SCREEN_WIDTH / 9), size: CGSize(width: SCREEN_WIDTH * 2 / 9, height: SCREEN_WIDTH * 2 / 9)), nil)
        self.fillColor = COLOR_FADED_RED
        self.lineWidth = 4
        let label = SKLabelNode(fontNamed:"DINAlternate-Bold")
        label.fontSize = SCREEN_WIDTH / 6;
        label.text = String(level)
        label.position.x = super.position.x
        label.position.y = super.position.y - SCREEN_WIDTH / 16
        self.addChild(label)
        self.name = "Level"+String(level)
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
    var shape = MODE_CIRCLE
    
    func unlock() {
        locked = false
        self.fillColor = COLOR_FADED_RED
    }
    
    func lock() {
        locked = true
        self.fillColor = COLOR_GREY
    }
    
    func select() {
        if !locked {
            self.fillColor = COLOR_FADED_RED_DARKER
        }
    }
    
    func deselect() {
        if !locked {
            self.fillColor = COLOR_FADED_RED
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}