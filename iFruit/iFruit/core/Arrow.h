//
//  Arrow.h
//  iFruit
//
//  Created by mac on 12-1-2.
//  Copyright 2012年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Arrow : CCSprite {
    CGPoint offscreenPoint;
    int second;
}
@property (nonatomic) CGPoint offscreenPoint;
@property (nonatomic) int second;
@end
