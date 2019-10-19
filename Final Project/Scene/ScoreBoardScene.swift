//
//  ScoreBoardScene.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-08-09.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

class ScoreBoardScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    static var highScore: String? = nil
    
    override func didMove(to view: SKView) {
        setupScoreBoard()
    }

    func setupScoreBoard() {
        let background = SKSpriteNode(imageNamed: "background_01")
        
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.aspectScale(to: frame.size, width: true, multiplier: 1.0)
        background.zPosition = ZPosition.background
        addChild(background)
        
        // Create top one score label
        var myLabel: SKLabelNode!
        myLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        myLabel.text = "Top One Player"
        myLabel.fontSize = 30
        myLabel.fontColor = UIColor.darkGray
        myLabel.position = CGPoint(x: frame.midX, y: frame.midY * 1.5)
        
        addChild(myLabel)
        
        // Create top first player label
        var myFirst: SKLabelNode!
        myFirst = SKLabelNode(fontNamed: "AvenirNext-Bold")
        myFirst.text = ScoreBoardScene.highScore
        myFirst.fontSize = 30
        myFirst.fontColor = UIColor.darkGray
        myFirst.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(myFirst)
    }
}
