//
//  FrameAnimHelper.m
//  iFruit
//
//  Created by mac on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FrameAnimHelper.h"
#import "CommUtils.h"

@implementation FrameAnimHelper


+ (CCSprite *) animWithFilename:(CCLayer *)layer filename:(NSString *)filename
                              numFrames:(int)numFrames
                          plistFilename:(NSString *)plistFilename
                             spriteName:(NSString *)spriteName
                              spriteTag:(int)tag
                               repeatNum:(int)repeatNum
{
    // This loads an image of the same name (but ending in png), and goes through the
    // plist to add definitions of each fr(ame to the cache.
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFilename];        
    
    // Create a sprite sheet with the Happy Bear images
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:filename];
    [layer addChild:spriteSheet];
    
    
    // Load up the frames of our animation
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= numFrames; ++i) {
        NSLog(@"i:%d",i);
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                   spriteFrameByName:[NSString stringWithFormat:@"%@%d.png",spriteName, i]]];
    }
    
    // Create a sprite for our bear
    CCSprite *_sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@1.png",spriteName]];    
    _sprite.tag = tag;
    _sprite.position = ccp(160,50);
    
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
    
    id _walkAction = nil;
    if (repeatNum==0) {
        _walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        [_sprite runAction:_walkAction];
    }else{
        _walkAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO] times:repeatNum];
        [_sprite runAction:_walkAction];
        [self performSelector:@selector(removeSprite:)
                   withObject:_sprite afterDelay:1];
    }
    
    [spriteSheet addChild:_sprite];
    
    return _sprite;
}

+(void)removeSprite:(CCSprite *)sprite {
    [sprite removeFromParentAndCleanup:YES];
}

//+ (CCSpriteBatchNode *) animWithTexture:(CCTexture2D *)texture
//                              numFrames:(int)numFrames
//                          plistFilename:(NSString *)plistFilename
//                             spriteName:(NSString *)spriteName
//                              spriteTag:(int)tag
//{
//    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithTexture:texture];
//    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//    [frameCache addSpriteFramesWithFile:plistFilename texture:texture];
//    
//    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:numFrames];
//    CCSpriteFrame *frame;
//    CCSprite *node;
//    NSString *frameName;
//    for (int i = 1; i <= numFrames; i++) {
//        frameName = [NSString stringWithFormat:@"%@-%04d.png", spriteName, i];
//        if (i == 1) {
//            node = [CCSprite spriteWithSpriteFrameName:frameName];
//        }
//        frame = [frameCache spriteFrameByName:frameName];
//        [frames addObject:frame];
//    }
//    
//    CCAnimation *anim = [CCAnimation animationWithFrames:frames
//                                                   delay:1.0f/60];
//    node.tag = tag;
//    id animateAction = [CCAnimate actionWithAnimation:anim
//                                 restoreOriginalFrame:NO];
//    [node runAction:[CCRepeatForever actionWithAction:animateAction]];
//    [batchNode addChild:node];
//    return batchNode;
//}

@end
//DEFAULT_GAME_FPS 是一个常量，指定了游戏运行的帧数，定义在 GameConfig.h 中：
//
//#define DEFAULT_GAME_FPS        60
//用法示例：
//
//CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:@"Flowers.png"];
//CCSpriteBatchNode *batch;
//batch = [FrameAnimHelper animWithTexture:tex
//                               numFrames:20
//                           plistFilename:@"Flowers.plist"
//                              spriteName:@"Flower"
//                               spriteTag:FLOWERS_SPRITE_TAG];
//
//[self addChild:batch];
//提供的 spriteTag 参数会指定给 CCSpriteBatchNode 中包含的 CCSprite 对象。这样在需要暂停动画时就可以用：
//
//id sprite = [batch getChildByTag:FLOWERS_SPRITE_TAG];
//[[CCActionManager sharedManager] resumeTarget:sprite];
