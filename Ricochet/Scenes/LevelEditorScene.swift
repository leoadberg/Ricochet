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
    
	var currentLevel: CustomLevel
    
    var touching: Bool = false
    var touchStart: CGPoint = CGPoint()
    var scroll: CGFloat = 0
    var scrollSpeed: CGFloat = 0
	
	init(_ cl: CustomLevel, size: CGSize) {
		currentLevel = cl
		super.init(size: size)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        exitButton.lineWidth = 4
        saveButton.lineWidth = 4
        playButton.lineWidth = 4
        exitButton.fillColor = COLOR_FADED_RED_DARKER
        saveButton.fillColor = COLOR_FADED_GREEN
        playButton.fillColor = COLOR_FADED_YELLOW
        exitButton.position = CGPoint(x: SCREEN_WIDTH / 16, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        //saveButton.position = CGPoint(x: SCREEN_WIDTH / 8 + SCREEN_WIDTH * 7 / 32, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        saveButton.position = CGPoint(x: SCREEN_WIDTH * 0.34375, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        //playButton.position = CGPoint(x: SCREEN_WIDTH / 8 + SCREEN_WIDTH * 7 / 16 + SCREEN_WIDTH * 7 / 32, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        playButton.position = CGPoint(x: SCREEN_WIDTH * 0.78125, y: SCREEN_HEIGHT - SCREEN_WIDTH / 16)
        exitText.text = "×"
        saveText.text = "Save"
        playText.text = "Play"
        exitText.fontSize = SCREEN_WIDTH / 6
        saveText.fontSize = SCREEN_WIDTH / 10
        playText.fontSize = SCREEN_WIDTH / 10
        exitText.position.x = exitButton.position.x
        saveText.position.x = saveButton.position.x
        playText.position.x = playButton.position.x
        exitText.position.y = exitButton.position.y - SCREEN_WIDTH / 22
        saveText.position.y = saveButton.position.y - SCREEN_WIDTH / 28
        playText.position.y = playButton.position.y - SCREEN_WIDTH / 28
        
        newEffectButton.lineWidth = 4
        newEffectButton.fillColor = COLOR_FADED_GREEN
        newEffectButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 2)
        newEffectText.position.x = newEffectButton.position.x
        newEffectText.text = "New Effect"
        newEffectText.fontSize = SCREEN_WIDTH / 10
        
        scrollNode.addChild(newEffectText)
        scrollNode.addChild(newEffectButton)
        
        
        obstacleSlider.setValue(CGFloat(currentLevel.mode))
        winSlider.setValue(CGFloat(currentLevel.winConditions))
        ballRadiusSlider.setValue(CGFloat(currentLevel.ballRadiusModifier))
        startSpeedSlider.setValue(CGFloat(currentLevel.ballStartSpeedModifier))
        maxSpeedSlider.setValue(CGFloat(currentLevel.ballMaxSpeedModifier))
        speedIncreaseSlider.setValue(CGFloat(currentLevel.ballSpeedMultModifier))
        obstacleSizeSlider.setValue(CGFloat(currentLevel.obsLengthModifier))
        oneStarSlider.setValue(CGFloat(currentLevel.oneStar))
        twoStarSlider.setValue(CGFloat(currentLevel.twoStar))
        threeStarSlider.setValue(CGFloat(currentLevel.threeStar))
        
        sliders.append(obstacleSlider)
        sliders.append(winSlider)
        sliders.append(ballRadiusSlider)
        sliders.append(startSpeedSlider)
        sliders.append(maxSpeedSlider)
        sliders.append(speedIncreaseSlider)
        sliders.append(obstacleSizeSlider)
        sliders.append(oneStarSlider)
        sliders.append(twoStarSlider)
        sliders.append(threeStarSlider)
        
        sliders.append(tempEffect)
        
        for (i, slider) in sliders.enumerated() {
            slider.position = CGPoint(x: 0, y: SCREEN_HEIGHT * CGFloat(17 - 2 * i) / 20)
            scrollNode.addChild(slider)
        }
        
        newEffectButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * CGFloat(17 - 2 * sliders.count) / 20)
        newEffectText.position.y = newEffectButton.position.y - SCREEN_WIDTH / 28
        scrollNode.zPosition = -1
        
        self.addChild(scrollNode)
        self.addChild(exitButton)
        self.addChild(saveButton)
        self.addChild(playButton)
        self.addChild(exitText)
        self.addChild(saveText)
        self.addChild(playText)
    }
    
    let exitButton = SKShapeNode(rectOf: CGSize(width: SCREEN_WIDTH / 8, height: SCREEN_WIDTH / 8))
    let exitText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let saveButton = SKShapeNode(rectOf: CGSize(width: SCREEN_WIDTH * 7 / 16, height: SCREEN_WIDTH / 8))
    let saveText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let playButton = SKShapeNode(rectOf: CGSize(width: SCREEN_WIDTH * 7 / 16, height: SCREEN_WIDTH / 8))
    let playText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    let scrollNode = SKNode()
    
    let newEffectButton = SKShapeNode(rectOf: CGSize(width: SCREEN_WIDTH * 7 / 8, height: SCREEN_WIDTH / 8))
    let newEffectText = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    
    var sliders: [Slider] = []
    
    let obstacleSlider = Slider("Obstacle:", 0, 2, 1, 0, int: true)
    let winSlider = Slider("Win Condition:", 0, 1, 1, 0, int: true)
    let ballRadiusSlider = Slider("Ball Radius:", 0.1, 5, 0.1, 1)
    let startSpeedSlider = Slider("Start Speed:", 0.1, 5, 0.1, 1)
    let maxSpeedSlider = Slider("Max Speed:", 0.1, 5, 0.1, 1)
    let speedIncreaseSlider = Slider("Speed Increase:", 0, 5, 1, 1)
    let obstacleSizeSlider = Slider("Obs. Size:", 0.1, 5, 0.1, 1)
    let oneStarSlider = Slider("1 Star:", 1, 50, 1, 1, int: true)
    let twoStarSlider = Slider("2 Stars:", 1, 50, 1, 5, int: true)
    let threeStarSlider = Slider("3 Stars:", 1, 50, 1, 10, int: true)
    
    let tempEffect = EffectHeader(1)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        touching = true
        let location = touches.first!.location(in: self)
        touchStart = location
        
        if (exitButton.contains(location)) {
            exitButton.fillColor = COLOR_FADED_RED_EVEN_DARKER
        }
        else if (playButton.contains(location)) {
            playButton.fillColor = COLOR_FADED_YELLOW_DARKER
        }
        else if (saveButton.contains(location)) {
            saveButton.fillColor = COLOR_FADED_GREEN_DARKER
        }
        
        for slider in sliders {
            if (slider.slider.contains(AddPoints(touchStart, CGPoint(x: 0, y: -scroll - slider.position.y)))) {
                slider.selected = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touching = false
        let location = touches.first!.location(in: self)
        
        if (exitButton.contains(location) && exitButton.contains(touchStart)) {
            let menu_scene = MenuScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            menu_scene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
        else if (playButton.contains(location) && playButton.contains(touchStart)) {
            saveLevel()
            let game_scene = GameScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            game_scene.scaleMode = .aspectFill
            game_scene.currentLevel = currentLevel
            game_scene.inCustomLevel = true
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        else if (saveButton.contains(location) && saveButton.contains(touchStart)) {
            saveLevel()
        }
        
        for slider in sliders {
            slider.selected = false
            if let effectHead = slider as? EffectHeader {
                print("Let go on EffectHeader: ", effectHead)
            }
        }
        
        exitButton.fillColor = COLOR_FADED_RED_DARKER
        saveButton.fillColor = COLOR_FADED_GREEN
        playButton.fillColor = COLOR_FADED_YELLOW
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = true
        let touch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
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
        currentLevel.ballMaxSpeedModifier = maxSpeedSlider.sliderValue
        currentLevel.ballRadiusModifier = ballRadiusSlider.sliderValue
        currentLevel.ballSpeedMultModifier = speedIncreaseSlider.sliderValue
        currentLevel.obsLengthModifier = obstacleSizeSlider.sliderValue
        currentLevel.ballStartSpeedModifier = startSpeedSlider.sliderValue
        currentLevel.oneStar = Int(oneStarSlider.sliderValue)
        currentLevel.twoStar = Int(twoStarSlider.sliderValue)
        currentLevel.threeStar = Int(threeStarSlider.sliderValue)
        CUSTOM_LEVELS[currentLevel.levelNumber] = currentLevel 
        SaveCustomLevels()
    }
    
    func setCustomLevel(levelnumber: Int) {
        currentLevel = CUSTOM_LEVELS[levelnumber]
    }
    
    override func update(_ currentTime: CFTimeInterval) {
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
