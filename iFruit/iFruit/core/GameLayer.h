//
//  GameLayer.h
//  G03
//
//  Created by Mac Admin on 15/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Fruit.h"
#import "FruitCore.h"
#import "CommUtils.h"
#import "Bomb.h"
#import "SimpleAudioEngine.h"
#import "CCSpriteUtils.h"

@interface GameLayer : CCLayer <CCTouchAllAtOnceDelegate> {

    FruitCore *fruitCore;
    CGPoint gestureStartPoint;
    
    BOOL gamePlaying;
    int musicCanPlay,soundCanPlay;
    
    CCLabelTTF *timeText; //时间
    CCSprite *timemidbg;
    
    UIViewController * ctl;
    
    CCMenuItemSprite *hintItem;
}

+(id) scene;

@property (nonatomic,retain) FruitCore *fruitCore;
@property (nonatomic,retain) CCLabelTTF *timeText;
@property (nonatomic,retain) CCSprite *timemidbg;
@property (nonatomic,retain) CCMenuItemSprite *hintItem;
@property BOOL gamePlaying;
@property int musicCanPlay,soundCanPlay;

- (void) initTime:(int)time location:(CGPoint)location;
- (void) setTime:(int)time;

- (void)pause:(id)sender;
- (void)playGame:(id)sender;
- (void)restart:(BOOL)flag;
- (void)musicControll:(id)sender;
- (void)soundControll:(id)sender;
- (void)refresh:(id)sender;
- (void)addTime:(int)addTime;

- (void)nextLevel:(id)sender;
- (void) doubleScore;
-(void)resumeScore:(ccTime)dt;
-(void)resetMultiple:(id)sender data:(CCLabelTTF *)ttf;
-(void)autoMove:(ccTime)dt;
-(void)tip:(id)sender;
-(void)removeTip:(ccTime)dt;
-(void)gameLogic:(ccTime)dt;
-(void) showMultiple:(CCLabelTTF *)ttf;
- (void) goDropFruit;
- (void) startGameLogic;

//- (void)qipaoTip;
//- (void) removeQipaoTip:(CCSprite *)sprite;
- (void) addTime:(int)addTime;
- (void)howToPlay:(id)sender;

@end
