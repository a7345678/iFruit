//  File: BannerAdViewController.h
//  Project: AdsMOGO iPhone Sample
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "cocos2d.h"

@interface BannerAdViewController : UIViewController <AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate>{
    AdMoGoView *adView;
}
@property (nonatomic, retain) AdMoGoView *adView;

+(BannerAdViewController *)sharedInstance;
- (void) setLocation:(CGPoint)pt;
- (void) resetMainViewBanner;

@end
