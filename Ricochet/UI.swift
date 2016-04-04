//
//  UI.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/3/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MenuButton2: SKShapeNode {
    init(_ buttonName: String) {
        super.init()
        super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 5, y: -SCREEN_WIDTH / 12), size: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6)), nil)
        super.lineWidth = 0
        buttonLabel.text = buttonName
        self.addChild(buttonLabel)
        super.zPosition = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let buttonLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
}

class MenuButton: SKShapeNode {
    init(_ buttonName: String) {
        super.init()
        super.path = CGPathCreateWithRect(CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 5, y: -SCREEN_WIDTH / 12), size: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6)), nil)
        super.lineWidth = 4
        super.fillColor = COLOR_FADED_GREEN
        buttonLabel.fontSize = SCREEN_WIDTH / 9
        buttonLabel.text = buttonName
        buttonLabel.position.y = -SCREEN_WIDTH / 27
        self.addChild(buttonLabel)
    }
    
    let buttonLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    func select() {
        super.fillColor = COLOR_FADED_RED
    }
    
    func deselect() {
        super.fillColor = COLOR_FADED_GREEN
    }
    
    func moveOut() {
        let buttonMove = SKAction.moveToX(-SCREEN_WIDTH, duration: 0.5)
        buttonMove.timingMode = .EaseInEaseOut
        runAction(buttonMove)
    }
    
    func moveIn() {
        position.x = SCREEN_WIDTH * 2
        let buttonMove = SKAction.moveToX(SCREEN_WIDTH / 2, duration: 0.5)
        buttonMove.timingMode = .EaseInEaseOut
        runAction(buttonMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LevelSelector: SKShapeNode {
    override init() {
        super.init()
        super.path = CGPathCreateWithRect(CGRectMake(-SCREEN_WIDTH * 0.55, -SCREEN_WIDTH / 6, SCREEN_WIDTH * 1.1, SCREEN_WIDTH / 3), nil)
        super.lineWidth = 4
        super.fillColor = COLOR_FADED_GREEN
        super.zPosition = -1
    }
    
    var active = false
    var scroll: CGFloat = 0
    var scrollSpeed: CGFloat = 0
    
    func moveIn() {
        position.x = SCREEN_WIDTH * 2
        let modeSelectorMove = SKAction.moveToX(SCREEN_WIDTH / 2, duration: 0.5)
        modeSelectorMove.timingMode = .EaseInEaseOut
        runAction(modeSelectorMove)
    }
    
    func moveOut() {
        let modeSelectorMove = SKAction.moveToX(-SCREEN_WIDTH, duration: 0.5)
        modeSelectorMove.timingMode = .EaseInEaseOut
        runAction(modeSelectorMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func MoveInLevels(inout levels: [Level], _ levelSelector: LevelSelector) {
    for tempLevel in levels {
        if (UNLOCKED_LEVELS > tempLevel.levelNumber + 1) {
            tempLevel.position = CGPoint(x: -SCREEN_WIDTH, y: levelSelector.position.y)
        }
        else {
            tempLevel.position = CGPoint(x: 2 * SCREEN_WIDTH, y: levelSelector.position.y)
        }
        let tempLevelMove = SKAction.moveToX(SCREEN_WIDTH * (CGFloat(tempLevel.levelNumber) + 0.5) / 3 + levelSelector.scroll, duration: 0.5)
        tempLevel.runAction(tempLevelMove)
    }
}

func MoveOutLevels(inout levels: [Level], _ levelSelector: LevelSelector) {
    for tempLevel in levels {
        let tempLevelMove = SKAction.moveToX(-SCREEN_WIDTH, duration: 0.5)
        tempLevel.runAction(tempLevelMove)
    }
}



