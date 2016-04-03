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
    
    /*
    /*
     *
    **  HI LEO,
    **  
    **  I HAVE FINISHED IMPLEMENTING DIRECTIONAL
    **  GRAVITY AS A SUBCLASS OF LEVELEFFECT. TO USE
    **  IT, TAKE INPUT FROM THE PLIST, THEN CHECK FOR THE
    **  EFFECT ID. IF THE EFFECT ID IS 0, ADD A
    **  DIRECTIONALGRAVITY OBJECT TO THE EFFECTS SET
    **  HERE IN GAMESCENE WITH THE PARAMETERS (X, Y).
    **  AFTER YOU'VE DONE THAT, IT SHOULD TAKE CARE OF
    **  ITSELF.
    **
    **  FROM,
    **  BRANDON TAI ROBOT GUY
    **
    **  PS: I ALSO MADE BALL ITS OWN CLASS
    *
    */
    */
    
    var currentLevel = Level(level: 0)
    
    var effects: [LevelEffect] = []
    
    var OBS_LENGTH: CGFloat = SCREEN_WIDTH / 5
    
    var currentMode: Int = 0
    
    var first: Bool = true
    var lost: Bool = false
    var justLost: Bool = false
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let requiredScoreLabel = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    var ball = Ball()
    var obstacle = SKShapeNode(rectOfSize: CGSize(width: 1, height: 1))
    
    let restartButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    let menuButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    let nextLevelButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
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
        
        hintLabel.text = currentLevel.hint
        hintLabel.fontColor = SKColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.5)
        hintLabel.fontSize = SCREEN_WIDTH / 10
        hintLabel.position.x = SCREEN_WIDTH / 2
        hintLabel.position.y = SCREEN_HEIGHT / 10
        self.addChild(hintLabel)
        
        currentHighscore = getHighscore()
        currentMode = currentLevel.mode
        ball.radius = ball.radius * currentLevel.ballRadiusModifier
        ball.speedMult = ball.speedMult * currentLevel.ballSpeedMultModifier
        ball.maxSpeed = ball.maxSpeed * currentLevel.ballMaxSpeedModifier
        OBS_LENGTH = OBS_LENGTH * currentLevel.obsLengthModifier
        ball.spd = ball.spd * currentLevel.ballStartSpeedModifier
        
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
            OBS_LENGTH = SCREEN_HEIGHT
            
        }
        
        switch (currentMode) {
            
        case 0,
             1:
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
            let disappear = SKAction.fadeOutWithDuration(0.5)
            hintLabel.runAction(disappear)
            return
        }
        
        if (!lost) {
            
            switch (currentMode) {
            
            case 0:
                let touchLoc: [CGFloat] = [touchStart.x, touchStart.y]
                
                let newActiveWall = minimum(    distanceBetween(touchLoc, TOP_CENTER),
                                                distanceBetween(touchLoc, RIGHT_CENTER),
                                                distanceBetween(touchLoc, BOTTOM_CENTER),
                                                distanceBetween(touchLoc, LEFT_CENTER))
                
                currentLevel.activeWalls = [false, false, false, false]
                currentLevel.activeWalls[newActiveWall] = true
                
                switch (newActiveWall) {
                    
                case Wall.Top.rawValue:
                    obstacle.position = CGPoint(x: OBS_LENGTH / 2, y: OBS_LENGTH * 1.5 - wallThickness)
                    
                case Wall.Right.rawValue:
                    obstacle.position = CGPoint(x: SCREEN_WIDTH + OBS_LENGTH / 2 - wallThickness, y: OBS_LENGTH / 2)
                    
                case Wall.Bottom.rawValue:
                    obstacle.position = CGPoint(x: OBS_LENGTH / 2, y: OBS_LENGTH / -2 + wallThickness)
                    
                case Wall.Left.rawValue:
                    obstacle.position = CGPoint(x: OBS_LENGTH / -2 + wallThickness, y: OBS_LENGTH / 2)
                    
                default:
                    obstacle.position = CGPoint(x: -3 * OBS_LENGTH, y: -3 * OBS_LENGTH)
                    
                }
                
            case 1,
                 2:
                obstacle.position = touches.first!.locationInNode(self)
            
            default:
                return
                
            }
            
        }
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
            
            if (GAME_LEVELS.count > currentLevel.levelNumber + 1 && (score >= currentLevel.oneStar || UNLOCKED_LEVELS > currentLevel.levelNumber)) {
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
        
        for effect in effects {
            effect.update(timeSinceLastUpdate, &ball, &obstacle)
        }
        
        /*if (currentLevel.gravityMode == 1) {
            ball.xSpeed += Double(currentLevel.gravityX) * timeSinceLastUpdate
            ball.ySpeed += Double(currentLevel.gravityY) * timeSinceLastUpdate
        } else*/ if (currentLevel.gravityMode == 2) {
            
            let xDist = abs(currentLevel.gravityX * SCREEN_WIDTH - ball.position.x) * 1 + 10
            let yDist = abs(currentLevel.gravityY * SCREEN_HEIGHT - ball.position.y) * 1 + 10
            var gravityForce : CGFloat = 0
            if (abs(xDist) + abs(yDist) > 30) {
                gravityForce = currentLevel.gravityStrength / (pow(xDist, 2) + pow(yDist, 2))
            }
            //print(gravityForce)
            ball.xSpeed += CGFloat(gravityForce * (currentLevel.gravityX * SCREEN_WIDTH - ball.position.x) / (xDist + yDist))
            ball.ySpeed += CGFloat(gravityForce * (currentLevel.gravityY * SCREEN_HEIGHT - ball.position.y) / (xDist + yDist))
            
        }
        
        ball.update(timeSinceLastUpdate)
        
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

        switch (currentMode) {
            
        case 0,
             1:
            if (abs(ball.position.y - obstacle.position.y) < (OBS_LENGTH / 2 + ball.radius) && abs(ball.position.x -    obstacle.position.x) < (OBS_LENGTH / 2 + ball.radius)){
                if (!ball.colliding){
                    if (abs(ball.position.y - obstacle.position.y) > abs(ball.position.x - obstacle.position.x)){
                        ball.ySpeed = ball.position.y >= obstacle.position.y ? abs(ball.ySpeed) : abs(ball.ySpeed) * -1
                    }
                    else {
                        ball.xSpeed = ball.position.x >= obstacle.position.x ? abs(ball.xSpeed) : abs(ball.xSpeed) * -1
                    }
                    
                    ball.updatePolar()
                    speedUp()
                    addScore(1)
                }
                ball.colliding = true
            }
            else {
                ball.colliding = false
            }
            
        case 2:
            if (pow(Double(ball.position.y - obstacle.position.y), 2.0) + pow(Double(ball.position.x - obstacle.position.x),2.0) < pow(Double(OBS_LENGTH / 2 + ball.radius),2.0)){
                if (!ball.colliding){
                    let nx = Double(ball.position.x - obstacle.position.x)
                    let ny = Double(ball.position.y - obstacle.position.y)
                    let mxy = (Double(ball.xSpeed) * nx + Double(ball.ySpeed) * ny)
                    let dxy = (nx * nx + ny * ny)
                    let mdxy = mxy / dxy
                    let ux = mdxy * nx
                    let uy = mdxy * ny
                    let wx = Double(ball.xSpeed) - ux
                    let wy = Double(ball.ySpeed) - uy
                    ball.xSpeed = CGFloat(wx - ux)
                    ball.ySpeed = CGFloat(wy - uy)
                    
                    ball.updatePolar()
                    speedUp()
                    addScore(1)
                }
                ball.colliding = true
            }
            else {
                ball.colliding = false
            }
            
        default:
            return
            
        }
        
    }
    
    func speedUp() {
        let deltaMax: Double = Double(ball.maxSpeed) - Double(ball.spd)
        ball.spd += CGFloat(deltaMax * Double(ball.speedMult))
        
        ball.updateCartesian()
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
    
    func distanceBetween(loc1: [CGFloat], _ loc2: [CGFloat]) -> CGFloat {
        return sqrt(pow(loc1[0] - loc2[0], 2) + pow(loc1[1] - loc2[1], 2))
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
    
}
