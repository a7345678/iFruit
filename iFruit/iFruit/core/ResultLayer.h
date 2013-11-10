//
//  ResultLayer.h
//  iFruit
//
//  Created by mac on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "CommUtils.h"


@interface ResultLayer : CCLayerColor {
    
    NSMutableArray *spriteArray,*labelArray,*scoreArray,*itemSrpiteArray; //水果精灵列表
    CCLabelTTF *gameScoreValue,*highScoreValue;
    NSInteger *highScore,*maxScore;
    int gameScore;
    int time,addScore; //次数
    int maxFruit;
    BOOL isLevelUp;
    CCMenuItemSprite *contiuneItem;
    CCSprite *helper;
}

@property (nonatomic,retain) NSMutableArray *spriteArray,*labelArray,*scoreArray;
@property (nonatomic,retain) CCLabelTTF *gameScoreValue,*highScoreValue;


-(int)getMaxScore:(NSMutableArray *)array;
-(void)calcScore:(NSMutableArray *)array score:(int)score;
-(void)beginScoreAnimal;

- (void)closeTip:(id)sender;
-(void)restart:(id)sender;

@end
