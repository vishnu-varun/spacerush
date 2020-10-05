//
//  GameScene.swift
//  Space Rush
//
//  Created by Varun Vishnubhotla on 6/13/20.
//  Copyright © 2020 Varun Vishnubhotla. All rights reserved.
//

import SpriteKit
import GameplayKit

var score = 0
var wastedBulletMax = 10
class GameScene: SKScene, SKPhysicsContactDelegate {
    var levelVal = 0
    var livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    let player = SKSpriteNode (imageNamed: "userSpaceShip")
    let startLabel = SKLabelNode (fontNamed: "The Bold Font")
    
    enum gameStatus {
        case beforeGame
        case duringGame
        case postGame
    }
    
    var curGameStatus = gameStatus.beforeGame
    
    struct physicsCategories {
        static let None : UInt32 = 0
        static let Player: UInt32 = 0b1 //1
        static let Bullet: UInt32 = 0b10 //2
        static let enemyPlayer: UInt32 = 0b100 //4
    }
    
    func random () -> CGFloat{
        return CGFloat (Float(arc4random()) /  0xFFFFFFFF)
    }
    func random (min minimum : CGFloat, max: CGFloat) -> CGFloat {
        return random () * (max - minimum) + minimum
    }
    
    let gameArea : CGRect
    override init(size: CGSize) {
        
        let maxAspectRatio : CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        score = 0
        wastedBulletMax = 10
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "BG_starrynight")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale (1)
        player.position = CGPoint (x: self.size.width/2, y: self.size.width/5)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf : player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        player.physicsBody!.collisionBitMask = physicsCategories.None
        player.physicsBody!.contactTestBitMask = physicsCategories.None
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 65
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint (x: self.size.width * 0.2, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 200
        self.addChild(scoreLabel)
        
        livesLabel.text = "Bullets: 10"
        livesLabel.fontSize = 65
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        livesLabel.position = CGPoint (x: self.size.width * 0.6, y: self.size.height + scoreLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        startLabel.text = "Click screen to start"
        startLabel.fontSize = 85
        startLabel.fontColor = SKColor.white
        startLabel.zPosition = 1
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(startLabel)
        
        let fadeToScreen = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.2)
        scoreLabel.run (fadeToScreen)
        livesLabel.run (fadeToScreen)

    }
    func transitionToDuringGame(){
        
        curGameStatus = gameStatus.duringGame
        let dissapearFade = SKAction.fadeOut(withDuration: 0.4)
        let removeAction = SKAction.removeFromParent()
        let dissapearRemove = SKAction.sequence([dissapearFade, removeAction])
        startLabel.run(dissapearRemove)
        
        let openingSceneAction = SKAction.run (openingScene)
        player.run(openingSceneAction)
        
    }
    
    func loseBullet(){
        
        wastedBulletMax -= 1
        livesLabel.text = "Bullets: \(wastedBulletMax)"
       
        let zoomIn = SKAction.scale(to: 1.5, duration: 0.2)
        let zoomOut = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence ([zoomIn, zoomOut])
        livesLabel.run(scaleSequence)
        
        if wastedBulletMax == 0{
            gameOver()
        }
        
    }
    
    func scoreAdd (){
        
        score+=1
        scoreLabel.text = "Score: \(score)"
        
        if score == 21 || score == 38 || score == 49 || score == 70{
            openingScene()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.enemyPlayer && (body2.node?.position.y)! < self.size.height {
            

            if body2.node != nil{
                explode(positionOfExplosion: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            scoreAdd()
        }
    }
    
    func explode (positionOfExplosion : CGPoint){
        
        let explode = SKSpriteNode(imageNamed: "explosion")
        explode.position = positionOfExplosion
        explode.zPosition = 3
        explode.setScale (0)
        self.addChild (explode)
        
        let zoomIn = SKAction.scale (to: 1, duration: 0.1)
        let disappear = SKAction.fadeOut(withDuration: 0.1)
        let offScreen = SKAction.removeFromParent()
        
        let explodeSequence = SKAction.sequence ([zoomIn, disappear, offScreen])
        
        explode.run (explodeSequence)
    }
    
    func gameOver(){
        
        curGameStatus = gameStatus.postGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "bullet1"){
            bullet, stop in
            bullet.removeAllActions()
        
        }
        self.enumerateChildNodes(withName: "enemy"){
            enemyPlayer, stop in
            enemyPlayer.removeAllActions()
        }
        
        let transitionScenes = SKAction.run(transitionScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence ([waitToChangeScene, transitionScenes])
        self.run(changeSceneSequence)
        
    }
    
    func transitionScene(){
        
        let sceneTransition = SceneGameOver(size: self.size)
        sceneTransition.scaleMode = self.scaleMode
        let motion = SKTransition.fade(withDuration: 0.4)
        self.view!.presentScene(sceneTransition, transition: motion)
    }
    
    func openingScene(){
        
        levelVal += 1
        
        if self.action(forKey: "enemies") != nil {
            self.removeAction(forKey: "enemies")
        }
         var levelTime = TimeInterval()
        switch levelVal {
       
        case 1: levelTime = 0.5
        case 2: levelTime = 0.4
        case 3: levelTime = 0.3
        case 4: levelTime = 0.2
        case 5: levelTime = 0.1
            
        default:
            levelTime = 0.6
            print("Cannot find level value")
        }
        
        let initialSpawn = SKAction.run(enemyAppear)
        let waitToSpawn = SKAction.wait (forDuration: 1)
        let spawnSequence = SKAction.sequence ([waitToSpawn, initialSpawn])
        let spawnForever = SKAction.repeatForever (spawnSequence)
        self.run (spawnForever, withKey: "enemies")
        
    }
    
    
    func BulletFire (){
    
        let bullet = SKSpriteNode (imageNamed: "Bullet")
        bullet.name = "bullet1"
        bullet.color = SKColor.white
        bullet.setScale (1)
        bullet.position = player.position
        bullet.zPosition = 0
        bullet.physicsBody = SKPhysicsBody (rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        bullet.physicsBody!.contactTestBitMask = physicsCategories.enemyPlayer
        self.addChild (bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let loseBulletMethod = SKAction.run(loseBullet)
        let bulletSequence = SKAction.sequence([moveBullet,deleteBullet, loseBulletMethod])
        bullet.run(bulletSequence)

    }
    
    func enemyAppear (){
        let enemyPlayer = SKSpriteNode (imageNamed: "enemySpaceShip")
        enemyPlayer.name = "enemy"
        let randomXEnemy = random (min: gameArea.minX, max: gameArea.maxX)
        enemyPlayer.setScale (1)
        enemyPlayer.position = CGPoint (x: randomXEnemy, y: self.size.height * 0.8 )
        enemyPlayer.zPosition = 2
        enemyPlayer.physicsBody = SKPhysicsBody (rectangleOf: enemyPlayer.size)
        enemyPlayer.physicsBody!.affectedByGravity = false
        enemyPlayer.physicsBody!.categoryBitMask = physicsCategories.enemyPlayer
        enemyPlayer.physicsBody!.collisionBitMask = physicsCategories.None
        enemyPlayer.physicsBody!.contactTestBitMask = physicsCategories.Bullet
        self.addChild(enemyPlayer)
        
       if enemyPlayer.position.x > gameArea.maxX  - enemyPlayer.size.width / 2{
                             enemyPlayer.position.x = gameArea.maxX - enemyPlayer.size.width / 2
       }
       if enemyPlayer.position.x < gameArea.minX + enemyPlayer.size.width / 2 {
                             enemyPlayer.position.x = gameArea.minX + enemyPlayer.size.width / 2
       }
              
        let motionEnemyPlayerForward = SKAction.moveTo(x: gameArea.maxX - enemyPlayer.size.width / 2, duration: 0.5)
        let motionEnemyPlayerBackward = SKAction.moveTo (x: gameArea.minX + enemyPlayer.size.width / 2, duration: 0.5)
        let enemySequence = SKAction.sequence([motionEnemyPlayerForward, motionEnemyPlayerBackward])
        let spawnForever = SKAction.repeatForever (enemySequence)
        
        if curGameStatus == gameStatus.duringGame{
        enemyPlayer.run(spawnForever)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if curGameStatus == gameStatus.beforeGame {
                 transitionToDuringGame()
             }
        
        else if curGameStatus == gameStatus.duringGame {
            BulletFire()
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if curGameStatus == gameStatus.duringGame {
                 player.position.x += amountDragged
            }
           
            
            if player.position.x > gameArea.maxX  - player.size.width / 2{
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            if player.position.x < gameArea.minX + player.size.width / 2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
    }
}
