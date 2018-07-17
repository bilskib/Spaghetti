//
//  ViewController.swift
//  Reversi
//
//  Created by Bartosz on 18.10.2017.
//  Copyright © 2017 Bartosz Bilski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //@IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var blackScoreLabel: UILabel!
    @IBOutlet weak var whiteScoreLabel: UILabel!
    
    // rozwazyc usuniecie
    var gameController: GameController!
    var playerSide = CellType.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameController = GameController(view: self)
        //gameController?.startNewGame()
        //gameController.setInitialBoard()
        //gameController.drawBoard()
        gameController.startNewGame(.black)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressCell(_ sender: UIButton) {
        var posX: Int! = sender.tag
        posX = (posX-100)/10
        var posY: Int! = sender.tag
        posY = (posY-100)%10
        print("The cell \(posX,posY) was pressed."  )
        if (gameController.gameModel.currentPlayer.name == "HUMAN") {
            gameController.performMove(posX, posY)
        }
    }
    
    
    @IBAction func newGame(_ sender: UIButton) {
        print("newGame button pressed")
        gameController.startNewGame(playerSide)
    }
}

