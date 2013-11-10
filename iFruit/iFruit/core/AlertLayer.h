//
//  OptionLayer.h
//  iFruit
//
//  Created by mac on 11-8-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"
#import <GameKit/GameKit.h>

#define GAME_TIP 1
#define DROPFRUIT_TIP 2

@interface AlertLayer : CCLayerColor {
    CCLabelTTF *label;
}

+(AlertLayer *)sharedInstance;

@property (nonatomic) int type;

@end
