//
//  DMFeedsAdView.h
//  DomobAdSDK
//
//  Copyright (c) 2013年 Domob Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DMAdView.h"

@protocol DMFeedsAdViewDelegate;
@interface DMFeedsAdView : UIView
// set delegate
@property (nonatomic, assign) id <DMFeedsAdViewDelegate>delegate;
// set rootViewController
@property (nonatomic, retain) UIViewController *rootViewController;

// init FeedsAdView with size 320*240 only support for iPhone/iPod

- (id)initWithPublisherId:(NSString *)publisherId     // Domob PublisherId
              placementId:(NSString *)placementId     // Domob PlacementId
                   origin:(CGPoint)adOrigin;          // origin for FeedsAdView

// load ad
- (void)loadAd;
// present ad
- (void)present;
// close the ad view
- (void)closeAd;

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


@protocol DMFeedsAdViewDelegate

@optional
// Sent when an ad request success to load an ad
- (void)dmFeedsSuccessToLoadAd:(DMFeedsAdView *)dmFeeds;
// Sent when an ad request fail to load an ad
- (void)dmFeedsFailToLoadAd:(DMFeedsAdView *)dmFeeds withError:(NSError *)err;
// Sent when the feeds ad is clicked
- (void)dmFeedsDidClicked:(DMFeedsAdView *)dmFeeds;

// Sent just before presenting the user a modal view
- (void)dmFeedsWillPresentModalView:(DMFeedsAdView *)dmFeeds;
// Sent just after dismissing the modal view
- (void)dmFeedsDidDismissModalView:(DMFeedsAdView *)dmFeeds;
// Sent just before the application will background or terminate because the user's action
// (Such as the user clicked on an ad that will launch App Store).
- (void)dmFeedsApplicationWillEnterBackground:(DMFeedsAdView *)dmFeeds;

// Sent just before presenting an feeds ad view
- (void)dmFeedsWillPresentScreen:(DMFeedsAdView *)dmFeeds;
// Sent just after dismissing a feeds ad view
- (void)dmFeedsDidDismissScreen:(DMFeedsAdView *)dmFeeds;

@end

