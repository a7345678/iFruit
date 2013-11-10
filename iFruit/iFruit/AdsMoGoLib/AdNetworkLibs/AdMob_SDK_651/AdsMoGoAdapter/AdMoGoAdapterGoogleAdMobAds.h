//
//  File: AdMoGoAdapterGoogleAdMobAds.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//
//AdMob v5.0.5

#import "AdMoGoAdNetworkAdapter.h"
#import "GADBannerViewDelegate.h"

@interface AdMoGoAdapterGoogleAdMobAds : AdMoGoAdNetworkAdapter
<GADBannerViewDelegate> {
    
    BOOL isStop;
    NSTimer *timer;
}

- (SEL)delegatePublisherIdSelector;
- (NSString *)hexStringFromUIColor:(UIColor *)color;
+ (NSDictionary *)networkType;
- (NSString *)publisherId;
@end
