//
//  SenceManager.h
//  iFruit
//
//  Created by mac on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuLayer.h"
#import "GameLayer.h"
#import "OptionLayer.h"
#import "DropFruitLayer.h"
#import "BowFruitLayer.h"
#import "EarnLayer.h"

@interface SceneManager : NSObject {
}

+(void) goMenu;
+(void) goBowFruit;
+(void) goPlay;
+(void) go: (CCLayer *) layer;

+(void) pushEarn;
+(void) pushScene: (CCLayer *) layer;
+(void) popScene;
+(CCScene *) addLayer: (CCLayer *) layer z:(int)z tag:(int)tag;
+(CCScene *) wrap: (CCLayer *) layer;
+(void) pause;
+(void) resume;

@end
