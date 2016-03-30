//
//  GameScene.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright (c) 2016 Tigersushi. All rights reserved.
//

import SpriteKit
import Darwin

//infix operator ^^ { }
//func ^^ (radix: Int, power: Int) -> Int {
//    return Int(pow(Double(radix), Double(power)))
//}

//var BALL_RADIUS: CGFloat = SCREEN_WIDTH / 12
//var BALL_MAX_SPEED: Double = Double(SCREEN_WIDTH) * 6
//var BALL_SPEED_MULT: Double = 0.01

let MIN_FRAMERATE: Double = 30.0

var unitLength: Double = 0.0

let TOP_CENTER: [CGFloat] = [SCREEN_WIDTH / 2, SCREEN_HEIGHT]
let RIGHT_CENTER: [CGFloat] = [SCREEN_WIDTH, SCREEN_HEIGHT / 2]
let BOTTOM_CENTER: [CGFloat] = [SCREEN_WIDTH / 2, 0]
let LEFT_CENTER: [CGFloat] = [0, SCREEN_HEIGHT / 2]

var wallThickness: CGFloat = SCREEN_WIDTH / 10

//var OBS_LENGTH: CGFloat = SCREEN_WIDTH / 5

class GameScene: SKScene {
    
    var currentLevel = Level(level: 0)
    var BALL_RADIUS = SCREEN_WIDTH / 12
    var BALL_MAX_SPEED: CGFloat = SCREEN_WIDTH * 6
    var BALL_SPEED_MULT: CGFloat = 0.01
    var OBS_LENGTH: CGFloat = SCREEN_WIDTH / 5
    var BALL_START_SPEED: CGFloat = 1
    
    var currentMode: Int = 0
    
    var first: Bool = true
    var lost: Bool = false
    var justLost: Bool = false
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let requiredScoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    // Ball Speed in unitLength / second
    var ball_speed: Double = 0
    var ball_angle: Double = 0
    var ball_xSpeed: Double = 0
    var ball_ySpeed: Double = 0
    
    var ball_colliding: Bool = false
    
    var ball = SKShapeNode(circleOfRadius: 1)
    var obstacle = SKShapeNode(rectOfSize: CGSize(width: 1, height: 1))
    
    let restartButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    let menuButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    let nextLevelButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    var touchStart = CGPoint(x: 0, y: 0)
    
    func updateHighscore(score: Int, mode: Int) {
        if (getHighscore(mode) < score){
            DEFAULTS.setInteger(score, forKey: "Highscore\(mode)")
        }
    }
    
    func getHighscore(mode: Int) -> Int {
        return DEFAULTS.integerForKey("Highscore\(mode)")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        currentMode = currentLevel.mode
        BALL_RADIUS = BALL_RADIUS * currentLevel.ballRadiusModifier
        BALL_SPEED_MULT = BALL_SPEED_MULT * currentLevel.ballSpeedMultModifier
        BALL_MAX_SPEED = BALL_MAX_SPEED * currentLevel.ballMaxSpeedModifier
        OBS_LENGTH = OBS_LENGTH * currentLevel.obsLengthModifier
        BALL_START_SPEED = BALL_START_SPEED * currentLevel.ballStartSpeedModifier
        ball = SKShapeNode(circleOfRadius: BALL_RADIUS)
        
        unitLength = Double(SCREEN_WIDTH)
        wallThickness = SCREEN_WIDTH * CGFloat(currentLevel.wallThicknessMultiplier)
        
        scoreLabel.text = String(score);
        scoreLabel.fontSize = SCREEN_WIDTH / 2;
        scoreLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2);
        scoreLabel.zPosition = -1
        
        self.addChild(scoreLabel)
        
        requiredScoreLabel.text = "\(currentLevel.scoreRequired) to win";
        requiredScoreLabel.fontColor = SKColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        requiredScoreLabel.fontSize = SCREEN_WIDTH / 5;
        requiredScoreLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 9 / 10);
        requiredScoreLabel.zPosition = -1
        
        if (UNLOCKED_LEVELS <= currentLevel.levelNumber) {
            self.addChild(requiredScoreLabel)
        }
        
        ball.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 3)
        ball.zPosition = 0
        ball.fillColor = COLOR_FADED_GREEN
        ball.lineWidth = 4
        
        ball_speed = Double(BALL_START_SPEED) * unitLength / 4
        ball_angle = (Double(arc4random_uniform(50)) + 20) * (M_PI / 180) + (M_PI / 2) * Double(arc4random_uniform(4))
        
        updateCartesian()
        
        self.addChild(ball)
        
        switch (currentMode) {
            
        case 0:
            obstacle = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            
        case 1:
            obstacle = SKShapeNode(rectOfSize: CGSize(width: OBS_LENGTH, height: OBS_LENGTH))
            
        case 2:
            obstacle = SKShapeNode(circleOfRadius: OBS_LENGTH / 2)
            
        default:
            obstacle = SKShapeNode(rectOfSize: CGSize(width: OBS_LENGTH, height: OBS_LENGTH))
            
        }
        obstacle.position = CGPoint(x: OBS_LENGTH * -3, y: OBS_LENGTH * -3)
        obstacle.zPosition = 1
        obstacle.fillColor = COLOR_FADED_RED
        obstacle.lineWidth = 4
        
        self.addChild(obstacle)
        
        self.scene?.backgroundColor = COLOR_FADED_BLUE
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        touchStart = (touches.first?.locationInNode(self))!
        
        if (first || lost) {
            first = false
            return
        }
        
        if (!lost) {
            
            switch (currentMode) {
            
            case 0:
                let touchLoc: [CGFloat] = [touchStart.x, touchStart.y]
                
                let newActiveWall = minimum(    distanceBetween(touchLoc, loc2: TOP_CENTER),
                                            n2: distanceBetween(touchLoc, loc2: RIGHT_CENTER),
                                            n3: distanceBetween(touchLoc, loc2: BOTTOM_CENTER),
                                            n4: distanceBetween(touchLoc, loc2: LEFT_CENTER))
                
                currentLevel.activeWalls = [false, false, false, false]
                currentLevel.activeWalls[newActiveWall] = true
                
                switch (newActiveWall) {
                    
                case Wall.Top.rawValue:
                    obstacle.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 1.5 - wallThickness)
                    
                case Wall.Right.rawValue:
                    obstacle.position = CGPoint(x: SCREEN_WIDTH * 1.5 - wallThickness, y: SCREEN_HEIGHT / 2)
                    
                case Wall.Bottom.rawValue:
                    obstacle.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / -2 + wallThickness)
                    
                case Wall.Left.rawValue:
                    obstacle.position = CGPoint(x: SCREEN_WIDTH / -2 + wallThickness, y: SCREEN_HEIGHT / 2)
                    
                default:
                    obstacle.position = CGPoint(x: -3 * SCREEN_WIDTH, y: -3 * SCREEN_HEIGHT)
                    
                }
                
            case 1,
                 2:
                obstacle.position = touches.first!.locationInNode(self)
            
            default:
                return
                
            }
            
        }
        
        /*
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let location = touches.first!.locationInNode(self)
        
        if (restartButton.containsPoint(location) && restartButton.containsPoint(touchStart)) {
            let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            
            game_scene.scaleMode = .AspectFill
            game_scene.currentLevel = currentLevel
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            //self.scene!.removeAllActions()
            //self.scene!.removeAllChildren()
            self.scene!.view!.presentScene(game_scene, transition: transition)
        }
        else if (menuButton.containsPoint(location) && menuButton.containsPoint(touchStart)) {
            let menu_scene = MenuScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            
            menu_scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            //self.scene!.removeAllActions()
            //self.scene!.removeAllChildren()
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
        else if (nextLevelButton.containsPoint(location) && nextLevelButton.containsPoint(touchStart)) {
            let game_scene = GameScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            
            game_scene.scaleMode = .AspectFill
            game_scene.currentLevel = GAME_LEVELS[currentLevel.levelNumber+1]
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            //self.scene!.removeAllActions()
            //self.scene!.removeAllChildren()
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
            
            updateHighscore(score, mode: currentMode)
            
            let highscoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            highscoreLabel.text = "Highscore: \(getHighscore(currentMode))"
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
            
            let restartLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            restartLabel.text = "Restart"
            restartLabel.fontSize = SCREEN_WIDTH / 9;
            restartLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 7 / 40)
            restartLabel.zPosition = 4
            self.addChild(restartLabel)
            
            restartButton.position = CGPoint(x: restartLabel.position.x, y: restartLabel.position.y + SCREEN_WIDTH / 27)
            restartButton.lineWidth = 4
            restartButton.zPosition = 3
            restartButton.strokeColor = COLOR_TRANSPARENT
            self.addChild(restartButton)
            
            let menuLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
            menuLabel.text = "Menu"
            menuLabel.fontSize = SCREEN_WIDTH / 9;
            menuLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 1 / 20)
            menuLabel.zPosition = 4
            self.addChild(menuLabel)
            
            menuButton.position = CGPoint(x: menuLabel.position.x, y: menuLabel.position.y + SCREEN_WIDTH / 27)
            menuButton.lineWidth = 4
            menuButton.zPosition = 3
            menuButton.strokeColor = COLOR_TRANSPARENT
            self.addChild(menuButton)
            
            if (score >= currentLevel.scoreRequired || UNLOCKED_LEVELS > currentLevel.levelNumber) {
                UNLOCKED_LEVELS = max(UNLOCKED_LEVELS, currentLevel.levelNumber + 1)
                DEFAULTS.setInteger(UNLOCKED_LEVELS, forKey: "Unlocked Levels")
                let nextLevelLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
                nextLevelLabel.text = "Next Level"
                nextLevelLabel.fontSize = SCREEN_WIDTH / 9;
                nextLevelLabel.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 3 / 10)
                nextLevelLabel.zPosition = 4
                self.addChild(nextLevelLabel)
                
                nextLevelButton.position = CGPoint(x: nextLevelLabel.position.x, y: nextLevelLabel.position.y + SCREEN_WIDTH / 27)
                nextLevelButton.lineWidth = 4
                nextLevelButton.zPosition = 3
                nextLevelButton.strokeColor = COLOR_TRANSPARENT
                self.addChild(nextLevelButton)
            }
            
            lost = true;
            
        }
        
        let timeSinceLastUpdate: Double = min(currentTime - lastUpdateTime, 1 / MIN_FRAMERATE)
        lastUpdateTime = currentTime
        
        if (currentLevel.gravityMode == 1) {
            ball_xSpeed += Double(currentLevel.gravityX) * timeSinceLastUpdate
            ball_ySpeed += Double(currentLevel.gravityY) * timeSinceLastUpdate
        }
        
        ball.position.x += CGFloat(ball_xSpeed * timeSinceLastUpdate)
        ball.position.y += CGFloat(ball_ySpeed * timeSinceLastUpdate)
        
        // Right Wall Collision Case
        if (abs(ball.position.x - SCREEN_WIDTH) <= BALL_RADIUS + wallThickness) {
            
            if (!currentLevel.activeWalls[Wall.Right.rawValue]) {
                justLost = true
            }
            else {
                ball_xSpeed = abs(ball_xSpeed) * -1
                updatePolar()
                speedUp()
                addScore(1)
            }
            
        }
    
        // Left Wall Collision Case
        else if (abs(ball.position.x) <= BALL_RADIUS + wallThickness) {
            
            if (!currentLevel.activeWalls[Wall.Left.rawValue]) {
                justLost = true
            }
            else {
                ball_xSpeed = abs(ball_xSpeed)
                updatePolar()
                speedUp()
                addScore(1)
            }
            
        }
        
        // Top Wall Collision Case
        if (abs(ball.position.y - SCREEN_HEIGHT) <= BALL_RADIUS + wallThickness) {
            
            if (!currentLevel.activeWalls[Wall.Top.rawValue]) {
                justLost = true
            }
            else {
                ball_ySpeed = abs(ball_ySpeed) * -1
                updatePolar()
                speedUp()
                addScore(1)
            }
            
        }
        
        // Bottom Wall Collision Case
        else if (abs(ball.position.y) <= BALL_RADIUS + wallThickness) {
            
            if (!currentLevel.activeWalls[Wall.Bottom.rawValue]) {
                justLost = true
            }
            else {
                ball_ySpeed = abs(ball_ySpeed)
                updatePolar()
                speedUp()
                addScore(1)
            }
            
        }

        switch (currentMode) {
            
        case 1:
            if (abs(ball.position.y - obstacle.position.y) < (OBS_LENGTH / 2 + BALL_RADIUS) && abs(ball.position.x -    obstacle.position.x) < (OBS_LENGTH / 2 + BALL_RADIUS)){
                if (!ball_colliding){
                    if (abs(ball.position.y - obstacle.position.y) > abs(ball.position.x - obstacle.position.x)){
                        ball_ySpeed = ball.position.y >= obstacle.position.y ? abs(ball_ySpeed) : abs(ball_ySpeed) * -1
                    }
                    else {
                        ball_xSpeed = ball.position.x >= obstacle.position.x ? abs(ball_xSpeed) : abs(ball_xSpeed) * -1
                    }
                    
                    updatePolar()
                    speedUp()
                    addScore(1)
                }
                ball_colliding = true
            }
            else {
                ball_colliding = false
            }
            
        case 2:
            if (pow(Double(ball.position.y - obstacle.position.y), 2.0) + pow(Double(ball.position.x - obstacle.position.x),2.0) < pow(Double(OBS_LENGTH / 2 + BALL_RADIUS),2.0)){
                if (!ball_colliding){
                    let nx = Double(ball.position.x - obstacle.position.x)
                    let ny = Double(ball.position.y - obstacle.position.y)
                    let ux = (ball_xSpeed * nx + ball_ySpeed * ny) / (nx * nx + ny * ny) * nx
                    let uy = (ball_xSpeed * nx + ball_ySpeed * ny) / (nx * nx + ny * ny) * ny
                    let wx = ball_xSpeed - ux
                    let wy = ball_ySpeed - uy
                    ball_xSpeed = wx - ux
                    ball_ySpeed = wy - uy
                    
                    updatePolar()
                    speedUp()
                    addScore(1)
                }
                ball_colliding = true
            }
            else {
                ball_colliding = false
            }
            
        default:
            return
            
        }
        
    }
    
    func speedUp() {
        let deltaMax = Double(BALL_MAX_SPEED) - ball_speed
        ball_speed += deltaMax * Double(BALL_SPEED_MULT)
        
        updateCartesian()
    }
    
    func addScore(n: Int) {
        score += n
        scoreLabel.text = String(score);
    }
    
    func updateCartesian() {
        ball_xSpeed = ball_speed * cos(ball_angle)
        ball_ySpeed = ball_speed * sin(ball_angle)
    }
    
    func updatePolar() {
        ball_speed = sqrt( ball_xSpeed * ball_xSpeed + ball_ySpeed * ball_ySpeed )
        ball_angle = atan2(ball_ySpeed, ball_xSpeed)
    }
    
    func distanceBetween(loc1: [CGFloat], loc2: [CGFloat]) -> CGFloat {
        return sqrt(pow(loc1[0] - loc2[0], 2) + pow(loc1[1] - loc2[1], 2))
    }
        
    func minimum(n1: CGFloat, n2: CGFloat, n3: CGFloat, n4: CGFloat) -> Int {
    
        if (n1 < n2 && n1 < n3 && n1 < n4) {
            return 0
        }
        else if (n2 < n3 && n2 < n4) {
            return 1
        }
        else if (n3 < n4) {
            return 2
        }
        else {
            return 3
        }
        
    }
    
}
