//
//  EndScene.swift
//  Car Game
//
//  Created by Mobile on 3/6/26.
//

import SpriteKit
import GameplayKit

class EndScene: SKScene {
    
    var finalScore = CGFloat()
    
    override func didMove(to view: SKView) {
        let scoreText = SKLabelNode()
        scoreText.fontSize = 100
        scoreText.fontColor = .white
        scoreText.text = "\(finalScore)"
        addChild(scoreText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nextScene = GameScene(fileNamed: "GameScene")
        nextScene?.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(nextScene!, transition: transition)
    }
}
