//
//  AdMoGoAdapterAdwo.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-10-26.
//  Copyright (c) 2012年 Mogo. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdapterAdwo.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
extern BOOL AdwoAdSetAGGChannel(UIView *adView, enum ADWOSDK_AGGREGATION_CHANNEL channel);

static NSString* const adwoResponseErrorInfoList[] = {
    @"操作成功",
    @"广告初始化失败",
    @"当前广告已调用了加载接口",
    @"不该为空的参数为空",
    @"参数值非法",
    @"非法广告对象句柄",
    @"代理为空或adwoGetBaseViewController方法没实现",
    @"非法的广告对象句柄引用计数",
    @"意料之外的错误",
    @"已创建了过多的Banner广告，无法继续创建",
    @"广告加载失败",
    @"全屏广告已经展示过",
    @"全屏广告还没准备好来展示",
    @"全屏广告资源破损",
    @"开屏全屏广告正在请求",
    @"当前全屏已设置为自动展示",
    
    @"服务器繁忙",
    @"当前没有广告",
    @"未知请求错误",
    @"PID不存在",
    @"PID未被激活",
    @"请求数据有问题",
    @"接收到的数据有问题",
    @"当前IP下广告已经投放完",
    @"当前广告都已经投放完",
    @"没有低优先级广告",
    @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
    @"服务器响应出错",
    @"设备当前没连网络，或网络信号不好",
    @"请求URL出错"
};

@implementation AdMoGoAdapterAdwo

+ (NSDictionary *)networkType {
	return [self makeNetWorkType:AdMoGoAdNetworkTypeAdwo IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
}

+(void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    
    isSuccess = NO;
    isStop = NO;
    isStopTimer = NO;
    isLoaded = NO;
    [adMoGoCore adDidStartRequestAd];
	[adMoGoCore adapter:self didGetAd:@"adwo"];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type = [configData.ad_type intValue];
    
    enum ADWO_ADSDK_BANNER_SIZE  adwo_ad_type;
    
    //set frame
    frame = CGRectZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            adwo_ad_type = ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case AdViewTypeiPadNormalBanner:
            adwo_ad_type = ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case AdViewTypeLargeBanner:
            adwo_ad_type = ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110;
            frame = CGRectMake(0.0, 0.0, 720.0, 110.0);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    NSString *pid = [self.ration objectForKey:@"key"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
//    adView = [[AWAdView alloc]initWithAdwoPid:pid adTestMode:!testMode];
    adView = AdwoAdCreateBanner(pid, !testMode, self);
    AdwoAdSetAGGChannel(adView,ADWOSDK_AGGREGATION_CHANNEL_MOGO);
    NSLog(@"create adview %@",adView);
    
    if(adView){
        BOOL islocation = [configData islocationOn];
        if (islocation) {
//            adView.disableGPS = NO;
            AdwoAdSetAdAttributes(adView, &(struct AdwoAdPreferenceSettings){
                .disableGPS = NO                                       // 禁用GPS导航功能
            });
        }else{
//            adView.disableGPS = YES;
            AdwoAdSetAdAttributes(adView, &(struct AdwoAdPreferenceSettings){
                .disableGPS = YES                                       // 禁用GPS导航功能
            });
        }
        

        
        adView.frame = frame;
        AdwoAdLoadBannerAd(adView, adwo_ad_type);

        
        
    }else {
        [self  stopTimer];
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    

}


#pragma mark AWAdView delegate

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
 */
- (UIViewController*)adwoGetBaseViewController{
    
    if (isStop) {
        return nil;
    }
    
    return [adMoGoDelegate viewControllerForPresentingModalView];
}



/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView_{
    int errCode = AdwoAdGetLatestErrorCode();
    NSLog(@"Ad request failed, because: %@", adwoResponseErrorInfoList[errCode]);
    if(isStop){
        return;
    }
    [self stopTimer];

    if (AdwoAdPauseBannerRequest(adView)) {
        
    }

    
    [adMoGoCore adapter:self didFailAd:nil];

}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)_adView{
    isLoaded = YES;
    if(isStop){
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    _adView.frame = frame;
    [adMoGoCore adapter:self didReceiveAdView:_adView waitUntilDone:YES];
    isSuccess = YES;
    if (AdwoAdPauseBannerRequest(adView)) {
        
    }
}



/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
 */
- (void)adwoDidPresentModalViewForAd:(UIView*)adView{
    if (isStop) {
        return;
    }
    [self helperNotifyDelegateOfFullScreenModal];

}   

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
 */
- (void)adwoDidDismissModalViewForAd:(UIView*)adView{
    if (isStop) {
        return;
    }

}

-(void)stopAd{
    isStop = YES;
    [self stopTimer];
    if(adView){
        AdwoAdPauseBannerRequest(adView);
    }
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
    }else{
        return;
    }
    
}

-(void)stopBeingDelegate{
    /*2013*/
    if(adView){
        AdwoAdRemoveAndDestroyBanner(adView);
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    NSLog(@"请求超时");
    if (isStop || isLoaded) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

-(void)dealloc{
    [self stopTimer];
    [super dealloc];
}

@end
