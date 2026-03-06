//
//  GameViewController.swift
//  Car Game
//
//  Created by Mobile on 2/9/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = MenuScene(fileNamed: "MenuScene") {
            let skView = self.view as! SKView
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            skView.ignoresSiblingOrder = true
            
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            // Present the scene
            skView.presentScene(scene)
        }
        
        
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
