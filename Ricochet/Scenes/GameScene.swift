//
//  GameScene.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright (c) 2016 Tigersushi. All rights reserved.
//

import SpriteKit
import Darwin

let MIN_FRAMERATE: Double = 30.0

var unitLength: Double = 0.0

let TOP_CENTER: [CGFloat] = [SWOVER2, SCREEN_HEIGHT]
let RIGHT_CENTER: [CGFloat] = [SCREEN_WIDTH, SCREEN_HEIGHT / 2]
let BOTTOM_CENTER: [CGFloat] = [SWOVER2, 0]
let LEFT_CENTER: [CGFloat] = [0, SCREEN_HEIGHT / 2]

var wallThickness: CGFloat = SCREEN_WIDTH / 10

class GameScene: SKScene {
    
    var currentLevel: Level = Level(level: 0)
    var inCustomLevel: Bool = false
    
    var effects: [LevelEffect] = []
    
    var currentMode: Int = 0
    
    var first: Bool = true
    var lost: Bool = false
    var justLost: Bool = false
    
    var score: Int = 0
    let scoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let requiredScoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    var startTime: Double = 0
    let obstaclesLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    var ball = Ball()
    var obstacle = Obstacle()
    
    let restartButton = MenuButton2("Restart")
    let menuButton = MenuButton2("Menu")
    let returnToEditorButton = MenuButton2("Edit Level")
    let nextLevelButton = MenuButton2("Next Level")
    
    var touchStart = CGPoint(x: 0, y: 0)
    
    var hintLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    func updateHighscore(_ score: Int) {
        if (getHighscore() < score){
            DEFAULTS.set(score, forKey: "Highscore\(currentLevel.levelNumber)")
        }
    }
    var currentHighscore : Int = 0
    func getHighscore() -> Int {
        return DEFAULTS.integer(forKey: "Highscore\(currentLevel.levelNumber)")
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
		currentMode = currentLevel.mode
		
		switch currentMode {
		case 0:
			obstacle = WallObstacle()
			currentLevel.activeWalls = [false, false, false, false]
			obstacle.length = SCREEN_HEIGHT
		case 1:
			obstacle = SquareObstacle()
		case 2:
			obstacle = CircleObstacle()
		default:
			fatalError("Unknown mode")
		}
		
        effects = currentLevel.effects
        for effect in effects {
            effect.visualEffect.removeFromParent()
            self.addChild(effect.visualEffect)
        }
        
        hintLabel.text = currentLevel.hint
        hintLabel.fontColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        hintLabel.fontSize = SCREEN_WIDTH / 10
        hintLabel.position.x = SWOVER2
        hintLabel.position.y = SCREEN_HEIGHT / 10
        self.addChild(hintLabel)
        
        currentHighscore = getHighscore()
        ball.radius *= currentLevel.ballRadiusModifier
        ball.speedMult *= currentLevel.ballSpeedMultModifier
        ball.maxSpeed *= currentLevel.ballMaxSpeedModifier
        obstacle.length *= currentLevel.obsLengthModifier
        ball.spd *= currentLevel.ballStartSpeedModifier
        ball.draw()
        
        unitLength = Double(SCREEN_WIDTH)
        wallThickness = SCREEN_WIDTH * CGFloat(currentLevel.wallThicknessMultiplier)
        
        scoreLabel.text = String(score);
        scoreLabel.fontSize = SCREEN_WIDTH / 2;
        scoreLabel.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 2);
        scoreLabel.zPosition = -1
        
        self.addChild(scoreLabel)
        
        requiredScoreLabel.fontColor = SKColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        requiredScoreLabel.fontSize = SCREEN_WIDTH / 6;
        requiredScoreLabel.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 9 / 10);
        requiredScoreLabel.zPosition = -1
        
        if (currentHighscore < currentLevel.oneStar) {
            requiredScoreLabel.text = "\(currentLevel.oneStar) to ★";
        }
        else if (currentHighscore < currentLevel.twoStar) {
            requiredScoreLabel.text = "\(currentLevel.twoStar) to ★★";
        }
        else if (currentHighscore < currentLevel.threeStar) {
            requiredScoreLabel.text = "\(currentLevel.threeStar) to ★★★";
        }
        else {
            requiredScoreLabel.text = "★★★";
        }
        self.addChild(requiredScoreLabel)
        
        ball.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 3)
        ball.zPosition = 0
        ball.fillColor = COLOR_FADED_GREEN
        ball.lineWidth = 4
        
        ball.spd *= CGFloat(unitLength) / 4
        ball.angle = (Double(arc4random_uniform(50)) + 20) * (Double.pi / 180) + (Double.pi / 2) * Double(arc4random_uniform(4))
        
        ball.updateCartesian()
        
        self.addChild(ball)
        
        obstacle.shapeID = currentMode
        obstacle.draw()
        
        self.addChild(obstacle)
        
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        initializeEffects()
        
        if (obstacle.numAvailable != -1) {
            
            self.addChild(obstaclesLabel)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        touchStart = (touches.first?.location(in: self))!
        
        if (first || lost) {
            first = false
            startTime = NSDate.timeIntervalSinceReferenceDate
            let disappear = SKAction.fadeOut(withDuration: 0.5)
            hintLabel.run(disappear)
            return
        }
        
        if (!lost) {
            
            obstacle.move(touchStart, &currentLevel)
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        
        if (restartButton.contains(location) && restartButton.contains(touchStart)) {
            //self.removeAllChildren()
            let game_scene = GameScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            game_scene.scaleMode = .aspectFill
            game_scene.currentLevel = currentLevel
            game_scene.inCustomLevel = self.inCustomLevel
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        else if (menuButton.contains(location) && menuButton.contains(touchStart)) {
            //self.removeAllChildren()
            let menu_scene = MenuScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            menu_scene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
        else if (returnToEditorButton.contains(location) && returnToEditorButton.contains(touchStart) && inCustomLevel) {
            //self.removeAllChildren()
            //let editor_scene = MenuScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            //editor_scene.scaleMode = .aspectFill
            //let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            //self.scene!.view!.presentScene(editor_scene, transition: transition)
            
            
            let editor_scene = LevelEditorScene(currentLevel as! CustomLevel, size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            editor_scene.scaleMode = .aspectFill
//            editor_scene.currentLevel =
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(editor_scene, transition: transition)
        }
        else if (!inCustomLevel && nextLevelButton.contains(location) && nextLevelButton.contains(touchStart)) {
            
            //self.removeAllChildren()
            let game_scene = GameScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            game_scene.scaleMode = .aspectFill
            game_scene.currentLevel = GAME_LEVELS[currentLevel.levelNumber+1]
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        
    }
    
    var lastUpdateTime: CFTimeInterval = 0
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (first || lost) {
            return
        }
        
        if (justLost) {
            
            updateHighscore(score)
            
            let highscoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            highscoreLabel.text = "Highscore: \(getHighscore())"
            highscoreLabel.fontSize = SCREEN_WIDTH / 9;
            highscoreLabel.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 9 / 10)
            highscoreLabel.zPosition = 4
            self.addChild(highscoreLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            finalScoreLabel.text = "Final Score:"
            finalScoreLabel.fontSize = SCREEN_WIDTH / 9;
            finalScoreLabel.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 3 / 4)
            finalScoreLabel.zPosition = 4
            self.addChild(finalScoreLabel)
            
            scoreLabel.zPosition = 4
            
            let fade = SKSpriteNode(color: COLOR_TRANSPARENT_BLACK, size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            fade.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 2)
            fade.zPosition = 2
            self.addChild(fade)
            
            restartButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 7 / 40)
            menuButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 2 / 40)
            returnToEditorButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 12 / 40)
            nextLevelButton.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 12 / 40)
            self.addChild(restartButton)
            if (inCustomLevel) {
                self.addChild(returnToEditorButton)
            }
            self.addChild(menuButton)
            
            if (!inCustomLevel && GAME_LEVELS.count > currentLevel.levelNumber + 1 && (score >= currentLevel.oneStar || UNLOCKED_LEVELS > currentLevel.levelNumber)) {
                UNLOCKED_LEVELS = max(UNLOCKED_LEVELS, currentLevel.levelNumber + 1)
                DEFAULTS.set(UNLOCKED_LEVELS, forKey: "Unlocked Levels")
                self.addChild(nextLevelButton)
            }
            
            lost = true;
            
        }
        
        let timeSinceLastUpdate: Double = min(currentTime - lastUpdateTime, 1 / MIN_FRAMERATE)
        lastUpdateTime = currentTime
        
        updateEffects(timeSinceLastUpdate)
        
        ball.update(timeSinceLastUpdate: timeSinceLastUpdate)
        
        //let temp = obstacle.update(timeSinceLastUpdate, &ball)
        //obstacles += temp * currentLevel.obstaclesPerBounce
        //obstaclesLabel.text = String(obstacles + currentLevel.obstaclesPerSecond * Int(NSDate.timeIntervalSinceReferenceDate() - startTime))
        
        obstaclesLabel.text = String(obstacle.numAvailable)
        
        if (currentLevel.winConditions == 1) {
            
            score = Int(NSDate.timeIntervalSinceReferenceDate - startTime)
            _ = obstacle.update(timeSinceLastUpdate, &ball)
            addScore(0)
            
        }
        else {
            
            addScore(obstacle.update(timeSinceLastUpdate, &ball))
            
        }
        
        // Right Wall Collision Case
        if (abs(ball.position.x - SCREEN_WIDTH) <= ball.radius && !currentLevel.activeWalls[Wall.Right.rawValue]) {
            
            justLost = true
                
        }
    
        // Left Wall Collision Case
        else if (abs(ball.position.x) <= ball.radius && !currentLevel.activeWalls[Wall.Left.rawValue]) {
            
            justLost = true
            
        }
        
        // Top Wall Collision Case
        if (abs(ball.position.y - SCREEN_HEIGHT) <= ball.radius && !currentLevel.activeWalls[Wall.Top.rawValue]) {
            
            justLost = true
            
        }
        
        // Bottom Wall Collision Case
        else if (abs(ball.position.y) <= ball.radius && !currentLevel.activeWalls[Wall.Bottom.rawValue]) {
            
            justLost = true
        
        }
        
    }
    
    func addScore(_ n: Int) {
        score += n
        scoreLabel.text = String(score);
        if (score >= currentHighscore) {
            if (score > currentLevel.threeStar) {
                requiredScoreLabel.text = "★★★";
            }
            else if (score >= currentLevel.twoStar) {
                requiredScoreLabel.text = "\(currentLevel.threeStar) to ★★★";
            }
            else if (score >= currentLevel.oneStar) {
                requiredScoreLabel.text = "\(currentLevel.twoStar) to ★★";
            }
        }
    }
    
    func initializeEffects() {
        
        for effect in effects {
            
            effect.initialize(&ball, &obstacle)
            
        }
        
    }
    
    func updateEffects(_ timeSinceLastUpdate: Double) {
        
        for effect in effects {
            
            effect.update(timeSinceLastUpdate, &ball, &obstacle)
            
        }
        
    }
}

func minimum(_ n0: CGFloat, _ nums: CGFloat...) -> Int {
    
    var minValue: CGFloat = n0
    var minIndex: Int = 0
    
    var i = 0
    
    for num in nums {
        
        i += 1
        
        if (num < minValue) {
            minValue = num
            minIndex = i
        }
        
    }
    
    return minIndex
    
}

func distanceBetween(_ loc1: [CGFloat], _ loc2: [CGFloat]) -> CGFloat {
    return sqrt(pow(loc1[0] - loc2[0], 2) + pow(loc1[1] - loc2[1], 2))
}
