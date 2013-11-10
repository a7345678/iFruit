//
//  NumUtils.m
//  Fruit
//
//  Created by mac on 11-7-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NumUtils.h"

@implementation NumUtils
@synthesize numArray,curNumArray;

-(NumUtils *)init:(CCLayer *)layer {
    
    self = [super init];
    if(self)
    {
        view = layer;
        curNumArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NumUtils *)initLayer:(CCLayer *)layer {
    
    self = [super init];
    if(self)
    {
        view = layer;
        curNumArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeNum:(id)sender{
    
    if ([curNumArray count]==0) return;
    
    for (int i=0; i<[curNumArray count]; i++) {
        CCSprite *sp = [curNumArray objectAtIndex:i];
        [sp removeFromParentAndCleanup:NO];
    }
    [curNumArray removeAllObjects];
}

- (void)drawScore:(CCLayer *) layer beginPoint:(CGPoint)beginPoint endPoint:(CGPoint)endPoint num:(NSString *)numstr {
        
    int num;
    for(int i=0; i<[numstr length]; i++){
        
        NSMutableArray *idArray = [[NSMutableArray alloc] init];
        
        num = [[numstr substringWithRange:NSMakeRange(i, 1)] intValue];
        
        NSString *filename = [NSString stringWithFormat:@"a%d.png",num];
        CCSprite *sp = [CCSprite spriteWithFile:filename];
        sp.position = CGPointMake(beginPoint.x+(i+1)*sp.contentSize.width, beginPoint.y+sp.contentSize.height);
        [view addChild:sp];
        [curNumArray addObject:sp];
        
//        float sec = 0.75-0.25*i;
//        float delay = 0.2*i;
        
        float sec = 0.45-0.15*i;
        float delay = 0.1*i;
        
        id delayTime = [CCDelayTime actionWithDuration:delay];
        [idArray addObject:delayTime];
        id actionMove = [CCMoveTo actionWithDuration:sec position:ccp(sp.position.x, sp.position.y+80)]; 
        [idArray addObject:actionMove];
        
        id actionMoveToScore = [CCMoveTo actionWithDuration:0.5 position:endPoint];
        [idArray addObject:actionMoveToScore];
        
        if(i==[numstr length]-1){
            id completeAutoMove = [CCCallFunc actionWithTarget:self selector:@selector(removeNum:)];
            [idArray addObject:completeAutoMove];
        }
        
        [sp runAction:[CCSequence actionWithArray:idArray]];
        [idArray release];
    }
}

-(void)dealloc {
    [numArray release];
    [curNumArray release];
    [super dealloc];
}

@end