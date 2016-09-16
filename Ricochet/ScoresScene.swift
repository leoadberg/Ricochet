//
//  ScoresScene.swift
//  Ricochet
//
//  Created by Tigersushi on 3/27/16.
//  Copyright © 2016 Tigersushi. All rights reserved.
//

import SpriteKit

class ScoresScene: SKScene {
    
    let scoreSquare = SKShapeNode(rectOf: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH * 2 / 5))
    let scoreCircle = SKShapeNode(circleOfRadius: SCREEN_WIDTH / 5)
    let backButton = SKShapeNode(rectOf: CGSize(width: SCREEN_WIDTH * 2 / 5, height: SCREEN_WIDTH / 6))
    
    let scoreSquare_text = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let scoreCircle_text = SKLabelNode(fontNamed:"DINAlternate-Bold")
    let backButton_text = SKLabelNode(fontNamed:"DINAlternate-Bold")
    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = COLOR_FADED_BLUE
        
        backButton_text.position = CGPoint(x: SWOVER2, y: SCREEN_WIDTH  / 4)
        backButton_text.text = "Back"
        backButton_text.fontSize = SCREEN_WIDTH / 9;
        
        backButton.position = CGPoint(x: backButton_text.position.x, y: backButton_text.position.y + SCREEN_WIDTH / 27)
        backButton.fillColor = COLOR_FADED_GREEN
        backButton.lineWidth = 4
        
        scoreSquare.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT * 4 / 5)
        scoreSquare.fillColor = COLOR_FADED_RED
        scoreSquare.lineWidth = 4
        scoreCircle.position = CGPoint(x: SWOVER2, y: SCREEN_HEIGHT / 2)
        scoreCircle.fillColor = COLOR_FADED_RED
        scoreCircle.lineWidth = 4
        
        scoreSquare_text.position.y = scoreSquare.position.y - SCREEN_WIDTH / 16
        scoreSquare_text.position.x = SWOVER2
        scoreSquare_text.text = String(DEFAULTS.integer(forKey: "Highscore1"))
        scoreSquare_text.fontSize = SCREEN_WIDTH / 6
        scoreSquare_text.zPosition = 2
        
        scoreCircle_text.position.y = scoreCircle.position.y - SCREEN_WIDTH / 16
        scoreCircle_text.position.x = SWOVER2
        scoreCircle_text.text = String(DEFAULTS.integer(forKey: "Highscore2"))
        scoreCircle_text.fontSize = SCREEN_WIDTH / 6
        scoreCircle_text.zPosition = 2
        
        self.addChild(backButton)
        self.addChild(backButton_text)
        self.addChild(scoreSquare_text)
        self.addChild(scoreCircle_text)
        self.addChild(scoreSquare)
        self.addChild(scoreCircle)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        /* Called when a touch begins */
        
        let location = touches.first!.location(in: self)
        
        if (backButton.contains(location)) {
            backButton.fillColor = COLOR_FADED_RED
        }
        else {
            backButton.fillColor = COLOR_FADED_GREEN
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if (backButton.contains(location)) {
            let menu_scene = MenuScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
            
            menu_scene.scaleMode = .aspectFill
            let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
            self.scene!.view!.presentScene(menu_scene, transition: transition)
        }
    }
}
