//
//  AdMoGoAdapterDoMobFullAd.h
//  TestMOGOSDKAPP
//
//  Created by 靳磊 on 12-11-16.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "DMInterstitialAdController.h"
#import "AdMoGoConfigData.h"

@interface AdMoGoAdapterDoMobFullAd : AdMoGoAdNetworkAdapter<DMInterstitialAdControllerDelegate>{
    BOOL isStop;
    DMInterstitialAdController *_dmInterstitial;
    NSTimer *timer;
    BOOL isRequest;
    BOOL isStopTimer;
}

@end
