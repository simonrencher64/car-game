//
//  MenuScene.swift
//  Car Game
//
//  Created by Mobile on 3/4/26.
//

//import Foundation

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    
    
    override func didMove(to view: SKView) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchNode = self.atPoint(touch.location(in: self))
            if touchNode.name == "startButton" {
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene?.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(nextScene!, transition: transition)
            }
        }
        
    }
    
    
    
}
