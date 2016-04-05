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

let TOP_CENTER: [CGFloat] = [SCREEN_WIDTH / 2, SCREEN_HEIGHT]
let RIGHT_CENTER: [CGFloat] = [SCREEN_WIDTH, SCREEN_HEIGHT / 2]
let BOTTOM_CENTER: [CGFloat] = [SCREEN_WIDTH / 2, 0]
let LEFT_CENTER: [CGFloat] = [0, SCREEN_HEIGHT / 2]

var wallThickness: CGFloat = SCREEN_WIDTH / 10

class GameScene: SKScene {
    
    var currentLevel = Level(level: 0)
    
    var effects: [LevelEffect] = []
    
    var currentMode: Int = 0
    
    var first: Bool = true
    var lost: Bool = false
    var justLost: Bool = false
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let requiredScoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    var startTime: Double = 0
    let obstaclesLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    var ball = Ball()
    var obstacle = Obstacle()
    
    let restartButton = MenuButton2("Restart")
    let menuButton = MenuButton2("Menu")
    let nextLevelButton = MenuButton2("Next Level")
    
    var touchStart = CGPoint(x: 0, y: 0)
    
    var hintLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    func updateHighscore(score: Int) {
        if (getHighscore() < score){
            DEFAULTS.setInteger(score, forKey: "Highscore\(currentLevel.levelNumber)")
        }
    }
    var currentHighscore : Int = 0
    func getHighscore() -> Int {
        return DEFAULTS.integerForKey("Highscore\(currentLevel.levelNumber)")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        effects = currentLevel.effects
        for effect in effects {
            effect.visualEffect.removeFromParent()
            self.addChild(effect.visualEffect)
        }
        
        hintLabel.text = currentLevel.hint
        hintLabel.fontColor = SKColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        hintLabel.fontSize = SCREEN_WIDTH / 10
        hintLabel.position.x = SCREEN_WIDTH / 2
        hintLabel.position.y = SCREEN_HEIGHT / 10
        self.addChild(hintLabel)
        
        currentHighscore = getHighscore()
        currentMode = currentLevel.mode
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
        scoreLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2);
        scoreLabel.zPosition = -1
        
        self.addChild(scoreLabel)
        
        requiredScoreLabel.fontColor = SKColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        requiredScoreLabel.fontSize = SCREEN_WIDTH / 6;
        requiredScoreLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 9 / 10);
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
        
        ball.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 3)
        ball.zPosition = 0
        ball.fillColor = COLOR_FADED_GREEN
        ball.lineWidth = 4
        
        ball.spd *= CGFloat(unitLength) / 4
        ball.angle = (Double(arc4random_uniform(50)) + 20) * (M_PI / 180) + (M_PI / 2) * Double(arc4random_uniform(4))
        
        ball.updateCartesian()
        
        self.addChild(ball)
        
        if (currentMode == 0) {
            
            currentLevel.activeWalls = [false, false, false, false]
            obstacle.length = SCREEN_HEIGHT
            
        }
        
        obstacle.shapeID = currentMode
        obstacle.draw()
        
        self.addChild(obstacle)
        
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        initializeEffects()
        
        if (obstacle.numAvailable != -1) {
            
            self.addChild(obstaclesLabel)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        touchStart = (touches.first?.locationInNode(self))!
        
        if (first || lost) {
            first = false
            startTime = NSDate.timeIntervalSinceReferenceDate()
            let disappear = SKAction.fadeOutWithDuration(0.5)
            hintLabel.runAction(disappear)
            return
        }
        
        if (!lost) {
            
            obstacle.move(touchStart, &currentLevel)
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let location = touches.first!.locationInNode(self)
        
        if (restartButton.containsPoint(location) && restartButton.containsPoint(touchStart)) {
            //self.removeAllChildren()
            let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            game_scene.scaleMode = .AspectFill
            game_scene.currentLevel = currentLevel
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        else if (menuButton.containsPoint(location) && menuButton.containsPoint(touchStart)) {
            //self.removeAllChildren()
            let menu_scene = MenuScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            menu_scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
        else if (nextLevelButton.containsPoint(location) && nextLevelButton.containsPoint(touchStart)) {
            
            //self.removeAllChildren()
            let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            game_scene.scaleMode = .AspectFill
            game_scene.currentLevel = GAME_LEVELS[currentLevel.levelNumber+1]
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        
    }
    
    var lastUpdateTime: CFTimeInterval = 0
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (first || lost) {
            return
        }
        
        if (justLost) {
            
            updateHighscore(score)
            
            let highscoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            highscoreLabel.text = "Highscore: \(getHighscore())"
            highscoreLabel.fontSize = SCREEN_WIDTH / 9;
            highscoreLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 9 / 10)
            highscoreLabel.zPosition = 4
            self.addChild(highscoreLabel)
            
            let finalScoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            finalScoreLabel.text = "Final Score:"
            finalScoreLabel.fontSize = SCREEN_WIDTH / 9;
            finalScoreLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 3 / 4)
            finalScoreLabel.zPosition = 4
            self.addChild(finalScoreLabel)
            
            scoreLabel.zPosition = 4
            
            let fade = SKSpriteNode(color: COLOR_TRANSPARENT_BLACK, size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            fade.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
            fade.zPosition = 2
            self.addChild(fade)
            
            restartButton.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 7 / 40)
            menuButton.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 2 / 40)
            nextLevelButton.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 12 / 40)
            self.addChild(restartButton)
            self.addChild(menuButton)
            
            if (GAME_LEVELS.count > currentLevel.levelNumber + 1 && (score >= currentLevel.oneStar || UNLOCKED_LEVELS > currentLevel.levelNumber)) {
                UNLOCKED_LEVELS = max(UNLOCKED_LEVELS, currentLevel.levelNumber + 1)
                DEFAULTS.setInteger(UNLOCKED_LEVELS, forKey: "Unlocked Levels")
                self.addChild(nextLevelButton)
            }
            
            lost = true;
            
        }
        
        let timeSinceLastUpdate: Double = min(currentTime - lastUpdateTime, 1 / MIN_FRAMERATE)
        lastUpdateTime = currentTime
        
        updateEffects(timeSinceLastUpdate)
        
        ball.update(timeSinceLastUpdate)
        
        //let temp = obstacle.update(timeSinceLastUpdate, &ball)
        //obstacles += temp * currentLevel.obstaclesPerBounce
        //obstaclesLabel.text = String(obstacles + currentLevel.obstaclesPerSecond * Int(NSDate.timeIntervalSinceReferenceDate() - startTime))
        
        obstaclesLabel.text = String(obstacle.numAvailable)
        
        if (currentLevel.winConditions == 1) {
            
            score = Int(NSDate.timeIntervalSinceReferenceDate() - startTime)
            obstacle.update(timeSinceLastUpdate, &ball)
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
    
    func addScore(n: Int) {
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
    
    func updateEffects(timeSinceLastUpdate: Double) {
        
        for effect in effects {
            
            effect.update(timeSinceLastUpdate, &ball, &obstacle)
            
        }
        
    }
}

func minimum(n0: CGFloat, _ nums: CGFloat...) -> Int {
    
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

func distanceBetween(loc1: [CGFloat], _ loc2: [CGFloat]) -> CGFloat {
    return sqrt(pow(loc1[0] - loc2[0], 2) + pow(loc1[1] - loc2[1], 2))
}
