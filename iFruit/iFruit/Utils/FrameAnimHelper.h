//
//  FrameAnimHelper.h
//  iFruit
//
//  Created by mac on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

/** 简化帧动画的实现
 */
@interface FrameAnimHelper : NSObject {
    
}

+ (CCSprite *) animWithFilename:(CCLayer *)layer filename:(NSString *)filename
                      numFrames:(int)numFrames
                  plistFilename:(NSString *)plistFilename
                     spriteName:(NSString *)spriteName
                      spriteTag:(int)tag
                      repeatNum:(int)repeatNum;
+(void)removeSprite:(CCSprite *)sprite;

@end
