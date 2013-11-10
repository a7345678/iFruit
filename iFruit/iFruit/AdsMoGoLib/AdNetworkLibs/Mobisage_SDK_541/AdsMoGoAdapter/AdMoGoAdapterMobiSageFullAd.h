//
//  AdMoGoAdapterMobiSageFullAd.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "MobiSageSDK.h"
@interface AdMoGoAdapterMobiSageFullAd : AdMoGoAdNetworkAdapter<MobiSageAdPosterDelegate>
{
    NSTimer *timer;
    BOOL isStop;
    BOOL isError;
    BOOL isReady;
    MobiSageAdPoster *adPoster;
}

+ (NSDictionary *)networkType;

- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
