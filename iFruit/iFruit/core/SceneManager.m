//
//  SenceManager.m
//  iFruit
//
//  Created by mac on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SceneManager.h"

@implementation SceneManager


+(void) goMenu{
    CCLayer *layer = [MenuLayer node];
    [SceneManager go: layer];
}

+(void) goBowFruit{
    [SceneManager go:[BowFruitLayer node]];
}

+(void) goPlay{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = (CCScene *)[GameLayer scene];
    if ([director runningScene]) {
        [director replaceScene: [CCTransitionFadeTR transitionWithDuration:1.2f scene:newScene]];
    }else {
        [director runWithScene: newScene];
    }
//    GameLayer *layer = [GameLayer node];
//    [SceneManager go: layer];
}

+(void) go: (CCLayer *) layer{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director replaceScene: newScene];
    }else {
        [director runWithScene:newScene];
    }
}

+(void) pushEarn {
    [SceneManager pushScene:[EarnLayer node]];
}

+(void) pushScene: (CCLayer *) layer{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director pushScene: newScene];
    }else {
        [director runWithScene:newScene];
    }
}

+(void) popScene{
    CCDirector *director = [CCDirector sharedDirector];
    [director popScene];
}

+(CCScene *) addLayer: (CCLayer *) layer z:(int)z tag:(int)tag{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    [scene addChild:layer z:z tag:tag];
    return scene;
}

+(void) pause {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    [scene pauseSchedulerAndActions];
}

+(void) resume {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    [scene resumeSchedulerAndActions];
}

+(CCScene *) wrap: (CCLayer *) layer{
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

@end