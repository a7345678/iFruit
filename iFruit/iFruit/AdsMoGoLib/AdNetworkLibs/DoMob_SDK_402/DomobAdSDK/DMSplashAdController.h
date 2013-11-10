//
//  DMSplashAdController.h
//
//  Copyright (c) 2013 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DMAdView.h"

// For iPhone
#define DOMOB_AD_SIZE_320x240   CGSizeMake(320, 240)
#define DOMOB_AD_SIZE_320x400   CGSizeMake(320, 400)

// For iPad
#define DOMOB_AD_SIZE_768x576   CGSizeMake(768, 576)
#define DOMOB_AD_SIZE_768x960   CGSizeMake(768, 960)

@protocol DMSplashAdControllerDelegate;
@interface DMSplashAdController : UIViewController

@property (nonatomic, assign) BOOL isReady; // if it is ready for presenting
@property (nonatomic, assign) NSObject <DMSplashAdControllerDelegate> *delegate; // set delegate
@property (nonatomic, assign) UIViewController *rootViewController; // set rootViewController

// init splash viewController
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                   window:(UIWindow *)window;       // Key Window for presenting the ad

// init splash viewController
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                   window:(UIWindow *)window        // Key Window for presenting the ad
               background:(UIColor *)background;    // background color/Image before the ad view appear, deafult is black

// init splash viewController
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                   window:(UIWindow *)keyWindow     // Key Window for presenting the ad
               background:(UIColor *)background     // background color/Image before the ad view appear, deafult is black
                animation:(BOOL)animation;          // animation for close,deafult is yes

// init splash viewController
// You can specify ad size, and display position. So that a better combination of advertising and default.png
- (id)initWithPublisherId:(NSString *)publisherId   // Domob PublisherId
              placementId:(NSString *)placementId   // Domob PlacementId
                     size:(CGSize)adSize            // size for Vertical screen ,full screen size for Horizontal screen
                   offset:(CGFloat)offset           // offset in origin.y only support Vertical screen
                   window:(UIWindow *)keyWindow     // Key Window for presenting the ad
               background:(UIColor *)background     /* background color/Image before the ad view appear, deafult is black，
                                                       Proposal set to "Launch Images" same picture。*/
                animation:(BOOL)animation;          // animation for close,deafult is yes

// present ad
- (void)present;

// The user's current location
- (void)setLocation:(CLLocation *)location;

// The user's postcode
- (void)setPostcode:(NSString *)postcode;

// The keyword of current activity
- (void)setKeywords:(NSString *)keywords;

// The user's birthday
- (void)setUserBirthday:(NSString *)userBirthday;

// The user's gender
- (void)setUserGender:(DMUserGenderType)userGender;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol DMSplashAdControllerDelegate
@optional
// Sent when an splash ad request success to loaded an ad
- (void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd;
// Sent when an ad request fail to loaded an ad
- (void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err;

// Sent just before presenting an splash ad view
- (void)dmSplashAdWillPresentScreen:(DMSplashAdController *)dmSplashAd;
// Sent just after dismissing an splash ad view
- (void)dmSplashAdDidDismissScreen:(DMSplashAdController *)dmSplashAd;
@end
