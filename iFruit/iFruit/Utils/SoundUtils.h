//
//  MyClass.h
//  iFruit
//
//  Created by mac on 11-7-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

#define BACKGROUNDMP3 @"background.mp3"

@interface SoundUtils : NSObject {
    
}

+ (void)buttonClick;
+ (void)playBackgroundMusic:(NSString *)filename volume:(float)volume flag:(int)musicCanPlay;
+ (void)pauseBackgroundMusic:(int)musicCanPlay;
+ (void)playEffect:(NSString *)filename volume:(float)volume;

@end
