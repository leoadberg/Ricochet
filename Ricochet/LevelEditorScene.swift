//
//  LevelEditorScene.swift
//  Ricochet
//
//  Created by Leo Adberg on 4/5/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import Foundation
import SpriteKit

class LevelEditorScene: SKScene {
    
    var currentLevel: CustomLevel = CustomLevel(level: 1)
    
    var touching: Bool = false
    var touchStart: CGPoint = CGPointZero
    var scroll: CGFloat = 0
    var scrollSpeed: CGFloat = 0

    override func didMoveToView(view: SKView) {
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        deleteButton.lineWidth = 4
        saveButton.lineWidth = 4
        playButton.lineWidth = 4
        deleteButton.fillColor = COLOR_FADED_RED_DARKER
        saveButton.fillColor = COLOR_FADED_GREEN
        playButton.fillColor = COLOR_FADED_YELLOW
        deleteButton.position = CGPoint(x: SCREEN_WIDTH / 16, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        //saveButton.position = CGPoint(x: SCREEN_WIDTH / 8 + SCREEN_WIDTH * 7 / 32, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        saveButton.position = CGPoint(x: SCREEN_WIDTH * 0.34375, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        //playButton.position = CGPoint(x: SCREEN_WIDTH / 8 + SCREEN_WIDTH * 7 / 16 + SCREEN_WIDTH * 7 / 32, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        playButton.position = CGPoint(x: SCREEN_WIDTH * 0.78125, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        deleteText.text = "×"
        saveText.text = "Save"
        playText.text = "Play"
        deleteText.fontSize = SCREEN_WIDTH / 6
        saveText.fontSize = SCREEN_WIDTH / 10
        playText.fontSize = SCREEN_WIDTH / 10
        deleteText.position.x = deleteButton.position.x
        saveText.position.x = saveButton.position.x
        playText.position.x = playButton.position.x
        deleteText.position.y = deleteButton.position.y - SCREEN_WIDTH / 22
        saveText.position.y = saveButton.position.y - SCREEN_WIDTH / 28
        playText.position.y = playButton.position.y - SCREEN_WIDTH / 28
        
        
        obstacleSlider.setValue(CGFloat(currentLevel.mode))
        winSlider.setValue(CGFloat(currentLevel.winConditions))
        
        sliders.append(obstacleSlider)
        sliders.append(winSlider)
        
        for (i, slider) in sliders.enumerate() {
            slider.position = CGPoint(x: 0, y: SCREEN_HEIGHT * CGFloat(17 - 2 * i) / 20)
        }
        
        
        scrollNode.zPosition = -1
        
        //self.view!.addSubview(testText)
        
        scrollNode.addChild(obstacleSlider)
        scrollNode.addChild(winSlider)
        
        self.addChild(scrollNode)
        self.addChild(deleteButton)
        self.addChild(saveButton)
        self.addChild(playButton)
        self.addChild(deleteText)
        self.addChild(saveText)
        self.addChild(playText)
    }
    
    let deleteButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH / 8, height: SCREEN_WIDTH / 8))
    let deleteText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let saveButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 7 / 16, height: SCREEN_WIDTH / 8))
    let saveText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let playButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 7 / 16, height: SCREEN_WIDTH / 8))
    let playText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    let testText = UITextField(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 5, height: SCREEN_WIDTH / 20))
    
    let scrollNode = SKNode()
    
    var sliders: [Slider] = []
    
    let obstacleSlider = Slider(text: "Obstacle:", 0, 2, 1, 0)
    let winSlider = Slider(text: "Win Condition:", 0, 1, 1, 0)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        touching = true
        let location = touches.first!.locationInNode(self)
        touchStart = location
        
        if (deleteButton.containsPoint(location)) {
            deleteButton.fillColor = COLOR_FADED_RED_EVEN_DARKER
        }
        else if (playButton.containsPoint(location)) {
            playButton.fillColor = COLOR_FADED_YELLOW_DARKER
        }
        else if (saveButton.containsPoint(location)) {
            saveButton.fillColor = COLOR_FADED_GREEN_DARKER
        }
        
        for slider in sliders {
            if (slider.slider.containsPoint(AddPoints(touchStart, CGPoint(x: 0, y: -scroll - slider.position.y)))) {
                slider.selected = true
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        touching = false
        let location = touches.first!.locationInNode(self)
        
        if (deleteButton.containsPoint(location) && deleteButton.containsPoint(touchStart)) {
            let menu_scene = MenuScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            menu_scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
        else if (playButton.containsPoint(location) && playButton.containsPoint(touchStart)) {
            saveLevel()
            let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            game_scene.scaleMode = .AspectFill
            game_scene.currentLevel = currentLevel
            game_scene.inCustomLevel = true
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        else if (saveButton.containsPoint(location) && saveButton.containsPoint(touchStart)) {
            saveLevel()
        }
        
        for slider in sliders {
            slider.selected = false
        }
        
        deleteButton.fillColor = COLOR_FADED_RED_DARKER
        saveButton.fillColor = COLOR_FADED_GREEN
        playButton.fillColor = COLOR_FADED_YELLOW
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = true
        let touch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        if (touchStart.y < SCREEN_HEIGHT - SCREEN_WIDTH / 8) {
            scrollSpeed = translation.y
            scroll += scrollSpeed
        }
        
        for slider in sliders {
            if (slider.selected) {
                slider.updateSlider(touch)
            }
        }
    }
    
    func saveLevel() {
        currentLevel.mode = Int(obstacleSlider.sliderValue)
        currentLevel.winConditions = Int(winSlider.sliderValue)
        CUSTOM_LEVELS[currentLevel.levelNumber] = currentLevel
        SaveCustomLevels()
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (!touching) {
            scroll += scrollSpeed
            scrollSpeed = scrollSpeed * 0.9
            if (abs(scrollSpeed) < 2) {
                scrollSpeed = 0
            }
        }
        scroll = min(max(0,scroll), 500)
        scrollNode.position.y = scroll
    }
}
