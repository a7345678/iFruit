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
#import "TipCore.h"
#import "CommUtils.h"
#import "Bomb.h"
#import "SimpleAudioEngine.h"
#import "CCSpriteUtils.h"

@interface TipLayer : CCLayer {

    TipCore *fruitCore;
    CGPoint gestureStartPoint;
    
    BOOL gamePlaying;
    int musicCanPlay,soundCanPlay;
    
    CCLabelTTF *timeText; //时间
    CCSprite *timemidbg;
    
    CGFloat _mx,_my;
    int _mIndex;
    
    CCSprite *helper;
}

+(id) scene;

@property (nonatomic,retain) CCLabelTTF *timeText;
@property (nonatomic,retain) CCSprite *timemidbg;
@property BOOL gamePlaying;
@property int musicCanPlay,soundCanPlay;

- (void) swapFruit:(NSMutableArray *)param;
-(void) refreshFruit:(id)sender;
- (void)refresh:(id)sender;


- (void)setGameValue:(NSString *)key value:(NSObject *)value;
- (NSObject *)getGameValue:(NSString *)key;
-(void)autoMove:(ccTime)dt;
-(void)tip:(id)sender;
-(void)removeTip:(ccTime)dt;


-(void)tipMovie:(id)sender;
-(void)monitorMove:(ccTime)dt;

@end
