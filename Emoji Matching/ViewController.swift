//
//  ViewController.swift
//  Emoji Matching
//
//  Created by FengYizhi on 2018/3/25.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var gameBoardBtns: [UIButton]!
    
    var game: MatchingGame!
    var blockUIIntentionally: Bool!
    var firstClick: Int!
    var secondClick: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    @IBAction func pressedNewGame(_ sender: Any) {
        startNewGame()
    }
    
    @IBAction func pressedGameBoardBtns(_ sender: Any) {
        if blockUIIntentionally {
            return
        }
        let gameBoardBtn = sender as! UIButton
        self.game.pressedCard(atIndex: gameBoardBtn.tag)
        
        if game.firstClick != -1 {
            if game.secondClick != -1 {
                self.updateCard(game.secondClick)
                self.secondClick = game.secondClick
                self.blockUIIntentionally = true
                delay(1.2, closure: {
                    self.game.startNewTurn()
                    self.updateCard(self.firstClick)
                    self.updateCard(self.secondClick)
                    self.firstClick = -1
                    self.secondClick = -1
                    self.blockUIIntentionally = false
                })
            } else {
                self.updateCard(game.firstClick)
                self.firstClick = self.game.firstClick
            }
        }
    }
    
    func startNewGame() {
        game = MatchingGame(numPairs: 10)
        blockUIIntentionally = false
        for i in 0..<game.cards.count {
            self.updateCard(i)
        }
        firstClick = -1
        secondClick = -1
        print(game)
    }
    
    func updateCard(_ index: Int) {
        let btn = gameBoardBtns[index]
        if game.cardStates[index] == .hidden {
            btn.setTitle("\(game.cardBack)", for: UIControlState.normal)
            btn.isEnabled = true
        } else if game.cardStates[index] == .shown {
            btn.setTitle("\(game.cards[index])", for: UIControlState.disabled)
            btn.isEnabled = false
        } else {
            btn.setTitle("", for: .disabled)
            btn.isEnabled = false
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
}

