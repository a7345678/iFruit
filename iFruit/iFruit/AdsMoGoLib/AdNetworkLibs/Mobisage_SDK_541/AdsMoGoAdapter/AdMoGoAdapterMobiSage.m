//  File: AdMoGoAdapterMobiSage.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Copyright 2011 AdsMogo.com. All rights reserved.


#import "AdMoGoAdapterMobiSage.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

static BOOL isloaded = false;
@implementation AdMoGoAdapterMobiSage
+ (NSDictionary *)networkType {
    return [self makeNetWorkType:AdMoGoAdNetworkTypeMobiSage IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
}

+ (void)load {
	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isStopTimer = NO;
    isSuccess = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	[adMoGoCore adapter:self didGetAd:@"mobisage"];

    AdViewType type =[configData.ad_type intValue];
    
    CGSize size =CGSizeMake(0, 0);
    NSUInteger adIndex = 0;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            adIndex = Ad_320X50;
            size = CGSizeMake(320, 50);
            break;
        case AdViewTypeRectangle:
            adIndex = Ad_300X250;
            size = CGSizeMake(300, 250);
            break;
        case AdViewTypeMediumBanner:
            adIndex = Ad_468X60;
            size = CGSizeMake(468, 60);
            break;
        case AdViewTypeLargeBanner:
            adIndex = Ad_728X90;
            size = CGSizeMake(728, 90);
            break;
        default:
            break;
    }
    
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut12
//                                              target:self
//                                            selector:@selector(loadAdTimeOut:)
//                                            userInfo:nil
//                                             repeats:NO] retain];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
   
        
    [[MobiSageManager getInstance] setPublisherID:[self.ration objectForKey:@"key"]];

    
    adView = [[MobiSageAdBanner alloc] initWithAdSize:adIndex
                                         withDelegate:self];
    [adView setInterval:Ad_NO_Refresh];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [view addSubview:adView];
    self.adNetworkView = view;
    [adView release];
    [view release];
}

- (void)stopBeingDelegate {
    MobiSageAdBanner *_adView = (MobiSageAdBanner *)[[self.adNetworkView subviews] lastObject];
	if (_adView != nil) {
        _adView.delegate = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc {
    isStop = YES;
	[super dealloc];
}

#pragma mark -
#pragma mark MobiSageAdViewDelegate method
//    注意:此处返回的 UIViewController 必须为 window 的 rootViewController,
//    如不是,请使用以 下方式替代 return self;否则会导致点击横幅广告后广告详细页面显示异常。
//    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] navigationController];
- (UIViewController *)viewControllerToPresent{
    UIViewController *rootCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootCon == nil) {
        rootCon = [adMoGoDelegate viewControllerForPresentingModalView];
    }
    return rootCon;
}

#pragma mark -
#pragma mark MobiSageAdBannerDelegate method

/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageAdBannerClick:(MobiSageAdBanner*)adBanner{
}

/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerSuccessToShowAd:(MobiSageAdBanner*)adBanner{
    if (isSuccess) {
        return;
    }
    isSuccess = YES;
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageAdBannerFaildToShowAd:(MobiSageAdBanner*)adBanner{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageAdBannerPopADWindow:(MobiSageAdBanner*)adBanner{
    if (isStop) {
        return;
    }
    [adMoGoCore stopTimer];
    [self helperNotifyDelegateOfFullScreenModal];
}

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerHideADWindow:(MobiSageAdBanner*)adBanner{
    if (isStop) {
        return;
    }
    [adMoGoCore fireTimer];
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}




///**
// *  adBanner被关闭
// *  @param adBanner
// */
//- (void)mobiSageAdBannerClose:(MobiSageAdBanner*)adBanner{
//    NSLog(@"%s",__FUNCTION__);
//}
//
///**
// *  adBanner轮播暂停
// *  @param adBanner
// */
//- (void)mobiSageAdBannerPause:(MobiSageAdBanner*)adBanner{
//    NSLog(@"%s",__FUNCTION__);
//}
//
///**
// *  adBanner继续轮播广告
// *  @param adBanner
// */
//- (void)mobiSageAdBannerContinue:(MobiSageAdBanner*)adBanner{
//    NSLog(@"%s",__FUNCTION__);
//}



@end
