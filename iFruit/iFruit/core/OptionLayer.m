//
//  OptionLayer.m
//  iFruit
//
//  Created by mac on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OptionLayer.h"
#import "CommUtils.h"
#import "GCHelper.h"
#import "SceneManager.h"
#import "EarnLayer.h"
#import "GameResource.h"
#import "BannerAdViewController.h"
#import "FullAdViewController.h"
#import "AlertLayer.h"

@implementation OptionLayer

- (id) init
{
	self= [super initWithColor:ccc4(0, 0, 0, 180)];
	if (self)
	{
        self.touchEnabled = YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        if(USEAD){
            BannerAdViewController *controller = [BannerAdViewController sharedInstance];
            [controller setLocation:CGPointMake(0, size.height-controller.adView.frame.size.height)];
            //[[[CCDirector sharedDirector] openGLView] addSubview : controller.view];
        }
        
//        if(USEAD){
//            FullAdViewController *controller = [FullAdViewController sharedInstance];
//            //controller.view.frame = CGRectMake(0, size.height/2, 320, 50);
//            [[[CCDirector sharedDirector] openGLView] addSubview :controller.view];
//        }

        CCSprite *tipbg = [CCSprite spriteWithFile:@"option_bg.png"];
        tipbg.position = ccp(size.width/2,isPad?size.height/2:240);
        [self addChild:tipbg];
        
        
        // 用图像创建，可以用CCMenuItemImage或者CCSprite（如下），后者的优点在于你可以用同一幅图，仅靠着不同色来达到高亮效果
        CCSprite* normal = [CCSprite spriteWithFile:@"close_button.png"];
        CCSprite* selected = [CCSprite spriteWithFile:@"close_button.png"];
        CCMenuItemSprite *closeItem = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected
                                                                 target:self selector:@selector(closeTip:)];
        closeItem.position = [CCSpriteUtils getPosition:(CCSprite *)closeItem location:ccp(isPad?260:128,isPad?80:38-iPhone5offsetHalf)];
        
        
        CCSprite* normal5 = [CCSprite spriteWithFile:@"game_restart.png"];
        CCSprite* selected5 = [CCSprite spriteWithFile:@"game_restart_selected.png"];
        CCMenuItemSprite* restartItem = [CCMenuItemSprite itemWithNormalSprite:normal5 selectedSprite:selected5
                                                                        target:self selector:@selector(restart:)];
        restartItem.position = ccp(isPad?-225:-120, 0-iPhone5offsetHalf);
        
        
        CCMenuItemImage *howToPlayOnItem = [CCMenuItemImage itemWithNormalImage:@"howtoplay.png"
                                                                  selectedImage:@"howtoplay.png"];
        CCMenuItemImage *howToPlayOffItem = [CCMenuItemImage itemWithNormalImage:@"howtoplay.png"
                                                                   selectedImage:@"howtoplay.png"];
        
        CCMenuItemToggle* howToPlayItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(howToPlayControll:) items:howToPlayOnItem, howToPlayOffItem, nil];
        
        howToPlayItem.selectedIndex =  [CommUtils getGameValue:@"howToPlay"]==1?0:1;
        howToPlayItem.position = ccp(isPad?-145:-75,0-iPhone5offsetHalf);
        
        
        
        CCScene *scene = [[CCDirector sharedDirector] runningScene];
        GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
        
        CCMenuItemImage *musicOnItem = [CCMenuItemImage itemWithNormalImage:@"music_on.png"
                                                             selectedImage:@"music_on.png"];
        CCMenuItemImage *musicOffItem = [CCMenuItemImage itemWithNormalImage:@"music_off.png"
                                                              selectedImage:@"music_off.png"]; 
                                                         
        CCMenuItemToggle* musicItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(music:) items:musicOnItem, musicOffItem, nil];
        
        //　当前状态是否播放背景音乐
        musicItem.selectedIndex = gameLayer.musicCanPlay==1?0:1;
        musicItem.position = ccp(isPad?-65:-30, 0-iPhone5offsetHalf);
        
        
        CCMenuItemImage *soundOnItem = [CCMenuItemImage itemWithNormalImage:@"sound_on.png"
                                                              selectedImage:@"sound_on.png"];
        CCMenuItemImage *soundOffItem = [CCMenuItemImage itemWithNormalImage:@"sound_off.png"
                                                               selectedImage:@"sound_off.png"]; 
        
        CCMenuItemToggle* soundItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(sound:) items:soundOnItem, soundOffItem, nil];

        soundItem.selectedIndex =  gameLayer.soundCanPlay==1?0:1;
        soundItem.position = ccp(15, 0-iPhone5offsetHalf);
        
        
//        CCSprite* normal6 = [CCSprite spriteWithFile:@"topscore_button.png"];
//        CCSprite* selected6 = [CCSprite spriteWithFile:@"topscore_button_selected.png"];
//        CCMenuItemSprite* gameCenterItem = [CCMenuItemSprite itemWithNormalSprite:normal6 selectedSprite:selected6
//                                                                        target:self selector:@selector(openGameCenter:)];
//        gameCenterItem.position = ccp(60, 0-iPhone5offsetHalf);
//        
//        CCSprite* normal7 = [CCSprite spriteWithFile:@"achievement_button.png"];
//        CCSprite* selected7 = [CCSprite spriteWithFile:@"achievement_button_selected.png"];
//        CCMenuItemSprite* achievementItem = [CCMenuItemSprite itemWithNormalSprite:normal7 selectedSprite:selected7
//                                                                           target:self selector:@selector(showAchievements:)];
//        achievementItem.position = ccp(105, 0-iPhone5offsetHalf);
        int copyRightY = isPad?430:200;
        int hightScoreY = isPad?604:284;
        
        CCSprite *copyRightBg = [CCSprite spriteWithFile:@"copyright_bg.png"];
        copyRightBg.position = ccp(isPad?400:size.width/2+18,copyRightY);
        [self addChild:copyRightBg];
        CCLabelTTF *cocos2dCopyRight = [CCLabelTTF labelWithString:
                                        @"Powered by cocos2d." fontName:@"Arial" fontSize:isPad?24:12];
        cocos2dCopyRight.position = ccp(isPad?400:200, copyRightY);
        [self addChild:cocos2dCopyRight];
        
        
        CCSprite *highscoreBg = [CCSprite spriteWithFile:@"highscore_bg.png"];
        highscoreBg.position = ccp(size.width/2,hightScoreY);
        [self addChild:highscoreBg];
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:closeItem,restartItem,howToPlayItem,
                                    musicItem,soundItem,/*gameCenterItem,achievementItem,*/nil];
        
        //if(isPad) [menu alignItemsHorizontallyWithPadding:20];
        [self addChild:menu];
        
        CCLabelTTF *hignScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score:"] 
                                                        fontName:@"Arial" fontSize:isPad?44:22];
        hignScoreLabel.position =  ccp(isPad?300:134,hightScoreY);
        hignScoreLabel.color = ccc3(255,255,255);
        [self addChild:hignScoreLabel];
        
        //获取最高分
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *highScoreDefault = [ud objectForKey:@"highScore"];
        
        if (highScoreDefault==NULL || highScoreDefault==nil) {
            highScoreDefault = @"0";
        }
        
        CCLabelTTF *highScoreValue = [CCLabelTTF labelWithString:highScoreDefault
                                                        fontName:@"Arial" fontSize:isPad?44:22];
        highScoreValue.position =  ccp(isPad?470:232,hightScoreY);
        highScoreValue.color = ccc3(255,246,0);
        [self addChild:highScoreValue];
        
        GameResource *res = [GameResource shared];
        int offsetX = isPad?100:50;
        int offsetY = isPad?300:146;
        
        CCTexture2D *starbgTexture = [[GameResource shared] sharedStarBgTexture];
        CCTexture2D *coinTexture = [[GameResource shared] sharedCoinTexture];
        
        itemSrpiteArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[[res itemImageArray] count]; i++) {
            
            CCSprite *starBg = [CCSpriteUtils createTexture2D:starbgTexture location:ccp((isPad?102:22)+i*offsetX,offsetY+38)];
            starBg.rotation = i*30;
            [self addChild:starBg];
            
            CCAction *action = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:1 angle:90]];
            [starBg runAction:action];
            
            Item *unknownLevel = [Item spriteWithFile:[[res itemImageArray] objectAtIndex:i]];
            unknownLevel.position = ccp((isPad?180:60)+i*offsetX,isPad?-40+offsetY:offsetY);
            unknownLevel.scale = 0.7;
            unknownLevel.style = i;
            [self addChild:unknownLevel];
            [itemSrpiteArray addObject:unknownLevel];
            //[unknownLevel release];
            
            CCSprite *coin = [CCSpriteUtils createTexture2D:coinTexture location:ccp(0,0)];
            coin.scale =0.6;
            [unknownLevel addChild:coin];
            
            NSString *str = [[res itemPayArray] objectAtIndex:i];
            int price = [str intValue]+(gameLayer.fruitCore.level-1)*50;
            CCLabelTTF *pay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%d",price] 
                                                 fontName:@"Arial" fontSize:isPad?24:12];
            pay.position = ccp(15,-18);
            pay.anchorPoint = ccp(0,0.5);
            [unknownLevel addChild:pay];
        }

    }
    return self;
}

             -(void)wp_resultForInvited:(id)sender{
                 NSLog(@"resultInvited");
                 CCLabelTTF *text = [CCLabelTTF labelWithString:
                    [NSString stringWithFormat:@"您目前已邀请%@个好友一起和你玩游戏!",[sender object]] 
                                                       fontName:@"Arial" fontSize:12];
                 text.position = ccp(224, 200);
                 [self addChild:text];
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
    NSLog(@"index:%d",index);
    if (index!=-1) {
        Item *sprite = [itemSrpiteArray objectAtIndex:index];
        int itemScore = [[[[GameResource shared] itemPayArray] objectAtIndex:index] intValue];
        if(gamelayer.fruitCore.score>itemScore){
            [gamelayer.fruitCore addItem:index];
            gamelayer.fruitCore.score -= itemScore;
            
            [gamelayer.fruitCore.scoreValue setString:[NSString stringWithFormat:@"%lld",gamelayer.fruitCore.score]];
            [gamelayer.fruitCore.scoreValueBg setString:[NSString stringWithFormat:@"%lld",gamelayer.fruitCore.score]];
            sprite.visible = false;
            
            [self performSelector:@selector(reshow:)
                       withObject:sprite afterDelay:1];
        }else{
            CCSprite *sprite = [itemSrpiteArray objectAtIndex:index];
            id moveActionA = [CCMoveBy actionWithDuration:0.1 position:ccp(-3,0)];
            id moveActionB = [CCMoveBy actionWithDuration:0.1 position:ccp(3,0)];
            [sprite runAction:[CCRepeat actionWithAction:[CCSequence actions:moveActionA,moveActionB, nil]
                                                   times:3]];
        }
    }
}

- (void) reshow:(CCSprite *)sprite {
    sprite.visible = true;
}

-(void)openGameCenter:(id)sender
{
    gameCenterView = [[UIViewController alloc] init];
    gameCenterView.view = [[CCDirector sharedDirector] openGLView];
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) 
    {
        leaderboardController.category = GAMECENTERCATEGORY;
        leaderboardController.leaderboardDelegate = self; 
        [gameCenterView presentModalViewController: leaderboardController animated: YES];
    }
    [leaderboardController release];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController 
{
    [gameCenterView dismissModalViewControllerAnimated:YES];
    [gameCenterView release];
}

- (void) showAchievements:(id)sender
{
    gameCenterView = [[UIViewController alloc] init];
    gameCenterView.view = [[CCDirector sharedDirector] openGLView];
    
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != nil)
    {
        achievements.achievementDelegate = self;
        [gameCenterView presentModalViewController: achievements animated: YES];
    }
    [achievements release];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    [gameCenterView dismissModalViewControllerAnimated:YES];
    [gameCenterView release];
}

-(void) pushTip:(id)sender {
    
}

-(void) earn:(id)sender {
    [SceneManager pushScene:[EarnLayer node]];
}

-(void) review:(id)sender {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=464566287"]];
}

-(void) howToPlayControll:(id)sender {
    //int value = [CommUtils getGameValue:@"howToPlay"] == 1?0:1;
    //[CommUtils setGameValue:@"howToPlay" value:[NSNumber numberWithInt:value]];
    
    AlertLayer *alertLayer = [AlertLayer node];
    [self addChild:alertLayer];
}

-(void) closeTip:(id)sender {
    [self play:nil];
    
    [[BannerAdViewController sharedInstance] resetMainViewBanner];
}

-(void) play:(id)sender {
    CCDirector *director = [CCDirector sharedDirector];
    if([director isPaused]) [director resume];
    CCScene *scene = [director runningScene];
    [scene removeChildByTag:3 cleanup:FALSE];
    GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
    [gamelayer playGame:nil];
}
-(void) music:(id)sender {
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
    [gamelayer musicControll:nil];
}
-(void) sound:(id)sender {
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
    [gamelayer soundControll:nil];
}
-(void) goback:(id)sender {
    [SceneManager goMenu];
}
-(void) restart:(id)sender {
    if([[CCDirector sharedDirector] isPaused])
                [[CCDirector sharedDirector] resume];
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    [scene removeChildByTag:3 cleanup:FALSE];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[BannerAdViewController sharedInstance] setLocation:CGPointMake(size.width, 0)];
    
    GameLayer *gamelayer = (GameLayer *)[scene getChildByTag:0];
    [gamelayer restart:0];
}

-(void)dealloc{     
    [super dealloc];
}
@end
