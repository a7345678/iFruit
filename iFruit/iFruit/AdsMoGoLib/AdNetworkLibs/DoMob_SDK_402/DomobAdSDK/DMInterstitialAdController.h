//
//  DMInterstitialAdViewController.h
//
//  Copyright (c) 2013 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAdView.h"

@protocol DMInterstitialAdControllerDelegate;
@interface DMInterstitialAdController : UIViewController

// if it is ready
@property (nonatomic, readonly) BOOL isReady;
// set delegate
@property (nonatomic, assign) NSObject <DMInterstitialAdControllerDelegate> *delegate;
// if set the statusBarHidden = YES ? default is YES
@property (nonatomic, assign) BOOL shouldHiddenStatusBar;

// init an Interstitial ad viewController。deafult size:
// iPhone/iPod: 300x250
// iPad:        600x500
- (id)initWithPublisherId:(NSString *)publisherId                   // Domob PublisherId
              placementId:(NSString *)placementId                   // Domob PlacementId
       rootViewController:(UIViewController *)rootViewController;   // set RootViewController

//  init an Interstitial ad viewController
- (id)initWithPublisherId:(NSString *)publisherId                   // Domob PublisherId
              placementId:(NSString *)placementId                   // Domob PlacementId
       rootViewController:(UIViewController *)rootViewController    // set RootViewController
                     size:(CGSize)adSize;                           // size for interstitial ad view

// load ad
- (void)loadAd;

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

@protocol DMInterstitialAdControllerDelegate
@optional
// Sent when an ad request success to loaded an ad
- (void)dmInterstitialSuccessToLoadAd:(DMInterstitialAdController *)dmInterstitial;
// Sent when an ad request fail to loaded an ad
- (void)dmInterstitialFailToLoadAd:(DMInterstitialAdController *)dmInterstitial withError:(NSError *)err;
// Sent when the ad is clicked
- (void)dmInterstitialDidClicked:(DMInterstitialAdController *)dmInterstitial;

// Sent just before presenting an interstitial
- (void)dmInterstitialWillPresentScreen:(DMInterstitialAdController *)dmInterstitial;
// Sent just after dismissing an interstitial
- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial;

// Sent just before presenting the user a modal view
- (void)dmInterstitialWillPresentModalView:(DMInterstitialAdController *)dmInterstitial;
// Sent just after dismissing the modal view.
- (void)dmInterstitialDidDismissModalView:(DMInterstitialAdController *)dmInterstitial;
// Sent just before the application will background or terminate because the user's action
// (Such as the user clicked on an ad that will launch App Store).
- (void)dmInterstitialApplicationWillEnterBackground:(DMInterstitialAdController *)dmInterstitial;
@end
