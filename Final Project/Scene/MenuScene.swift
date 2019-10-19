//
//  MenuScene.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-24.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    override func didMove(to view: SKView) {
        // Call the main menu buttons
        setupMenu()
    }
    
    // Initialize the main menu
    func setupMenu() {
        
        // Setup the background sprite node
        let background = SKSpriteNode(imageNamed: "Background")
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1.0)
        background.zPosition = ZPosition.background
        addChild(background)
        
        // Setup the spritekit button
        let playButton = SpriteKitButton(defaultButtonImage: "play", action: goToLevelScene, index: 0)
        
        playButton.position = CGPoint(x: frame.midX, y: frame.midY * 1.5)
        playButton.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        playButton.zPosition = ZPosition.hudLabel
        addChild(playButton)
        
        // Setup the scoreboard spritekit button
        let scoreButton = SpriteKitButton(defaultButtonImage: "prize", action: goToScoreScene, index: 0)
        
        scoreButton.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreButton.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        scoreButton.zPosition = ZPosition.hudLabel
        addChild(scoreButton)
        
        // Setup the quit spritekit button
        let exitButton = SpriteKitButton(defaultButtonImage: "close", action: goToExitScene, index: 0)
        
        exitButton.position = CGPoint(x: frame.midX, y: frame.midY * 0.51)
        exitButton.aspectScale(to: frame.size, width: false, multiplier: 0.2)
        exitButton.zPosition = ZPosition.hudLabel
        addChild(exitButton)
    }
    
    // Redirect to the select level scene
    func goToLevelScene(_: Int) {
        sceneManagerDelegate?.presentLevelScene()
    }
    
    // Redirect to the scoreboard scene
    func goToScoreScene(_: Int) {
        sceneManagerDelegate?.presentScoreBoardScene()
    }
    
    // Terminate the application
    func goToExitScene(_: Int) {
        exit(0);
    }
}
