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
#import "SoundUtils.h"
#import "BowFruitLayer.h"
#import "AlertLayer.h"

@implementation GameLayer
@synthesize fruitCore;
@synthesize timeText;
@synthesize timemidbg;
@synthesize gamePlaying;
@synthesize musicCanPlay,soundCanPlay;
@synthesize hintItem;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
    
	// add layer as a child to scene
    [scene addChild:layer z:0 tag:0];
    
	// return the scene
	return scene;
}

- (id) init
{
	self = [super init];
	if (self)
	{
        // accept touch now!
        self.touchEnabled = YES;
        
        fruitCore = (FruitCore *)[[FruitCore alloc] init:self];
        
        //获取系统设置
        gamePlaying = TRUE;
        musicCanPlay = [CommUtils getGameValue:@"musicCanPlay"];
        soundCanPlay = [CommUtils getGameValue:@"soundCanPlay"];
                
        CGSize size = [[CCDirector sharedDirector] winSize];
        //        StretchableSprite *ssprite = [StretchableSprite spriteWithFile:@"button_click.png" size:CGSizeMake(100, 100) leftCap:30 topCap:30];
        //        ssprite.position =  ccp( size.width /2 -50, size.height-120 );
        //        [self addChild:ssprite];
                
        CCSprite* pauseNormal = [CCSprite spriteWithFile:@"pause.png"];
        CCSprite* pauseSelected = [CCSprite spriteWithFile:@"pause_selected.png"];
        
        CCMenuItemSprite* item1 = [CCMenuItemSprite itemWithNormalSprite:pauseNormal selectedSprite:pauseSelected
                                                                  target:self selector:@selector(pause:)];
        
        
        CCSprite* hintNormal = [CCSprite spriteWithFile:@"hint.png"];
        CCSprite* hintSelected = [CCSprite spriteWithFile:@"hint_selected.png"];
        hintItem = [CCMenuItemSprite itemWithNormalSprite:hintNormal selectedSprite:hintSelected
                                                                  target:self selector:@selector(tip:)];
        
		[CCMenuItemFont setFontName: @"Marker Felt"];
		[CCMenuItemFont setFontSize:34];
        
        
        CCSprite* howToPlayNormal = [CCSprite spriteWithFile:@"howtoplay.png"];
        CCSprite* howToPlaySelected = [CCSprite spriteWithFile:@"howtoplay.png"];
        CCMenuItemSprite *howToPlayItem = [CCMenuItemSprite itemWithNormalSprite:howToPlayNormal selectedSprite:howToPlaySelected
                                                   target:self selector:@selector(howToPlay:)];
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:item1,hintItem,howToPlayItem,nil];
        //menu.anchorPoint = CGPointMake(0,0.5);
        menu.position = CGPointMake(isPad?140:80, size.height-(isPad?156:36)-iPhone5offset);
        [self addChild:menu];
        // 把菜单项排列起来
        [menu alignItemsHorizontallyWithPadding:10];
        
        int timebgX = isPad?150:82;
        int timeY = isPad?750:404;
        CCSprite *timelabel = [CCSpriteUtils createCCSprite:@"time_label.png" location:ccp(18,timeY+8)];
        [self addChild:timelabel z:0 tag:99];
        
        CCSprite *timemidbgalpha = [CCSpriteUtils createCCSprite:@"time_mid_bg_alpha.png" location:ccp(timebgX,timeY)];
        timemidbgalpha.anchorPoint = ccp(0,0.5);
        timemidbgalpha.scaleX = GAMETIMESCALEX;
        [self addChild:timemidbgalpha  z:0 tag:99];
        
        timemidbg = [CCSpriteUtils createCCSprite:@"time_mid_bg.png" location:ccp(timebgX,timeY)];
        timemidbg.anchorPoint = ccp(0,0.5);
        timemidbg.scaleX = GAMETIMESCALEX;
        [self addChild:timemidbg  z:0 tag:99];
        
        CCSprite *timeleftbg = [CCSpriteUtils createCCSprite:@"time_left_bg.png" location:ccp(timebgX-2,timeY)];
        [self addChild:timeleftbg z:0 tag:99];
        
        CCSprite *timerightbg = [CCSpriteUtils createCCSprite:@"time_right_bg.png" location:ccp(timebgX+(isPad?360:180),timeY)];
        [self addChild:timerightbg  z:0 tag:99];
        
        //播放背景音乐
        if(self.musicCanPlay==1)
        [SoundUtils playBackgroundMusic:BACKGROUNDMP3 volume:0.8 flag:musicCanPlay];
        
        [self initTime:GAMETIME location:ccp( 280 , size.height-84 )];
	}
	
	return self;
}

- (void)howToPlay:(id)sender {

    [self unschedule:@selector(gameLogic:)];
    gamePlaying = FALSE;
    
    AlertLayer *alertLayer = [AlertLayer node];
    [self addChild:alertLayer];
}

- (void) initTime:(int)time location:(CGPoint)location {
    timeText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",time] fontName:@"Marker Felt" fontSize:22];
    timeText.position =  location;
    timeText.color = ccc3(255, 255, 255);
    timeText.visible = false;
    [self addChild: timeText];
    [self schedule:@selector(gameLogic:) interval:1.0];  //游戏时间
}


- (void) setTime:(int)time {
    [timeText setString:[NSString stringWithFormat:@"%d",time]];
    [timemidbg setScaleX:(GAMETIMESCALEX/GAMETIME)*time];
    [self schedule:@selector(gameLogic:) interval:1.0];  //游戏时间
}

- (void) startGameLogic {
    [self schedule:@selector(gameLogic:) interval:1.0];  //游戏时间
}

- (void) addTime:(int)addTime {
    int time = [[timeText string] intValue];
    time+=addTime;
    if(time >= GAMETIME) time = GAMETIME;
    [timeText setString:[NSString stringWithFormat:@"%d",time]];
    int scaleX = (GAMETIMESCALEX/GAMETIME)*time;
    if(scaleX>GAMETIMESCALEX) scaleX = GAMETIMESCALEX;
    [timemidbg setScaleX:scaleX];
}

-(void)scoreAnimal:(ccTime)dt{
    [fruitCore scoreAnimal:dt];
}

-(void) doubleScore {
    [self unschedule:@selector(resumeScore:)];
    [fruitCore.multipleTTF stopAllActions];
    
    fruitCore.multiple *= 2;

    if(fruitCore.multipleTTF == nil){
        fruitCore.multipleTTF = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%d",fruitCore.multiple] fontName:@"Marker Felt" fontSize:isPad?44:22];
        fruitCore.multipleTTF.position = ccp(isPad?650:296, isPad?830:415);
        fruitCore.multipleTTF.color =  ccc3(255, 168, 0);
        [self addChild:fruitCore.multipleTTF];
        
        fruitCore.multipleTTFBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%d",fruitCore.multiple] fontName:@"Marker Felt" fontSize:isPad?44:22];
        fruitCore.multipleTTFBg.color =  ccc3(255, 246, 0);
        fruitCore.multipleTTFBg.position = ccp(isPad?652:298, isPad?832:417);
        //ccp(fruitCore.multipleTTFBg.position.x+20,fruitCore.multipleTTFBg.position.y+20);
        [self addChild:fruitCore.multipleTTFBg];
    }else{
        [fruitCore.multipleTTF setString:[NSString stringWithFormat:@"X%d",fruitCore.multiple]];
        [fruitCore.multipleTTFBg setString:[NSString stringWithFormat:@"X%d",fruitCore.multiple]];
    }
    
    [self showMultiple:fruitCore.multipleTTF];
    [self showMultiple:fruitCore.multipleTTFBg];

    [self schedule:@selector(resumeScore:) interval:24];
}

-(void) showMultiple:(CCLabelTTF *)ttf {
    ttf.scale = 5;
    id moveAction = [CCScaleTo actionWithDuration:1 scale:1];
    [ttf runAction:moveAction];
}

-(void)resumeScore:(ccTime)dt{
    [self unschedule:@selector(resumeScore:)];
    
    id fadeOut = [CCFadeOut actionWithDuration:0.5];
    id fadeIn = [CCFadeIn actionWithDuration:0.5]; 
    
    id fadeAction = [CCRepeat actionWithAction:[CCSequence actions:fadeOut,fadeIn, nil] times:6];
  
    id actionDone = [CCCallFuncND actionWithTarget:self 
                                          selector:@selector(resetMultiple:data:) data:nil];
    
    [fruitCore.multipleTTF runAction:[CCSequence actions:fadeAction,actionDone, nil]];
}

-(void)resetMultiple:(id)sender data:(CCLabelTTF *)ttf {
        fruitCore.multiple = SCORESCALE;
    [fruitCore.multipleTTFBg removeFromParentAndCleanup:YES];
    fruitCore.multipleTTFBg = nil;
        [fruitCore.multipleTTF removeFromParentAndCleanup:YES];
        fruitCore.multipleTTF = nil;
}

-(void)autoMove:(ccTime)dt{
    [fruitCore autoMove:dt];
}

-(void)tip:(id)sender {
    [fruitCore tip:nil];
    if(self.soundCanPlay==1) [SoundUtils buttonClick];
}
-(void)removeTip:(ccTime)dt{
    [fruitCore removeTip:dt];
}

//重新布局水果
- (void)refresh:(id)sender{
    [fruitCore refreshFruit];
}

- (void)pause:(id)sender{
    if (!gamePlaying) return;
    [self unschedule:@selector(gameLogic:)];
    gamePlaying = FALSE;
    [SoundUtils pauseBackgroundMusic:musicCanPlay];
    //[[CCDirector sharedDirector] pause];
    if(self.soundCanPlay==1) [SoundUtils buttonClick];
    OptionLayer *optionlayer = [OptionLayer node];
    [SceneManager addLayer:optionlayer z:3 tag:3];
}

- (void)restart:(BOOL)flag{

    gamePlaying = TRUE;
    if(self.soundCanPlay==1) [SoundUtils buttonClick];
    if(self.musicCanPlay==1)
    [SoundUtils playBackgroundMusic:BACKGROUNDMP3 volume:0.8 flag:musicCanPlay];
    [[CCDirector sharedDirector] resume];
    fruitCore.score=0;
    fruitCore.helpNum = HELPNUM;
    [fruitCore.scoreValue setString:@"0"];
    [fruitCore.scoreValueBg setString:@"0"];
    fruitCore.level = 1;
    [fruitCore.levelValue setString:[NSString stringWithFormat:@"%d",fruitCore.level]];
    [fruitCore.levelScoreValue setString:[NSString stringWithFormat:@"%d",
                    [fruitCore getLevelScore]]];
    [self resetMultiple:nil data:nil];
    [fruitCore resetScoreArray];
    [self setTime:GAMETIME];
    [fruitCore refreshFruit];
    if(!flag) [Item removeAll];
    [fruitCore gameStart:0];
}

- (void)playGame:(id)sender{
    
    gamePlaying = TRUE;
    [self startGameLogic];
//    if([[CCDirector sharedDirector] isPaused])
//        [[CCDirector sharedDirector] resume];
    //[CommUtils hiddenAd];
    if(self.soundCanPlay==1) [SoundUtils buttonClick];
    if(self.musicCanPlay==1)
    [SoundUtils playBackgroundMusic:BACKGROUNDMP3 volume:0.8 flag:musicCanPlay];
    int timer = [[timeText string] intValue];
    if(timer<=0){
        fruitCore.score=0;
        fruitCore.helpNum = HELPNUM;
        [fruitCore.scoreValue setString:@"0"];
        [fruitCore.scoreValueBg setString:@"0"];
        [fruitCore resetScoreArray];
        [self setTime:GAMETIME];
        [Item removeAll];
        [fruitCore refreshFruit];
        [fruitCore gameStart:0];
    }
}

- (void)nextLevel:(id)sender{
    
    BOOL isLevelUp = [sender intValue]==1;
    
    gamePlaying = TRUE;
//    if([[CCDirector sharedDirector] isPaused])
//        [[CCDirector sharedDirector] resume];
    //[CommUtils hiddenAd];
    if(self.soundCanPlay==1) [SoundUtils buttonClick];
    if(self.musicCanPlay==1)
    [SoundUtils playBackgroundMusic:BACKGROUNDMP3 volume:0.8 flag:musicCanPlay];
    
    if(isLevelUp){
        fruitCore.level++;
        [self setTime:GAMETIME];
    }else{
        int timer = [[timeText string] intValue];
        [self setTime:timer];
    }
//    CCLabelTTF *levelScoreValue = fruitCore.levelScoreValue;
//    int levelScore = [[levelScoreValue string] intValue];
    
    [fruitCore.levelValue setString:[NSString stringWithFormat:@"%d",fruitCore.level]];
    [fruitCore.levelScoreValue setString:
            [NSString stringWithFormat:@"%d",[fruitCore getLevelScore]]];
    [fruitCore resetScoreArray];
    [self resetMultiple:nil data:nil];
    [fruitCore refreshFruit];
    [fruitCore gameStart:0];
}

- (void)musicControll:(id)sender{
    if(self.soundCanPlay==1) [SoundUtils buttonClick];
    
    if(musicCanPlay==1){
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        musicCanPlay = 0;
        [CommUtils setGameValue:@"musicCanPlay" value:[NSNumber numberWithInt:musicCanPlay]];
    }else{
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        musicCanPlay = 1;
        [CommUtils setGameValue:@"musicCanPlay" value:[NSNumber numberWithInt:musicCanPlay]];
    }
}
- (void)soundControll:(id)sender{
    if(self.soundCanPlay==0) [SoundUtils buttonClick];
    
    if(soundCanPlay==1){
        soundCanPlay = 0;
        [CommUtils setGameValue:@"soundCanPlay" value:[NSNumber numberWithInt:soundCanPlay]];
    }else{
        soundCanPlay = 1;
        [CommUtils setGameValue:@"soundCanPlay" value:[NSNumber numberWithInt:soundCanPlay]];
    }
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
    
    int curScore = [[fruitCore.scoreValue string] intValue];
    if(curScore>=fruitCore.score && (timer <=0 || [fruitCore levelup]) && fruitCore.clickStatus==-1 && fruitCore.autoMoveComplete){
        
        gamePlaying = FALSE;
        if(timer<=0) [Item removeAll];
        [SoundUtils pauseBackgroundMusic:musicCanPlay];
        [fruitCore.multipleTTF removeFromParentAndCleanup:YES];
        [fruitCore.multipleTTFBg removeFromParentAndCleanup:YES];
        fruitCore.multipleTTF = nil;
        fruitCore.multipleTTFBg = nil;
        [self unschedule:@selector(gameLogic:)];
        
        ResultLayer *resultlayer = [ResultLayer node];
        [SceneManager addLayer:resultlayer z:0 tag:1];
    }
}

- (void) goDropFruit{
    [self unschedule:@selector(gameLogic:)];
    gamePlaying = FALSE;
    [SoundUtils pauseBackgroundMusic:musicCanPlay];
    
    DropFruitLayer *dropFruitLayer = [DropFruitLayer node];
    dropFruitLayer.multiple = fruitCore.multiple;
    [SceneManager addLayer:dropFruitLayer z:1 tag:9];
}

- (void) goBowFruit{
    [self unschedule:@selector(gameLogic:)];
    gamePlaying = FALSE;
    [SoundUtils pauseBackgroundMusic:musicCanPlay];
    
    BowFruitLayer *layer = [BowFruitLayer node];
    [SceneManager addLayer:layer z:1 tag:10];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"begin touch");
    if (!gamePlaying || [fruitCore isLockFruit]) return; //自动拖动完成后，方可执行第二次拖动
    
    //NSLog(@"fruitCore.clickStatus :%d",fruitCore.clickStatus);
    if(fruitCore.clickStatus == -1) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        gestureStartPoint = [[CCDirector sharedDirector] convertToGL:location];
        if ([touches count]==1)   {   //单击才响应该函数
            fruitCore.curClickFruitIndex = [Fruit SomethingWasTouched:fruitCore.fruitArray pos:gestureStartPoint];
            //NSLog(@"location x:%f y:%f,currentClick:%d",gestureStartPoint.x,gestureStartPoint.y,fruitCore.curClickFruitIndex);
        }
        if(fruitCore.curClickFruitIndex!=-1 && fruitCore.lastClickFruitIndex!=-1)
            fruitCore.clickStatus = -2;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"move touch:%d curIndex:%d, isLock:%d",gamePlaying?1:0,fruitCore.curClickFruitIndex,[fruitCore isLockFruit]?1:0);
    //自动拖动完成后，方可执行第二次拖动
    if (!gamePlaying || fruitCore.curClickFruitIndex==-1
        || fruitCore.curClickFruitIndex==-2 || [fruitCore isLockFruit]) return; 
        
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint currentPosition = [[CCDirector sharedDirector] convertToGL:location];

    CGFloat deltaX = gestureStartPoint.x - currentPosition.x;
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    CGFloat absdeltaX = fabsf(deltaX);
    CGFloat absdeltaY = fabsf(deltaY);
    
    if(deltaX>COL*FRUITWIDTH) return;
    if(deltaY>ROW*FRUITHEIGHT) return;
    
    if (fruitCore.clickStatus == -1) {
        if(absdeltaX>= kMinimumGestureLength && absdeltaY <=kMaximumVariance){
                fruitCore.clickStatus = ROW_OPER;
                [fruitCore copyRowFruit:fruitCore.curClickFruitIndex];
        }else if(absdeltaY >= kMinimumGestureLength && absdeltaX <= kMaximumVariance){
                fruitCore.clickStatus= COL_OPER;
                [fruitCore copyColFruit:fruitCore.curClickFruitIndex];
        }
    }else{
        
        // NSLog(@"deltaX:%f,deltaY:%f",deltaX,deltaY);
        if(fruitCore.clickStatus ==ROW_OPER){//横向拖动
            [fruitCore moveRowFruit:fruitCore.curClickFruitIndex x:deltaX y:deltaY];
        }else if(fruitCore.clickStatus==COL_OPER) {//纵向拖动
            [fruitCore moveColFruit:fruitCore.curClickFruitIndex x:deltaX y:deltaY];
        }
    }
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"end touch");
    if (!gamePlaying || [fruitCore isLockFruit]) return; //自动拖动完成后，方可执行第二次拖动
    
	//NSArray *mySprites = [Fruit allMySprites];
	//int count = [mySprites count];
    
    if([touches count]==1){
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint currentPosition = [[CCDirector sharedDirector] convertToGL:location];
        
        //判断是否点击了道具
        int index = [Item SomethingWasTouched:fruitCore.itemArray pos:currentPosition];
        NSLog(@"click:%d",index);
        if (index!=-1) {
            Item *item = [[Item itemArray] objectAtIndex:index];
            int style = [item style];
            [fruitCore useItem:index];
            switch (style) {
                case 0:
                    [fruitCore runBomb];
                    break;
                case 1:
                    [fruitCore refreshBombFruit];
                    break;
                case 2:
                    [self doubleScore];
                    break;
                case 3:
                    [self addTime:GAMETIME/2];
                    break;
                case 4:
                    [self goDropFruit];
                    break;
                case 5:
                    [self goBowFruit];
                    break;
                default:
                    break;
            }
            return;
        }
        
        if(fruitCore.curClickFruitIndex==-1) return; //水果交换
        
        if(fruitCore.clickStatus == -2) {
            if(fruitCore.lastClickFruitIndex==-1) return;
                [fruitCore swapFruit:fruitCore.curClickFruitIndex to:fruitCore.lastClickFruitIndex isOperate:YES];
        }else if(fruitCore.clickStatus>=0 && fruitCore.clickStatus<=1){
            
            CGFloat deltaX = gestureStartPoint.x - currentPosition.x;// 大于0向左　小于0向右　　
            CGFloat deltaY = gestureStartPoint.y - currentPosition.y;// 大于0向上　小于0向下
            
            [fruitCore lockFruit]; //锁定水果
            [fruitCore autoMoveFruit:fruitCore.curClickFruitIndex x:deltaX y:deltaY isOperate:1];
        }
    }
    
//    else if([touches count]>=SAMENUM){
//        
//        [fruitCore lockFruit];
//        
//        NSLog(@"touches:%d",[touches count]);
//        
//
//        NSArray *multiTouches = [touches allObjects];
//        NSMutableArray *sameFruit = [[NSMutableArray alloc] init];
//        
//        
//        //检测多点触摸是否得分
//        for (int i=0; i<[multiTouches count]; i++) {
//            UITouch *touch = [multiTouches objectAtIndex:i];
//            CGPoint tmpLoc = [touch locationInView: [touch view]];
//            CGPoint location = [[CCDirector sharedDirector] convertToGL:tmpLoc];
//            
//            int index = [Fruit SomethingWasTouched:fruitCore.fruitArray pos:location];
//            
//            if (index==-1) continue;
//            
//            if([sameFruit count] == 0){
//                [sameFruit addObject:[NSNumber numberWithInt:index]];
//            }else{
//                Fruit *obj = [fruitCore.fruitArray objectAtIndex:index];
//                Fruit *tempFruit = [fruitCore.fruitArray objectAtIndex:[[sameFruit lastObject] intValue]];
//                if(tempFruit.style == obj.style)
//                [sameFruit addObject:[NSNumber numberWithInt:index]];
//                else break;
//            }
//        }
//        [fruitCore dropFruit:sameFruit level:[NSNumber numberWithInt:3]];
//        
//        [sameFruit release];
//    }
}

- (void) dealloc
{
    // Disable layer touch
    self.touchEnabled = NO;
    //[[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    
    [timeText release];
    [timemidbg release];
    [fruitCore release]; 
    [super dealloc];
}

@end
