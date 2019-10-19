//
//  GameScene.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-22.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit
import GameplayKit

enum RoundState {
    case ready, flying, finished, animating, gameOver
}

class GameScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var mapNode = SKTileMapNode()
    
    var enemyLabel: SKLabelNode!
    static var enemyNum: Int = 3
    
    var bulletLabel: SKLabelNode!
    static var bullet: Int = 3
    
    var scoreLabel: SKLabelNode!
    static var score: Int = 0
    
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var maxScale: CGFloat = 0
    
    var bomb = Bomb(type: .red)
    var bombs = [Bomb]()
    var enemies = 0 {
        didSet {
            if enemies < 1 {
                roundState = .gameOver
                presentPopup(victory: true)
            }
        }
    }
    let anchor = SKNode()
    
    var level: Int?
    
    var roundState = RoundState.ready
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        guard let level = level else {
            return
        }
        guard let levelData = LevelData(level: level) else {
            return 
        }
        for bombColor in levelData.bombs {
            if let newBombType = BombType(rawValue: bombColor) {
                bombs.append(Bomb(type: newBombType))
            }
        }
                
        // Initialize the player's HUD
        enemyLabel = childNode(withName: "enemyNumber") as? SKLabelNode
        enemyLabel.text = "Enemy: \(GameScene.enemyNum)"
        
        GameScene.bullet = 3
        bulletLabel = childNode(withName: "playerBullet") as? SKLabelNode
        bulletLabel.text = "Bullet: \(GameScene.bullet)"
        
        GameScene.score = 0
        scoreLabel = childNode(withName: "playerScore") as? SKLabelNode
        scoreLabel.text = "Score: \(GameScene.score)"
        
        setupLevel()
        setupGestureRecognizers()
    }
    
    // TouchesBegan method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // The camera will follow the bomb based of the method such as ready, flying or finished
        switch roundState {
        case .ready:
            if let touch = touches.first {
                let location = touch.location(in: self)
                if bomb.contains(location) {
                    panRecognizer.isEnabled = false
                    bomb.grabbed = true
                    bomb.position = location
                }
            }
        case .flying:
            break
        case .finished:
            guard let view = view else { return }
            roundState = .animating
            let moveCameraBackAction = SKAction.move(to: CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2), duration: 2.0)
            moveCameraBackAction.timingMode = .easeInEaseOut
            gameCamera.run(moveCameraBackAction, completion: {
                self.panRecognizer.isEnabled = true
                self.addBomb()
            })
        case .animating:
            break
        case .gameOver:
            break
        }
    }
    
    // TouchesMoves method
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if bomb.grabbed {
                let location = touch.location(in: self)
                bomb.position = location
            }
        }
    }
    
    // TouchesEnded method
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bomb.grabbed {
            gameCamera.setConstraits(with: self, and: mapNode.frame, to: bomb)
            bomb.grabbed = false
            bomb.flying = true
            roundState = .flying
            contraintToAnchor(active: false)
            let dx = anchor.position.x - bomb.position.x
            let dy = anchor.position.y - bomb.position.y
            let impulse = CGVector(dx: dx, dy: dy)
            bomb.physicsBody?.applyImpulse(impulse)
            bomb.isUserInteractionEnabled = false
            
            // Decrease the bullet
            GameScene.bullet -= 1
        }
    }
    
    // Setup the gesture recognizers
    func setupGestureRecognizers() {
        guard let view = view else { return }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    func setupLevel() {
        if let mapNode = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = mapNode
            maxScale = mapNode.mapSize.width / frame.size.width
        }
        
        // Create an object in the scene
        for child in mapNode.children {
            if let child = child as? SKSpriteNode {
                guard let name = child.name else { continue }
                
                switch name {
                case "wood", "stone", "glass":
                    if let block = createBlock(from: child, name: name) {
                        mapNode.addChild(block)
                        child.removeFromParent()
                    }
                case "enemyOne":
                    if let enemy = createEnemy(from: child, name: name) {
                        mapNode.addChild(enemy)
                        enemies += 1
                        child.removeFromParent()
                    }
                case "enemyTwo":
                    if let enemy = createEnemy(from: child, name: name) {
                        mapNode.addChild(enemy)
                        enemies += 1
                        child.removeFromParent()
                    }
                case "enemyThree":
                    if let enemy = createEnemy(from: child, name: name) {
                        mapNode.addChild(enemy)
                        enemies += 1
                        child.removeFromParent()
                    }
                case "playerTank":
                    if let userTank = createPlayer(from: child, name: name) {
                        mapNode.addChild(userTank)
                        child.removeFromParent()
                    }
                default:
                    break
                }
            }
        }
        
        addCamera()
        
        // Setup the physics of the tileset
        let physicsRect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: physicsRect)
        physicsBody?.categoryBitMask = PhysicsCategory.edge
        physicsBody?.contactTestBitMask = PhysicsCategory.bomb | PhysicsCategory.block
        physicsBody?.collisionBitMask = PhysicsCategory.all
        
        anchor.position = CGPoint(x: mapNode.frame.midX / 4.3, y: mapNode.frame.maxY / 2)
        addChild(anchor)
        
        addBomb()
    }
    
    // Create a camera position
    func addCamera() {
        guard let view = view else { return }
        
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        
        camera = gameCamera
        gameCamera.setConstraits(with: self, and: mapNode.frame, to: nil)
    }
    
    // Setup the physics of the bomb and the bitmask
    func addBomb() {
        // If there's no bomb left, display game over
        if bombs.isEmpty {
            roundState = .gameOver
            
            // Display the popup when the bomb is empty
            presentPopup(victory: false)
            
            let saveString = scoreLabel.text
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(saveString, forKey: "Key")
            
            return
        }
        bomb = bombs.removeFirst()
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.bomb
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.all
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.edge
        bomb.physicsBody?.isDynamic = false
        bomb.position = anchor.position
        bomb.zPosition = ZPosition.bomb
        addChild(bomb)
        bomb.aspectScale(to: mapNode.tileSize, width: true, multiplier: 0.8)
        contraintToAnchor(active: true)
        roundState = .ready
    }
    
    // Setup the block's position, size and z position
    func createBlock(from placeholder: SKSpriteNode, name: String) -> Block? {
        guard let type = BlockType(rawValue: name) else { return nil }
        let block = Block(type: type)
        block.size = placeholder.size
        block.position = placeholder.position
        block.zRotation = placeholder.zRotation
        block.zPosition = ZPosition.obstacles
        block.createPhysicsBody()
        return block
    }
    
    // Setup the enemy's position, size and z position
    func createEnemy(from placeholder: SKSpriteNode, name: String) -> Enemy? {
        guard let enemyType = EnemyType(rawValue: name) else {
            return nil
        }
        let enemy = Enemy(type: enemyType)
        enemy.size = placeholder.size
        enemy.position = placeholder.position
        enemy.createPhysicsBody()
        return enemy
    }
    
    // Setup the player's position, size and z position
    func createPlayer(from placeholder: SKSpriteNode, name: String) -> Player? {
        guard let playerType = PlayerType(rawValue: name) else {
            return nil
        }
        let player = Player(type: playerType)
        player.size = placeholder.size
        player.position = placeholder.position
        player.createPhysicsBody()
        return player
    }
    
    func contraintToAnchor(active: Bool) {
        if active {
            let tankRange = SKRange(lowerLimit: 0.0, upperLimit: bomb.size.width * 3)
            let positionConstraint = SKConstraint.distance(tankRange, to: anchor)
            bomb.constraints = [positionConstraint]
        } else {
            bomb.constraints?.removeAll()
        }
    }
    
    func presentPopup(victory: Bool) {
        if victory {
            let popup = Popup(type: 0, size: frame.size)
            popup.zPosition = ZPosition.hugBackground
            popup.popupbuttonHandlerDelegate = self
            gameCamera.addChild(popup)
        } else {
            let popup = Popup(type: 1, size: frame.size)
            popup.zPosition = ZPosition.hugBackground
            popup.popupbuttonHandlerDelegate = self
            gameCamera.addChild(popup)
        }
    }
    
    // Bomb will be destroyed by hitting the ground
    override func didSimulatePhysics() {
        guard let physicsBody = bomb.physicsBody else { return }
        if roundState == .flying && physicsBody.isResting {
            gameCamera.setConstraits(with: self, and: mapNode.frame, to: nil)
            bomb.removeFromParent()
            roundState = .finished
        }
    }
}

extension GameScene: PopupButtonHandlerDelegate {
    
    // Triggered to menu
    func menuTapped() {
        sceneManagerDelegate?.presentLevelScene()
    }
    
    // Triggered to next level
    func nextTapped() {
        if let level = level {
            sceneManagerDelegate?.presentGameSceneFor(level: level + 1)
        }
    }
    
    // Triggered to retry the game
    func retryTapped() {
        if let level = level {
            sceneManagerDelegate?.presentGameSceneFor(level: level)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    // Setup the impact and contact of the objects
    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
        case PhysicsCategory.bomb | PhysicsCategory.block, PhysicsCategory.block | PhysicsCategory.edge:
            if let block = contact.bodyB.node as? Block {
                block.impact(with: Int(contact.collisionImpulse))
            } else if let block = contact.bodyA.node as? Block {
                block.impact(with: Int(contact.collisionImpulse))
            }
            if let bomb = contact.bodyA.node as? Bomb {
                bomb.flying = false
            } else if let bomb = contact.bodyB.node as? Bomb {
                bomb.flying = false
            }
        case PhysicsCategory.block | PhysicsCategory.block:
            if let block = contact.bodyA.node as? Block {
                block.impact(with: Int(contact.collisionImpulse))
            }
            if let block = contact.bodyB.node as? Block {
                block.impact(with: Int(contact.collisionImpulse))
            }
        case PhysicsCategory.bomb | PhysicsCategory.edge:
            bomb.flying = false
        case PhysicsCategory.bomb | PhysicsCategory.enemy:
            if let enemy = contact.bodyA.node as? Enemy {
                if enemy.impact(with: Int(contact.collisionImpulse)) {
                    enemies -= 1
                }
            } else if let enemy = contact.bodyB.node as? Enemy {
                if enemy.impact(with: Int(contact.collisionImpulse)) {
                    enemies -= 1
                }
            }
        default:
            break
        }
        
        // Update the enemy number
        bulletLabel = childNode(withName: "enemyNumber") as? SKLabelNode
        bulletLabel.text = "Enemy: \(GameScene.enemyNum)"
        
        // Update the bullet
        bulletLabel = childNode(withName: "playerBullet") as? SKLabelNode
        bulletLabel.text = "Bullet: \(GameScene.bullet)"
        
        // Update the score
        scoreLabel = childNode(withName: "playerScore") as? SKLabelNode
        scoreLabel.text = "Score: \(GameScene.score)"
    }
}

extension GameScene {
    // Pan Gesture Recognizer
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let view = view else { return }
        let translation = sender.translation(in: view) * gameCamera.yScale 
        gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    // Pinch Gesture Recognizer
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        guard let view = view else { return }
        if sender.numberOfTouches == 2 {
            let locationInView = sender.location(in: view)
            let location = convertPoint(fromView: locationInView)
            if sender.state == .changed {
                let convertedScale = 1 / sender.scale
                let newScale = gameCamera.yScale * convertedScale
                if newScale < maxScale && newScale > 0.5 {
                    gameCamera.setScale(newScale)
                }
                
                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = location - locationAfterScale
                let newPosition = gameCamera.position + locationDelta
                gameCamera.position = newPosition
                sender.scale = 1.0
                gameCamera.setConstraits(with: self, and: mapNode.frame, to: nil)
            }
        }
    }
}
