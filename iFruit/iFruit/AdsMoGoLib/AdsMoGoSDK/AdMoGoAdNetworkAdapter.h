//
//  File: AdMoGoAdNetworkAdapter.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.7
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

/*
    所有适配器父类 old code
 */
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoCore.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"

#ifndef TypeIsSDK
#define TypeIsSDK @"isSDK"
#endif
#ifndef TypeIsAPI
#define TypeIsAPI @"isAPI"
#endif
#ifndef TypeIsBanner
#define TypeIsBanner @"isBanner"
#endif
#ifndef TypeIsFullScreen
#define TypeIsFullScreen @"isFullScreen"
#endif
#ifndef TypeIsAutoOptimize
#define TypeIsAutoOptimize @"isAutoOptimize"
#endif
#ifndef TypeIsS2S
#define TypeIsS2S @"isS2S"
#endif
#ifndef TypeIsVideo
#define TypeIsVideo @"isVideo"
#endif


#ifndef AdapterTimeOut5
#define AdapterTimeOut5 8
#endif

#ifndef AdapterTimeOut15
#define AdapterTimeOut15 15
#endif

#ifndef AdapterTimeOut30
#define AdapterTimeOut30 30
#endif

#ifndef AdapterTimeOut60
#define AdapterTimeOut60 60
#endif


#ifndef AdapterTimeOut8
#define AdapterTimeOut8 8
#endif

#ifndef AdapterTimeOut12
#define AdapterTimeOut12 12
#endif

typedef enum {
	AdMoGoAdNetworkTypeAdMob             = 1,
	AdMoGoAdNetworkTypeJumpTap           = 2,
	AdMoGoAdNetworkTypeVideoEgg          = 3,
	AdMoGoAdNetworkTypeMedialets         = 4,
	AdMoGoAdNetworkTypeLiveRail          = 5,
	AdMoGoAdNetworkTypeMillennial        = 6,
	AdMoGoAdNetworkTypeGreyStripe        = 7,
	AdMoGoAdNetworkTypeQuattro           = 8,
	AdMoGoAdNetworkTypeCustom            = 9,
	AdMoGoAdNetworkTypeAdMoGo10          = 10,
	AdMoGoAdNetworkTypeMobClix           = 11,
	AdMoGoAdNetworkTypeMdotM             = 12,
	AdMoGoAdNetworkTypeAdMoGo13          = 13,
	AdMoGoAdNetworkTypeGoogleAdSense     = 14,
	AdMoGoAdNetworkTypeGoogleDoubleClick = 15,
	AdMoGoAdNetworkTypeGeneric           = 16,
	AdMoGoAdNetworkTypeEvent             = 17,
	AdMoGoAdNetworkTypeInMobi            = 18,
	AdMoGoAdNetworkTypeIAd               = 19,
	AdMoGoAdNetworkTypeZestADZ           = 20,
	
	AdMoGoAdNetworkTypeAdChina      = 21,
	AdMoGoAdNetworkTypeWiAd         = 22,
	AdMoGoAdNetworkTypeWooboo       = 23,
	AdMoGoAdNetworkTypeYouMi        = 24,
	AdMoGoAdNetworkTypeCasee        = 25,
	AdMoGoAdNetworkTypeSmartMAD     = 26,
	AdMoGoAdNetworkTypeMoGo         = 27,
    AdMoGoAdNetworkTypeAdTouch      = 28,
    AdMoGoAdNetworkTypeDoMob        = 29,
    AdMoGoAdNetworkTypeAdOnCN       = 30,
    AdMoGoAdNetworkTypeMobiSage     = 31,
    AdMoGoAdNetworkTypeAirAd        = 32,
    AdMoGoAdNetworkTypeAdwo         = 33,
    AdMoGoAdNetworkTypeSmaato       = 35,
    AdMoGoAdNetworkTypeIZP          = 40,
    AdMoGoAdNetworkTypeBaiduMobAd   = 44,
    AdMoGoAdNetworkTypeExchange     = 45,
    AdMoGoAdNetworkTypeLMMOB        = 46,
    AdMoGoAdNetworkTypePremiumAD    = 48,
    AdMoGoAdNetworkTypeAdFractal    = 50,
    AdMoGoAdNetworkTypeSuiZong      = 51,
    AdMoGoAdNetworkTypeWinsAd       = 52,
    AdMoGoAdNetworkTypeMobWinAd     = 53,
    AdMoGoAdNetworkTypeRecommendAD  = 54,
    AdMoGoAdNetworkTypeUM           = 55,
    AdMoGoAdNetworkTypeWQ           = 56,
    AdMoGoAdNetworkTypeAdermob      = 57,
    AdMoGoAdNetworkTypeAllyesi      = 59,
    AdMoGoAdNetworkTypeAduu         = 60,
    AdMoGoAdNetworkTypeUMAppUnion   = 62,
    AdMoGoAdNetworkTypeMiidi        = 63,
    AdMoGoAdNetworkTypeMogoSTS      = 66,
    AdMoGoAdNetworkTypeAdfonic      = 70,
    AdMoGoAdNetworkTypePunchBox     = 71,
    AdMoGoAdNetworkTypeNokia        = 73,
    AdMoGoAdNetworkTypeChartboost   = 74,
    AdMoGoAdNetworkTypeGuomob       = 75,
    AdMoGoAdNetworkTypeYiTong       = 76,
    AdMoGoadNetworkTypeYiJiFen      = 77,
    AdMoGoAdNetworkTypePuchBox      = 79,
    AdMoGoAdNetworkTypeIWant        = 80,
    AdMoGoAdNetworkTypeWAPS         = 87,
    AdMoGoAdNetworkTypeMIX          = 88,
    AdMoGoAdNetworkTypeLeadBolt     = 89,
    AdMoGoAdNetworkTypeMobFox       = 90,
    AdMoGoAdNetworkTypeMojiva       = 91,
    AdMoGoAdNetworkTypeVungle       = 92,
    AdMoGoAdNetworkTypeZhiXun       = 99,

    AdMoGoAdNetworkTypeS2S_First    = 1000,
    AdMoGoAdNetworkTypeS2S_Last     = 1499,
    AdMoGoAdNetworkTypeAutoOptimization = 2000,
    
    AdMoGoAdNetworkTypeCustomEventPlatform_1 = 0x51,
    AdMoGoAdNetworkTypeCustomEventPlatform_2 = 0x52,
    AdMoGoAdNetworkTypeCustomEventPlatform_3 = 0x53,
    AdMoGoAdNetworkTypeCustomEventPlatform_unknow = 0xfff
    
} AdMoGoAdNetworkType;

@class AdMoGoView;
//@class AdMoGoConfig;
@class AdMoGoCore;
@class AdMoGoAdNetworkConfig;

@interface AdMoGoAdNetworkAdapter : NSObject {
	id<AdMoGoDelegate> adMoGoDelegate;
	AdMoGoView *adMoGoView;
//	AdMoGoConfig *adMoGoConfig;
    AdMoGoCore *adMoGoCore;
//	AdMoGoAdNetworkConfig *networkConfig;
	UIView *adNetworkView;
    NSDictionary *ration;
    id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;
    /*
        2012-9-11 特殊id
     */
    NSString *specialID;
    AdMoGoInterstitial *interstitial;
    id<AdMoGoInterstitialDelegate> adMoGoInterstitialDelegate;
}

+(NSDictionary *)makeNetWorkType:(NSInteger) netType IsSDK:(BOOL)isSDK isApi:(BOOL)isApi isBanner:(BOOL)isBanner isFullScreen:(BOOL)isFullScreen;

+(NSDictionary *)makeNetWorkType:(NSInteger) netType IsSDK:(BOOL)isSDK isApi:(BOOL)isApi isBanner:(BOOL)isBanner isFullScreen:(BOOL)isFullScreen isVideo:(BOOL)isVideo;

+(NSDictionary *)makeNetWorkType:(NSInteger) netType IsSDK:(BOOL)isSDK isApi:(BOOL)isApi isBanner:(BOOL)isBanner isFullScreen:(BOOL)isFullScreen isAutoOptimize:(BOOL) isAutoOptimize isS2S:(BOOL)isS2S;

+(NSDictionary *)makeNetWorkType:(NSInteger) netType IsSDK:(BOOL)isSDK isApi:(BOOL)isApi isBanner:(BOOL)isBanner isFullScreen:(BOOL)isFullScreen isAutoOptimize:(BOOL) isAutoOptimize isS2S:(BOOL)isS2S isVideo:(BOOL)isVideo;

+(NSDictionary *)makeCustomNetWorkType:(NSInteger) netType isFullScreen:(BOOL) isFullScreen;
/*
- (id)initWithAdMoGoDelegate:(id<AdMoGoDelegate>)delegate
						view:(AdMoGoView *)view
					   core:(AdMoGoCore *)core
			   networkConfig:(AdMoGoAdNetworkConfig *)netConf;
*/

- (id)initWithAdMoGoDelegate:(id<AdMoGoDelegate>)delegate
                        view:(AdMoGoView *)view
                        core:(AdMoGoCore *)core
               networkConfig:(NSDictionary *)netConf;

/*
 全屏适配器
 */
- (id)initWithAdMoGoInterstitialDelegate:(id<AdMoGoInterstitialDelegate>)delegate
                            interstitial:(AdMoGoInterstitial *)interstitial
                         networkConfig:(NSDictionary *)netConf;

/*
- (id)initWithAdMoGoDelegateview:(AdMoGoView *)view
					  config:(AdMoGoConfig *)config
                   networkConfig:(AdMoGoAdNetworkConfig *)netConf;
 */
- (void)getAd;
- (void)stopBeingDelegate;
- (void)stopTimer;

- (BOOL)shouldSendExMetric;
- (BOOL)shouldSendExRequest;

- (void)stopAd;
- (BOOL)isReadyPresentInterstitial;
- (void)presentInterstitial;

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;
/*
- (BOOL)isBannerAnimationOK:(AMBannerAnimationType)animType;
*/
//- (NSDictionary *)getDictValue;

@property (nonatomic,assign) id<AdMoGoDelegate> adMoGoDelegate;

@property (nonatomic,assign) AdMoGoView *adMoGoView;
@property (nonatomic,assign) AdMoGoCore *adMoGoCore;
@property (nonatomic,retain) AdMoGoAdNetworkConfig *networkConfig;
@property (nonatomic,retain) UIView *adNetworkView;
@property (nonatomic,retain) NSDictionary *ration;

@property (nonatomic,assign) id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;
/*
 2012-9-11 特殊id
 */
@property (nonatomic,retain) NSString *specialID;



@property (nonatomic,assign) AdMoGoInterstitial *interstitial;
@property (nonatomic,assign) id<AdMoGoInterstitialDelegate> adMoGoInterstitialDelegate;

@end