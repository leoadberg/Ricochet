//
//  MenuScene.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import SpriteKit
import Darwin


let COLOR_FADED_GREEN: SKColor = SKColor(red: 161 / 255, green: 212 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_GREEN_DARKER: SKColor = SKColor(red: 141 / 255, green: 191 / 255, blue: 124 / 255, alpha: 1)
let COLOR_FADED_RED: SKColor = SKColor(red: 212 / 255, green: 161 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_RED_DARKER: SKColor = SKColor(red: 207 / 255, green: 129 / 255, blue: 103 / 255, alpha: 1)
let COLOR_FADED_RED_EVEN_DARKER: SKColor = SKColor(red: 201 / 255, green: 64 / 255, blue: 99 / 255, alpha: 1)
let COLOR_FADED_BLUE: SKColor = SKColor(red: 144 / 255, green: 195 / 255, blue: 212 / 255, alpha: 1)
let COLOR_FADED_YELLOW: SKColor = SKColor(red: 212 / 255, green: 212 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_YELLOW_DARKER: SKColor = SKColor(red: 196 / 255, green: 196 / 255, blue: 134 / 255, alpha: 1)
let COLOR_TRANSPARENT_BLACK: SKColor = SKColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.6)
let COLOR_TRANSPARENT: SKColor = SKColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0)
let COLOR_GREY: SKColor = SKColor(red: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)

let MODE_WALLS: Int = 0
let MODE_SQUARE: Int = 1
let MODE_CIRCLE: Int = 2

enum Wall: Int {
    case Top = 0, Right = 1, Bottom = 2, Left = 3
}

class MenuScene: SKScene {
    
    let playButton = MenuButton("Play")
    let customButton = MenuButton("Custom")
//    let scoresButton = MenuButton("Scores")
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
    
    var inTransition = false;
	
	let playY: CGFloat = SCREEN_HEIGHT / 2
	let custY: CGFloat = SCREEN_HEIGHT / 4
	let selectorRadius: CGFloat = SCREEN_WIDTH / 6
    
    override func didMove(to view: SKView) {
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
        nameLabel.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 7 / 10);
        nameLabel.zPosition = 1
        self.addChild(nameLabel)
        
        playButton.position = CGPoint(x: SWOVER2, y: playY)
        self.addChild(playButton)
        
        customButton.position = CGPoint(x: SWOVER2, y: custY)
        self.addChild(customButton)
        
//        scoresButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 6)
//        self.addChild(scoresButton)
		
        levelSelector.position = CGPoint(x: SCREEN_WIDTH * 2, y: playY)
        //levelSelector.fillColor = COLOR_FADED_GREEN
        //levelSelector.lineWidth = 4
        //levelSelector.zPosition = -1
        self.addChild(levelSelector)
        customLevelSelector.position = CGPoint(x: SCREEN_WIDTH * 2, y: custY)
        self.addChild(customLevelSelector)
        newCustomLevel.label.text = "+"
        newCustomLevel.unlock()
        newCustomLevel.label.position.y = 0
        newCustomLevel.label.verticalAlignmentMode = .center
        newCustomLevel.position = CGPoint(x: SCREEN_WIDTH * 2, y: custY)
        self.addChild(newCustomLevel)
        
        for tempLevel: Level in GAME_LEVELS {
            if (!levelSelector.active) {
                tempLevel.position.x = SCREEN_WIDTH * 2
                tempLevel.update()
            }
        }
        
        for tempLevel: CustomLevel in CUSTOM_LEVELS {
            tempLevel.position = CGPoint(x: SCREEN_WIDTH * 2, y: custY)
            self.addChild(tempLevel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins, this part takes like 10 seconds to compile so it needs some serious optimization */
        
        touching = true
        let location: CGPoint = touches.first!.location(in: self)
        touchStart = location
        
        //let touchedNode = self.nodeAtPoint(location)
        
        for tempLevel: Level in GAME_LEVELS {
            if (!levelSelector.active) {
                tempLevel.position.x = SCREEN_WIDTH * 2
                tempLevel.update()
            }
            if (tempLevel.contains(location)) {
               tempLevel.select()
            }
        }
        
        for tempLevel: CustomLevel in CUSTOM_LEVELS {
            if (!customLevelSelector.active) {
                tempLevel.position.x = SCREEN_WIDTH * 2
            }
            if (tempLevel.editButton.contains(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y))) {
                tempLevel.selectEdit()
            }
            else if (tempLevel.deleteButton.contains(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y))) {
                tempLevel.selectDelete()
            }
            else if (tempLevel.contains(location)) {
                tempLevel.select()
            }
        }
        
        if (playButton.contains(location)) {
            playButton.select()
        }
        
//        if (scoresButton.contains(location)) {
//            scoresButton.select()
//        }
		
        if (customButton.contains(location)) {
            customButton.select()
        }
        
        if (newCustomLevel.contains(location)) {
            newCustomLevel.select()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touching = false
        let location = touches.first!.location(in: self)
        
        if (newCustomLevel.contains(location) && newCustomLevel.contains(touchStart)) {
			let editor_scene = LevelEditorScene(CUSTOM_LEVELS[NewCustomLevel()], size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            editor_scene.scaleMode = .aspectFill
            
//            editor_scene.currentLevel = CUSTOM_LEVELS[NewCustomLevel()]
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(editor_scene, transition: transition)
            inTransition = true;
        }
        
        for tempLevel in GAME_LEVELS {
            tempLevel.deselect()
            if (!tempLevel.locked && tempLevel.contains(location) && tempLevel.contains(touchStart)) {
                let game_scene = GameScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
                game_scene.scaleMode = .aspectFill
                game_scene.currentLevel = tempLevel
                let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
                self.scene!.view!.presentScene(game_scene, transition: transition)
            }
        }
        
        for (i, tempLevel) in CUSTOM_LEVELS.enumerated() {
            tempLevel.deselect()
            if (tempLevel.editButton.contains(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y)) && tempLevel.editButton.contains(CGPoint(x: touchStart.x - tempLevel.position.x, y: touchStart.y - tempLevel.position.y))) {
                //Edit code
                let editor_scene = LevelEditorScene(tempLevel, size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
                editor_scene.scaleMode = .aspectFill
                //editor_scene.currentLevel = tempLevel
                let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
                self.scene!.view!.presentScene(editor_scene, transition: transition)
            }
            else if (tempLevel.deleteButton.contains(CGPoint(x: location.x - tempLevel.position.x, y: location.y - tempLevel.position.y)) && tempLevel.deleteButton.contains(CGPoint(x: touchStart.x - tempLevel.position.x, y: touchStart.y - tempLevel.position.y))) {
                
                let alertController = UIAlertController(title: "Level Removal", message: "Are you sure you want to delete this level?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    CUSTOM_LEVELS.remove(at: i)
                    tempLevel.removeFromParent()
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.view!.window!.rootViewController!.present(alertController, animated: true, completion: nil)
            }
            else if (tempLevel.contains(location) && tempLevel.contains(touchStart)) {
                let game_scene = GameScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
                game_scene.scaleMode = .aspectFill
                game_scene.currentLevel = tempLevel
                game_scene.inCustomLevel = true
                let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
                self.scene!.view!.presentScene(game_scene, transition: transition)
            }
        }
        
        if (playButton.contains(location) && playButton.contains(touchStart)) {
            if (customLevelSelector.active) {
                //MoveOutLevels(&GAME_LEVELS, levelSelector)
                customLevelSelector.moveOut()
                customButton.moveIn()
                customLevelSelector.active = false
                let levelAction = SKAction.moveTo(x: -SCREEN_WIDTH, duration: 0.5)
                newCustomLevel.run(levelAction)
                for tempLevel in CUSTOM_LEVELS {
                    tempLevel.run(levelAction)
                }
            }
            playButton.moveOut()
            levelSelector.moveIn()
            levelSelector.scroll = -SCREEN_WIDTH * CGFloat(min(GAME_LEVELS.count - 3, max(UNLOCKED_LEVELS - 1, 0))) / 3
            MoveInLevels(&GAME_LEVELS, levelSelector)
            levelSelector.active = true
        }
        else if (customButton.contains(location) && customButton.contains(touchStart)) {
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
                let addLevelAction = SKAction.moveTo(x: (CGFloat(CUSTOM_LEVELS.count) + 0.5) / 3 * SCREEN_WIDTH, duration: 0.5)
                newCustomLevel.run(addLevelAction)
            }
            for (i, tempLevel) in CUSTOM_LEVELS.enumerated() {
                tempLevel.position.x = SCREEN_WIDTH * 2
                if i < 3 {
                    let levelAction = SKAction.moveTo(x: (CGFloat(i) + 0.5) / 3 * SCREEN_WIDTH, duration: 0.5)
                    tempLevel.run(levelAction)
                }
            }
        }
//        else if (scoresButton.contains(location) && scoresButton.contains(touchStart)) {
//            let scores_scene = ScoresScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
//            scores_scene.scaleMode = .aspectFill
//            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
//            self.scene!.view!.presentScene(scores_scene, transition: transition)
//        }
		
//        scoresButton.deselect()
        playButton.deselect()
        customButton.deselect()
        newCustomLevel.deselect()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = true
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        if (levelSelector.active && touchStart.y < playY + selectorRadius && touchStart.y > playY - selectorRadius) {
            levelSelector.scroll += translation.x
            levelSelector.scrollSpeed = translation.x
        }
        if (customLevelSelector.active && touchStart.y < custY + selectorRadius && touchStart.y > custY - selectorRadius) {
            customLevelSelector.scroll += translation.x
            customLevelSelector.scrollSpeed = translation.x
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
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
                for (i, tempLevel) in CUSTOM_LEVELS.enumerated() {
                    tempLevel.position.x = SCREEN_WIDTH * (CGFloat(i) + 0.5) / 3 + customLevelSelector.scroll
                }
                newCustomLevel.position.x = SCREEN_WIDTH * (CGFloat(CUSTOM_LEVELS.count) + 0.5) / 3 + customLevelSelector.scroll
            }
        }
    }
}







