//
//  BombMgr.h
//  iFruit
//
//  Created by mac on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bomb.h"
#import "Adventurer.h"


@interface BombMgr : NSObject {
    CCLayer *_layel;
    CCTexture2D *_texture;
	CCSpriteBatchNode *_spriteSheet;
	NSMutableArray *_charArray;
    int index;
}

@property (nonatomic, assign) CCTexture2D *texture;
@property (nonatomic, assign) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, retain) NSMutableArray *charArray;
@property int index;

-(BombMgr *) init:(CCLayer *)layer;
-(Adventurer *)addAdventurer;
-(void)runAction:(Adventurer *)adventurer;
//-(void) addAdventurers;
- (Adventurer *)getBomb;
-(void) reset;


@end
