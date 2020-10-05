//
//  Scene_GameOver.swift
//  Space Rush
//
//  Created by Varun Vishnubhotla on 6/17/20.
//  Copyright © 2020 Varun Vishnubhotla. All rights reserved.
//

import SpriteKit
import Foundation

class SceneGameOver : SKScene{
     let restartButton = SKLabelNode (fontNamed: "The Bold Font")
    override func didMove(to view: SKView) {
        
        let background1 = SKSpriteNode (imageNamed: "BG_starrynight")
        background1.position = CGPoint (x: self.size.width/3, y: self.size.height/2)
        background1.zPosition = 0
        self.addChild(background1)
        
        let gameEndLabel = SKLabelNode (fontNamed: "The Bold Font")
        gameEndLabel.text = "Game Ended"
        gameEndLabel.fontSize = 170
        gameEndLabel.fontColor = SKColor.white
        gameEndLabel.position = CGPoint (x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameEndLabel.zPosition = 1
        self.addChild(gameEndLabel)
        
        let finalScore = SKLabelNode (fontNamed: "The Bold Font")
        finalScore.text = "Score: \(score)"
        finalScore.fontSize = 110
        finalScore.fontColor = SKColor.white
        finalScore.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.55)
        finalScore.zPosition = 1
        self.addChild (finalScore)
        
        let defaultVal = UserDefaults()
        var highScoreVal = defaultVal.integer(forKey: "highScoreValTotal")
        
        if score > highScoreVal {
            highScoreVal = score
            defaultVal.set (highScoreVal, forKey: "highScoreValTotal")
        }
        
        let highScoreValLabel = SKLabelNode (fontNamed: "The Bold Font")
        highScoreValLabel.text = "High Score: \(highScoreVal)"
        highScoreValLabel.fontSize = 110
        highScoreValLabel.fontColor = SKColor.white
        highScoreValLabel.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.45)
        highScoreValLabel.zPosition = 1
        self.addChild (highScoreValLabel)
        
        
        restartButton.text = "Restart Game"
        restartButton.fontSize = 100
        restartButton.fontColor = SKColor.white
        restartButton.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.25)
        restartButton.zPosition = 1
        restartButton.name = "restartButton"
        self.addChild(restartButton)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches{
        let pointOfTouch = touch.location(in: self)
        let nodeTapped = atPoint (pointOfTouch)
            
            if nodeTapped.name == "restartButton" {
            let sceneTransition2 = GameScene (size: self.size)
            sceneTransition2.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.4)
            self.view!.presentScene (sceneTransition2, transition: myTransition)
            }
            
            
            
     
    }
}
}

