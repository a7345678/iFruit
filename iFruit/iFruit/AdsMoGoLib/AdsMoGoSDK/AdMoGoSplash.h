//
//  AdMoGoSplash.h
//  wanghaotest
//
//  Created by MOGO on 13-6-21.
//
//

#import <Foundation/Foundation.h>
#import "AdMoGoSplashDelegate.h"
#import "AdMoGoSplashConfigInfDelegate.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
typedef void (^ AdMoGoSplashViewReset)(UIView *);
@interface AdMoGoSplash : NSObject<AdMoGoSplashConfigInfDelegate>

@property (nonatomic, assign) BOOL isReady; // 可以通过该属性获知开屏广告是否可以展现
@property (nonatomic, assign) id<AdMoGoSplashDelegate> delegate; // 指定开屏广告的委派
@property (nonatomic, assign) id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;

- (id) initWithAppKey:(NSString *)ak
        adMoGoSplashDelegate:(id<AdMoGoSplashDelegate>) delegate
        window:(UIWindow *)window;
// 请求广告
- (void) requestAd :(NSString *)imageName andType:(NSString *)type;
// 对广告视图重新设置
- (void)setAdMoGoSplashViewReset:(AdMoGoSplashViewReset)resetBlock_;
@end
