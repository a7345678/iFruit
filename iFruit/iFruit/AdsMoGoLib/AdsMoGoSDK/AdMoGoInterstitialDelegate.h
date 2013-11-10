//
//  AdMoGoInterstitialDelegate.h
//  wanghaotest
//
//  Created by MOGO on 13-2-20.
//
//

#import <Foundation/Foundation.h>

@class AdMoGoInterstitial;

@protocol AdMoGoInterstitialDelegate <NSObject>

@required

/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingInterstitialModalView;



@optional

/*
    全屏广告开始请求
 */
- (void)adsMoGoInterstitialAdDidStart;

/*
    全屏广告准备完毕
 */
- (void)adsMoGoInterstitialAdIsReady;

/*
    全屏广告接收成功
 */
- (void)adsMoGoInterstitialAdReceivedRequest;

/*
    全屏广告将要展示
 */
- (void)adsMoGoInterstitialAdWillPresent;

/*
    全屏广告接收失败
 */
- (void)adsMoGoInterstitialAdFailedWithError:(NSError *) error;

/*
    全屏广告消失
 */
- (void)adsMoGoInterstitialAdDidDismiss;

/*
    全屏广告浏览器展示
 */
- (void)adsMoGoWillPresentInterstitialAdModal;

/*
    全屏广告浏览器消失
 */
- (void)adsMoGoDidDismissInterstitialAdModal;

/*
    芒果广告关闭
 */
- (void)adsMogoInterstitialAdClosed;

/**
 *视频广告加载成功
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial didLoadVideoAd:(NSURL *)url;
/**
 *视频广告加载失败
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial failLoadVideoAd:(NSURL *)url;
/**
 *视频广告开始播放
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial didPlayVideoAd:(NSURL *)url;
/**
 *视频广告播放完成
 */
-(void)adsMogoInterstitial:(AdMoGoInterstitial *)adMoGoInterstitial finishVideoAd:(NSURL *)url;

/*
    芒果广告轮空回调
 */
- (void)adsMogoInterstitialAdAllAdsFail:(NSError *) error;

-(BOOL)interstitialShouldAlertQAView:(UIAlertView *)alertView;

@end
