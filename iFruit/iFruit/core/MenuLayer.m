//
//  SysMenu.m
//  G03
//
//  Created by Mac Admin on 15/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "GameResource.h"
#import "AlertLayer.h"
#import "GCHelper.h"

@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
	self = [super init];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    

    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    //[[GCHelper sharedInstance] authenticateLocalUser]; // GameCenter auth

    
    CCSprite *startBg = [CCSpriteUtils createCCSprite:START_BG location:ccp(0,size.height)];
    [self addChild:startBg];
    
    int offsetX = 45 , offsetY = 0;
    if(iPhone5) offsetY = 88;
    if(isPad) { offsetX= 145; offsetY =  320; }
    
    CCSprite *logo = [CCSpriteUtils createCCSprite:@"logo.png" location:ccp(offsetX,400+offsetY)];
    [self addChild:logo];
    
    logo.anchorPoint = ccp(0.5,0);
    
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    id moveAction = [CCMoveTo actionWithDuration:0.5 position:[CCSpriteUtils getPosition:logo location:ccp(offsetX,280+offsetY)]];
    [idArray addObject:moveAction];
    
    for (int i=5; i>0; i--) {
        id scaleSmallAction = [CCScaleTo actionWithDuration:0.1 scale:(1-i*0.1)];
        [idArray addObject:scaleSmallAction];
        id scaleBigAction = [CCScaleTo actionWithDuration:0.1 scale:1.0];
        [idArray addObject:scaleBigAction];
    }
    [logo runAction:[CCSequence actionWithArray:idArray]];
    [idArray release];
    
    // 用图像创建，可以用CCMenuItemImage或者CCSprite（如下），后者的优点在于你可以用同一幅图，仅靠着不同色来达到高亮效果
    CCSprite* normal = [CCSprite spriteWithFile:@"play_button.png"];
    CCSprite* selected = [CCSprite spriteWithFile:@"play_button_click.png"];
    CCMenuItemSprite* item = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected
                                                              target:self selector:@selector(onNewGame:)];
    item.position = ccp(0, -128);
    

    musicCanPlay = [CommUtils getGameValue:@"musicCanPlay"];
    soundCanPlay = [CommUtils getGameValue:@"soundCanPlay"];
    howToPlay = [CommUtils getGameValue:@"soundCanPlay"];
    
    [SoundUtils playBackgroundMusic:@"startmusic.mp3" volume:1.0 flag:YES];
    if(musicCanPlay==0)  [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    
    CCMenuItemImage *musicOnItem = [CCMenuItemImage itemWithNormalImage:@"music_on.png"
                                                          selectedImage:@"music_on.png"];
    CCMenuItemImage *musicOffItem = [CCMenuItemImage itemWithNormalImage:@"music_off.png"
                                                           selectedImage:@"music_off.png"]; 
    
    CCMenuItemToggle* musicItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicControll:) items:musicOnItem, musicOffItem, nil];
    
    //　当前状态是否播放背景音乐
    musicItem.selectedIndex = musicCanPlay==1?0:1;
    musicItem.position = ccp(isPad?84:54, isPad?0:-45);
    
    
    CCMenuItemImage *soundOnItem = [CCMenuItemImage itemWithNormalImage:@"sound_on.png"
                                                          selectedImage:@"sound_on.png"];
    CCMenuItemImage *soundOffItem = [CCMenuItemImage itemWithNormalImage:@"sound_off.png"
                                                           selectedImage:@"sound_off.png"]; 
    
    CCMenuItemToggle* soundItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(soundControll:) items:soundOnItem, soundOffItem, nil];
    
    soundItem.selectedIndex =  soundCanPlay==1?0:1;
    soundItem.position = ccp(isPad?150:90, isPad?0:-45);
    
    
//    CCMenuItemImage *howToPlayOnItem = [CCMenuItemImage itemFromNormalImage:@"howtoplay.png" 
//                                                          selectedImage:@"howtoplay.png"];
//    CCMenuItemImage *howToPlayOffItem = [CCMenuItemImage itemFromNormalImage:@"howtoplay.png"
//                                                           selectedImage:@"howtoplay.png"];
//    
//    CCMenuItemToggle* howToPlayItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(howToPlay:) items:howToPlayOnItem, howToPlayOffItem, nil];
//    
//    howToPlayItem.selectedIndex =  howToPlay==1?0:1;
//    howToPlayItem.position = ccp(0, -55);
    
    CCLabelTTF *readme = [CCLabelTTF labelWithString:@"拖动整行、整列或交换相邻水果,行列上三个相同水果即可消除,还可以使用道具哦～" dimensions:CGSizeMake(isPad?600:300,150) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:isPad?22:14];
    readme.position = ccp(size.width/2, isPad?0:-30);
    [self addChild:readme];
    
    // 创建菜单
    CCMenu* menu = [CCMenu menuWithItems: item,musicItem,soundItem, nil];
    if(isPad) {
        //[menu alignItemsHorizontallyWithPadding:20];
        menu.position = CGPointMake(size.width/2, 428);
    }else{
        menu.position = CGPointMake(size.width/2, size.height/2+offsetY/2);
    }

    [self addChild:menu];
    
    
    self.touchEnabled = YES;
    
	return self;
}

-(void) review:(id)sender {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=464566287"]];
}

-(void) task :(id)sender {
    //[SceneManager pushEarn];
}

- (void)onNewGame:(id)sender{

    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameLayer scene]]];
   //[SceneManager goPlay];
    //[SceneManager goBowFruit];
}

- (void)musicControll:(id)sender{
    if(musicCanPlay==1){
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        musicCanPlay = 0;
    }else{
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        musicCanPlay = 1;
    }
    [CommUtils setGameValue:@"musicCanPlay" value:[NSNumber numberWithInt:musicCanPlay]];
}
- (void)soundControll:(id)sender{
    if(soundCanPlay==1){
        soundCanPlay = 0;
    }else{
        soundCanPlay = 1;
    }
    [CommUtils setGameValue:@"soundCanPlay" value:[NSNumber numberWithInt:soundCanPlay]];
}

- (void)howToPlay:(id)sender {
    AlertLayer *alertLayer = [AlertLayer node];
    [self addChild:alertLayer];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"begin touch");
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"move touch");
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     NSLog(@"end touch");
}

@end
