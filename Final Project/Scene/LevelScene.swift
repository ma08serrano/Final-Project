//
//  LevelScene.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-24.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {

    var sceneManagerDelegate: SceneManagerDelegate?
    
    // Called the setupLevelSelection to the container
    override func didMove(to view: SKView) {
        setupLevelSelection()
    }
    
    // Setup the level button
    func setupLevelSelection() {
        let background = SKSpriteNode(imageNamed: "LevelBackground")
        
        // Set the background position, aspectScale, zPosition
        // Add the background to the scene
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1.0)
        background.zPosition = ZPosition.background
        addChild(background)
        
        var level = 1
        let columnStartingPoint = frame.midX / 2
        let rowStartingPoint = frame.midY + frame.midY / 2
        
        // Loop the row to maximum of 3
        for row in 0..<3 {
    
            // Loop the column to maximum of 3 then next line
            for column in 0..<3 {
                let levelBoxbutton = SpriteKitButton(defaultButtonImage: "btn", action: goToGameSceneFor, index: level)
                
                // Setup the button position and zPosition
                // Add the button to the scene
                levelBoxbutton.position = CGPoint(x: columnStartingPoint + CGFloat(column) * columnStartingPoint, y: rowStartingPoint - CGFloat(row) * frame.midY / 2)
                levelBoxbutton.zPosition = ZPosition.hugBackground
                addChild(levelBoxbutton)
                
                // Change the level number font layout, alignment and aspectScale
                let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
                levelLabel.fontSize = 200.0
                levelLabel.verticalAlignmentMode = .center
                levelLabel.text = "\(level)"
                levelLabel.aspectScale(to: levelBoxbutton.size, width: false, multiplier: 0.5)
                
                // Add the level number to the button
                // Control the button zPosition and aspectScale
                levelBoxbutton.addChild(levelLabel)
                levelLabel.zPosition = ZPosition.hudLabel
                levelBoxbutton.aspectScale(to: frame.size, width: false, multiplier: 0.2)
                
                // Increment the level number
                level += 1
            }
        }
    }
    
    // Triggered when tapping the level button
    func goToGameSceneFor(level: Int) {
        sceneManagerDelegate?.presentGameSceneFor(level: level)
    }
}
