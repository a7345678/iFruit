//
//  Score.h
//  iFruit
//
//  Created by mac on 11-7-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Score : NSObject {
    CCLabelTTF *scoreLabel,*scoreLabelBg;
    CCLabelTTF *scoreValue,*scoreValueBg;
    NSMutableArray *scoreCountArray;
    NSUserDefaults* prefs; //保存最高分玩家
}

@property (nonatomic,retain) CCLabelTTF *scoreLabel,*scoreLabelBg,*scoreValue,*scoreValueBg;
@property (nonatomic,retain) NSMutableArray *scoreCountArray;

@end
