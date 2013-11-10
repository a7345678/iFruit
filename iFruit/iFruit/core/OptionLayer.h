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

@interface OptionLayer : CCLayerColor<GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate> {
    BOOL play,music,sound;
    NSMutableArray *itemSrpiteArray;
    UIViewController *gameCenterView;
}

-(void) play:(id)sender;
-(void) music:(id)sender;
-(void) sound:(id)sender;
-(void) goback:(id)sender;
-(void) restart:(id)sender;
-(void) howToPlayControll:(id)sender;
-(void)openGameCenter:(id)sender;
- (void) showAchievements:(id)sender;

@end
