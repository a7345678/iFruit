//
//  AdMoGoAdapterAdwo.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-10-26.
//  Copyright (c) 2012年 Mogo. All rights reserved.
//


#import "AdMoGoAdNetworkAdapter.h"
#import "AdwoAdSDK.h"

@interface AdMoGoAdapterAdwo :AdMoGoAdNetworkAdapter<AWAdViewDelegate>{
    
    BOOL isSuccess;
    BOOL isStop;
    CGRect frame;
    UIView *adView;
    NSTimer *timer;
    BOOL isStopTimer;
    BOOL isLoaded;
}

@end
