//
//  GameModel.swift
//  Reversi
//
//  Created by Bartosz on 23.10.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import Foundation
import GameplayKit

let allPlayers: [Player] = [Player(disk: .black), Player(disk: .white)]

class GameModel: NSObject, GKGameModel {
    
    var gameBoard = Board(rows: 8, columns: 8)
    var currentPlayer: Player = allPlayers[0]
    
    //bart
    func flipDisk(_ x: Int, _ y: Int) {
        let currentPlayerDisk = self.currentPlayer.disk
        
        for direction in Move.directions.values {
            if let move = Move.verifyMoveDirection(gameBoard, x, y, (direction.x,direction.y), cellType: currentPlayerDisk) {
                var newX = move.x - direction.x
                var newY = move.y - direction.y
                while (newX != x || newY != y) {
                    gameBoard[newX, newY] = currentPlayerDisk
                    newX -= direction.x
                    newY -= direction.y
                }
            }
        }
    }
    
    // GKGameModel protocol requirements
    var players: [GKGameModelPlayer]? { return allPlayers }
    var activePlayer: GKGameModelPlayer? { return currentPlayer }   // black
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let sourceModel = gameModel as? GameModel {
            self.gameBoard = sourceModel.gameBoard
            self.currentPlayer = sourceModel.currentPlayer}
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        let player = player as! Player
        var moves: [Move] = Move.createMoves(board: self.gameBoard, player)
        
        //var moves = [Move]()
        moves = Move.createMoves(board: self.gameBoard, player)
        
        //moves.append(Move(x:5, y: 5))
        if moves.isEmpty {
            // bart tu sie wywala
            print("GameModel:gameModelUpdates(for player:) ... if moves.isEmpty == true {return nil}")
            return nil
        }
        return moves
    }
    
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            
            gameBoard[move.x, move.y] = currentPlayer.disk
            flipDisk(move.x, move.y)
        
            if Move.hasPossibleMoves(board: self.gameBoard, currentPlayer.oppositePlayer) {
                currentPlayer = currentPlayer.oppositePlayer
            }
            
        }
    }
    
    // NSCopying protocol requirements
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameModel()
        copy.setGameModel(self)
        return copy
    }
    
    // scoreForPlayer is required by GKGameModel protocol
    func score(for player: GKGameModelPlayer) -> Int {
        let player = player as! Player
        var playerScore: Int = 0
        
        playerScore += gameBoard.countDisks(gameboard: gameBoard, color: player.name)
        player.playerScore = playerScore
        return 0
    }
}
