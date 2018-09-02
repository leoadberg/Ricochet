//
//  GameViewController.swift
//  Ricochet
//
//  Created by Tigersushi on 3/26/16.
//  Copyright (c) 2016 Tigersushi. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    /*override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
    
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let scene = GameScene(size: CGSizeMake(self.view.frame.width, self.view.frame.height))
        //let scene = MenuScene(size: CGSize(width: self.scene!.view!.frame.width, height: self.scene!.view!.frame.height))
		
		
        let scene = MenuScene(size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        let skView = self.view as! SKView
		
		let maxFPS = UIScreen.main.maximumFramesPerSecond
		skView.preferredFramesPerSecond = maxFPS
		skView.showsFPS = true
		
		skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        
        let transition = SKTransition.crossFade(withDuration: TimeInterval(0.5))
        
        skView.presentScene(scene, transition: transition)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        /*if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .allButUpsideDown
        } else {
            return .all
        }*/
        return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*override func viewDidDisappear(animated: Bool) {
        let skView = self.view as! SKView
        skView.presentScene(nil)
    }*/
}
