//  File: FullAdViewController.m
//  Project: AdsMOGO iPhone Sample
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "FullAdViewController.h"


@implementation FullAdViewController
@synthesize interstitial;

static FullAdViewController *sharedFullAdViewController = nil;

+(FullAdViewController *)sharedInstance{
    if (!sharedFullAdViewController) {
        sharedFullAdViewController = [[FullAdViewController alloc] init];
    }
    return sharedFullAdViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    interstitial.delegate = nil;
    interstitial.adWebBrowswerDelegate = nil;
    [interstitial stopInterstitial];
    [interstitial release];
    interstitial = nil;
    
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
    interstitial = [[AdMoGoInterstitial alloc]
              initWithAppKey:MoGo_ID
              isRefresh:YES
              adInterval:20
              adType:AdViewTypeFullScreen
              adMoGoViewDelegate:self];
    /*
     默认请求时间10秒 设置刷新
     interstitial =  [[AdMoGoInterstitial alloc]
                        initWithAppKey:@"bb0bf739cd8f4bbabb74bbaa9d2768bf"
                        adType:AdViewTypeFullScreen
                        adMoGoViewDelegate:self];
     */
    interstitial.adWebBrowswerDelegate = self;
    
//    UIButton *Interstitialbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [Interstitialbutton setTitle:@"展示全屏插屏" forState:UIControlStateNormal];
//    [Interstitialbutton setFrame:CGRectMake(0.0, 0.0, 100.0, 40.0)];
//    [Interstitialbutton setCenter:CGPointMake(160.0, 50.0)];
//    [Interstitialbutton addTarget:self action:@selector(showInterstitial:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:Interstitialbutton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// 兼容iOS6.0以下系统
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [interstitial interstitialorientationChanged:interfaceOrientation];
    
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

// 兼容iOS6.0及以上版本
- (BOOL)shouldAutorotate
{
    // 开发者可以根据自己当前视图所支持屏幕方向的需求来做相应处理
    UIInterfaceOrientation currOrientation = self.interfaceOrientation;
    
    if(currOrientation == UIInterfaceOrientationPortrait || currOrientation == UIInterfaceOrientationPortraitUpsideDown || currOrientation == UIInterfaceOrientationLandscapeLeft || currOrientation == UIInterfaceOrientationLandscapeRight)
    {
        //        [AdwoFSAdContainer receiveOrientation:currOrientation];
        [interstitial interstitialorientationChanged:currOrientation];
        return YES;
    }
    
    return NO;
}

- (IBAction)showInterstitial:(id)sender{
    if (interstitial) {
        if ([interstitial isInterstitialReady]) {
            [interstitial present];
        }
    }
}

/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    return self;
}

/*
 全屏广告开始请求
 */
- (void)adsMoGoInterstitialAdDidStart{
    NSLog(@"MOGO Full Screen Start");
    
}

/*
 全屏广告准备完毕
 */
- (void)adsMoGoInterstitialAdIsReady{
    NSLog(@"MOGO Full Screen IsReady");
    
}

/*
 全屏广告接收成功
 */
- (void)adsMoGoInterstitialAdReceivedRequest{
    NSLog(@"MOGO Full Screen Received");
    
}

/*
 全屏广告将要展示
 */
- (void)adsMoGoInterstitialAdWillPresent{
    NSLog(@"MOGO Full Screen Will Present");
}


/*
 全屏广告接收失败
 */
- (void)adsMoGoInterstitialAdFailedWithError:(NSError *) error{
    NSLog(@"MOGO Full Screen Failed");
    
}


/*
 全屏广告消失
 */
- (void)adsMoGoInterstitialAdDidDismiss{
    NSLog(@"MOGO Full Screen Dismiss");
}

/*
 全屏广告浏览器展示
 */
- (void)adsMoGoWillPresentInterstitialAdModal{
    NSLog(@"MOGO AdModal Screen Present");
}
/*
 全屏广告浏览器消失
 */
- (void)adsMoGoDidDismissInterstitialAdModal{
    NSLog(@"MOGO AdModal Screen Dismiss");
}


@end
