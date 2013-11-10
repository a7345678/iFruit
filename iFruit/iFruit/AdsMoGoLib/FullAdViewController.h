//  File: FullAdViewController.h
//  Project: AdsMOGO iPhone Sample
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"

@interface FullAdViewController : UIViewController <AdMoGoInterstitialDelegate,AdMoGoWebBrowserControllerUserDelegate>{
    AdMoGoInterstitial *interstitial;
}
@property (nonatomic, retain) AdMoGoInterstitial *interstitial;

+(FullAdViewController *)sharedInstance;
- (IBAction)showInterstitial:(id)sender;

@end
