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
#import "CCSpriteUtils.h"
#import "Arrow.h"



@interface BowFruitLayer : CCLayer{
//    CCSprite *bow,*arrow;
//    CGPoint gestureStartPoint;
//    int status;  //0 瞄准、1 拉弓
//    //CGPoint shootVector,lastPoint;
//    //CGFloat cocosAngle,deltaX; //当前弧度
    
    
    CCSprite *_player;
	NSMutableArray *_targets;
	NSMutableArray *_projectiles;
	int _projectilesDestroyed;
    Arrow *_nextProjectile;
    
    CCMenuItemToggle* play;
    
    CCLabelTTF *arrowNumBg,*arrowNum,*scoreValueBg,*scoreValue;
    int64_t _score,_arrowNum;
}
- (void)backgame:(id)sender;
- (void)closeTip:(id)sender data:(NSObject *)param;

@end
