//
//  GCHelper.h
//  iFruit
//
//  Created by mac on 11-9-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate 
- (void)matchStarted;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    id <GCHelperDelegate> delegate;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;

- (BOOL)isGameCenterAvailable;
+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate;

- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier;
- (void) loadAchievements;

@end