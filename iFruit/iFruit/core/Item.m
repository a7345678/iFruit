//
//  Item.m
//  Item
//
//  Created by mac on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

@implementation Item
@synthesize style;

static NSMutableArray *itemArray = nil;

-(id) init {
	self = [super init];
	if (self != nil){
	}
    [self SetCanTrack:YES];
	return self;
}

+(NSMutableArray *)itemArray {
    @synchronized(itemArray) {
        if (itemArray == nil)
            itemArray = [[[NSMutableArray alloc] init] autorelease];
        return itemArray;
    }
	return nil;
}
+(void)track: (Item *)aSprite {
	@synchronized(itemArray){
		[[Item itemArray] addObject:aSprite];
        
	}
}
+(void)untrack:(Item *)aSprite {
	@synchronized(itemArray) {
		[[Item itemArray] removeObject:aSprite];
	}
}

+(void)removeAll {
    if ([itemArray count]==0) return;
    @synchronized(itemArray) {
        for (int i=[itemArray count]-1; i>=0; i--) {
            Item *curItem = [itemArray objectAtIndex:i];
            [itemArray removeObject:curItem];
            [curItem removeFromParentAndCleanup:YES];
            NSLog(@"itemArray:%d",i);
        } 
	}
}

+(NSInteger)SomethingWasTouched:(NSArray *)array pos:(CGPoint)pos {
	NSUInteger i, count = [array count];
    NSInteger index = -1;
	for(i=0; i<count; i++){
		Item *obj = [array objectAtIndex:i];
		if(CGRectContainsPoint([obj rect], pos) && [obj GetCanTrack]){
            index = i;
		}
	}
	return index;
}

+(Item *) FindByTag:(int) tagVar {
	NSUInteger i, count = [itemArray count];
	for(i=0; i <count; i++){
		Item *obj = (Item *)[itemArray objectAtIndex:i];
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
	[Item untrack:self];
	[super dealloc];
}

@end
