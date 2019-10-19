//
//  GameViewController.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-22.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

// Interface of the scenes
protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentLevelScene()
    func presentScoreBoardScene()
    func presentGameSceneFor(level: Int)
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentMenuScene()
    }
    
    // Do action everytime the view appear
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Key")
        ScoreBoardScene.highScore = value;
    }
}

extension GameViewController: SceneManagerDelegate {
    // Called the menuScene
    func presentMenuScene() {
        let menuScene = MenuScene()
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene)
    }
    
    // Called the levelScene
    func presentLevelScene() {
        let levelScene = LevelScene()
        levelScene.sceneManagerDelegate = self
        present(scene: levelScene)
    }
    
    // Called the scoreBoardScene
    func presentScoreBoardScene() {
        let scoreBoardScene = ScoreBoardScene()
        scoreBoardScene.sceneManagerDelegate = self
        present(scene: scoreBoardScene)
    }
    
    // Called which game scene will be redirected to
    func presentGameSceneFor(level: Int) {
        if level == 1 {
            let sceneName = "GameScene_\(level)"
            if let gameScene = SKScene(fileNamed: sceneName) as? GameScene {
                gameScene.sceneManagerDelegate = self
                gameScene.level = level
                present(scene: gameScene)
            }
        } else {
            present(scene: SKScene(fileNamed: "UnderConstruction") as! GameScene)
        }
    }
    
    // To find our initialize scene
    // Example: Menu, Level, and Scoreboard
    func present(scene: SKScene) {
        if let view = self.view as! SKView? {
            if let gestureRecognizers = view.gestureRecognizers {
                for recognizer in gestureRecognizers {
                    // Remove the gesture recognizer and restart to the fresh scene
                    view.removeGestureRecognizer(recognizer)
                }
            }
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            // To render our node efficiently
            view.ignoresSiblingOrder = true
        }
    }
}
