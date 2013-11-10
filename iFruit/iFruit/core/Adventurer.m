//
//  Adventurer.m
//  SpriteTutorialPart3
//
//  Created by MajorTom on 9/13/10.
//  Copyright 2010 iPhoneGameTutorials.com All rights reserved.
//

#import "Adventurer.h"


@implementation Adventurer

@synthesize charSprite = _charSprite;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;
@synthesize animate = _animate;

-(id) init{
	self = [super init];
	if (!self) {
		return nil;
	}
	
	return self;
}

- (void) dealloc
{
	self.charSprite = nil;
    self.walkAction = nil;
	self.moveAction = nil;
	[super dealloc];
}

@end
