//
//  AdMoGoAdapterMobiSageFullAd.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdapterMobiSageFullAd.h"
#import "AdMoGoAdapterMobiSage.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

static BOOL isloaded = false; 
@implementation AdMoGoAdapterMobiSageFullAd

+ (NSDictionary *)networkType {
	return [self makeNetWorkType:AdMoGoAdNetworkTypeMobiSage IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
}

+ (void)load {
	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isError = NO;
    isReady = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    
    AdViewType type =[configData.ad_type intValue];
    
    CGSize size =CGSizeMake(0, 0);
    NSUInteger adIndex = 0;
    switch (type) {
        case AdViewTypeFullScreen:
            adIndex = Poster_320X480;
            size = CGSizeMake(320.0, 480.0);
            break;
        case AdViewTypeiPadFullScreen:
            adIndex = Poster_640X960;
            size = CGSizeMake(640.0, 960.0);
            break;
        default:
            [interstitial adapter:self didFailAd:nil];
            return;
            break;
    }
    
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30
//                                              target:self
//                                            selector:@selector(loadAdTimeOut:)
//                                            userInfo:nil
//                                             repeats:NO] retain];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
   
    
    [[MobiSageManager getInstance] setPublisherID:[self.ration objectForKey:@"key"]];
    
    adPoster = [[MobiSageAdPoster alloc] initWithAdSize:adIndex
                                           withDelegate:self];

    
    [interstitial adapterDidStartRequestAd:self];
}

- (void)stopBeingDelegate {
    adPoster.delegate = nil;
//    [adPoster release],adPoster = nil;
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}

- (void)stopTimer {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        
    });
    
}

- (void)dealloc {
    isStop = YES;
    if (adPoster) {
        [adPoster release];
        adPoster = nil;
    }
	[super dealloc];
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    [interstitial adapter:self WillPresent:nil];
    [adPoster show];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    isError = YES;
    [interstitial adapter:self didFailAd:nil];
}
#pragma mark -
#pragma mark MobiSageAdPosterDelegate method

- (UIViewController *)viewControllerToPresent{
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    if (viewController.navigationController != nil &&
        viewController.parentViewController != nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return viewController;
}


/**
 *  AdPoster被点击
 *  @param adPoster
 */
- (void)mobiSageAdPosterClick:(MobiSageAdPoster*)adPoster{
    [interstitial specialSendRecordNum];
    
}

/**
 *  AdPoster被关闭
 *  @param adPoster
 */
- (void)mobiSageAdPosterClose:(MobiSageAdPoster*)adPoster{
    [interstitial adapter:self didDismissScreen:self -> adPoster];
}


/**
 *  AdPoster请求成功
 *  @param adPoster
 */
- (void)mobiSageAdPosterSuccessToRequest:(MobiSageAdPoster*)adPoster{
    if (isStop || isError || isReady) {
        return;
    }
    
    [self stopTimer];
    
    isReady = YES;
    
    [interstitial adapter:self didReceiveInterstitialScreenAd:self.adNetworkView];
}


/**
 *  AdPoster请求失败
 *  @param adPoster
 */
- (void)mobiSageAdPosterFaildToRequest:(MobiSageAdPoster*)adPoster{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    isError = YES;
    [interstitial adapter:self didFailAd:nil];
}


#pragma mark -
#pragma mark MobiSageAdView Notification method
- (void)adPosterError:(NSNotification *)notification {
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    isError = YES;
    [interstitial adapter:self didFailAd:nil];
}
- (void)adPosterFinish:(NSNotification *)notification {

    if (isStop || isError || isReady) {
        return;
    }
    
    [self stopTimer];
    
    isReady = YES;
    
    [interstitial adapter:self didReceiveInterstitialScreenAd:self.adNetworkView];
    
}
- (void)adPosterClose:(NSNotification *)notification {
    
    if (isStop ) {
        return;
    }
    [interstitial adapter:self didDismissScreen:self -> adPoster];
    
}

- (void)adClick:(NSNotification *)notification {
    if (isStop) {
        return;
    }
    [interstitial specialSendRecordNum];
}

@end
