//
//  DropFruitLayer.m
//  iFruit
//
//  Created by mac on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DropFruitLayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FullAdViewController.h"
#import "AlertLayer.h"

@implementation DropFruitLayer
@synthesize dropFruitArray;
@synthesize bear = _bear;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;
@synthesize play;
@synthesize multiple;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DropFruitLayer *layer = [DropFruitLayer node];
    
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
        self.accelerometerEnabled = YES; //开启加速计
        
        int x = 220;
        //int offsetX = isPad?10:2;
        int y = isPad?800:372;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
 
        if(USEAD){
            BannerAdViewController *controller = [BannerAdViewController sharedInstance];
            [controller setLocation:CGPointMake(0, 0)];
            //[[[CCDirector sharedDirector] openGLView] addSubview : controller.view];
        }
        
        CCSprite *spriteBg = [CCSpriteUtils createCCSprite:DROPFRUIT_BG location:ccp(0,size.height)];
        [self addChild:spriteBg];
        
//        CCLabelTTF *labelText = [CCLabelTTF labelWithString:@"海 底 捞 月" fontName:@"Marker Felt" fontSize:56];
//        labelText.position =  ccp(160, 320);
//        labelText.color=ccc3(255, 255, 255);
//        labelText.opacity = 30;
//        [self addChild:labelText];
        
        CCMenuItemImage *pauseItem = [CCMenuItemImage itemWithNormalImage:@"pause.png"
                                                              selectedImage:@"pause_selected.png"];
        CCMenuItemImage *playItem = [CCMenuItemImage itemWithNormalImage:@"play.png"
                                                               selectedImage:@"play_selected.png"]; 
        
        play = [CCMenuItemToggle itemWithTarget:self
                                        selector:@selector(pause:) items:pauseItem, playItem, nil];
        
        CCSprite* hintNormal = [CCSprite spriteWithFile:@"goback.png"];
        CCSprite* hintSelected = [CCSprite spriteWithFile:@"goback.png"];
        CCMenuItemSprite* goback = [CCMenuItemSprite itemWithNormalSprite:hintNormal selectedSprite:hintSelected
                                                                  target:self selector:@selector(backgame:)];
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:play,goback,nil];
        menu.position = CGPointMake(isPad?90:56, y);
        [self addChild:menu];
        // 把菜单项排列起来
        [menu alignItemsHorizontallyWithPadding:10];
        
        
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tortoise.plist"];
        
        // Create a sprite sheet with the Happy Bear images
        //CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"tortoise.png"];
        //[self addChild:spriteSheet];
    
        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 4; ++i) {
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:isPad?@"tortoise0%d.png":@"tortoise0%d.png", i]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        
        // Create a sprite for our bear
        self.bear = [CCSprite spriteWithSpriteFrameName:isPad?@"tortoise01.png":@"tortoise01.png"];
        _bear.position = ccp(160,50);
        bearIsLive = true;
        //if(!isRetina) self.bear.scale = 0.5;
        
        self.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim
                                                             ]];
        //[_bear runAction:_walkAction];
        //[spriteSheet addChild:_bear];
        [self addChild:_bear];
        
//        id sprite = [batch getChildByTag:1];
//        [[CCActionManager sharedManager] resumeTarget:sprite];
        
//        CCAnimation* animation = [[CCAnimation alloc] init];
//        for( int i=1;i<5;i++)
//        {
//            [animation addFrameWithFilename: [NSString stringWithFormat:@"tortoise0%d.png", i]];
//        }
//        [player runAction:animation];
        
//        lifeBg = [CCSprite spriteWithFile:@"life_bg.png"];
//        life = [CCSprite spriteWithFile:@"life.png"];
//        [self addChild:lifeBg];
//        [self addChild:life];
//        lifeBg.position = ccp(_bear.position.x+lifeY,_bear.position.y);
//        life.position = ccp(_bear.position.x+lifeY,_bear.position.y);
//        life.scaleX = 60;
//        life.anchorPoint = ccp(0,0.5);
//        lifeBg.anchorPoint = ccp(0,0.5);
        
        _score = 0;
        isTouch = false;
        _playerVelocity = ccp(_bear.position.x,_bear.position.y);
        //_bearPerSecY = _bear.position.y;
        dropFruitArray  = [[NSMutableArray alloc] init];
        
        CCSprite *coin = [CCSpriteUtils createCCSprite:@"coin.png" location:ccp(202,y+18)];
        [self addChild:coin];
        
        ccColor3B bgcolor = ccc3(255, 168, 0);
        ccColor3B textcolor = ccc3(255, 246, 0);

        CCLabelTTF *scoreLabelBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"] 
                                                      fontName:@"Arial" fontSize:isPad?44:22];
        scoreLabelBg.position =  ccp( x+(isPad?16:0)+scoreLabelBg.contentSize.width/2 , y+10-scoreLabelBg.contentSize.height/2 );
        scoreLabelBg.color=bgcolor;
        [self addChild: scoreLabelBg];
        
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"] 
                                                    fontName:@"Arial" fontSize:isPad?44:22];
        scoreLabel.position =  ccp( x+(isPad?18:2)+scoreLabel.contentSize.width/2 , y+11-scoreLabel.contentSize.height/2 );
        scoreLabel.color=textcolor;
        [self addChild: scoreLabel];
        
        CCDirector *director = [CCDirector sharedDirector];
        CCScene *scene = [director runningScene];
        GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
        
        _score = gameLayer.fruitCore.score;
        scoreValueBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_score] 
                                          fontName:@"Arial" fontSize:isPad?48:24];
        scoreValueBg.position =  ccp( x+(isPad?42:12)+scoreValueBg.contentSize.width/2 , y+13-scoreValueBg.contentSize.height/2 );
        scoreValueBg.color=ccc3(255, 168, 0);
        scoreValueBg.anchorPoint = CGPointMake(0, 0.5);
        [self addChild: scoreValueBg];
        
        scoreValue = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_score] 
                                        fontName:@"Arial" fontSize:isPad?48:24];
        scoreValue.position =  ccp( x+(isPad?40:10)+scoreValue.contentSize.width/2 , y+12-scoreValue.contentSize.height/2 );
        scoreValue.color=ccc3(255, 246, 0);
        scoreValue.anchorPoint = CGPointMake(0, 0.5);
        [self addChild: scoreValue];
        
        fruitTextrueArray = [[NSMutableArray alloc] init];
        for (int i=1; i<=9; i++) {
            [fruitTextrueArray addObject:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"dropfruit0%d.png",i]]];
        }
        
        musicCanPlay = [CommUtils getGameValue:@"musicCanPlay"];
        soundCanPlay = [CommUtils getGameValue:@"soundCanPlay"];
        
        //播放背景音乐
        if(musicCanPlay==1)
        [SoundUtils playBackgroundMusic:@"dropfruit_bg.mp3" volume:1.0 flag:[CommUtils getGameValue:@"musicCanPlay"]];
        
        [self howToPlay];
        }
    return self;
}

- (void)howToPlay {
    AlertLayer *alertLayer = [AlertLayer node];
    alertLayer.type = DROPFRUIT_TIP;
    [self addChild:alertLayer];
}

- (void) startGameLogic {
    [self performSelector:@selector(gameStart) withObject:nil afterDelay:1];
}

- (void)pause:(id)sender{
    CCDirector *director = [CCDirector sharedDirector];
    if([director isPaused]) {
        [director resume];
        play.selectedIndex = 0;
    }else {
        [director pause];
        play.selectedIndex = 1;
    }
    
//    FullAdViewController *controller = [FullAdViewController sharedInstance];
//    [controller interstitial];
}
- (void)backgame:(id)sender{
    [self unschedule:@selector(dropFruit:)];
    [self closeTip:nil data:nil];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
//    #define kFilteringFactor 0.1
//    #define kRestAccelX -0.0 //-0.6
//    #define kShipMaxPointsPerSec (winSize.height*0.5) 
//    #define kMaxDiffX 0.2
//    
//    UIAccelerationValue rollingX /**, rollingY, rollingZ**/;
//    
//    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor)); 
//    //rollingY = (acceleration.y * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor)); 
//    //rollingZ = (acceleration.z * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
//    
//    float accelX = acceleration.x - rollingX;
//    //float accelY = acceleration.y - rollingY;
//    //float accelZ = acceleration.z - rollingZ;
//    
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    
//    float accelDiff = accelX - kRestAccelX;
//    float accelFraction = accelDiff / kMaxDiffX;
//    float pointsPerSec = kShipMaxPointsPerSec * accelFraction;
//    
//    _bearPerSecX = pointsPerSec;
    
    float deceleration = 0.4f;//控制减速的速率(值越低=可以更快的改变方向)
    float sensitivity = 10.0f;//加速计敏感度的值越大,主角精灵对加速计的输入就越敏感
    float maxVelocity =100; //最大速度值
    
    // 基于当前加速计的加速度调整速度
    _playerVelocity.x = _playerVelocity.x*deceleration+acceleration.x*sensitivity;
//    _playerVelocity.y = _playerVelocity.y*deceleration+acceleration.y*sensitivity;
    
//    if(CGPointEqualToPoint(_startVelocity, CGPointZero)){
//        NSLog(@"aaaaa");
//        _startVelocity.x = _playerVelocity.x;
//        _startVelocity.y = _playerVelocity.y;
//    }
//    else{
//        _playerVelocity.x -=_startVelocity.x;
//        _playerVelocity.y -=_startVelocity.y;
//    }
    
    
    // 我们必须在两个方向上都限制主角精灵的最大速度值
    if(_playerVelocity.x > maxVelocity){
        _playerVelocity.x = maxVelocity;
    }else if(_playerVelocity.x < -maxVelocity){
        _playerVelocity.x =-maxVelocity;
    }
//    if(_playerVelocity.y > maxVelocity){
//        _playerVelocity.y = maxVelocity;
//    }else if(_playerVelocity.y < -maxVelocity){
//        _playerVelocity.y =-maxVelocity;
//    }
    
    if(acceleration.z>0){
        _playerVelocity.x *=-1;
    }
}

- (void)closeTip:(id)sender data:(NSObject *)param{
	CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    [scene removeChildByTag:9 cleanup:YES];
    
    
    if(USEAD){
        if(iPhone5 || isPad){
            [[BannerAdViewController sharedInstance] setLocation:CGPointMake(0, 0)];
        }else{
            CGSize size = [[CCDirector sharedDirector] winSize];
            [[BannerAdViewController sharedInstance] setLocation:CGPointMake(size.width, 0)];
        }
    }

    //ad close
    GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
    [gameLayer.fruitCore calcScore:[NSNumber numberWithInt:_score-gameLayer.fruitCore.score]];
    [gameLayer playGame:nil];
    [gameLayer startGameLogic];
    NSLog(@"closeTip");
}

-(void) gameStart {
    [self scheduleUpdate];
    [_bear runAction:_walkAction];
    [self schedule:@selector(dropFruit:) interval:0.2]; 
}

-(void) update:(ccTime)dt {
    if(isTouch) return;
    
    float maxX = 320;
    float minX = 0;
    
//    float maxY = 100;
//    float minY = 50;
    
    float newX = _bear.position.x + _playerVelocity.x;
    newX = MIN(MAX(newX, minX), maxX);
    
//    NSLog(@"bearPerSecY:%f",_bearPerSecY);
//    float newY = _bear.position.y;
//    if(_bearPerSecY>=1) newY=newY-(_bearPerSecY*dt);
//    else newY = newY +(_bearPerSecY*dt);
//    
//    newY = MIN(MAX(newY, minY), maxY);
//    
//    NSLog(@"NEWY:%f",newY);
    
    if(bearIsLive){
        _bear.position = ccp(newX, _bear.position.y);
        [self moveLife];
    }
}

-(void) dropFruit:(id)sender {
    
    if ([dropFruitArray count]<=120) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        int style = [CommUtils getRandom:1 to:9];
        int random = [CommUtils getRandom:0 to:size.width]; //生成水果的位置
        double time = [CommUtils getDoubleRandom:1 to:1.8]; //水果掉落的速度
        Item *sprite = [Item spriteWithTexture:[fruitTextrueArray objectAtIndex:style-1]];
        sprite.style = style;
        [sprite SetCanTrack:YES];
        [dropFruitArray addObject:sprite];
        sprite.position = ccp(random,size.height);
        id moveAction = [CCMoveTo actionWithDuration:time position:ccp(random,0)];
        [sprite runAction:moveAction]; //执行该动画
        [self addChild:sprite];
    }
    
    int liveNum = 0;
    for(int i=0; i<[dropFruitArray count]; i++){
        Item *item = (Item*)[dropFruitArray objectAtIndex:i];
      
        if (item!=nil && [item GetCanTrack] && CGRectIntersectsRect([item rect], [self getTortoiseRect])) {
            //if (CGRectContainsRect([item rect], [_bear rect])) {
            //[dropFruitArray removeObject:item];
            [item SetCanTrack:NO];
            [item removeFromParentAndCleanup:YES];
            
            if(soundCanPlay==1){
                if(item.style==9)
                    [SoundUtils playEffect:@"explode.caf" volume:0.8];
                else
                    [SoundUtils playEffect:@"getfruit.caf" volume:0.5];
            }
            
            NSLog(@"item.style:%d",item.style);
            if (item.style == 9) {
                CCSprite *node = [FrameAnimHelper animWithFilename:self filename:@"explode.png" 
                                                                  numFrames:23 plistFilename:@"explode.plist" spriteName:@"explode" spriteTag:5 repeatNum:1];
                node.position = item.position;
                node.scale = 2;
                
                [_bear runAction:[CCFadeIn actionWithDuration:2]];
                liveNum=0;
                bearIsLive = false;
                break;
            }else{
                _score +=DROPFRUITSCORESCALE*multiple;
                [scoreValue setString:[NSString stringWithFormat:@"%d",_score]];
                [scoreValueBg setString:[NSString stringWithFormat:@"%d",_score]];
                
                NumUtils *util = [[NumUtils alloc] initLayer:self];
                //得分动画
                [util drawScore:self beginPoint:_bear.position endPoint:ccp(265,372)
                            num:[NSString stringWithFormat:@"%d",DROPFRUITSCORESCALE*multiple]];
            }
        }
        if (item.position.y<=50){
            [item SetCanTrack:NO];
        }
        if ([item GetCanTrack]==YES)
            liveNum++;
    }

    if(liveNum==0) {
        //AudioServicesPlaySystemSound (kSystemSoundID_Vibrate); //振动
        [self unschedule:@selector(dropFruit:)];
        [self performSelector:@selector(closeTip:data:) withObject:nil afterDelay:1];
    }
}

- (CGRect) getTortoiseRect {
    float w = [_bear contentSize].width;
	float h = [_bear contentSize].height;
	CGPoint point = CGPointMake([_bear position].x - (w/2), [_bear position].y - (h/2));
    return CGRectMake(point.x,point.y,w,h);
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint pt = [[CCDirector sharedDirector] convertToGL:location];

    CCDirector *director = [CCDirector sharedDirector];
    if([director isPaused]) { [director resume]; play.selectedIndex = 0;}

    if(CGRectContainsPoint([self getTortoiseRect], pt)){
        isTouch = true;
        if(![_bear isRunning]){
            [self.bear runAction:_walkAction];
        }
    }
}


- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isTouch) return; 

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    CGPoint pt = [[CCDirector sharedDirector] convertToGL:location];
    
    if(bearIsLive) {
        _bear.position = ccp(pt.x,_bear.position.y);
        [self moveLife];
    }
}

- (void)moveLife {
//    lifeBg.position = ccp(_bear.position.x+lifeY,_bear.position.y);
//    life.position = ccp(_bear.position.x+lifeY,_bear.position.y); 
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouch = false;
    //[self.bear stopAction:_walkAction];
}

-(void) dealloc {
    [dropFruitArray release];
    [_bear release];
    [_walkAction release];
    [_moveAction release];
    [super dealloc];
}

@end
