//
//  AdMoGoAdapterAdwoFullAd.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdwoAdSDK.h"

@interface AdMoGoAdapterAdwoFullAd:AdMoGoAdNetworkAdapter<AWAdViewDelegate>{
    BOOL isSuccess;
    BOOL isFail;
    BOOL isDelloced;
    BOOL isStop;
//    UIView *adFullScreenView;
    NSTimer *timer;
//    BOOL isReady;
    BOOL isStopTimer;
}
@end
