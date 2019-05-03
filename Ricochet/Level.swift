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
        self.pre_init(level: level)
    }
    
    init(_ levelNumber: Int, _ dict: NSDictionary) {
        
        super.init()
        self.pre_init(level: levelNumber)
        
        self.winConditions = dict["Win Conditions"] as! Int
        self.hint = dict["Hint"] as! String
        self.mode = dict["Game Mode"] as! Int
        self.oneStar = dict["1 Star"] as! Int
        self.twoStar = dict["2 Star"] as! Int
        self.threeStar = dict["3 Star"] as! Int
        self.ballMaxSpeedModifier = dict["Max Speed Multiplier"] as! CGFloat
        self.ballRadiusModifier = dict["Ball Radius Multiplier"] as! CGFloat
        self.ballSpeedMultModifier = dict["Speed Increase Multiplier"] as! CGFloat
        self.obsLengthModifier = dict["Obstacle Size Multiplier"] as! CGFloat
        self.ballStartSpeedModifier = dict["Start Speed Multiplier"] as! CGFloat
        
        let tempEffects = dict["Effects"] as! [NSDictionary]
        for effect in tempEffects {
            switch (effect["EffectID"] as! Int) {
            case 0:
                self.effects.append(DirectionalGravity(effect))
            case 1:
                self.effects.append(PointGravity(effect))
            case 2:
                self.effects.append(RotatingObstacle(effect))
            case 3:
                self.effects.append(ResizingObstacle(effect))
            case 4:
                self.effects.append(LimitedObstacles(effect))
            default:
                break
            }
        }
    }
    
    func pre_init(level: Int) {
        super.path = CGPath(rect: CGRect(origin: CGPoint(x: -SCREEN_WIDTH / 9, y: -SCREEN_WIDTH / 9), size: CGSize(width: SCREEN_WIDTH * 2 / 9, height: SCREEN_WIDTH * 2 / 9)), transform: nil)
        super.fillColor = COLOR_FADED_RED
        super.lineWidth = 4
        label.fontSize = SCREEN_WIDTH / 6;
        label.text = String(level)
        label.position.x = super.position.x
        label.position.y = super.position.y - SCREEN_WIDTH / 32
        starText.fontSize = SCREEN_WIDTH / 16;
        starText.position.x = super.position.x
        starText.position.y = super.position.y - SCREEN_WIDTH / 11
        super.addChild(label)
        super.addChild(starText)
        super.name = "Level"+String(level)
        levelNumber = level
    }
    
    //var startingObstacles = -1
    //var obstaclesPerBounce = 0
    //var obstaclesPerSecond = 0
    var levelNumber = 0
    var winConditions = 0
    var oneStar = 0
    var twoStar = 0
    var threeStar = 0
    var starText = SKLabelNode(fontNamed: "DINAlternate-Bold")
    var label = SKLabelNode(fontNamed:"DINAlternate-Bold")
    var locked = false
    var ballRadiusModifier : CGFloat = 1
    var ballMaxSpeedModifier : CGFloat = 1
    var ballSpeedMultModifier : CGFloat = 1
    var obsLengthModifier : CGFloat = 1
    var ballStartSpeedModifier : CGFloat = 1
    var mode = MODE_CIRCLE
    var activeWalls: [Bool] = [false, false, false, false] // [Top, Right, Bottom, Left]
    var wallThicknessMultiplier = 0.025
    //var gravityMode: Int = 0 //0 = none, 1 = constant acceleration of <x,y>, 2 = gravity at point (x% of screen width,y% of screen height) of strength gravityStrenth
    //var gravityX: CGFloat = 0
    //var gravityY: CGFloat = 0
    //var gravityStrength: CGFloat = 0
    var hint : String = ""
    var effects: [LevelEffect] = []
    
    func update() {
        //self.position.x = SCREEN_WIDTH * 2
        let highscore = DEFAULTS.integer(forKey: "Highscore"+String(levelNumber))
        if (highscore >= threeStar) {
            starText.text = "★★★"
            label.position.y = -SCREEN_WIDTH / 32
        }
        else if (highscore >= twoStar) {
            starText.text = "★★"
            label.position.y = -SCREEN_WIDTH / 32
        }
        else if (highscore >= oneStar) {
            starText.text = "★"
            label.position.y = -SCREEN_WIDTH / 32
        }
        else {
            starText.text = ""
            label.position.y = -SCREEN_WIDTH / 16
        }
    }
    
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

class CustomLevel: Level {
    
    override init(level: Int) {
        
        super.init(level: level)
        
        self.post_init()
        
    }
    
    override init(_ levelNumber: Int, _ dict: NSDictionary) {
        
        super.init(levelNumber, dict)
        self.label.text = dict["Name"] as? String
        
        self.post_init()
        
    }
    
    func post_init() {
    
        editButton.lineWidth = 4
        editButton.fillColor = COLOR_FADED_YELLOW
        editText.text = "Edit"
        editText.position = CGPoint(x: -SCREEN_WIDTH / 22, y: -SCREEN_WIDTH / 11)
        editText.fontSize = SCREEN_WIDTH / 16
        
        deleteButton.lineWidth = 4
        deleteButton.fillColor = COLOR_FADED_RED_DARKER
        deleteText.text = "×"
        deleteText.position = CGPoint(x: SCREEN_WIDTH * (0.069444), y: -SCREEN_WIDTH / 10) //0.069444 = 1/9 - 1/24
        deleteText.fontSize = SCREEN_WIDTH / 9
        
        super.addChild(editButton)
        super.addChild(editText)
        super.addChild(deleteButton)
        super.addChild(deleteText)
        
        super.label.fontSize = SCREEN_WIDTH / 16
        super.label.position.y = SCREEN_WIDTH / 24
        super.label.text = levelName
        super.starText.fontSize = SCREEN_WIDTH / 24
        super.starText.text = "★★★"
        super.starText.position.y = -SCREEN_WIDTH / 128
    
    }
    
    let editButton = SKShapeNode(rect: CGRect(x: -SCREEN_WIDTH / 9, y: -SCREEN_WIDTH / 9, width: SCREEN_WIDTH * (2/9-1/12), height: SWOVER12))
    var editText = SKLabelNode(fontNamed: "DINAlternate-Bold")
    let deleteButton = SKShapeNode(rect: CGRect(x: SCREEN_WIDTH * (1/9-1/12), y: -SCREEN_WIDTH / 9, width: SWOVER12, height: SWOVER12))
    var deleteText = SKLabelNode(fontNamed: "DINAlternate-Bold")

    var levelName = "Custom"
    
    func selectEdit() {
        editButton.fillColor = COLOR_FADED_YELLOW_DARKER
    }
    
    func deselectEdit() {
        editButton.fillColor = COLOR_FADED_YELLOW
    }
    
    func selectDelete() {
        deleteButton.fillColor = COLOR_FADED_RED_EVEN_DARKER
    }
    
    func deselectDelete() {
        deleteButton.fillColor = COLOR_FADED_RED_DARKER
    }
    
    override func deselect() {
        super.deselect()
        deselectDelete()
        deselectEdit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        for (i, tempLevel) in CUSTOM_LEVELS.enumerated() {
            if tempLevel == self {
                print("Level \(i) in CUSTOM_LEVELS was just released!")
            }
        }
        print("A level was just released!")
    }
    
}

func NewCustomLevel() -> Int {
    let newLevel = CustomLevel(level: CUSTOM_LEVELS.count)
    CUSTOM_LEVELS.append(newLevel)
    return CUSTOM_LEVELS.count - 1
}

