//  File: BannerAdViewController.m
//  Project: AdsMOGO iPhone Sample
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "BannerAdViewController.h"


@implementation BannerAdViewController
@synthesize adView;

static BannerAdViewController *sharedBannerAdViewController = nil;

+(BannerAdViewController *)sharedInstance{
    if (!sharedBannerAdViewController) {
        sharedBannerAdViewController = [[BannerAdViewController alloc] init];
    }
    return sharedBannerAdViewController;
}

- (void)dealloc
{
    adView.delegate = nil;
    adView.adWebBrowswerDelegate = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    adView = [[AdMoGoView alloc] initWithAppKey:isPad?MoGo_ID_IPAD:MoGo_ID
                                         adType:isPad?AdViewTypeLargeBanner:AdViewTypeNormalBanner                                adMoGoViewDelegate:self];
    adView.adWebBrowswerDelegate = self;
    
//    typedef enum {
//        AdViewTypeUnknown = 0,          //error
//        AdViewTypeNormalBanner = 1,     //e.g. 320 * 50 ; 320 * 48  iphone banner  
//        AdViewTypeLargeBanner = 2,      //e.g. 728 * 90 ; 768 * 110 ipad only
//        AdViewTypeMediumBanner = 3,     //e.g. 468 * 60 ; 508 * 80  ipad only
//        AdViewTypeRectangle = 4,        //e.g. 300 * 250; 320 * 270 ipad only 
//        AdViewTypeSky = 5,              //Don't support
//        AdViewTypeFullScreen = 6,       //iphone full screen ad
//        AdViewTypeVideo = 7,            //Don't support
//        AdViewTypeiPadNormalBanner = 8, //ipad use iphone banner
//    } AdViewType;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    if(isPad) adView.frame = CGRectMake(0.0, 0.0, size.width, 110);
    else adView.frame = CGRectMake(0.0, 0.0, size.width, 50.0);
    
    [self.view addSubview:adView];
    [adView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setLocation:(CGPoint)pt {
    
    CGRect rect;
    if(isPad){
        rect = CGRectMake(pt.x+20, pt.y, self.adView.frame.size.width, self.adView.frame.size.height);
    }else{
        rect = CGRectMake(pt.x, pt.y, self.adView.frame.size.width, self.adView.frame.size.height);
    }
    
    self.adView.frame = rect;
}

- (void)resetMainViewBanner {
    CGSize size = [[CCDirector sharedDirector] winSize];
    int x = size.width;
    if(isPad || iPhone5) x = 0;
    [[BannerAdViewController sharedInstance] setLocation:CGPointMake(x, 0)];
}

#pragma mark -
#pragma mark AdMoGoDelegate delegate 
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}



/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    NSLog(@"点击广告回调");
}
/**
 *You can get notified when the user delete the ad 
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告关闭回调");
}

#pragma mark -
#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate 

/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

- (void)webBrowserShare:(NSString *)url{
    
}

@end
