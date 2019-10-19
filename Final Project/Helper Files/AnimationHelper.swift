//
//  AnimationHelper.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-25.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

class AnimationHelper {
    
    static func loadTextures(from atlas: SKTextureAtlas, withName name: String) -> [SKTexture] {
        var textures = [SKTexture]()
        
        for index in 0..<atlas.textureNames.count {
            let textureName = name + String(index + 1)
            textures.append(atlas.textureNamed(textureName))
        }
        
        return textures
    }
}
