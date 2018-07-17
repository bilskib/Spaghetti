//
//  Player.swift
//  Reversi
//
//  Created by Bartosz on 23.10.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import Foundation
import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {
    
    // GKGameModelPlayer protocol requirements
    // Identifying a player
    var playerId: Int { return id }
    
    // Class properties & methods
    var disk: CellType
    var name: String
    var id: Int
    var playerScore: Int
    
    var oppositePlayer: Player {
        if disk == .black {
            return allPlayers[1]
        } else {
            return allPlayers[0]
        }
    }
    
    init(disk: CellType) {
        self.disk = disk
        self.id = disk.rawValue
        self.name = ""
        self.playerScore = 0
        
        if (disk == .black) {
            self.name = "BLACK"
            self.id = disk.rawValue
        } else if (disk == .white) {
            self.name = "WHITE"
            self.id = disk.rawValue
        }
    }
}
