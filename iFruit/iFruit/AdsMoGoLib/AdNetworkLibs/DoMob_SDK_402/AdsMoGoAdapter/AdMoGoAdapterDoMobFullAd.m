//
//  AdMoGoAdapterDoMobFullAd.m
//  TestMOGOSDKAPP
//
//  Created by 靳磊 on 12-11-16.
//
//

#import "AdMoGoAdapterDoMobFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
@implementation AdMoGoAdapterDoMobFullAd

+ (NSDictionary *)networkType{
    return [self makeNetWorkType:AdMoGoAdNetworkTypeDoMob IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
}

+ (void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isRequest = NO;
    isStopTimer = NO;
    //获取用于展示插屏的UIViewController

    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    }

    if(uiViewController){
        
        AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
        
        AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
        
        AdViewType type =[configData.ad_type intValue];
        NSString *publishId = nil;
        NSString *placementId = nil;
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSDictionary class]]) {
            publishId  = [key objectForKey:@"PublisherId"];
            placementId = [key objectForKey:@"PlacementId"];
        }
        else{
            [interstitial adapter:self didFailAd:nil];
        }
        if (_dmInterstitial == nil) {
            switch (type) {
                case AdViewTypeFullScreen:
                    _dmInterstitial = [[DMInterstitialAdController alloc]
                                       initWithPublisherId:publishId                  
                                       placementId:placementId
                                       rootViewController:uiViewController
                                       size:DOMOB_AD_SIZE_300x250];
                    break;
                case AdViewTypeiPadFullScreen:
                    _dmInterstitial = [[DMInterstitialAdController alloc]
                                       initWithPublisherId:publishId
                                       placementId:placementId
                                       rootViewController:uiViewController
                                       size:DOMOB_AD_SIZE_600x500];
                    break;
                default:
                    [interstitial adapter:self didFailAd:nil];
            }
            // 设置插屏广告的Delegate
            _dmInterstitial.delegate = self;
        }
        
        
        
        //开始加载广告
        [_dmInterstitial loadAd];
        [interstitial adapterDidStartRequestAd:self];
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [interstitial adapter:self didFailAd:nil];
    }
}

-(void)stopBeingDelegate{
    if(_dmInterstitial){
        _dmInterstitial.delegate = nil;
        [_dmInterstitial release],_dmInterstitial = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    
}

- (void)dealloc {
    if(_dmInterstitial){
        _dmInterstitial.delegate = nil;
        [_dmInterstitial release],_dmInterstitial = nil;
    }
    
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return _dmInterstitial.isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    [_dmInterstitial present];
}

#pragma mark DoMob Delegate
// 当插屏广告被成功加载后，回调该方法
- (void)dmInterstitialSuccessToLoadAd:(DMInterstitialAdController *)dmInterstitial{
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    
//    [self helperNotifyDelegateOfFullScreenAdModal];
    [interstitial adapter:self didReceiveInterstitialScreenAd:dmInterstitial];
}
// 当插屏广告加载失败后，回调该方法
- (void)dmInterstitialFailToLoadAd:(DMInterstitialAdController *)dmInterstitial withError:(NSError *)err{
    if(isStop){
        return;
    }
    
    [self stopTimer];
    if (!isRequest) {
        isRequest = YES;
    }else{
        return;
    }
    [interstitial adapter:self didFailAd:nil];
}

// 当插屏广告要被呈现出来前，回调该方法
- (void)dmInterstitialWillPresentScreen:(DMInterstitialAdController *)dmInterstitial{
    [interstitial adapter:self WillPresent:dmInterstitial];
}
// 当插屏广告被关闭后，回调该方法
- (void)dmInterstitialDidDismissScreen:(DMInterstitialAdController *)dmInterstitial{
    [interstitial adapter:self didDismissScreen:dmInterstitial];
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
- (void)dmInterstitialWillPresentModalView:(DMInterstitialAdController *)dmInterstitial{
    [interstitial adapterAdModal:self WillPresent:dmInterstitial];
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
- (void)dmInterstitialDidDismissModalView:(DMInterstitialAdController *)dmInterstitial{
    [interstitial adapterAdModal:self didDismissScreen:dmInterstitial];
}


// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
- (void)dmInterstitialApplicationWillEnterBackground:(DMInterstitialAdController *)dmInterstitial{
    
}

- (void)dmInterstitialDidClicked:(id)dmInterstitial{
    [interstitial specialSendRecordNum];
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

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}
@end
