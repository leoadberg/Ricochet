//
//  MenuScene.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import SpriteKit
import Darwin

let SCREEN: CGRect = UIScreen.mainScreen().bounds
let SCREEN_WIDTH: CGFloat = SCREEN.width
let SCREEN_HEIGHT: CGFloat = SCREEN.height
let SCREEN_RATIO: CGFloat = SCREEN.height / SCREEN.width

let COLOR_FADED_GREEN: SKColor = SKColor(colorLiteralRed: 161 / 255, green: 212 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_GREEN_DARKER: SKColor = SKColor(colorLiteralRed: 141 / 255, green: 191 / 255, blue: 124 / 255, alpha: 1)
let COLOR_FADED_RED: SKColor = SKColor(colorLiteralRed: 212 / 255, green: 161 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_RED_DARKER: SKColor = SKColor(colorLiteralRed: 207 / 255, green: 129 / 255, blue: 103 / 255, alpha: 1)
let COLOR_FADED_RED_EVEN_DARKER: SKColor = SKColor(colorLiteralRed: 201 / 255, green: 64 / 255, blue: 99 / 255, alpha: 1)
let COLOR_FADED_BLUE: SKColor = SKColor(colorLiteralRed: 144 / 255, green: 195 / 255, blue: 212 / 255, alpha: 1)
let COLOR_FADED_YELLOW: SKColor = SKColor(colorLiteralRed: 212 / 255, green: 212 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_YELLOW_DARKER: SKColor = SKColor(colorLiteralRed: 196 / 255, green: 196 / 255, blue: 134 / 255, alpha: 1)
let COLOR_TRANSPARENT_BLACK: SKColor = SKColor(colorLiteralRed: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.6)
let COLOR_TRANSPARENT: SKColor = SKColor(colorLiteralRed: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0)
let COLOR_GREY: SKColor = SKColor(colorLiteralRed: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)

let MODE_WALLS: Int = 0
let MODE_SQUARE: Int = 1
let MODE_CIRCLE: Int = 2

enum Wall: Int {
    case Top = 0, Right = 1, Bottom = 2, Left = 3
}

class MenuScene: SKScene {
    
    let playButton = MenuButton("Play")
    let customButton = MenuButton("Custom")
    let scoresButton = MenuButton("Scores")
    let newCustomLevel = Level(level: -1)
    let nameLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    //let levelSelector = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 1.1, height: SCREEN_WIDTH / 3))
    //var scroll: CGFloat = 0
    //var scrollSpeed: CGFloat = 0
    //var inLevelSelector = false
    let levelSelector = LevelSelector()
    let customLevelSelector = LevelSelector()
    
    var touching = false
    var touchStart = CGPoint(x: 0, y: 0)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var inTransition = false;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        for tempLevel in GAME_LEVELS {
            self.addChild(tempLevel)
            if (tempLevel.levelNumber > UNLOCKED_LEVELS){
                tempLevel.lock()
            } else {
                tempLevel.unlock()
            }
        }
        
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        nameLabel.text = "Ricochet";
        nameLabel.fontSize = SCREEN_WIDTH / 6;
        nameLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 7 / 10);
        nameLabel.zPosition = 1
        self.addChild(nameLabel)
        
        playButton.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        self.addChild(playButton)
        
        customButton.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 3)
        self.addChild(customButton)
        
        scoresButton.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 6)
        self.addChild(scoresButton)
        
        levelSelector.position = CGPoint(x: SCREEN_WIDTH * 2, y: SCREEN_HEIGHT / 2)
        //levelSelector.fillColor = COLOR_FADED_GREEN
        //levelSelector.lineWidth = 4
        //levelSelector.zPosition = -1
        self.addChild(levelSelector)
        customLevelSelector.position = CGPoint(x: SCREEN_WIDTH * 2, y: SCREEN_HEIGHT / 3)
        self.addChild(customLevelSelector)
        newCustomLevel.label.text = "+"
        newCustomLevel.unlock()
        newCustomLevel.label.position.y = 0
        newCustomLevel.label.verticalAlignmentMode = .Center
        newCustomLevel.position = CGPoint(x: SCREEN_WIDTH * 2, y: SCREEN_HEIGHT / 3)
        self.addChild(newCustomLevel)
        
        for tempLevel: Level in GAME_LEVELS {
            if (!levelSelector.active) {
                tempLevel.position.x = SCREEN_WIDTH * 2
                tempLevel.update()
            }
        }
        
        for tempLevel: CustomLevel in CUSTOM_LEVELS {
            tempLevel.position = CGPoint(x: SCREEN_WIDTH * 2, y: SCREEN_HEIGHT / 3)
            self.addChild(tempLevel)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        touching = true
        let location: CGPoint = touches.first!.locationInNode(self)
        touchStart = location
        
        //let touchedNode = self.nodeAtPoint(location)
        
        for tempLevel: Level in GAME_LEVELS {
            if (!levelSelector.active) {
                tempLevel.position.x = SCREEN_WIDTH * 2
                tempLevel.update()
            }
            if (tempLevel.containsPoint(location)) {
               tempLevel.select()
            }
        }
        
        for tempLevel: CustomLevel in CUSTOM_LEVELS {
            if (!customLevelSelector.active) {
                tempLevel.position.x = SCREEN_WIDTH * 2
            }
            if (tempLevel.editButton.containsPoint(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y))) {
                tempLevel.selectEdit()
            }
            else if (tempLevel.deleteButton.containsPoint(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y))) {
                tempLevel.selectDelete()
            }
            else if (tempLevel.containsPoint(location)) {
                tempLevel.select()
            }
        }
        
        if (playButton.containsPoint(location)) {
            playButton.select()
        }
        
        if (scoresButton.containsPoint(location)) {
            scoresButton.select()
        }
        
        if (customButton.containsPoint(location)) {
            customButton.select()
        }
        
        if (newCustomLevel.containsPoint(location)) {
            newCustomLevel.select()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        touching = false
        let location = touches.first!.locationInNode(self)
        
        if (newCustomLevel.containsPoint(location) && newCustomLevel.containsPoint(touchStart)) {
            let editor_scene = LevelEditorScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            editor_scene.scaleMode = .AspectFill
            let newLevel = CustomLevel(level: CUSTOM_LEVELS.count)
            CUSTOM_LEVELS.append(newLevel)
            editor_scene.currentLevel = newLevel
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(editor_scene, transition: transition)
            inTransition = true;
        }
        
        for tempLevel in GAME_LEVELS {
            tempLevel.deselect()
            if (!tempLevel.locked && tempLevel.containsPoint(location) && tempLevel.containsPoint(touchStart)) {
                let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
                game_scene.scaleMode = .AspectFill
                game_scene.currentLevel = tempLevel
                let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
                self.scene!.view!.presentScene(game_scene, transition: transition)
            }
        }
        
        for (i, tempLevel) in CUSTOM_LEVELS.enumerate() {
            tempLevel.deselect()
            if (tempLevel.editButton.containsPoint(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y)) && tempLevel.editButton.containsPoint(CGPoint(x: touchStart.x - tempLevel.position.x, y: touchStart.y - tempLevel.position.y))) {
                //Edit code
                let editor_scene = LevelEditorScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
                editor_scene.scaleMode = .AspectFill
                editor_scene.currentLevel = tempLevel
                let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
                self.scene!.view!.presentScene(editor_scene, transition: transition)
            }
            else if (tempLevel.deleteButton.containsPoint(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y)) && tempLevel.deleteButton.containsPoint(CGPoint(x: touchStart.x - tempLevel.position.x, y: touchStart.y - tempLevel.position.y))) {
                
                let alertController = UIAlertController(title: "Level Removal", message: "Are you sure you want to delete this level?", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    CUSTOM_LEVELS.removeAtIndex(i)
                    tempLevel.removeFromParent()
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.view!.window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
            else if (tempLevel.containsPoint(location) && tempLevel.containsPoint(touchStart)) {
                let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
                game_scene.scaleMode = .AspectFill
                game_scene.currentLevel = tempLevel
                game_scene.inCustomLevel = true
                let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
                self.scene!.view!.presentScene(game_scene, transition: transition)
            }
        }
        
        if (playButton.containsPoint(location) && playButton.containsPoint(touchStart)) {
            if (customLevelSelector.active) {
                //MoveOutLevels(&GAME_LEVELS, levelSelector)
                customLevelSelector.moveOut()
                customButton.moveIn()
                customLevelSelector.active = false
                let levelAction = SKAction.moveToX(-SCREEN_WIDTH, duration: 0.5)
                newCustomLevel.runAction(levelAction)
                for tempLevel in CUSTOM_LEVELS {
                    tempLevel.runAction(levelAction)
                }
            }
            playButton.moveOut()
            levelSelector.moveIn()
            levelSelector.scroll = -SCREEN_WIDTH * CGFloat(min(GAME_LEVELS.count - 3, max(UNLOCKED_LEVELS - 1, 0))) / 3
            MoveInLevels(&GAME_LEVELS, levelSelector)
            levelSelector.active = true
        }
        else if (customButton.containsPoint(location) && customButton.containsPoint(touchStart)) {
            if (levelSelector.active) {
                MoveOutLevels(&GAME_LEVELS, levelSelector)
                levelSelector.moveOut()
                playButton.moveIn()
                levelSelector.active = false
            }
            customButton.moveOut()
            customLevelSelector.moveIn()
            customLevelSelector.active = true
            newCustomLevel.position.x = SCREEN_WIDTH * 2
            if (CUSTOM_LEVELS.count < 3) {
                let addLevelAction = SKAction.moveToX((CGFloat(CUSTOM_LEVELS.count) + 0.5) / 3 * SCREEN_WIDTH, duration: 0.5)
                newCustomLevel.runAction(addLevelAction)
            }
            for (i, tempLevel) in CUSTOM_LEVELS.enumerate() {
                tempLevel.position.x = SCREEN_WIDTH * 2
                if i < 3 {
                    let levelAction = SKAction.moveToX((CGFloat(i) + 0.5) / 3 * SCREEN_WIDTH, duration: 0.5)
                    tempLevel.runAction(levelAction)
                }
            }
        }
        else if (scoresButton.containsPoint(location) && scoresButton.containsPoint(touchStart)) {
            let scores_scene = ScoresScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            scores_scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(scores_scene, transition: transition)
        }
        
        scoresButton.deselect()
        playButton.deselect()
        customButton.deselect()
        newCustomLevel.deselect()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = true
        let touch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        if (levelSelector.active && touchStart.y < SCREEN_HEIGHT / 2 + SCREEN_WIDTH / 6 && touchStart.y > SCREEN_HEIGHT / 2 - SCREEN_WIDTH / 6) {
            levelSelector.scroll += translation.x
            levelSelector.scrollSpeed = translation.x
        }
        if (customLevelSelector.active && touchStart.y < SCREEN_HEIGHT / 3 + SCREEN_WIDTH / 6 && touchStart.y > SCREEN_HEIGHT / 3 - SCREEN_WIDTH / 6) {
            customLevelSelector.scroll += translation.x
            customLevelSelector.scrollSpeed = translation.x
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (levelSelector.active && !(GAME_LEVELS.first?.hasActions())!) {
            if (!touching) {
                levelSelector.scroll += levelSelector.scrollSpeed
                levelSelector.scrollSpeed = levelSelector.scrollSpeed * 0.9
                if (abs(levelSelector.scrollSpeed) < 2) {
                    levelSelector.scrollSpeed = 0
                }
            }
            if (levelSelector.scroll != 0) {
                levelSelector.scroll = max(min(0,levelSelector.scroll), -SCREEN_WIDTH * (CGFloat(GAME_LEVELS.count) - 3) / 3)
                for tempLevel in GAME_LEVELS {
                    tempLevel.position.x = SCREEN_WIDTH * (CGFloat(tempLevel.levelNumber) + 0.5) / 3 + levelSelector.scroll
                }
            }
        }
        if (customLevelSelector.active && ((CUSTOM_LEVELS.first == nil) || !(CUSTOM_LEVELS.first?.hasActions())!)) {
            if (!touching) {
                customLevelSelector.scroll += customLevelSelector.scrollSpeed
                customLevelSelector.scrollSpeed = customLevelSelector.scrollSpeed * 0.9
                if (abs(customLevelSelector.scrollSpeed) < 2) {
                    customLevelSelector.scrollSpeed = 0
                }
            }
            //if (customLevelSelector.scroll != 0) {
            if !inTransition && !customLevelSelector.hasActions() {
                customLevelSelector.scroll = max(min(0,customLevelSelector.scroll), -SCREEN_WIDTH * (CGFloat(CUSTOM_LEVELS.count) - 0 /*2*/) / 3)
                for (i, tempLevel) in CUSTOM_LEVELS.enumerate() {
                    tempLevel.position.x = SCREEN_WIDTH * (CGFloat(i) + 0.5) / 3 + customLevelSelector.scroll
                }
                newCustomLevel.position.x = SCREEN_WIDTH * (CGFloat(CUSTOM_LEVELS.count) + 0.5) / 3 + customLevelSelector.scroll
            }
        }
    }
}







