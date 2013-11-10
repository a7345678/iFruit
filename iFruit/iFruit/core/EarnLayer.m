//
//  EarnLayer.m
//  iFruit
//
//  Created by mac on 12-1-1.
//  Copyright 2012年 asiainfo-linkage. All rights reserved.
//

#import "EarnLayer.h"
#import "SceneManager.h"


@implementation EarnLayer

- (id) init
{
	self = [super init];
	if (self)
	{
        
        CCSprite* earnNormal = [CCSprite spriteWithFile:@"earn.png"];
        CCSprite* earnSelected = [CCSprite spriteWithFile:@"earn.png"];
        CCMenuItemSprite* earnItem = [CCMenuItemSprite itemFromNormalSprite:earnNormal selectedSprite:earnSelected 
                                                                     target:self selector:@selector(earn:)];
        earnItem.position = ccp(0, 100);
        
//        if([[WPlusManager sharedManager] isLogon])
//            [earnItem setIsEnabled:NO];
        
        CCSprite* earnNormal1 = [CCSprite spriteWithFile:@"earn.png"];
        CCSprite* earnSelected1 = [CCSprite spriteWithFile:@"earn.png"];
        CCMenuItemSprite* earnItem1 = [CCMenuItemSprite itemFromNormalSprite:earnNormal1 selectedSprite:earnSelected1 
                                                                     target:self selector:@selector(earn1:)];
        earnItem1.position = ccp(50, 100);
        
        CCSprite* earnNormal2 = [CCSprite spriteWithFile:@"earn.png"];
        CCSprite* earnSelected2 = [CCSprite spriteWithFile:@"earn.png"];
        CCMenuItemSprite* earnItem2 = [CCMenuItemSprite itemFromNormalSprite:earnNormal2 selectedSprite:earnSelected2 
                                                                     target:self selector:@selector(earn2:)];
        earnItem2.position = ccp(100, 100);
        
        CCSprite* earnNormal3 = [CCSprite spriteWithFile:@"earn.png"];
        CCSprite* earnSelected3 = [CCSprite spriteWithFile:@"earn.png"];
        CCMenuItemSprite* earnItem3 = [CCMenuItemSprite itemFromNormalSprite:earnNormal3 selectedSprite:earnSelected3 
                                                                      target:self selector:@selector(earn3:)];
        earnItem3.position = ccp(150, 100);
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:earnItem,earnItem1,earnItem2,earnItem3,nil];       
        [self addChild:menu];

    }
    return self;
}


-(void) earn2:(id)sender {
    
}

-(void) earn3:(id)sender {
    [SceneManager popScene];
}


@end
