//
//  DropFruitLayer.h
//  iFruit
//
//  Created by mac on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CommUtils.h"
#import "Fruit.h"
#import "Item.h"
#import "CCSpriteUtils.h"
#import "SoundUtils.h"
#import "GameLayer.h"
#import "FrameAnimHelper.h"
#import "NumUtils.h"
#import "BannerAdViewController.h"

#define lifeY 0

@interface DropFruitLayer : CCLayer {

    NSMutableArray *dropFruitArray,*fruitTextrueArray;
    Fruit *player;
    CCSprite *lifeBg,*life;
    
    BOOL isTouch,bearIsLive;
    int musicCanPlay,soundCanPlay;
    int multiple;
    
    int _score;
    CCLabelTTF *scoreValueBg,*scoreValue;
    
    
    CCSprite *_bear;
    CCAction *_walkAction;
    CCAction *_moveAction;
    BOOL _moving;
    
//    float _bearPerSecX;
//    float _bearPerSecY;
    
    CGPoint _startVelocity,_playerVelocity;
    
    CCMenuItemToggle* play;
}

@property (nonatomic,retain) NSMutableArray *dropFruitArray;
@property (nonatomic) int multiple;

+(id) scene;
- (void)closeTip:(id)sender data:(NSObject *)param;
- (CGRect) getTortoiseRect;
- (void)pause:(id)sender;
- (void)backgame:(id)sender;
- (void)moveLife;

- (void) startGameLogic;

@property (nonatomic, retain) CCSprite *bear;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCMenuItemToggle *play;

@end
