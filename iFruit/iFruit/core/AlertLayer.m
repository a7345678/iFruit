//
//  OptionLayer.m
//  iFruit
//
//  Created by mac on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AlertLayer.h"
#import "DropFruitLayer.h"

@implementation AlertLayer
@synthesize type = _type;

static AlertLayer *alertLayer = nil;

+(AlertLayer *)sharedInstance{
    if (!alertLayer) {
        alertLayer = [AlertLayer node];
    }
    return alertLayer;
}

- (id) init
{
	self= [super initWithColor:ccc4(0, 0, 0, 180)];
	if (self)
	{
        self.touchEnabled = YES;
        
        _type = GAME_TIP;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *tipbg = [CCSprite spriteWithFile:@"alert_bg.png"];
        tipbg.position = ccp(size.width/2,isPad?size.height/2:240);
        
        [self addChild:tipbg];
        
        // 用图像创建，可以用CCMenuItemImage或者CCSprite（如下），后者的优点在于你可以用同一幅图，仅靠着不同色来达到高亮效果
        CCSprite* normal = [CCSprite spriteWithFile:@"close_button.png"];
        CCSprite* selected = [CCSprite spriteWithFile:@"close_button.png"];
        CCMenuItemSprite* item = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected
                                                                 target:self selector:@selector(closeTip:)];
        item.position = ccp(isPad?260:128,isPad?150:83-iPhone5offsetHalf);
        
        NSString *text;
        if(_type==GAME_TIP){
            text = @"游戏说明：拖动整行、整列或交换相邻水果,行列上三个相同水果即可消除,还可以使用道具哦,发挥不同道具的特性助您获得高分,祝您游戏愉快～";
        }else{
            text = @"游戏说明：海底捞月模式，摆动手机或拖动海龟接住掉落的水果得分,若碰触炸弹则返回游戏主界，祝您游戏愉快～";
        }
        label = [CCLabelTTF labelWithString:text dimensions:CGSizeMake(isPad?480:240,150) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:isPad?28:14];
        label.position = ccp(size.width/2, size.height/2-(isPad?30:40)-iPhone5offsetHalf);
        [self addChild:label];
        
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:item,nil];
    
        [self addChild:menu];

    }
    return self;
}
             
-(void)setType:(int)type{
    _type = type;
    NSString *text = NULL;
    if(type==GAME_TIP){
        text = @"游戏说明：拖动整行、整列或交换相邻水果,行列上三个相同水果即可消除,还可以使用道具哦,发挥不同道具的特性助您获得高分,祝您游戏愉快～";
    }else if(type==DROPFRUIT_TIP){
        text = @"海底捞月模式：摆动手机或拖动海龟接住掉落的水果得分,若碰触炸弹则返回游戏主界面，祝您游戏愉快～";
    }
    label.string = text;
}

-(void) closeTip:(id)sender {
    NSLog(@"clost tip it");
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
//    [scene removeChildByTag:11 cleanup:YES];
    [self removeFromParentAndCleanup:YES];
    
    if(_type==GAME_TIP){
        GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
        [gameLayer playGame:nil];
        [gameLayer startGameLogic];
    }else{
        DropFruitLayer *gameLayer = (DropFruitLayer *)[scene getChildByTag:9];
        [gameLayer startGameLogic];
    }
}
-(void)dealloc{
    [super dealloc];
}
@end
