//
//  SpriteKitButton.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-25.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

class SpriteKitButton: SKSpriteNode {

    var defaultButton: SKSpriteNode
    var action: (Int) -> ()
    var index: Int
    
    // Default constructor
    init(defaultButtonImage: String, action: @escaping (Int) -> (), index: Int) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        self.action = action
        self.index = index
        
        super.init(texture: nil, color: UIColor.clear, size: defaultButton.size)
        
        isUserInteractionEnabled = true
        addChild(defaultButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TouchesBegan method
    // Minimize the button opacity when clicked
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 0.75
    }
    
    // TouchesMoved method
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        // Minimize the button opacity when moved
        // or else set to original opacity
        if defaultButton.contains(location) {
            defaultButton.alpha = 0.75
        } else {
            defaultButton.alpha = 1.0
        }
    }
    
    // TouchesEnded method
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch = touches.first! as UITouch
        let location: CGPoint = touch.location(in: self)
        
        if defaultButton.contains(location) {
            action(index)
        }
        
        // Set the opacity color to original when release
        defaultButton.alpha = 1.0
    }
    
    // TouchesCancelled method
    // Set opacity to original when cancelled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 1.0
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
