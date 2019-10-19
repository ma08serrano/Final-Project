//
//  SKNode+Extensions.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-24.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    // Setting the sprite node's x and y scale to achieve the specified size in it's parent's coordinate space
    func aspectScale(to size: CGSize, width: Bool, multiplier: CGFloat) {
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        
        self.setScale(scale)
    }
}
