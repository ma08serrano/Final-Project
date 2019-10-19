//
//  GameCamera.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-23.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

class GameCamera: SKCameraNode {
    
    // Set the camera to follow when the user throw the bomb to the enemy
    // Go back the original camera state to the player tank position
    func setConstraits(with scene: SKScene, and frame: CGRect, to node: SKNode?) {
        let scaledSize = CGSize(width: scene.size.width * xScale, height: scene.size.height * yScale)
        let boardContentRect = frame
        
        let xInset = min(scaledSize.width / 2, boardContentRect.width / 2)
        let yInset = min(scaledSize.height / 2, boardContentRect.height / 2)
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
        
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        
        if let node = node {
            let zeroRange = SKRange(constantValue: 0.0)
            let positionConstraint = SKConstraint.distance(zeroRange, to: node)
            constraints = [positionConstraint, levelEdgeConstraint]
        } else {
            constraints = [levelEdgeConstraint]
        }
    }
}
