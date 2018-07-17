//
//  Board.swift
//  Reversi
//
//  Created by Bartosz on 23.10.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import Foundation

enum CellType: Int {
    
    case empty = 0
    case black = 1
    case white = 2
    case legal = 3
    //case blackLast = 11
    //case whiteLast = 22
}

class Board {
    
    let rows: Int, columns: Int
    var grid: [CellType]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: .empty, count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return (row >= 0 && row < rows) && (column >= 0 && column < columns)
    }
    
    subscript(row: Int, column: Int) -> CellType {
        
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }

 // moved to GameController

    func countDisks(gameboard: Board, color: String) -> Int {
        var counter: Int = 0
        if (color.lowercased() == "white") {
            for row in 0..<8 {
                for column in 0..<8 {
                    if gameboard[row, column] == .white //|| gameboard[row, column] == .whiteLast
                    {
                        counter += 1
                    }
                }
            }
        } else if (color.lowercased() == "black") {
            for row in 0..<8 {
                for column in 0..<8 {
                    if gameboard[row, column] == .black //|| gameboard[row, column] == .blackLast
                    {
                        counter += 1
                    }
                }
            }
        }
        return counter
    }
}
