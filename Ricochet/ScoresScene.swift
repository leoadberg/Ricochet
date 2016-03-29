//
//  ScoresScene.swift
//  Ball Game
//
//  Created by Leo Adberg on 3/27/16.
//  Copyright © 2016 Leo Adberg. All rights reserved.
//

import SpriteKit

class ScoresScene: SKScene {
    
    let scoreSquare = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH * 2 / 5))
    let scoreCircle = SKShapeNode(circleOfRadius: SCREEN_WIDTH / 5)
    let backButton = SKShapeNode(rectOfSize: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    
    let scoreSquare_text = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let scoreCircle_text = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let backButton_text = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    override func didMoveToView(view: SKView) {
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        backButton_text.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_WIDTH  / 4)
        backButton_text.text = "Back"
        backButton_text.fontSize = SCREEN_WIDTH / 9;
        
        backButton.position = CGPoint(x: backButton_text.position.x, y: backButton_text.position.y + SCREEN_WIDTH / 27)
        backButton.fillColor = COLOR_FADED_GREEN
        backButton.lineWidth = 4
        
        scoreSquare.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT * 4 / 5)
        scoreSquare.fillColor = COLOR_FADED_RED
        scoreSquare.lineWidth = 4
        scoreCircle.position = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        scoreCircle.fillColor = COLOR_FADED_RED
        scoreCircle.lineWidth = 4
        
        scoreSquare_text.position.y = scoreSquare.position.y - SCREEN_WIDTH / 16
        scoreSquare_text.position.x = SCREEN_WIDTH / 2
        scoreSquare_text.text = String(DEFAULTS.integerForKey("Highscore1"))
        scoreSquare_text.fontSize = SCREEN_WIDTH / 6
        scoreSquare_text.zPosition = 2
        
        scoreCircle_text.position.y = scoreCircle.position.y - SCREEN_WIDTH / 16
        scoreCircle_text.position.x = SCREEN_WIDTH / 2
        scoreCircle_text.text = String(DEFAULTS.integerForKey("Highscore2"))
        scoreCircle_text.fontSize = SCREEN_WIDTH / 6
        scoreCircle_text.zPosition = 2
        
        self.addChild(backButton)
        self.addChild(backButton_text)
        self.addChild(scoreSquare_text)
        self.addChild(scoreCircle_text)
        self.addChild(scoreSquare)
        self.addChild(scoreCircle)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        let location = touches.first!.locationInNode(self)
        
        if (backButton.containsPoint(location)) {
            backButton.fillColor = COLOR_FADED_RED
        }
        else {
            backButton.fillColor = COLOR_FADED_GREEN
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        if (backButton.containsPoint(location)) {
            let menu_scene = MenuScene(size: CGSizeMake(self.scene!.view!.frame.width, self.scene!.view!.frame.height))
            
            menu_scene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
    }
}