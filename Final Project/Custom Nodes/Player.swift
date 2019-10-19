//
//  Player.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-29.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

enum PlayerType: String {
    case playerTank
}

class Player: SKSpriteNode {
    
    let type: PlayerType
    var health: Int
    let animationFrames: [SKTexture]
    
    // Initialize the player sprites, color and size
    // Setup the player's life to 500
    init(type: PlayerType) {
        self.type = type
        animationFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: type.rawValue), withName: type.rawValue)
        
        switch type {
        case .playerTank:
            health = 500
        }
        
        let texture = SKTexture(imageNamed: type.rawValue + "1")
        super.init(texture: texture, color: UIColor.clear, size: CGSize.zero)
        animatePlayer()
    }
    
    // Animate the player's sprite
    func animatePlayer() {
        run(SKAction.repeatForever(SKAction.animate(with: animationFrames, timePerFrame: 0.1, resize: false, restore: true)))
    }
    
    // Setup the player's physics and collision
    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.player
        physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.block | PhysicsCategory.edge
        physicsBody?.collisionBitMask = PhysicsCategory.enemy | PhysicsCategory.block | PhysicsCategory.edge
    }
    
    // Decrease the player's health based on the bomb's force
    // Destroy the player's sprite if the health is less than 1
    func impact(with force: Int) -> Bool {
        health -= force
        if health < 1 {
            removeFromParent()
            return true
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
