//
//  Adventurer.h
//  SpriteTutorialPart3
//
//  Created by MajorTom on 9/13/10.
//  Copyright 2010 iPhoneGameTutorials.com All rights reserved.
//

#import "cocos2d.h"
#import "Bomb.h"
#import "SimpleAudioEngine.h"

@interface Adventurer : CCNode {
	Bomb *_charSprite;
    CCAction *_walkAction;
	CCAction *_moveAction;
    CCAnimate *_animate;
    BOOL _moving;
}

@property (nonatomic, retain) Bomb *charSprite;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, retain) CCAnimate *animate;

@end
