//
//  NumUtils.h
//  Fruit
//
//  Created by mac on 11-7-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface NumUtils : NSObject {
    CCLayer *view;
    NSMutableArray *numArray,*curNumArray;
}

@property (nonatomic,retain) NSMutableArray *numArray,*curNumArray;

- (NumUtils *)init:(CCLayer *)layer;
-(NumUtils *)initLayer:(CCLayer *)layer;
- (void)removeNum:(id)sender;
- (void)drawScore:(CCLayer *) layer beginPoint:(CGPoint)beginPoint endPoint:(CGPoint)endPoint num:(NSString *)numstr;

@end
