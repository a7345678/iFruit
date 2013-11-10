//
//  AdMoGoFullScreen.h
//  AdsMogo
//
//  Created by MOGO on 13-2-19.
//
//

#import <Foundation/Foundation.h>
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "AdViewType.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoInterstitialDelegate.h"

@class AdMoGoAdNetworkAdapter;



@interface AdMoGoInterstitial : NSObject{
    BOOL isStop;
    AdMoGoAdNetworkAdapter *adapter;
    NSTimer *timer;
    BOOL isadTaped;
    BOOL isRequest;
}

@property(nonatomic,assign) id<AdMoGoInterstitialDelegate> delegate;

@property(nonatomic,assign) id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;
@property(nonatomic,retain) AdMoGoAdNetworkAdapter *adapter;
@property(nonatomic,retain) NSTimer *timer;
@property (nonatomic,readonly) NSString *configKey;
@property(nonatomic,retain) NSString *mogoAppKey;
/*
    初始化 
    默认轮换 没有轮换间隔时间
    ak:芒果ID
    type:全屏 插屏
    delegate:全屏回调
 */
- (id) initWithAppKey:(NSString *)ak
               adType:(AdViewType)type
   adMoGoViewDelegate:(id<AdMoGoInterstitialDelegate>) delegate;

/*
    初始化
    ak:芒果ID
    refreshed:是否刷新
    adInterval:间隔时间（所有平台都请求失败，并且允许刷新，那么间隔这个时间后在请求全屏）
    type:全屏 插屏
    delegate:全屏回调
 */
- (id) initWithAppKey:(NSString *)ak
            isRefresh:(BOOL)refreshed
          adInterval:(int)adInterval
               adType:(AdViewType)type
   adMoGoViewDelegate:(id<AdMoGoInterstitialDelegate>) delegate;

/*
    展示全屏
 */

-(void) present;

/*
 全屏广告是否准备
 返回YES 表示准备完成 可以展示
 */
-(BOOL) isInterstitialReady;

/*
    非自动刷新下请求插屏
 */
-(void)nofreshRequestInterstitial;

/*
    销毁全屏
 */
-(void) stopInterstitial;

- (void)adapter:(AdMoGoAdNetworkAdapter *)_adapter didFailAd:(NSError *)error;

- (void)adapter:(AdMoGoAdNetworkAdapter *)_adapter didReceiveInterstitialScreenAd:(id)fullScreenAd;

- (void)adapter:(AdMoGoAdNetworkAdapter *)_adapter WillPresent:(id)fullScreenAd;

- (void)adapter:(AdMoGoAdNetworkAdapter *)_adapter didDismissScreen:(id)fullScreenAd;

- (void)adapterAdModal:(AdMoGoAdNetworkAdapter *)_adapter WillPresent:(id)fullScreenAd;

- (void)adapterAdModal:(AdMoGoAdNetworkAdapter *)_adapter didDismissScreen:(id)fullScreenAd;

- (void)adapterMoGoInterstitialAdClose;

- (void)adapterDidStartRequestAd:(AdMoGoAdNetworkAdapter *)_adapter;

/*
 特殊发送
 */
- (void)specialSendRecordNum;

- (void)premiumADClickDict:(NSMutableDictionary *)receiveValue;

-(BOOL)shouldAlertQAView:(UIAlertView *)alertView;

/**
 *播放视频
 */
-(void)playVideoAd;

/*
    暂支持安沃插屏旋转
 */
- (void)interstitialorientationChanged:(UIInterfaceOrientation)orientation;

/*
    s2s的插屏请求统计
 */
- (void)adapterS2SDidStartRequestAd:(AdMoGoAdNetworkAdapter *)_adapter withAdPlatformId:(NSString *)type;


@end
