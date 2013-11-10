//
//  AdMoGoSplashDelegate.h
//  wanghaotest
//
//  Created by MOGO on 13-6-21.
//
//

#import <Foundation/Foundation.h>
@class AdMoGoSplash;
@protocol AdMoGoSplashDelegate <NSObject>
@required
// 返回开屏广告尺寸
- (CGRect)adMoGoSplashAdSize;
@optional
// UIViewController
- (UIViewController *)adsMoGoSplashAdViewControllerForPresentingModalView;
// 是否可以点击
//- (BOOL)adsMoGoSplashAdCanTap:(AdMoGoSplash *)splashAd;
// 当开屏广告加载成功后，回调该方法
- (void)adsMoGoSplashAdSuccessToLoadAd:(AdMoGoSplash *)splashAd;
// 当开屏广告加载失败后，回调该方法
- (void)adsMoGoSplashAdFailToLoadAd:(AdMoGoSplash *)splashAd withError:(NSError *)err;

// 当插屏广告要被呈现出来前，回调该方法
- (void)adsMoGoSplashAdWillPresentScreen:(AdMoGoSplash *)splashAd;
// 当插屏广告被关闭后，回调该方法
- (void)adsMoGoSplashAdDidDismissScreen:(AdMoGoSplash *)splashAd;

//ipad 屏幕适配 (旋转相关)
//设备旋转 需更换开屏广告的default图片
- (NSString *)adsMoGoSplash:(AdMoGoSplash *)splashAd OrientationDidChangeGetImageName:(UIInterfaceOrientation)interfaceOri;
//如果已展示广告旋转的过程需要调整广告的位置
- (CGPoint)adsMogoSplash:(AdMoGoSplash *)splashAd OrientationDidChangeGetAdPoint:(UIInterfaceOrientation)interfaceOri;
@end
