//
//  ResultLayer.m
//  iFruit
//
//  Created by mac on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResultLayer.h"
#import "FruitCore.h"
#import "GCHelper.h"
#import "SoundUtils.h"
#import "GameResource.h"
#import "BannerAdViewController.h"

@implementation ResultLayer
@synthesize spriteArray,labelArray,scoreArray;
@synthesize gameScoreValue,highScoreValue;

-(void)dealloc {
//    if(spriteArray!=nil) [spriteArray release];
//    if(labelArray!=nil) [labelArray release];
//    if(scoreArray!=nil) [scoreArray release];
//    if(itemSrpiteArray!=nil) [itemSrpiteArray release];
//    if(gameScoreValue!=nil) [gameScoreValue release];
//    if(highScoreValue!=nil) [highScoreValue release];
//    if(contiuneItem!=nil) [contiuneItem release];
    [super dealloc];
}

- (id) init
{
	self= [super initWithColor:ccc4(0, 0, 0, 180)];
	if (self)
	{
        CGSize size = [[CCDirector sharedDirector] winSize];
        if(USEAD){
            BannerAdViewController *controller = [BannerAdViewController sharedInstance];
            [controller setLocation:CGPointMake(0, size.height-controller.adView.frame.size.height)];
        }
        
        spriteArray = [[NSMutableArray alloc] init];
        labelArray = [[NSMutableArray alloc] init];
        itemSrpiteArray = [[NSMutableArray alloc] init];
        
        // accept touch now! 
		self.touchEnabled = YES;
    
        CCSprite *tipbg = [CCSprite spriteWithFile:@"tip_bg.png"];
        tipbg.position = ccp(size.width/2,isPad?size.height/2:240);
        [self addChild:tipbg];

        CCScene *scene = [[CCDirector sharedDirector] runningScene];
        GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
        
        isLevelUp = [gameLayer.fruitCore levelup];
        CCSprite *tiplabel = [CCSprite spriteWithFile:isLevelUp?@"levelup.png":@"youlose.png"];
        tiplabel.position = ccp(isPad?384:156,isPad?700:352);
        [self addChild:tiplabel];
        
        GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
        
        if(isLevelUp){
            tiplabel.scale = 5;
            [tiplabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
            
            if(gamelayer.soundCanPlay==1)
            [SoundUtils playEffect:@"win.caf" volume:1.0];
        }else{
            id moveLeft = [CCMoveTo actionWithDuration:0.1 position:ccp(tiplabel.position.x-1,tiplabel.position.y)];
            id moveRight = [CCMoveTo actionWithDuration:0.1 position:ccp(tiplabel.position.x+1,tiplabel.position.y)];
            [tiplabel runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moveLeft,moveRight,nil]]];
            if(gamelayer.soundCanPlay==1)
            [SoundUtils playEffect:@"lose.caf" volume:1.0];
        }
        
//        // 用图像创建，可以用CCMenuItemImage或者CCSprite（如下），后者的优点在于你可以用同一幅图，仅靠着不同色来达到高亮效果
//        CCSprite* normal = [CCSprite spriteWithFile:@"close_button.png"];
//        CCSprite* selected = [CCSprite spriteWithFile:@"close_button.png"];
//        CCMenuItemSprite* item = [CCMenuItemSprite itemFromNormalSprite:normal selectedSprite:selected 
//                                                                 target:self selector:@selector(closeTip:)];
//        item.position = ccp(128,136-iPhone5offsetHalf);
        
        CCTexture2D *contiuneTexture = [[GameResource shared] sharedContiuneTexture];

        CCSprite* contiuneNormal = [CCSprite spriteWithTexture:contiuneTexture];
        CCSprite* continueSelected = [CCSprite spriteWithTexture:contiuneTexture];
        CCSprite* continueDisabled = [CCSprite spriteWithFile:@"contine_disabled.png"];
        contiuneItem = [CCMenuItemSprite itemWithNormalSprite:contiuneNormal
                                selectedSprite:continueSelected 
                                disabledSprite:continueDisabled                                     
                                target:self selector:@selector(closeTip:)];
        
        CCMenu* menu = [CCMenu menuWithItems:contiuneItem,nil];
        if(isLevelUp) {
            contiuneItem.position = ccp(isPad?140:56,-134-iPhone5offsetHalf);
        }else{
            
            CCTexture2D *restartTexture = [[GameResource shared] sharedRestartTexture];
            
            CCSprite* restartNormal = [CCSprite spriteWithTexture:restartTexture];
            CCSprite* restartSelected = [CCSprite spriteWithTexture:restartTexture];
            CCMenuItemSprite* restartItem = [CCMenuItemSprite itemWithNormalSprite:restartNormal selectedSprite:restartSelected target:self selector:@selector(restart:)];
            restartItem.position = ccp(isPad?-100:-56,-132-iPhone5offsetHalf);
            [menu addChild:restartItem];
            contiuneItem.position = ccp(isPad?140:56,-132-iPhone5offsetHalf);
            [contiuneItem setIsEnabled:NO];
        }
        
        if(isPad) menu.position = CGPointMake(menu.position.x, 350);
        [self addChild:menu];
        
        // 统计各种水果的得分情况
        for (int i =0; i<9; i++) {
            
            CCSprite *sprite =  [CCSprite spriteWithFile:[NSString stringWithFormat:@"fruit0%ds.png",i+1]];
            
            int x = (isPad?120:40)+sprite.contentSize.width+i%3*(isPad?160:80);
            int y = isPad?572-i/3*72:286-i/3*36;
            
            sprite.position = ccp(x,y);
            [self addChild:sprite];
            [spriteArray addObject:sprite];
            
            CCLabelTTF *xxx = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"]
                                                 fontName:@"Arial" fontSize:isPad?44:22];
            xxx.position =  ccp(x+(isPad?50:30),y);
            xxx.color = ccc3(255,255,255);
            [self addChild:xxx];
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",0] 
                                                   fontName:@"Arial" fontSize:isPad?44:22];
            label.position =  ccp(x+(isPad?80:50),y);
            label.color = ccc3(255,255,255);
            [self addChild:label];
            [labelArray addObject:label];
        }
        
        int offsetX = isPad?100:50;
        int offsetY = isPad?378:172;
        
        CCTexture2D *starbgTexture = [[GameResource shared] sharedStarBgTexture];
        CCTexture2D *coinTexture = [[GameResource shared] sharedCoinTexture];

        for (int i=0; i<[[[GameResource shared] itemImageArray] count]; i++) {
            
            CCSprite *starBg = [CCSpriteUtils createTexture2D:starbgTexture location:ccp((isPad?102:22)+i*offsetX,offsetY+38)];
            starBg.rotation = i*30;
            [self addChild:starBg];
            
            CCAction *action = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:90]];
            [starBg runAction:action];
            
            Item *unknownLevel = [Item spriteWithFile:[[[GameResource shared] itemImageArray] objectAtIndex:i]];
            unknownLevel.position = ccp((isPad?180:60)+i*offsetX,isPad?-40+offsetY:offsetY);
            unknownLevel.scale = 0.7;
            unknownLevel.style = i;
            [self addChild:unknownLevel];
            [itemSrpiteArray addObject:unknownLevel];
            
            CCSprite *coin = [CCSpriteUtils createTexture2D:coinTexture location:ccp(0,0)];
            coin.scale =0.6;
            [unknownLevel addChild:coin];
            
            NSString *str = [[[GameResource shared] itemPayArray] objectAtIndex:i];
            int price = [str intValue]+(gameLayer.fruitCore.level-1)*50;
            CCLabelTTF *pay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%d",price] 
                                                 fontName:@"Arial" fontSize:isPad?24:12];
            pay.position = ccp(isPad?20:15,isPad?-36:-18);
            pay.anchorPoint = ccp(0,0.5);
            [unknownLevel addChild:pay];
            
            if(i==3){
                helper = [CCSprite spriteWithFile:@"helper.png"];
                helper.position = ccpAdd(coin.position,ccp(isPad?32:22,isPad?132:66));
                helper.flipY = -1;
                [unknownLevel addChild:helper];

                id moveActionA = [CCMoveBy actionWithDuration:0.1 position:ccp(0,-3)];
                id moveActionB = [CCMoveBy actionWithDuration:0.1 position:ccp(0,3)];
                [helper runAction:[CCRepeatForever actionWithAction:[CCSequence actions:moveActionA,moveActionB, nil]]];
            }
        }
        
        int x = isPad?180:60;
        int y = isPad?650:316;
        ccColor3B textColor= ccc3(255,246,0);
        
        CCSprite *coin = [CCSpriteUtils createTexture2D:coinTexture location:ccp(x,y+20)];
        coin.scale =0.8;
        [self addChild:coin];

        CCLabelTTF *scoreLabelBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"] 
                                                      fontName:@"Arial" fontSize:isPad?40:20];
        scoreLabelBg.position =  ccp( x+(isPad?40:30) , y+(isPad?-15:0));
        scoreLabelBg.color=textColor;
        [self addChild: scoreLabelBg];
        
        gameScoreValue = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",0] 
                                            fontName:@"Arial" fontSize:isPad?36:18];
        gameScoreValue.position =  ccp(x+(isPad?90:60),y+(isPad?-15:0));
        gameScoreValue.color = textColor;
        [self addChild:gameScoreValue];
        
        CCSprite *highscore = [CCSpriteUtils createCCSprite:@"wplustop.png" location:ccp(x+(isPad?186:116),y+20)];
        highscore.scale = 0.7;
        [self addChild:highscore];
        
        CCLabelTTF *highscoreBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"] 
                                                     fontName:@"Arial" fontSize:isPad?40:20];
        highscoreBg.position =  ccp( x+(isPad?266:160) , y+(isPad?-15:0) );
        highscoreBg.color=textColor;
        [self addChild: highscoreBg];
        
        //获取最高分
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *highScoreDefault = [ud objectForKey:@"highScore"];

        if (highScoreDefault==NULL || highScoreDefault==nil) {
            highScoreDefault = @"0";
        }
        
        highScoreValue = [CCLabelTTF labelWithString:highScoreDefault
                                            fontName:@"Arial" fontSize:isPad?36:18];
        highScoreValue.position =  ccp(x+(isPad?326:192),y+(isPad?-15:0));
        highScoreValue.color = textColor;
        [self addChild:highScoreValue];
        
        //设置最高分
        if (gameLayer.fruitCore.score>[highScoreDefault intValue]) {
            [ud setValue:[NSString stringWithFormat:@"%lld",gameLayer.fruitCore.score]
                  forKey:@"highScore"];
        }
        
//        GCHelper *gcHelper = [GCHelper sharedInstance];
//        [gcHelper reportScore:gameLayer.fruitCore.score forCategory:GAMECENTERCATEGORY];
//
//        NSString *achievement;
//        float curPercent = 0.0f;
//        //NSLog(@"score:%d",gameLayer.fruitCore.score>=ACHIEVEMENT1?1:0);
//
//        if(gameLayer.fruitCore.score>0){
//            achievement = FRUITSTORMACHIA;
//            curPercent = gameLayer.fruitCore.score/ACHIEVEMENT1;
//            [gcHelper reportAchievementIdentifier:achievement percentComplete:curPercent*100];
//        }
//        
//        if (gameLayer.fruitCore.score>ACHIEVEMENT1) {
//            achievement = FRUITSTORMACHIB;
//            curPercent = gameLayer.fruitCore.score/ACHIEVEMENT2;
//            [gcHelper reportAchievementIdentifier:achievement percentComplete:curPercent*100];
//        }
//        
//        if (gameLayer.fruitCore.score>ACHIEVEMENT2) {
//            achievement = FRUITSTORMACHIC;
//            curPercent = gameLayer.fruitCore.score/ACHIEVEMENT3;
//            [gcHelper reportAchievementIdentifier:achievement percentComplete:curPercent*100];
//        }
        
        // 得分动画
        [self calcScore:gameLayer.fruitCore.scoreArray score:gameLayer.fruitCore.score];
        
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
    if(!gamelayer.fruitCore.autoMoveComplete) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint currentPosition = [[CCDirector sharedDirector] convertToGL:location];
    int index = [CommUtils SomethingWasTouched:itemSrpiteArray pos:currentPosition];
    if (index!=-1) {
        Item *sprite = [itemSrpiteArray objectAtIndex:index];
        int itemScore = [[[[GameResource shared] itemPayArray] objectAtIndex:index] intValue];
        if(gameScore>itemScore){
            gameScore -= itemScore;
            [gameScoreValue setString:[NSString stringWithFormat:@"%d",gameScore]];
            
            [gamelayer.fruitCore addItem:index];
            if(index==3){
                int timer = [[gamelayer.timeText string] intValue];
                if(timer<=0) {
                    [[gamelayer fruitCore] autoUseItem:3];
                    [gamelayer addTime:GAMETIME/2];
                }
                [contiuneItem setIsEnabled:YES];
                [helper removeFromParentAndCleanup:YES];
            }
            gamelayer.fruitCore.score -= itemScore;
            
            [gamelayer.fruitCore.scoreValue setString:[NSString stringWithFormat:@"%lld",gamelayer.fruitCore.score]];
            [gamelayer.fruitCore.scoreValueBg setString:[NSString stringWithFormat:@"%lld",gamelayer.fruitCore.score]];
            sprite.visible = false;
            
            [self performSelector:@selector(reshow:)
                       withObject:sprite afterDelay:0.5];
        }else{
            CCSprite *sprite = [itemSrpiteArray objectAtIndex:index];
            id moveActionA = [CCMoveBy actionWithDuration:0.1 position:ccp(-3,0)];
            id moveActionB = [CCMoveBy actionWithDuration:0.1 position:ccp(3,0)];
            [sprite runAction:[CCRepeat actionWithAction:[CCSequence actions:moveActionA,moveActionB, nil]
                                                   times:2]];
        }
    }
}

- (void) reshow:(CCSprite *)sprite {
    sprite.visible = true;
}

-(int)getMaxScore:(NSMutableArray *)array{
    int max = 0;
     for (int i=0; i<[array count]; i++) {
         
         int score = [[array objectAtIndex:i] intValue];
         if(max<score){
             max = score;
         }
     }
    return max;
}

-(void)calcScore:(NSMutableArray *)array score:(int)score{
    
    scoreArray = array;
    gameScore = score;
    
    //NSLog(@"calcScore");
    //if ([fruitCore.scoreArray count]>0) maxScore = [self getMaxScore:fruitCore.scoreArray];
    
    //if(gameScore==0) return;
    
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
    if(gamelayer.soundCanPlay)
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"calscore.caf"];
    
    time = 0;
    addScore = 0;
    if(gameScore != 0) {
        addScore = gameScore / 100;
        addScore = addScore>=1?addScore:1;
        maxFruit = [self getMaxScore:array];
    }
    //NSLog(@"maxFruit:%d",maxFruit);
    
//    [self performSelector:@selector(beginScoreAnimal)
//                        withObject:nil afterDelay:0.2];
    [self beginScoreAnimal];
    
}
     
-(void) beginScoreAnimal {
    [self schedule:@selector(resultScoreAnimal:) interval:0.02];
}

-(void)resultScoreAnimal:(ccTime)dt {

    int curGameScore = [[gameScoreValue string] intValue];
    curGameScore+=addScore;
    
    [gameScoreValue setString:[NSString stringWithFormat:@"%d",curGameScore]];

    if (scoreArray==nil || [scoreArray count]==0 || curGameScore>=gameScore-addScore) { 
        [self unschedule:@selector(resultScoreAnimal:)];
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
    
    
    time++;
    //NSLog(@"timer:%d",time);
    if(maxFruit>0 || time<=maxFruit) {
       
        for (int i=0; i<[labelArray count]; i++) {
            CCLabelTTF *label = [labelArray objectAtIndex:i];
            int curScore = [[label string] intValue];
            int fruitScore = [[scoreArray objectAtIndex:i] intValue];
            if (curScore<fruitScore) {
                curScore++;
                [label setString:[NSString stringWithFormat:@"%d",curScore]];
            }
        }
        
    }
}

-(void) review:(id)sender {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=464566287"]];
}

- (void)closeTip:(id)sender{
	CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    
    [[BannerAdViewController sharedInstance] resetMainViewBanner];
    
    GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
    [gameLayer nextLevel:[NSNumber numberWithInt:isLevelUp?1:0]];
    
    //[scene removeChildByTag:1 cleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

-(void)restart:(id)sender {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    
    [[BannerAdViewController sharedInstance] resetMainViewBanner];
    
    GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
    [gameLayer restart:1];
    
    //[scene removeChildByTag:1 cleanup:YES];
    [self removeFromParentAndCleanup:YES];
}

@end
