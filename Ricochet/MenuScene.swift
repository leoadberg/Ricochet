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
let SCREEN_WIDTH = SCREEN.width
let SCREEN_HEIGHT = SCREEN.height

let COLOR_FADED_GREEN = SKColor(colorLiteralRed: 161 / 255, green: 212 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_RED = SKColor(colorLiteralRed: 212 / 255, green: 161 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_RED_DARKER = SKColor(colorLiteralRed: 207 / 255, green: 129 / 255, blue: 103 / 255, alpha: 1)
let COLOR_FADED_RED_EVEN_DARKER = SKColor(colorLiteralRed: 201 / 255, green: 64 / 255, blue: 99 / 255, alpha: 1)
let COLOR_FADED_BLUE = SKColor(colorLiteralRed: 144 / 255, green: 195 / 255, blue: 212 / 255, alpha: 1)
let COLOR_FADED_YELLOW = SKColor(colorLiteralRed: 212 / 255, green: 212 / 255, blue: 144 / 255, alpha: 1)
let COLOR_FADED_YELLOW_DARKER = SKColor(colorLiteralRed: 196 / 255, green: 196 / 255, blue: 134 / 255, alpha: 1)
let COLOR_TRANSPARENT_BLACK = SKColor(colorLiteralRed: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.6)
let COLOR_TRANSPARENT = SKColor(colorLiteralRed: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0)
let COLOR_GREY = SKColor(colorLiteralRed: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)

let MODE_WALLS = 0
let MODE_SQUARE = 1
let MODE_CIRCLE = 2

enum Wall: Int {
    case Top = 0, Right = 1, Bottom = 2, Left = 3
}

class MenuScene: SKScene {
    
    let playButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    let scoresButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    let nameLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let playLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    let levelSelector = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 1.1, height: SCREEN_WIDTH / 3))
    var scroll: CGFloat = 0
    var scrollSpeed: CGFloat = 0
    let modeSquare = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 9, height: SCREEN_WIDTH * 2 / 9))
    let modeCircle = SKShapeNode(circleOfRadius: SCREEN_WIDTH / 9)
    var inLevelSelector = false
    var touching = false
    var touchStart = CGPoint(x: 0, y: 0)
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let testCustomeLevel = CustomLevel()
        testCustomeLevel.position = CGPoint (x: SCREEN_WIDTH / 3, y: SCREEN_HEIGHT / 10)
        self.addChild(testCustomeLevel)
        
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
        
        playLabel.text = "Play";
        playLabel.fontSize = SCREEN_WIDTH / 9;
        playLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 9 / 20);
        playLabel.zPosition = 1
        self.addChild(playLabel)
        
        playButton.position = CGPoint(x: playLabel.position.x, y: playLabel.position.y + SCREEN_WIDTH / 27)
        playButton.fillColor = COLOR_FADED_GREEN
        playButton.lineWidth = 4
        playButton.zPosition = 0
        self.addChild(playButton)
        
        let scoresLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
        scoresLabel.text = "Scores";
        scoresLabel.fontSize = SCREEN_WIDTH / 9;
        scoresLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 4);
        scoresLabel.zPosition = 1
        self.addChild(scoresLabel)
        
        scoresButton.position = CGPoint(x: scoresLabel.position.x, y: scoresLabel.position.y + SCREEN_WIDTH / 27)
        scoresButton.fillColor = COLOR_FADED_GREEN
        scoresButton.lineWidth = 4
        scoresLabel.zPosition = 0
        self.addChild(scoresButton)
        
        levelSelector.position = CGPoint(x: SCREEN_WIDTH * 2, y: SCREEN_HEIGHT / 2)
        levelSelector.fillColor = COLOR_FADED_GREEN
        levelSelector.lineWidth = 4
        levelSelector.zPosition = -1
        self.addChild(levelSelector)
        
        for tempLevel in GAME_LEVELS {
            if (!inLevelSelector) {
                tempLevel.position.x = SCREEN_WIDTH * 2
                tempLevel.update()
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        touching = true
        let location = touches.first!.locationInNode(self)
        touchStart = location
        
        //let touchedNode = self.nodeAtPoint(location)
        
        for tempLevel in GAME_LEVELS {
            if (!inLevelSelector) {
                tempLevel.position.x = SCREEN_WIDTH * 2
                tempLevel.update()
            }
            if (tempLevel.containsPoint(location)) {
               tempLevel.select()
            }
        }
        
        if (playButton.containsPoint(location)) {
            playButton.fillColor = COLOR_FADED_RED
        }
        else {
            playButton.fillColor = COLOR_FADED_GREEN
        }
        
        if (scoresButton.containsPoint(location)) {
            scoresButton.fillColor = COLOR_FADED_RED
        }
        else {
            scoresButton.fillColor = COLOR_FADED_GREEN
        }
        
        if (modeSquare.containsPoint(location)) {
            modeSquare.fillColor = COLOR_FADED_RED_DARKER
        }
        else {
            modeSquare.fillColor = COLOR_FADED_RED
        }
        
        if (modeCircle.containsPoint(location)) {
            modeCircle.fillColor = COLOR_FADED_RED_DARKER
        }
        else {
            modeCircle.fillColor = COLOR_FADED_RED
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        touching = false
        let location = touches.first!.locationInNode(self)
        
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
        
        if (playButton.containsPoint(location) && playButton.containsPoint(touchStart)) {
            let buttonMove = SKAction.moveToX(-SCREEN_WIDTH, duration: 0.5)
            buttonMove.timingMode = .EaseInEaseOut
            playButton.runAction(buttonMove)
            playLabel.runAction(buttonMove)
            
            let modeSelectorMove = SKAction.moveToX(SCREEN_WIDTH / 2, duration: 0.5)
            modeSelectorMove.timingMode = .EaseInEaseOut
            levelSelector.runAction(modeSelectorMove)
            
            scroll = -SCREEN_WIDTH * CGFloat(min(GAME_LEVELS.count-3,max(UNLOCKED_LEVELS-1,0))) / 3
            
            for tempLevel in GAME_LEVELS {
                //tempLevel.update()
                if (UNLOCKED_LEVELS > tempLevel.levelNumber + 3) {
                    tempLevel.position = CGPoint(x: -SCREEN_WIDTH, y: SCREEN_HEIGHT / 2)
                }
                else {
                    tempLevel.position = CGPoint(x: 2 * SCREEN_WIDTH, y: SCREEN_HEIGHT / 2)
                }
                let tempLevelMove = SKAction.moveToX(SCREEN_WIDTH * (CGFloat(tempLevel.levelNumber) + 0.5) / 3 + scroll, duration: 0.5)
                tempLevel.runAction(tempLevelMove)
            }
            
            inLevelSelector = true
        }
        else if (scoresButton.containsPoint(location) && scoresButton.containsPoint(touchStart)) {
            let scores_scene = ScoresScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            scores_scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(scores_scene, transition: transition)
        }
        
        scoresButton.fillColor = COLOR_FADED_GREEN
        playButton.fillColor = COLOR_FADED_GREEN
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = true
        let touch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        if (inLevelSelector && touchStart.y < SCREEN_HEIGHT / 2 + SCREEN_WIDTH / 3 && touchStart.y > SCREEN_HEIGHT / 2 - SCREEN_WIDTH / 3) {
            scroll += translation.x
            scrollSpeed = translation.x
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (inLevelSelector && !(GAME_LEVELS.first?.hasActions())!) {
            if (!touching) {
                scroll += scrollSpeed
                scrollSpeed = scrollSpeed * 0.9
                if (abs(scrollSpeed) < 2) {
                    scrollSpeed = 0
                }
            }
            if (scroll != 0) {
                scroll = max(min(0,scroll), -SCREEN_WIDTH * (CGFloat(GAME_LEVELS.count) - 3) / 3)
                for tempLevel in GAME_LEVELS {
                    tempLevel.position.x = SCREEN_WIDTH * (CGFloat(tempLevel.levelNumber) + 0.5) / 3 + scroll
                }
            }
        }
    }
    
}







