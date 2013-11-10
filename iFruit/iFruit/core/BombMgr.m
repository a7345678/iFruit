//
//  BombMgr.m
//  iFruit
//
//  Created by mac on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BombMgr.h"
#import "GameLayer.h"
#import "SoundUtils.h"


@implementation BombMgr
@synthesize texture = _texture;
@synthesize spriteSheet = _spriteSheet;
@synthesize charArray = _charArray;
@synthesize index;

enum {
	kTagSpriteSheet = 1,
};

-(BombMgr *) init:(CCLayer *)layer{
    self = [super init];
    if(self)
    {
        _layel = layer;
        self.charArray = [[NSMutableArray alloc] init];    
        
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bombflower.plist"];        
        
        // Create a sprite sheet with the Happy Bear images
        _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bombflower.png"];
        [_layel addChild:_spriteSheet z:0 tag:kTagSpriteSheet];
        
        for (int i=0; i<36; i++) {
            Adventurer *adventurer = [self addAdventurer];
            [_charArray addObject:adventurer];
        }
    }
    return self;
}

-(Adventurer *)addAdventurer {
    // Load up the frames of our animation
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 7; ++i) {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bombflower%d.png", i]]];
    }
    
    Adventurer * adventurer = [[Adventurer alloc] init];
    if (adventurer != nil) {
        
        CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
        
        // Create a sprite for our bear
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        adventurer.charSprite = [CCSprite spriteWithSpriteFrameName:@"bombflower1.png"];        
        //adventurer.charSprite.position = ccp(winSize.width/2, winSize.height/2);
        adventurer.charSprite.position = ccp(-100, -100);
        
        //第一种方法
        //adventurer.walkAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO] times:1];
        
        //第二种方法
        adventurer.animate = [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO];
        adventurer.walkAction = [CCRepeat actionWithAction:adventurer.animate times:1];
        
        //id actionWalkDone = [CCCallFuncND actionWithTarget:self selector:@selector(spriteFinished:data:) data:nil];
        //CCSequence *seq = [CCSequence actions:adventurer.animate, actionWalkDone,nil];
        //[adventurer.charSprite runAction:adventurer.walkAction];
         
        [self.spriteSheet addChild:adventurer.charSprite];
    }
    return adventurer;
}

-(void)spriteFinished:(id)sender data:(NSMutableArray *)param {   
    if(param == nil) return;
} 

-(void)runAction:(Adventurer *)adventurer{
    if(adventurer==nil) return;
    id actionWalkDone = [CCCallFuncND actionWithTarget:self selector:@selector(spriteFinished:data:) data:nil];
    CCSequence *seq = [CCSequence actions:adventurer.animate, actionWalkDone,nil];
    adventurer.walkAction = [CCRepeat actionWithAction:seq times:1];
    [adventurer.charSprite runAction:adventurer.walkAction];
    if(((GameLayer *)_layel).soundCanPlay==1)
    [SoundUtils playEffect:@"bombflower.caf" volume:1.0];
    
}

- (Adventurer *)getBomb{
    if (index>=36)  return nil;
    return [_charArray objectAtIndex:index++];
}

- (void) reset {
    index = 0;
}

- (void) dealloc
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[self.charArray removeAllObjects];
	[super dealloc];
}

@end
