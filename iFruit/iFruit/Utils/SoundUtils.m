//
//  MyClass.m
//  iFruit
//
//  Created by mac on 11-7-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SoundUtils.h"
#import "CommUtils.h"

@implementation SoundUtils

static NSMutableDictionary *trackFiles;
static BOOL enabled_=TRUE;
//static BOOL musicVolume_=1.0f;



//    使用cocos2d的SimpleAudioEngine可以很简单的播放背景音乐和音效。
//    1，准备工作
//    引入头文件：#import "SimpleAudioEngine.h"
//    2，播放背景音乐
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.wav"];
//    注：如果之前有播放过名字为background.wav的背景音乐，则这个方法为从头开始播放背景音乐。
//    3，播放音效
//    [[SimpleAudioEngine sharedEngine] playEffect:@"effect1.wav"];
//    4，暂停背景音乐
//    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
//    5，预先加载背景音乐
//    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic];
//    
//    使用CDAudioManager来更改音乐的属性（更改属性之前必须有背景音乐在播放或者背景音乐被preload进来 了）
//    6，更改音量（音量大小从0到1）
//    [CDAudioManager sharedManager].backgroundMusic.volume = 1.0f;
//    7，循环播放N次背景音乐
//    [CDAudioManager sharedManager].backgroundMusic.numberOfLoops ＝ N;
//    8，背景音乐停止时触发事件
//    [[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector()];

//
//把音频文件按着名字添加到字典中
//
+(void) addMusicTrack:(NSString*)filename name:(NSString*)name {
    if (trackFiles == nil) {
        trackFiles = [[NSMutableDictionary alloc] init];
    }
    [trackFiles setObject:filename forKey:name];
}
//
//通过判断字典中是否为空，看有没有音频文件。
//
+ (BOOL)hasMusicTrack:(NSString*)name {
    id obj = [trackFiles objectForKey:name];
    if(obj==nil) return FALSE;
    else
        return TRUE;
}
//
//对上文提及的方法进行封装，参数是播放的名字，和是否重复播放
//
+ (void)playMusicTrack:(NSString*)name withRepeat:(BOOL)b {
#ifndef DEBUG_NO_SOUND
    if (!enabled_) return;
    if (trackFiles == nil) return;
    
//    if(track!=nil) {
//        @try {
//            [self stopCurrentTrack];
//        }
//        @catch (NSException* ex) {
//            NSLog([ex description]);
//        }
//    }
//    //
//    // 这个函数initWithPath就是上文提及的，初始化方法。
//    //
//    track = [[GBMusicTrack alloc] initWithPath:[[NSBundle mainBundle] 
//                                                pathForResource:[trackFiles objectForKey:name] 
//                                                ofType:@"mp3"]];
//    [track setRepeat:b];
//    [track setVolume:musicVolume_];
//    // 音乐的播放
//    //
//    [track play];
#endif
}


+ (void)buttonClick {
    [[SimpleAudioEngine sharedEngine] playEffect:@"button_click.caf"];
}

+ (void)playBackgroundMusic:(NSString *)filename volume:(float)volume flag:(int)musicCanPlay{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:filename];
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = volume;
    if(musicCanPlay==0)  [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}
+ (void)pauseBackgroundMusic:(int)musicCanPlay{
    if(musicCanPlay==1)  [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

+ (void)playEffect:(NSString *)filename volume:(float)volume{
    [SimpleAudioEngine sharedEngine].effectsVolume = volume;
    if([CommUtils getGameValue:@"SoundCanPlay"]==1) {
        [[SimpleAudioEngine sharedEngine] playEffect:filename];
    }
}

@end
