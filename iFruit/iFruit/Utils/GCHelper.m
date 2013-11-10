//
//  GCHelper.m
//  iFruit
//
//  Created by mac on 11-9-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

//
//  GCHelper.h
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCHelper.h"
#import "cocos2d.h"

@implementation GCHelper
@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
                                           options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
        }
    }
    return self;
}

#pragma mark Internal functions

- (void)authenticationChanged {    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;           
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

#pragma mark User functions

- (void)authenticateLocalUser { 
    
    NSLog(@"gamecenteravailbale yes or no:%d",gameCenterAvailable?1:0);
    if (!gameCenterAvailable) return;
    
    
//    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
//    
//    localPlayer.authenticateHandler =^(UIViewController *viewController,
//      NSError *error) {
//        
//        // Player already authenticated
//        if (localPlayer.authenticated) {
//            //_gameCenterFeaturesEnabled = YES;
//            NSLog(@"成功");
//        } else if(viewController) {
//            NSLog(@"弹出");
//            //BannerAdViewController *controller = [BannerAdViewController sharedInstance];
//            //[[[CCDirector sharedDirector] openGLView] addSubview :viewController.view];
//            //[self presentViewController:viewController];
//        } else {
//            NSLog(@"成功");
//            //_gameCenterFeaturesEnabled = NO;
//        }
//    };
    
//    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
//        
//        if (error == nil) {
//            
//            //成功处理
//            
//            NSLog(@"成功");
//            
//            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
//            
//            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
//            
//            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
//            
//            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
//            
//            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
//            
//        }else {
//            
//            //错误处理
//            
//            NSLog(@"失败  %@",error);
//            
//        }
//        
//    }];
    
//    NSLog(@"Authenticating local user...");
//    if ([GKLocalPlayer localPlayer].authenticated == NO) {     
//        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
//        NSLog(@"authenticated failed!");
//    } else {
//        NSLog(@"Already authenticated!");
//    }
    
//    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error){
//        if (error == nil) {
//            //成功处理
//            NSLog(@"成功");
//            NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
//            NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
//            NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
//            NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
//            NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
//        }else {
//            //错误处理
//            NSLog(@"失败  %@",error);
//        }
//    }];
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if ([localPlayer respondsToSelector:@selector(setAuthenticateHandler:)]) {
        [localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
            if (viewController) {
                self.presentingViewController = viewController;
            }
            
            if (error) {
                if (error.code == 2 && [error.domain isEqualToString:@"GKErrorDomain"]) {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Game Center"
                                              message:@"If Game Center is disabled try logging in through the Game Center app"
                                              delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Open Game Center", nil];
                    
                    [alertView show];
                }
            }
        }];
    } else {
        NSLog(@"auth...gamecenter");
        //if ([[NSUserDefaults standardUserDefaults] boolForKey:kHasEnabledGamekitUserDefaultsKey]) {
            [localPlayer authenticateWithCompletionHandler:nil];
        //}
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    if(!userAuthenticated) return;
    
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error) 
    {
        if(error==NULL)
        {
        }
        else 
        {
            NSLog(@"上传分数失败  %@",error);
        }
        
    }];
}


//6.1汇报一个成就的进度
//对于一个玩家可见的成就,你需要尽可能的报告给玩家解锁的进度;对于一个一部完成的成就,则不需要,当玩家的进度达到100%的时候,会自动解锁该成就.
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 //The proper way for your application to handle network errors is retain 
                 //the achievement object (possibly adding it to an array). Then, periodically 
                 //attempt to report the progress until it is successfully reported. 
                 //The GKAchievement class supports the NSCoding protocol to allow your 
                 //application to archive an achie
                 NSLog(@"报告成就进度失败 ,错误信息为: \n %@",error);
             }else {
                 //对用户提示,已经完成XX%进度
                 NSLog(@"报告成就进度---->成功!");
                 NSLog(@"    completed:%d",achievement.completed);
                 NSLog(@"    hidden:%d",achievement.hidden);
                 NSLog(@"    lastReportedDate:%@",achievement.lastReportedDate);
                 NSLog(@"    percentComplete:%f",achievement.percentComplete);
                 NSLog(@"    identifier:%@",achievement.identifier);
             }
         }];
    }
}
//其中该函数的参数中identifier是你成就的ID, percent是该成就完成的百分比

// 方法二:根据ID获取成就
- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    //NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] init];
   //GKAchievement *achievement = [achievementDictionary objectForKey:identifier];
    GKAchievement *achievement = nil;
    if (achievement == nil)
    {
    achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
     //[achievementDictionary setObject:achievement forKey:achievement.identifier];
     }
   return [[achievement retain] autorelease];
}


- (void) loadAchievements
{
NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] init];
    NSLog(@"loadAchievements...");
[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements,NSError *error)
{
            if (error == nil) {
                 NSArray *tempArray = [NSArray arrayWithArray:achievements];
                  for (GKAchievement *tempAchievement in tempArray) {
                   [achievementDictionary setObject:tempAchievement forKey:tempAchievement.identifier];
                        NSLog(@"    completed:%d",tempAchievement.completed);
                       NSLog(@"    hidden:%d",tempAchievement.hidden);
                   NSLog(@"    lastReportedDate:%@",tempAchievement.lastReportedDate);
                     NSLog(@"    percentComplete:%f",tempAchievement.percentComplete);
                   NSLog(@"    identifier:%@",tempAchievement.identifier);
                  }
               }
}];
}


- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate {
    
    if (!gameCenterAvailable) return;
    
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;               
    [presentingViewController dismissModalViewControllerAnimated:NO];
    
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];    
    mmvc.matchmakerDelegate = self;
    
    [presentingViewController presentModalViewController:mmvc animated:YES];
    
}

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [presentingViewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    NSLog(@"Error finding match: %@", error.localizedDescription);    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
    }
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    if (match != theMatch) return;
    
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    
    if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
            }
            
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }                 
    
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

@end