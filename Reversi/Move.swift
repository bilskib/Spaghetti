//
//  Move.swift
//  Reversi
//
//  Created by Bartosz on 23.10.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import Foundation
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    fileprivate var score: Int = 0
    // required by GKGameModelUpdate protocol
    var value: Int {
        get { return score }
        set { score = newValue }
    }
    
    // Properties and methods
    typealias directionType = (x: Int, y: Int)
    
    static let directions: [String: directionType] = [
        "north"     : (-1, 0),
        "south"     : (1, 0),
        "east"      : (0, 1),
        "west"      : (0, -1),
        "northeast" : (-1, 1),
        "northwest" : (1, -1),
        "southeast" : (1, 1),
        "southwest" : (-1, -1),
        ]
    
    ////////
    let x: Int, y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    //////////
    
    static func verifyMoveDirection(_ board: Board, _ x: Int, _ y: Int, _ moveDirection: (x: Int, y: Int), cellType: CellType) -> Move? {
        let opponentPlayerCellType: CellType = (cellType == .black ) ? .white : .black
        let outOfBoard = { return ($0 < 0) || ($0 > 7) }
        
        var newX = x + moveDirection.x
        var newY = y + moveDirection.y
        
        //  1. Check if new cell is not out of the board, for example check cell (7,7) with southeast direction (1,1)
        if outOfBoard(newX) || outOfBoard(newY) { return nil }
        
        //  2A. Check if new cell is of opponent's color
        if board[newX, newY] != opponentPlayerCellType { return nil }
        //  2B. While new cell is of opponent's color, check next cells with given direction
        while board[newX, newY] == opponentPlayerCellType {
            newX += moveDirection.x
            if outOfBoard(newX) { return nil }
            newY += moveDirection.y
            if outOfBoard(newY) { return nil }
        }
        
        if board[newX, newY] == cellType {
            return Move(x: newX, y: newY)
        }
        // sprawdzic czy mozna usunac
        return nil
    }
    
    static func checkMoveLegalityAtCell (_ board: Board, _ x: Int, _ y: Int, cellType: CellType) -> Bool {
        //  1. Move is illegal on already taken cell
        if board[x, y] == .black || board[x, y] == .white { return false }
        
        //  2. If there is at least one possible move
        for direction in directions.values {
            if self.verifyMoveDirection(board, x, y, (direction.x, direction.y), cellType: cellType) != nil {
                return true
            }
        }
        return false
    }
    
    static func hasPossibleMoves (board: Board, _ player: Player) -> Bool {
        for row in 0..<8 {
            for column in 0..<8 {
                if checkMoveLegalityAtCell(board, row, column, cellType: player.disk) { return true }
            }
        }
        return false
    }
    
    static func createMoves (board: Board, _ player: Player) -> [Move] {
        var legalMoves: [Move] = []
        //var legalCells = board
        let legalCells = board
        
        for row in 0..<8 {
            for column in 0..<8 {
                if checkMoveLegalityAtCell(board, row, column, cellType: player.disk) {
                    //legalMoves.append(Move(x: 5, y: 5))
                    legalMoves.append(Move(x: row, y: column))
                    legalCells[row, column] = .legal
                }
            }
        }
        return legalMoves
    }
}
