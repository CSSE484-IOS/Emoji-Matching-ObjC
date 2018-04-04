//
//  MatchingGame.h
//  Emoji Matching
//
//  Created by FengYizhi on 2018/4/3.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_NUM_PAIR 50

typedef NS_ENUM(NSInteger, CardState) {
    CardStateHidden,
    CardStateShown,
    CardStateRemoved
};

typedef NS_ENUM(NSInteger, GameState) {
    GameStateWaitFirst,
    GameStateWaitSecond,
    GameStateTurnDone
};

@interface MatchingGame : NSObject {
    CardState cardStates[MAX_NUM_PAIR];
}

- (id) initWithNumPairs:(NSInteger) numPairs;
- (void) pressedCardAtIndex:(NSInteger) index;
- (void) startNewTurn;
- (CardState) getCardStateAtIndex:(NSInteger) index;
- (NSString*) description;

@property (nonatomic) GameState gameState;
@property (nonatomic) NSInteger numPairs;
@property (nonatomic) NSArray* cards;
@property (nonatomic, copy) NSString* cardBack;
@property (nonatomic) NSInteger firstClick;
@property (nonatomic) NSInteger secondClick;

@end
