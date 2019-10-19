//
//  Popup.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-08-09.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

// Interface for the button actions
protocol PopupButtonHandlerDelegate {
    func menuTapped()
    func nextTapped()
    func retryTapped()
}

// Initialize the button orders
struct PopupButtons {
    static let menu = 0
    static let next = 1
    static let retry = 2
}

class Popup: SKSpriteNode {
    let type: Int
    var popupbuttonHandlerDelegate: PopupButtonHandlerDelegate?
    
    // Initialize the popup layout
    init(type: Int, size: CGSize) {
        self.type = type
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        setupPopup()
    }
    
    // Setup the popup layout
    func setupPopup() {
        let background = type == 0 ? SKSpriteNode(imageNamed: "win") : SKSpriteNode(imageNamed: "lose")
        
        // Resize the popup window
        background.aspectScale(to: size, width: false, multiplier: 0.5)
        
        // Display the menu button
        let menuButton = SpriteKitButton(defaultButtonImage: "menu", action: popUpButtonHandler, index: PopupButtons.menu)
        
        // Display the play button
        let nextButton = SpriteKitButton(defaultButtonImage: "play", action: popUpButtonHandler, index: PopupButtons.next)
        
        
        // Display the restart button
        let retryButton = SpriteKitButton(defaultButtonImage: "restart", action: popUpButtonHandler, index: PopupButtons.retry)
        nextButton.isUserInteractionEnabled = type == 0 ? true : false
        
        // Setup the background size
        menuButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        nextButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        retryButton.aspectScale(to: background.size, width: true, multiplier: 0.2)
        
        let buttonWidthOffset = retryButton.size.width / 2
        let buttonHeightOffset = retryButton.size.height / 2
        let backgroundWidthOffset = background.size.width / 2
        let backgroundHeightOffset = background.size.height / 2
        
        menuButton.position = CGPoint(x: -backgroundWidthOffset + buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset)
        nextButton.position = CGPoint(x: 0, y: -backgroundHeightOffset - buttonHeightOffset)
        retryButton.position = CGPoint(x: backgroundWidthOffset  - buttonWidthOffset, y: -backgroundHeightOffset - buttonHeightOffset)
        background.position = CGPoint(x: 0, y: buttonHeightOffset)
        
        addChild(menuButton)
        addChild(nextButton)
        addChild(retryButton)
        addChild(background)
    }
    
    // Triggered which button has been clicked by the user
    func popUpButtonHandler(index: Int) {
        switch index {
        case PopupButtons.menu:
            popupbuttonHandlerDelegate?.menuTapped()
        case PopupButtons.next:
            popupbuttonHandlerDelegate?.nextTapped()
        case PopupButtons.retry:
            popupbuttonHandlerDelegate?.retryTapped()
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
