//
//  GameViewController.swift
//  Ball Game
//
//  Created by Leo Adberg on 3/26/16.
//  Copyright (c) 2016 Leo Adberg. All rights reserved.
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
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let scene = GameScene(size: CGSizeMake(self.view.frame.width, self.view.frame.height))
        let scene = MenuScene(size: CGSizeMake(self.view.frame.width, self.view.frame.height))
        
        let skView = self.view as! SKView
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        
        let transition = SKTransition.crossFadeWithDuration(NSTimeInterval(0.5))
        
        skView.presentScene(scene, transition: transition)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*override func viewDidDisappear(animated: Bool) {
        let skView = self.view as! SKView
        skView.presentScene(nil)
    }*/
}
