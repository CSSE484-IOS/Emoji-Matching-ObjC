//
//  MatchingGame.swift
//  Emoji Matching
//
//  Created by FengYizhi on 2018/3/26.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import Foundation

let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")

extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }
}

class MatchingGame: CustomStringConvertible {
    enum CardState: String {
        case hidden = "Hidden"
        case shown = "Shown"
        case removed = "Removed"
    }
    
    enum GameState {
        case waitFirst
        case waitSecond(Int)
        case turnDone(Int, Int)
        
        func simpleDescription() -> String {
            switch self {
            case .waitFirst:
                return "Waiting for first selection"
            case .waitSecond(let first):
                return "Waiting for second selection: first click = \(first)"
            case .turnDone(let first, let second):
                return "Turn complete: first click = \(first) second click = \(second)"
            }
        }
    }
    
    var cardStates: [CardState]
    var gameState: GameState
    
    var numPairs: Int
    var cards: [Character]
    var cardBack: Character
    
    var firstClick: Int = -1;
    var secondClick: Int = -1;
    
    init(numPairs: Int) {
        self.cardStates = [CardState](repeating: .hidden, count: numPairs * 2)
        self.gameState = .waitFirst
        self.numPairs = numPairs
        
        // Randomly select emojiSymbols
        var emojiSymbolsUsed = [Character]()
        while emojiSymbolsUsed.count < numPairs {
            let index = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
            let symbol = allEmojiCharacters[index]
            if !emojiSymbolsUsed.contains(symbol) {
                emojiSymbolsUsed.append(symbol)
            }
        }
        self.cards = emojiSymbolsUsed + emojiSymbolsUsed
        self.cards.shuffle()
        
        // Randomly select a card back for this round
        let index = Int(arc4random_uniform(UInt32(allCardBacks.count)))
        self.cardBack = allCardBacks[index]
    }
    
    func pressedCard(atIndex: Int) {
        if self.firstClick == -1 {
            if self.cardStates[atIndex] == .hidden {
                self.cardStates[atIndex] = .shown
                self.firstClick = atIndex
                self.gameState = .waitSecond(firstClick)
            }
        } else if self.secondClick == -1 && atIndex != self.firstClick {
            if self.cardStates[atIndex] == .hidden {
                self.cardStates[atIndex] = .shown
                self.secondClick = atIndex
                self.gameState = .turnDone(firstClick, secondClick)
            }
        }
    }
    
    func startNewTurn() {
        if self.cards[self.firstClick] == self.cards[self.secondClick] {
            self.cardStates[self.firstClick] = .removed
            self.cardStates[self.secondClick] = .removed
        } else {
            self.cardStates[self.firstClick] = .hidden
            self.cardStates[self.secondClick] = .hidden
        }
        self.firstClick = -1
        self.secondClick = -1
        self.gameState = .waitFirst
    }
    
    var description: String {
        var str = ""
        for i in 0..<self.numPairs * 2 {
            if i % 4 == 0 && i > 0 {
                str += "\n"
            }
            str += "\(self.cards[i])"
        }
        return str
    }
}
