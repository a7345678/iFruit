//
//  Fruit.h
//  Fruit
//
//  Created by mac on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Item : CCSprite {
    int style;
    BOOL canTrack;
}

@property (nonatomic) int style;

+(NSMutableArray *)itemArray;
+(void)track: (Item *)aSprite;
+(void)untrack: (Item *)aSprite;
+(void)removeAll;
+(NSInteger)SomethingWasTouched:(NSArray *)array pos:(CGPoint)pos;
+(Item *) FindByTag:(int) tagVar;
-(CGRect) rect;
-(void)SetCanTrack:(BOOL) val;
-(BOOL)GetCanTrack;

@end
