//
//  Bomb.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-23.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

enum BombType: String {
    case red, blue, black
}

class Bomb: SKSpriteNode {
    
    let bombType: BombType
    
    var grabbed = false
    
    // Animate the bomb when it's flying
    // or else disabled the animation
    var flying = false {
        didSet {
            if flying {
                physicsBody?.isDynamic = true
                animateFlight(active: true)
            } else {
                animateFlight(active: false)
            }
        }
    }
    
    let flyingFrames: [SKTexture]
    
    // Initialize the bomb texture based on the index number
    init(type: BombType) {
        bombType = type
        flyingFrames = AnimationHelper.loadTextures(from: SKTextureAtlas(named: type.rawValue), withName: type.rawValue)
        
        let texture = SKTexture(imageNamed: type.rawValue + "1")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Animate the bomb and the timeFrame
    func animateFlight(active: Bool) {
        if active {
            run(SKAction.repeatForever(SKAction.animate(with: flyingFrames, timePerFrame: 0.1, resize: true, restore: true)))
        } else {
            removeAllActions()
        }
    }
}
