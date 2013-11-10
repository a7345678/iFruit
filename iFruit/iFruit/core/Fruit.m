//
//  Fruit.m
//  Fruit
//
//  Created by mac on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Fruit.h"


@implementation Fruit

@synthesize fruitCenter;
@synthesize style,moveNum,item;
@synthesize index;



-(id) init {
	self = [super init];
	if (self != nil){
        status = 0;
        fruitCenter = self.position;
	}
    [self SetCanTrack:YES];
	return self;
}

+(NSInteger)SomethingWasTouched:(NSArray *)array pos:(CGPoint)pos {
	NSUInteger i, count = [array count];
    NSInteger index = -1;
	for(i=0; i<count; i++){
		Fruit *obj = [array objectAtIndex:i];
        //NSLog(@"rect:%@,pos:%f,%f",NSStringFromCGRect([obj rect]),pos.x,pos.y);
		if(CGRectContainsPoint([obj rect], pos) /*&& [obj GetCanTrack]*/){
            index = i;
		}
	}
	return index;
}

+(Fruit *) FindByTag:(NSArray *)allMySprites tag:(int) tagVar {
	NSUInteger i, count = [allMySprites count];
	for(i=0; i <count; i++){
		Fruit *obj = (Fruit *)[allMySprites objectAtIndex:i];
		if([obj tag] == tagVar) {
			return obj;
		}
	}
	return nil;
}

-(void) SetCanTrack:(BOOL)val {
	canTrack = val;
}
-(BOOL) GetCanTrack {
	return canTrack;
}

-(CGRect) rect {
	float w = [self contentSize].width;
	float h = [self contentSize].height;
	CGPoint point = CGPointMake([self position].x - (w/2), [self position].y - (h/2));
	return CGRectMake(point.x,point.y,w,h);
}

-(void)dealloc {
	[super dealloc];
}

@end
