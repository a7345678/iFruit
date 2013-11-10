//
//  DropFruitLayer.m
//  iFruit
//
//  Created by mac on 11-10-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BowFruitLayer.h"
#import "SimpleAudioEngine.h"
#import "SoundUtils.h"
#import "NumUtils.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FrameAnimHelper.h"
#import "GameLayer.h"

@implementation BowFruitLayer

-(void)spriteMoveFinished:(id)sender {
    
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
	
	if (sprite.tag == 1) { // target
		[_targets removeObject:sprite];
        Item *target = (Item *)sprite;
        if(target.style==9){
            CCSprite *node = [FrameAnimHelper animWithFilename:self filename:@"explode.png" 
                                                     numFrames:23 plistFilename:@"explode.plist" spriteName:@"explode" spriteTag:5 repeatNum:1];

            
            node.position = ccpAdd(target.position,ccp
                                   (45,0));
            node.scale = 2;
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            [self performSelector:@selector(backgame:) withObject:nil afterDelay:2];
        }
//		GameOverScene *gameOverScene = [GameOverScene node];
//		[gameOverScene.layer.label setString:@"You Lose :["];
//		[[CCDirector sharedDirector] replaceScene:gameOverScene];
		
	} else if (sprite.tag == 2) { // projectile
		[_projectiles removeObject:sprite];
	}
	
}

-(void)addTarget {
    int style = [CommUtils getRandom:1 to:9];
	Item *target = [Item spriteWithFile:[NSString stringWithFormat:@"dropfruit0%d.png",style]];
    target.style = style;
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 2.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	target.tag = 1;
	[_targets addObject:target];
	
}

-(void)gameLogic:(ccTime)dt {
	
	[self addTarget];
	
}

// on "init" you need to initialize your instance
-(id) init
{
    
    //[[CCDirector sharedDirector] setDeviceOrientation:
    // UIDeviceOrientationLandscapeLeft];
    
    //[CommUtils showAd:self rect:CGRectMake(0, 430, 320, 150)]; //载入广告
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	self = [super init];
	if (self) {
		// Enable touch events
		self.touchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
		
		// Get the dimensions of the window for calculation purposes
		// CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *spriteBg = [CCSpriteUtils createCCSprite:@"bowfruit.jpg" location:ccp(0,320)];
        [self addChild:spriteBg];
		
		// Add the player to the middle of the screen along the y-axis, 
		// and as close to the left side edge as we can get
		// Remember that position is based on the anchor point, and by default the anchor
		// point is the middle of the object.
		_player = [[CCSprite spriteWithFile:@"bow.png"] retain];
		_player.position = ccp(_player.contentSize.width/2, 70);
        _player.anchorPoint = ccp(0,0.5);
		[self addChild:_player];
        
        // Useful for taking screenshots
        //[[CCScheduler sharedScheduler] setTimeScale:0.1];
		
		// Call game logic about every second
		[self schedule:@selector(gameLogic:) interval:1.0];
		[self schedule:@selector(update:)];
		
		// Start up the background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
        
        
        CCMenuItemImage *pauseItem = [CCMenuItemImage itemFromNormalImage:@"pause.png" 
                                                            selectedImage:@"pause_selected.png"];
        CCMenuItemImage *playItem = [CCMenuItemImage itemFromNormalImage:@"play.png" 
                                                           selectedImage:@"play_selected.png"]; 
        
        
        play = [CCMenuItemToggle itemWithTarget:self
                                       selector:@selector(pause:) items:pauseItem, playItem, nil];
        
        CCSprite* hintNormal = [CCSprite spriteWithFile:@"goback.png"];
        CCSprite* hintSelected = [CCSprite spriteWithFile:@"goback.png"];
        CCMenuItemSprite* goback = [CCMenuItemSprite itemWithNormalSprite:hintNormal selectedSprite:hintSelected
                                                                   target:self selector:@selector(backgame:)];
        
        // 创建菜单
        CCMenu* menu = [CCMenu menuWithItems:play,goback,nil];
        menu.position = CGPointMake(56, 292);
        [self addChild:menu];
        // 把菜单项排列起来
        [menu alignItemsHorizontallyWithPadding:10];
        
        CCDirector *director = [CCDirector sharedDirector];
        CCScene *scene = [director runningScene];
        GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
        _score = gameLayer.fruitCore.score;
        _arrowNum = 100;
        int x = 230;
        int y = 290;
        
        CCSprite  *bowItem = [CCSprite spriteWithFile:@"bowitem.png"];
        [self addChild:bowItem];
        bowItem.position = ccp(x,y);
        CCSprite *arrowItem = [CCSprite spriteWithFile:@"arrow.png"];
        [self addChild:arrowItem];
                               arrowItem.position = ccp(x+5,y);
                            arrowItem.scale = 0.5;
        
        [CommUtils showText:self text:@"X" position:ccp(x+30,y)];
        
        arrowNumBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_arrowNum] 
                                          fontName:@"Arial" fontSize:24];
        arrowNumBg.position =  ccp(x+50,y);
        arrowNumBg.color=ccc3(255, 168, 0);
        arrowNumBg.anchorPoint = CGPointMake(0, 0.5);
        [self addChild: arrowNumBg];
        
        arrowNum = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_arrowNum] 
                                        fontName:@"Arial" fontSize:24];
        arrowNum.position =  ccp(x+50, y+2);
        arrowNum.color=ccc3(255, 246, 0);
        arrowNum.anchorPoint = CGPointMake(0, 0.5);
        [self addChild: arrowNum];
        
        CCSprite *coin = [CCSprite spriteWithFile:@"coin.png"];
        [self addChild:coin];
        coin.position = ccp(x+120,y+4);
        
        [CommUtils showText:self text:@"X" position:ccp(x+130,y)];
        
        scoreValueBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_score] 
                                          fontName:@"Arial" fontSize:24];
        scoreValueBg.position =  ccp(x+149,y);
        scoreValueBg.color=ccc3(255, 168, 0);
        scoreValueBg.anchorPoint = CGPointMake(0, 0.5);
        [self addChild: scoreValueBg];
        
        scoreValue = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_score] 
                                        fontName:@"Arial" fontSize:24];
        scoreValue.position =  ccp(x+150, y+1);
        scoreValue.color=ccc3(255, 246, 0);
        scoreValue.anchorPoint = CGPointMake(0, 0.5);
        [self addChild: scoreValue];
		
	}
	return self;
}

-(void)calcScore:(NSNumber *)num{
    _score+=[num intValue];
    [self schedule:@selector(scoreAnimal:) interval:0.01];
}

-(void)scoreAnimal:(ccTime)dt {
    
    int curScore = [[scoreValue string] intValue];
    
    int tmp = _score-curScore;
    if(tmp<10) curScore++;
    else if(tmp<100) curScore+=6;
    else curScore+=12;
    
    [scoreValue setString:[NSString stringWithFormat:@"%d",curScore]];
    [scoreValueBg setString:[NSString stringWithFormat:@"%d",curScore]];
    if(curScore>=_score)
        [self unschedule:@selector(scoreAnimal:)];
}

-(void)stopScoreAnimal {
    [self unschedule:@selector(scoreAnimal:)];
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
}

- (void)backgame:(id)sender{
    [self unschedule:@selector(dropFruit:)];
    [self closeTip:nil data:nil];
}

- (void)closeTip:(id)sender data:(NSObject *)param{
	CCDirector *director = [CCDirector sharedDirector];
    CCScene *scene = [director runningScene];
    [scene removeChildByTag:10 cleanup:YES];
    GameLayer *gameLayer = (GameLayer *)[scene getChildByTag:0];
    [gameLayer.fruitCore calcScore:[NSNumber numberWithInt:_score-gameLayer.fruitCore.score]];
    [gameLayer playGame:nil];
    [gameLayer startGameLogic];
    //[[CCDirector sharedDirector] setDeviceOrientation:
    // UIDeviceOrientationPortrait];
    NSLog(@"closeTip");
}

- (void)update:(ccTime)dt {
    
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (CCSprite *projectile in _projectiles) {
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);
        
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
		for (CCSprite *target in _targets) {
			CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
										   target.position.y - (target.contentSize.height/2), 
										   target.contentSize.width, 
										   target.contentSize.height);
            
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
				[targetsToDelete addObject:target];				
			}						
		}
		
		for (Item *target in targetsToDelete) {
			[_targets removeObject:target];
			[self removeChild:target cleanup:YES];									
			_projectilesDestroyed++;
            [self calcScore:[NSNumber numberWithInt:DROPFRUITSCORESCALE]];
            [SoundUtils playEffect:@"getfruit.caf" volume:0.5];
            
            NumUtils *util = [[NumUtils alloc] initLayer:self];
            //得分动画
            [util drawScore:self beginPoint:target.position endPoint:ccp(390,296)
                        num:[NSString stringWithFormat:@"%d",DROPFRUITSCORESCALE]];
            
            if(target.style==9){
                for (CCSprite *obj in _targets) {
                    if(![targetsToDelete containsObject:obj]){
                        [_targets removeObject:target];
                        [self removeChild:target cleanup:YES];									
                        _projectilesDestroyed++;
                        [self calcScore:[NSNumber numberWithInt:DROPFRUITSCORESCALE]];
                        [SoundUtils playEffect:@"getfruit.caf" volume:0.5];
                        
                        NumUtils *util = [[[NumUtils alloc] initLayer:self] autorelease];
                        //得分动画
                        [util drawScore:self beginPoint:target.position endPoint:ccp(390,296)
                                    num:[NSString stringWithFormat:@"%d",DROPFRUITSCORESCALE]];
                    }
                }
                
            }
            
			if (_arrowNum<=0) {
                [self backgame:nil];
			}
		}
		
		if (targetsToDelete.count > 0) {
			[projectilesToDelete addObject:projectile];
		}
		[targetsToDelete release];
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[_projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_nextProjectile != nil) return;
    _arrowNum--;
    [arrowNumBg setString:[NSString stringWithFormat:@"%d",_arrowNum]];
    [arrowNum setString:[NSString stringWithFormat:@"%d",_arrowNum]];
    //
    // Easier method using Cocos2D helper functions, suggested by 
    // Caleb Wren - see comments for post
    //
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Play a sound!
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    // Set up initial location of projectile
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    _nextProjectile = [[CCSprite spriteWithFile:@"arrow.png"] retain];
    _nextProjectile.anchorPoint =ccp(0.0,0.5);
    _nextProjectile.position = CGPointMake(_player.position.x,_player.position.y);
    
    // Rotate player to face shooting direction
    CGPoint shootVector = ccpSub(location, _nextProjectile.position);
    CGFloat shootAngle = ccpToAngle(shootVector);
    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
    
    CGFloat curAngle = _player.rotation;
    CGFloat rotateDiff = cocosAngle - curAngle;    
    if (rotateDiff > 180)
		rotateDiff -= 360;
	if (rotateDiff < -180)
		rotateDiff += 360;    
    // Old way
    //CGFloat rotateSpeed = 0.5 / 180; // Would take 0.5 seconds to rotate half a circle
    //CGFloat rotateDuration = fabs(rotateDiff * rotateSpeed);
    // More clear way
    CGFloat rotateSpeed = 360; // degrees per second
    CGFloat rotateDuration = fabs(rotateDiff / rotateSpeed);
    
    [_player runAction:[CCSequence actions:
                        [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                        [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
                        nil]];
    
    // Move projectile offscreen
    ccTime delta = 1.0;
    CGPoint normalizedShootVector = ccpNormalize(shootVector);
    CGPoint overshotVector = ccpMult(normalizedShootVector, 420);
    CGPoint offscreenPoint = ccpAdd(_nextProjectile.position, overshotVector);
    
    [_nextProjectile runAction:[CCSequence actions:
                                [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                                [CCMoveTo actionWithDuration:delta position:offscreenPoint],
                                [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                                nil]];
    
    // Add to projectiles array
    _nextProjectile.tag = 2;
    
    /* Old method
     // Choose one of the touches to work with
     UITouch *touch = [touches anyObject];
     CGPoint location = [touch locationInView:[touch view]];
     location = [[CCDirector sharedDirector] convertToGL:location];
     
     // Set up initial location of projectile
     CGSize winSize = [[CCDirector sharedDirector] winSize];
     _nextProjectile = [[CCSprite spriteWithFile:@"Projectile2.png"] retain];
     _nextProjectile.position = ccp(20, winSize.height/2);
     
     // Determine offset of location to projectile
     int offX = location.x - _nextProjectile.position.x;
     int offY = location.y - _nextProjectile.position.y;
     
     // Bail out if we are shooting down or backwards
     if (offX <= 0) return;
     
     // Play a sound!
     [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
     
     // Determine where we wish to shoot the projectile to
     int realX = winSize.width + (_nextProjectile.contentSize.width/2);
     float ratio = (float) offY / (float) offX;
     int realY = (realX * ratio) + _nextProjectile.position.y;
     CGPoint realDest = ccp(realX, realY);
     
     // Determine the length of how far we're shooting
     int offRealX = realX - _nextProjectile.position.x;
     int offRealY = realY - _nextProjectile.position.y;
     float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
     float velocity = 480/1; // 480pixels/1sec
     float realMoveDuration = length/velocity;
     
     // Determine angle to face
     float angleRadians = atanf((float)offRealY / (float)offRealX);
     float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
     float cocosAngle = -1 * angleDegrees;
     float rotateSpeed = 0.5 / M_PI; // Would take 0.5 seconds to rotate 0.5 radians, or half a circle
     float rotateDuration = fabs(angleRadians * rotateSpeed);    
     [_player runAction:[CCSequence actions:
     [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
     [CCCallFunc actionWithTarget:self selector:@selector(finishShoot)],
     nil]];
     
     // Move projectile to actual endpoint
     [_nextProjectile runAction:[CCSequence actions:
     [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
     [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
     nil]];
     
     // Add to projectiles array
     _nextProjectile.tag = 2;
     */
}

- (void)finishShoot {
    
    // Ok to add now - we've finished rotation!
    [self addChild:_nextProjectile];
    [_projectiles addObject:_nextProjectile];
    
    // Release
    [_nextProjectile release];
    _nextProjectile = nil;
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_targets release];
	_targets = nil;
	[_projectiles release];
	_projectiles = nil;
    [_player release];
    _player = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
