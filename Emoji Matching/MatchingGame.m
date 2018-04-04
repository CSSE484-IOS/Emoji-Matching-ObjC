//
//  MatchingGame.m
//  Emoji Matching
//
//  Created by FengYizhi on 2018/4/3.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

#import "MatchingGame.h"

@implementation MatchingGame

- (id) initWithNumPairs:(NSInteger) numPairs {
    self = [super init];
    if (self) {
        self.numPairs = numPairs;
        self.firstClick = -1;
        self.secondClick = -1;
        
        NSArray* allCardBacks = [@"🎆,🎇,🌈,🌅,🌇,🌉,🌃,🌄,⛺,⛲,🚢,🌌,🌋,🗽" componentsSeparatedByString:@","];
        NSArray* allEmojiCharacters = [@"🚁,🐴,🐇,🐢,🐱,🐌,🐒,🐞,🐫,🐠,🐬,🐩,🐶,🐰,🐼,⛄,🌸,⛅,🐸,🐳,❄,❤,🐝,🌺,🌼,🌽,🍌,🍎,🍡,🏡,🌻,🍉,🍒,🍦,👠,🐧,👛,🐛,🐘,🐨,😃,🐻,🐹,🐲,🐊,🐙" componentsSeparatedByString:@","];
        
        
        // Randomly select emojiSymbols
        NSMutableArray* emojiSymbolsUsed = [[NSMutableArray alloc] init];
        while (emojiSymbolsUsed.count < numPairs) {
            NSString* symbol = allEmojiCharacters[arc4random_uniform((UInt32) allEmojiCharacters.count)];
            if (![emojiSymbolsUsed containsObject:symbol]) {
                [emojiSymbolsUsed addObject:symbol];
            }
        }
        [emojiSymbolsUsed addObjectsFromArray:emojiSymbolsUsed];
        // Shuffle the NSMutableArray before converting it to an NSArray.
        for (int i = 0; i < emojiSymbolsUsed.count; ++i) {
            UInt32 j = arc4random_uniform((UInt32) emojiSymbolsUsed.count - i) + i;
            [emojiSymbolsUsed exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
        self.cards = [NSArray arrayWithArray:emojiSymbolsUsed];
        
        // Randomly select a card back.
        self.cardBack = allCardBacks[arc4random_uniform((UInt32) allCardBacks.count)];
        
        // Reset cardStates to ensure default values.
        for (int i = 0; i < self.cards.count; ++i) {
            cardStates[i] = CardStateHidden;
        }
    }
    return self;
}

- (void) pressedCardAtIndex:(NSInteger) index {
    
}

- (void) startNewTurn {
    
}

- (CardState) getCardStateAtIndex:(NSInteger) index {
    return CardStateHidden;
}

- (NSString*) description {
    return @"";
}

@end

//class MatchingGame: CustomStringConvertible {
//
//    func pressedCard(atIndex: Int) {
//        if self.firstClick == -1 {
//            if self.cardStates[atIndex] == .hidden {
//                self.cardStates[atIndex] = .shown
//                self.firstClick = atIndex
//                self.gameState = .waitSecond(firstClick)
//            }
//        } else if self.secondClick == -1 && atIndex != self.firstClick {
//            if self.cardStates[atIndex] == .hidden {
//                self.cardStates[atIndex] = .shown
//                self.secondClick = atIndex
//                self.gameState = .turnDone(firstClick, secondClick)
//            }
//        }
//    }
//
//    func startNewTurn() {
//        if self.cards[self.firstClick] == self.cards[self.secondClick] {
//            self.cardStates[self.firstClick] = .removed
//            self.cardStates[self.secondClick] = .removed
//        } else {
//            self.cardStates[self.firstClick] = .hidden
//            self.cardStates[self.secondClick] = .hidden
//        }
//        self.firstClick = -1
//        self.secondClick = -1
//        self.gameState = .waitFirst
//    }
//
//    var description: String {
//        var str = ""
//        for i in 0..<self.numPairs * 2 {
//            if i % 4 == 0 && i > 0 {
//                str += "\n"
//            }
//            str += "\(self.cards[i])"
//        }
//        return str
//    }
//}
