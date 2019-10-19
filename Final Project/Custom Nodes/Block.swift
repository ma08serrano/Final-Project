//
//  Block.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-23.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

enum BlockType: String {
    case wood, stone, glass
}

class Block: SKSpriteNode {
    
    let type: BlockType
    var health: Int
    let damageThreshold: Int
    
    // Initialize the block sprites
    // Setup the health based on what kind of blocks
    init(type: BlockType) {
        self.type = type
        switch type {
        case .wood:
            health = 200
        case .stone:
            health = 500
        case .glass:
            health = 50
        }
        damageThreshold = health / 2
        
        let texture = SKTexture(imageNamed: type.rawValue)
        super.init(texture: texture, color: UIColor.clear, size: CGSize.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the block physics in the scene
    func createPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.block
        physicsBody?.contactTestBitMask = PhysicsCategory.all
        physicsBody?.collisionBitMask = PhysicsCategory.all
    }
    
    // Decrease the block's health based on the impact from the bomb
    // Destroy the blocks when the health is less than 1
    func impact(with force: Int) {
        health -= force
        print(health)
        if health < 1 {
            removeFromParent()
        } else if health < damageThreshold {
            // Display the broken block
            let brokenTexture = SKTexture(imageNamed: type.rawValue + "Broken")
            texture = brokenTexture
        }
    }
}
