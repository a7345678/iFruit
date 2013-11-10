//
//  CCSpriteUtils.h
//  iFruit
//
//  Created by mac on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface CCSpriteUtils : NSObject {
    
}

+ (CCSprite *)createCCSprite:(NSString *)filename location:(CGPoint)location;
+ (CCSprite *)createTexture2D:(CCTexture2D *)texturename location:(CGPoint)location;
+ (CGPoint)getPosition:(CCSprite *)sprite location:(CGPoint)location;

@end
