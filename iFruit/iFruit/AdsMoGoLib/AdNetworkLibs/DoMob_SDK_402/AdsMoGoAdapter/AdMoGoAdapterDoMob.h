//
//  AdMoGoAdapterDoMob.h
//  TestMOGOSDKAPP
//
//  Created by 孟令之 on 12-11-16.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "DMAdView.h"
#import "AdMoGoConfigData.h"

@interface AdMoGoAdapterDoMob : AdMoGoAdNetworkAdapter<DMAdViewDelegate>{
    DMAdView *dmAdView;
    AdMoGoConfigData *configData;
    BOOL isStop;
    NSTimer *timer;
    BOOL isStopTimer;
}
+ (NSDictionary *)networkType;
@end
