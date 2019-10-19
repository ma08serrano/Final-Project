//
//  Configuration.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-23.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import CoreGraphics

struct Levels {
    static var levelsDictionary = [String:Any]()
}

// Setup the objects z-position
struct ZPosition {
    static let background: CGFloat = 0
    static let obstacles: CGFloat = 1
    static let bomb: CGFloat = 2
    static let hugBackground: CGFloat = 10
    static let hudLabel: CGFloat = 11
}

// Setup the bitwise in general
struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let edge: UInt32 = 0x1
    static let bomb: UInt32 = 0x1 << 1
    static let block: UInt32 = 0x1 << 2
    static let enemy: UInt32 = 0x1 << 3
    static let player: UInt32 = 0x1 << 4
}

extension CGPoint {
    
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}
