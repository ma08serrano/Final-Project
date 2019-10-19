//
//  Level.swift
//  Final Project
//
//  Created by Michael Aldrich Serrano on 2019-07-26.
//  Copyright © 2019 Michael Aldrich Serrano. All rights reserved.
//

import Foundation

struct LevelData {
    let bombs: [String]
    
    init?(level: Int) {
        guard let levelDictionary = Levels.levelsDictionary["Level_\(level)"] as? [String:Any] else {
            return nil
        }
        guard let bombs = levelDictionary["Bombs"] as? [String] else {
            return nil
        }
        self.bombs = bombs
    }
}
