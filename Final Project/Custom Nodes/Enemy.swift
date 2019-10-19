//
//  Enemy.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-29.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

enum EnemyType: String {
    case enemyOne
    case enemyTwo
    case enemyThree
}

class Enemy: SKSpriteNode {
    
    let type: EnemyType
    var health: Int
    var score: Int
    let animationFrames: [SKTexture]
    
    // Initialize the enemy sprites, color and size
    // Setup the enemy's life to 500
    init(type: EnemyType) {
        self.type = type
        animationFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: type.rawValue), withName: type.rawValue)
        
        switch type {
        case .enemyOne:
            health = 300
            score = 100
        case .enemyTwo:
            health = 300
            score = 200
        case .enemyThree:
            health = 300
            score = 500
        }
        
        let texture = SKTexture(imageNamed: type.rawValue + "1")
        super.init(texture: texture, color: UIColor.clear, size: CGSize.zero)
        animateEnemy()
    }
    
    // Animate the enemy's sprite
    func animateEnemy() {
        run(SKAction.repeatForever(SKAction.animate(with: animationFrames, timePerFrame: 0.1, resize: false, restore: true)))
    }
    
    // Setup the enemy's physics and collision
    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.enemy
        physicsBody?.contactTestBitMask = PhysicsCategory.all
        physicsBody?.collisionBitMask = PhysicsCategory.all
    }
    
    // Decrease the enemy's health based on the bomb's force
    // Destroy the enemy's sprite if the health is less than 1
    func impact(with force: Int) -> Bool {
        health -= force
        if health < 1 {
            removeFromParent()
            
            GameScene.enemyNum -= 1
            
            // Add score when the enemy is destroyed
            GameScene.score += score
            
            return true
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
