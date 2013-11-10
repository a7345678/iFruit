//
//  GameLayer.m
//  G03
//
//  Created by Mac Admin on 15/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "SceneManager.h"
#import "ResultLayer.h"
#import "OptionLayer.h"
#import "TipLayer.h"
#import "SoundUtils.h"

@implementation TipLayer
@synthesize timeText;
@synthesize timemidbg;
@synthesize gamePlaying;
@synthesize musicCanPlay,soundCanPlay;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TipLayer *layer = [TipLayer node];
    
	// add layer as a child to scene
    [scene addChild:layer z:0 tag:1];
    
	// return the scene
	return scene;
}

- (id) init
{
	self = [super init];
	if (self)
	{
        fruitCore = (TipCore *)[[TipCore alloc] init:self];
        
        
        NSString *tipStr = @"HOW TO PLAY ?";
        NSString *tipRemark = @"scorlling fruit or swap fruit";
        
        if(USEWPLUS){
            tipRemark = @"游戏说明：拖动整行、整列或交换相邻水果,行列上三个水果可消除,还可以使用道具哦,祝您游戏愉快！";
            
            CCLabelTTF *remarkTextBg = [CCLabelTTF labelWithString:tipRemark dimensions:CGSizeMake(300,200) alignment:UITextAlignmentLeft fontName:@"Marker Felt" fontSize:18];
            remarkTextBg.position =  ccp(169, 362);
            remarkTextBg.color=ccc3(255, 255, 255);
            [self addChild:remarkTextBg];

            CCLabelTTF *remarkText = [CCLabelTTF labelWithString:
                                      tipRemark dimensions:CGSizeMake(300,200) alignment:UITextAlignmentLeft 
                                                        fontName:@"Marker Felt" fontSize:18];
            remarkText.position =  ccp(167, 363);
            remarkText.color=ccc3(216, 71, 0);
            [self addChild:remarkText];
        }else{
            CCLabelTTF *labelTextBg = [CCLabelTTF labelWithString:tipStr fontName:@"Marker Felt" fontSize:36];
            labelTextBg.position =  ccp(162, 440);
            labelTextBg.color=ccc3(255, 255, 255);
            [self addChild:labelTextBg];
            
            CCLabelTTF *labelText = [CCLabelTTF labelWithString:tipStr fontName:@"Marker Felt" fontSize:36];
            labelText.position =  ccp(160, 442);
            labelText.color=ccc3(255, 168, 0);
            [self addChild:labelText];
            
            CCLabelTTF *remarkTextBg = [CCLabelTTF labelWithString:tipRemark fontName:@"Marker Felt" fontSize:18];
            remarkTextBg.position =  ccp(162, 408);
            remarkTextBg.color=ccc3(255, 255, 255);
            [self addChild:remarkTextBg];
            
            CCLabelTTF *remarkText = [CCLabelTTF labelWithString:
                                     tipRemark fontName:@"Marker Felt" fontSize:18];
            remarkText.position =  ccp(160, 409);
            remarkText.color=ccc3(255, 168, 0);
            [self addChild:remarkText];
        }
        

        // 用图像创建，可以用CCMenuItemImage或者CCSprite（如下），后者的优点在于你可以用同一幅图，仅靠着不同色来达到高亮效果
        CCSprite* normal = [CCSprite spriteWithFile:@"show_button.png"];
        CCSprite* selected = [CCSprite spriteWithFile:@"show_button.png"];
        CCMenuItemSprite* item = [CCMenuItemSprite itemFromNormalSprite:normal selectedSprite:selected 
                                                                 target:self selector:@selector(donotshow:)];
        item.position = ccp(-45,120);
        
        
        CCSprite* normal2 = [CCSprite spriteWithFile:@"skip_button.png"];
        CCSprite* selected2 = [CCSprite spriteWithFile:@"skip_button.png"];
        CCMenuItemSprite* item2 = [CCMenuItemSprite itemFromNormalSprite:normal2 selectedSprite:selected2 
                                                                  target:self selector:@selector(skip:)];
        item2.position = ccp(36,122);
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:item,nil];       
        [self addChild:menu];
        
        // 创建菜单
        CCMenu* menu2 = [CCMenu menuWithItems:item2,nil];       
        [self addChild:menu2];
        
        int itemX = menu.position.x;
        int itemY = menu.position.y;
        
        id moAction1 = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(itemX, itemY+1)];
        id moAction2 = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(itemX, itemY-1)];
        [menu runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moAction1,moAction2, nil]]];
        
        int item2X = menu2.position.x;
        int item2Y = menu2.position.y;
        id moAction3 = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(item2X, item2Y-1)];
        id moAction4 = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(item2X, item2Y+1)];
        [menu2 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moAction3,moAction4, nil]]];

        
        [self tipMovie:nil];
	}
	
	return self;
}

-(void)tipMovie:(id)sender {
    _mx = 0; _my = 0;
    fruitCore.clickStatus = 0;
    
    int curIndex =  15;
    fruitCore.curClickFruitIndex = curIndex;
    [fruitCore copyRowFruit:fruitCore.curClickFruitIndex];
    
    helper = [CCSprite spriteWithFile:@"helper.png"];
    Fruit *fruit = [fruitCore.fruitArray objectAtIndex:curIndex];
    helper.position = ccp(fruit.position.x+3,fruit.position.y-20);
    [self addChild:helper];
    
    [self schedule:@selector(monitorMove:) interval:0.01];
}

-(void)monitorMove:(ccTime)dt {
    _mx++;
    helper.position = ccp(helper.position.x-1,helper.position.y);
    [fruitCore moveRowFruit:fruitCore.curClickFruitIndex x:_mx y:_my];
    if(_mx>=FRUITWIDTH*2) {
        [self unschedule:@selector(monitorMove:)];
        helper.visible = false;
        [fruitCore autoMoveFruit:fruitCore.curClickFruitIndex x:_mx y:_my isOperate:1];
        
        //延时执行
        [self performSelector:@selector(swapFruit:)
                   withObject:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:17],[NSNumber numberWithInt:23],nil] afterDelay:2];
    }
}

- (void) swapFruit:(NSMutableArray *)param {
        
    int aIndex = [[param objectAtIndex:0] intValue];
    int bIndex = [[param objectAtIndex:1] intValue];
    
    Fruit *fruitA = [fruitCore.fruitArray objectAtIndex:aIndex];
    Fruit *fruitB = [fruitCore.fruitArray objectAtIndex:bIndex];
    helper.visible = true;
    
    helper.position = ccpSub(fruitA.position,ccp(0,fruitA.contentSize.height/2));
    id moveAction = [CCMoveTo actionWithDuration:0.3
                                        position:ccpSub(fruitB.position,ccp(0,fruitB.contentSize.height/2))];
    id delay = [CCDelayTime actionWithDuration:1];
    id moveActionDone = [CCCallFuncND actionWithTarget:self selector:@selector(hiddenHelper:data:) data:param];
    id refreshFruit = [CCCallFuncN actionWithTarget:self selector:@selector(refreshFruit:)];
    id tipMovie = [CCCallFuncN actionWithTarget:self selector:@selector(tipMovie:)];
    
    [helper runAction:[CCSequence actions:delay,moveAction,delay,moveActionDone,delay,refreshFruit,tipMovie, nil]];
}

-(void)hiddenHelper:(id)sender data:(NSMutableArray *)param {
    int aIndex = [[param objectAtIndex:0] intValue];
    int bIndex = [[param objectAtIndex:1] intValue];
    [fruitCore swapFruit:aIndex to:bIndex isOperate:YES];
    helper.visible = false;
}

-(void) donotshow:(id)sender {
    [self setGameValue:@"howToPlay" value:[NSNumber numberWithInt:0]];
    [SceneManager goPlay];
}
-(void) skip:(id)sender {
    [SceneManager goPlay];
}

-(void) refreshFruit:(id)sender {
    [self unschedule:@selector(refreshFruit:)];
    [fruitCore refreshFruit];
}

-(void)autoMove:(ccTime)dt{
    [fruitCore autoMove:dt];
}

-(void)tip:(id)sender {
    [fruitCore tip:nil];
}
-(void)removeTip:(ccTime)dt{
    [fruitCore removeTip:dt];
}

//重新布局水果
- (void)refresh:(id)sender{
    [fruitCore refreshFruit];
}

- (void)setGameValue:(NSString *)key value:(NSObject *)value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
}

- (NSObject *)getGameValue:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

-(void)gameLogic:(ccTime)dt {
    int timer = [[timeText string] intValue];
    if(timer>0) timer--;
    else timer=0;
    [timeText setString:[NSString stringWithFormat:@"%d",timer]];
    
    if(timer>0){
        timemidbg.scaleX -= (int)GAMETIMESCALEX/GAMETIME;
    }else{
        timemidbg.scaleX = 0.1;
    }
    
    if((timer <=0 || [fruitCore levelup]) && fruitCore.clickStatus==-1 && fruitCore.autoMoveComplete){
        [self unschedule:@selector(gameLogic:)];
        gamePlaying = FALSE;
        [SoundUtils pauseBackgroundMusic:musicCanPlay];

        ResultLayer *resultlayer = [ResultLayer node];
        [SceneManager addLayer:resultlayer z:1 tag:1];

//        if (fruitCore.score>0)
//            [resultlayer calcScore:fruitCore.scoreArray score:fruitCore.score];
    }
}

- (void) dealloc
{
    [timeText release];
    [timemidbg release];
    //[fruitCore release];
    [super dealloc];
}

@end
