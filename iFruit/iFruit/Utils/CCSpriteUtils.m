//
//  CCSpriteUtils.m
//  iFruit
//
//  Created by mac on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CCSpriteUtils.h"


@implementation CCSpriteUtils

+ (CCSprite *)createCCSprite:(NSString *)filename location:(CGPoint)location {
    CCSprite *sprite = [CCSprite spriteWithFile:filename];
    sprite.position = ccp(location.x+sprite.contentSize.width/2,location.y-sprite.contentSize.height/2);
    return sprite;
}

+ (CCSprite *)createTexture2D:(CCTexture2D *)texture location:(CGPoint)location {
    CCSprite *sprite = [CCSprite spriteWithTexture:texture];
    sprite.position = ccp(location.x+sprite.contentSize.width/2,location.y-sprite.contentSize.height/2);
    return sprite;
}

+ (CGPoint)getPosition:(CCSprite *)sprite location:(CGPoint)location {
    return ccp(location.x+sprite.contentSize.width/2,location.y-sprite.contentSize.height/2);
}

+ (void) createAnimation:(CCLayer *)layer {
//    CCSpriteBatchNode * spritesheet = [CCSpriteBatchNode batchNodeWithFile:@"bee.png"];
//    [layer addChild:spritesheet];
//    
//    for (int i = 0; i < 2; i++) {
//        CCSpriteFrame* frame = [[CCSpriteFrame alloc] initWithTexture:spritesheet.texture rect:CGRectMake(i*38, 0, 37, 38)];
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:[NSString stringWithFormat:@"playerFrame%d", i]];
//        [frame release];
//    }
//    
//    SPBee = [[CCSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"playerFrame%d", 0]];
//    [spritesheet addChild:SPBee];
//    [SPBee release];
//    [SPBee setPosition:CGPointMake(260, winSize.height-305)];
//    
//    NSMutableArray* animFrames = [NSMutableArray array];
//    for (int i = 0; i < 2; i++) {
//        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"playerFrame%d", i]];
//        [animFrames addObject:frame];
//    }
//    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames delay:0.2f];
//    [SPBee runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]]];
}

@end
