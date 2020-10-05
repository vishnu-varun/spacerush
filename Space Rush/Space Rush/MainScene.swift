//
//  MainScene.swift
//  Space Rush
//
//  Created by Varun Vishnubhotla on 6/19/20.
//  Copyright © 2020 Varun Vishnubhotla. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene : SKScene {
    let startGameButton = SKLabelNode (fontNamed: "The Bold Font")
    override func didMove(to view: SKView) {
        
        let background2 = SKSpriteNode (imageNamed: "BG_starrynight")
        background2.position = CGPoint (x: self.size.height/2 , y: self.size.height / 2)
        background2.zPosition = 0
        self.addChild(background2)
        
        let gameName = SKLabelNode (fontNamed: "The Bold Font")
        gameName.text = "Space Rush"
        gameName.fontSize = 170
        gameName.color = SKColor.white
        gameName.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.7)
        gameName.zPosition = 1
        self.addChild (gameName)
        
        let beginGameLabel = SKLabelNode (fontNamed: "The Bold Font")
        beginGameLabel.text = "Begin Game"
        beginGameLabel.fontSize = 110
        beginGameLabel.color = SKColor.white
        beginGameLabel.position = CGPoint (x: self.size.width/2, y: self.size.height * 0.55)
        beginGameLabel.zPosition = 1
        beginGameLabel.name = "beginGame"
        self.addChild (beginGameLabel)
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches{
        let pointOfTouch = touch.location(in: self)
        let nodeTapped = atPoint (pointOfTouch)
            if nodeTapped.name == "beginGame" {
                let sceneTransition2 = GameScene (size: self.size)
                sceneTransition2.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.4)
                self.view!.presentScene (sceneTransition2, transition: myTransition)
            
            }
       
            
      
    }

    
    
}
}

