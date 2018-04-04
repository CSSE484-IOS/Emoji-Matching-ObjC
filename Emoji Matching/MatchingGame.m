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
    if (self.firstClick == -1) {
        if (cardStates[index] == CardStateHidden) {
            cardStates[index] = CardStateShown;
            self.firstClick = index;
            self.gameState = GameStateWaitSecond;
        }
    } else if (self.secondClick == -1 && index != self.firstClick) {
        if (cardStates[index] == CardStateHidden) {
            cardStates[index] = CardStateShown;
            self.secondClick = index;
            self.gameState = GameStateTurnDone;
        }
    }
}

- (void) startNewTurn {
    if (self.cards[self.firstClick] == self.cards[self.secondClick]) {
        cardStates[self.firstClick] = CardStateRemoved;
        cardStates[self.secondClick] = CardStateRemoved;
    } else {
        cardStates[self.firstClick] = CardStateHidden;
        cardStates[self.secondClick] = CardStateHidden;
    }
    self.firstClick = -1;
    self.secondClick = -1;
    self.gameState = GameStateWaitFirst;
}

- (CardState) getCardStateAtIndex:(NSInteger) index {
    return cardStates[index];
}

- (NSString*) description {
    NSMutableString* cardsString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.cards.count; i++) {
        if (i % 4 == 0 && i > 0) {
            [cardsString appendString:@"\n"];
        }
        [cardsString appendString:self.cards[i]];
    }
    return cardsString;
}

@end
