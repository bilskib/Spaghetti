//
//  GameController.swift
//  Reversi
//
//  Created by Bartosz on 23.10.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import Foundation
import GameplayKit

class GameController {
    
    var gameModel = GameModel()
    
    
    // bart - to jest do sprawdzenia
    let strategist = GKMinmaxStrategist()
    var gameView: ViewController
    
    init(view: ViewController) {
        self.gameView = view
        strategist.gameModel = gameModel
        strategist.maxLookAheadDepth = 2
    }
    
    func addDisk(_ color: CellType, _ x: Int, _ y: Int) {
        gameModel.gameBoard[x, y] = color
    }
    
    func setInitialBoard() {
        gameModel.gameBoard[3,4] = .black
        gameModel.gameBoard[4,3] = .black
        gameModel.gameBoard[3,3] = .white
        gameModel.gameBoard[4,4] = .white
        //gameModel.gameBoard[3,5] = .valid
    }
    
    func setInitialPlayer() {
        gameModel.currentPlayer = allPlayers[0]
    }
    
    func resetBoard() {
        for row in 0..<8 {
            for column in 0..<8 {
                let tagNumber = 100 + row * 10 + column
                let cellButton = gameView.view.viewWithTag(tagNumber) as? UIButton
                cellButton?.setImage(nil, for: .normal)
                gameModel.gameBoard[row, column] = .empty
            }
        }
    }
    
    func drawCell(_ x: Int, _ y: Int) {
        let tagNumber = 100 + x * 10 + y
        guard let cellButton = gameView.view.viewWithTag(tagNumber) as? UIButton else {
            print("Error! Can't find button with tag \(tagNumber)")
            return
        }
        if gameModel.gameBoard[x,y].rawValue == 1 {
            cellButton.setImage(UIImage(named:"blackPiece"), for: .normal)
        }
        if gameModel.gameBoard[x,y].rawValue == 2 {
            cellButton.setImage(UIImage(named:"whitePiece"), for: .normal)
        }
        if gameModel.gameBoard[x,y].rawValue == 3 {
            cellButton.setImage(UIImage(named:"availableMove"), for: .normal)
        }
//                else if gameModel.gameBoard[row, column].rawValue == 11 {
//                    cellButton.setImage(UIImage(named: "blackPieceLast.png"), for: .normal)
//                } else if gameModel.gameBoard[row, column].rawValue == 22 {
//                    cellButton.setImage(UIImage(named: "whitePieceLast.png"), for: .normal)
//                }
//        else {
//            cellButton.setImage(nil, for: .normal)
//       }
    }
    
    func drawBoard() {
        for row in 0..<8 {
            for column in 0..<8 {
                drawCell(row, column)
            }
        }
    }
    
    func countDisk(color: String) -> Int {
        var counter: Int = 0
        if (color.lowercased() == "white") {
            for row in 0..<8 {
                for column in 0..<8 {
                    if gameModel.gameBoard[row, column] == .white //|| gameModel.gameBoard[row, column] == .whiteLast
                    {
                        counter += 1
                    }
                }
            }
        } else if (color.lowercased() == "black") {
            for row in 0..<8 {
                for column in 0..<8 {
                    if gameModel.gameBoard[row, column] == .black //|| gameModel.gameBoard[row, column] == .blackLast
                    {
                        counter += 1
                    }
                }
            }
        }
        return counter
    }
    
    func updateScore() {
        gameView.whiteScoreLabel.text = String(countDisk(color: "white"))
        gameView.blackScoreLabel.text = String(countDisk(color: "black"))
    }
    
    func flipDisk(_ x: Int, _ y: Int) {
        let currentPlayer = gameModel.currentPlayer.disk
        
        for direction in Move.directions.values {
            if let move = Move.verifyMoveDirection(gameModel.gameBoard, x, y, (direction.x,direction.y), cellType: currentPlayer) {
                var newX = move.x - direction.x
                var newY = move.y - direction.y
                while (newX != x || newY != y) {
                    //gameModel.gameBoard[x, y] = currentPlayer -- czy flipujemy tylko to co w srodku? np flip(4,5)
                    gameModel.gameBoard[newX, newY] = currentPlayer
                    newX -= direction.x
                    newY -= direction.y
                    drawBoard()
                    updateScore()
                }
            }
        }
    }
    
    func aiMove() {
        print("inside the aiMove()")
        if let move = self.strategist.bestMoveForActivePlayer() as? Move {
            self.performMove(move.x, move.y)
        }
        return
    }
    
    func performMove (_ x: Int, _ y: Int) {
        addDisk(gameModel.currentPlayer.disk, x, y)
        flipDisk(x, y)
        
        if gameIsOver() {
            alertGameOver()
            //return
        }
        
        if (Move.hasPossibleMoves(board: gameModel.gameBoard, gameModel.currentPlayer)) {
            if (gameModel.currentPlayer.name == "HUMAN") {
                return
                //aiMove()
            } else {
                print("AI2MOVE-1")
                aiMove()
            }
        } else {
            print("Current Player \(gameModel.currentPlayer.disk) has no moves and has to pass!")
            gameModel.currentPlayer = gameModel.currentPlayer.oppositePlayer
            print("New current player is \(gameModel.currentPlayer.disk)")
            if (gameModel.currentPlayer.name == "AI") {
                print("now in func performMove(), before aiMove()")
                aiMove()
            } else {
                print("show available moves for human")
                //show moves for human player
            }
        }
    }
    
    func gameIsOver() -> Bool {
        if Move.hasPossibleMoves(board: gameModel.gameBoard, gameModel.currentPlayer) || Move.hasPossibleMoves(board: gameModel.gameBoard, gameModel.currentPlayer) {
            return false
        }
        return true
    }
    
    func alertGameOver() {
        let gameOverAlert = UIAlertController(title: "Game Over", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let blackDisksCounter = countDisk(color: "black")
        let whiteDisksCounter = countDisk(color: "white")
        
        if blackDisksCounter > whiteDisksCounter {
            gameOverAlert.message = "Black has won \(blackDisksCounter):\(whiteDisksCounter)"
        } else if whiteDisksCounter > blackDisksCounter {
            gameOverAlert.message = "White has won \(whiteDisksCounter):\(blackDisksCounter)"
        } else {
            gameOverAlert.message = "It was a draw!"
        }
        // add an action (button)
        gameOverAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: { action in self.gameView.newGame(UIButton())}))
        gameOverAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        //show the alert
        gameView.present(gameOverAlert, animated: true, completion: nil)
    }
    
    func processCell(_ x: Int, _ y: Int) {
        if (Move.checkMoveLegalityAtCell(gameModel.gameBoard, x, y, cellType: gameModel.currentPlayer.disk)){
            performMove(x, y)
        }
    }
    
    // STARTING A NEW GAME
    func startNewGame(_ playerSide: CellType) {
        resetBoard()
        setInitialBoard()
        setInitialPlayer()
        drawBoard()
        updateScore()
        printBoard()
        //flipDisk(4, 5)
        //alertGameOver()
        
        if(playerSide == .black) {
            gameModel.currentPlayer.name = "HUMAN"
            gameModel.currentPlayer.oppositePlayer.name = "AI"
            //bart
            print("current player is: \(gameModel.currentPlayer.disk)")
        } else {
            gameModel.currentPlayer.name = "AI"
            gameModel.currentPlayer.oppositePlayer.name = "HUMAN"
            aiMove()
            //bart
            print("current player is: \(gameModel.currentPlayer.disk)")
        }
    }
    
    // MARK: helper method
    func printBoard() {
        print(".................................................................................................")
        print("  0     1     2     3     4     5     6     7  /")
        for row in 0..<8 {
            print("-------------------------------------------------")
            for column in 0..<8 {
                print(gameModel.gameBoard[row, column], terminator: "|")
            }
            print(row)
        }
        print("-------------------------------------------------")
    }
}

