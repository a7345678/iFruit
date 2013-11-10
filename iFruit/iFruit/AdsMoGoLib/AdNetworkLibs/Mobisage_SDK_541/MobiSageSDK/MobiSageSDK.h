//
//  MobiSageSDK.h
//  MobiSageSDK
//
//  Created by sdk team on 2013/01/22.
//  Copyright (c) 2012 adsage. All rights reserved.
//  Version 5.4.0

#pragma mark - 当前版本支持的广告尺寸
#pragma mark 

#define Ad_Text                                 26    //文字广告
#define Ad_320X50                               38    //iphone 使用的横幅广告尺寸
#define Ad_300X250                              40    //ipad 使用的横幅广告尺寸
#define Ad_468X60                               41    //ipad 使用的横幅广告尺寸
#define Ad_728X90                               42    //ipad 使用的横幅广告尺寸

#define Poster_300X250                          50
#define Poster_320X480                          52
#define Poster_640X960                          53
#define Poster_600X500                          55

#pragma mark - 横幅广告相关枚举变量

/*广告切换动画枚举*/
typedef enum
{
    Random      = 1,        //    随机
    Fade        = 2,        //    淡入淡出
    FlipL2R     = 3,        //    水平翻转从左到右
    FlipT2B     = 4,        //    水平翻转从上到下
    CubeT2B     = 5,        //    立体翻转从左到右
    CubeL2R     = 6,        //    立体翻转从上到下
    Ripple      = 7,        //    水波纹效果
    PageCurl    = 8,        //    翻页效果从下到上
    PageUnCurl  = 9         //    翻页效果从上到下
    
} MobiSageAnimeType;        //    广告切换动画效果

/*广告刷新周期枚举*/
typedef enum
{
    Ad_NO_Refresh = 0,        //    不轮显
    Ad_Refresh_15 = 1,        //    15秒
    Ad_Refresh_20 = 2,        //    20秒
    Ad_Refresh_25 = 3,        //    25秒
    Ad_Refresh_30 = 4,        //    30秒
    Ad_Refresh_60 = 5         //    60秒
    
}MSAdRefreshInterval;         //    广告自动轮显时间


#pragma mark - 开屏广告方向
#pragma mark

#define MobiSage_Orientation_Portrait           1
#define MobiSage_Orientation_Landscape          2

#pragma mark 
#pragma mark MobiSageManager

@interface MobiSageManager : NSObject {
    
}

/**    
 *  获得MobiSage平台管理单例
 */
+(MobiSageManager*)getInstance;


/**    
 *  设置publisherID  
 *  @param publisherID	AC平台分配给应用的id
 */
- (void)setPublisherID:(NSString *)publisherID;

/**    
 *  设置应用分发渠道 
 *  @param deployChannel	分发渠道名称 
 */
- (void)setDeployChannel:(NSString *)deployChannel;

@end


#pragma mark
#pragma mark MobiSageAdBanner

//广告委托
@protocol MobiSageAdViewDelegate <NSObject>

@end

@class MobiSageAdBanner;



@protocol MobiSageAdBannerDelegate <MobiSageAdViewDelegate>

@required

- (UIViewController *)viewControllerToPresent;

@optional
/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageAdBannerClick:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerClose:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner轮播暂停
 *  @param adBanner
 */
- (void)mobiSageAdBannerPause:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner继续轮播广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerContinue:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerSuccessToShowAd:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageAdBannerFaildToShowAd:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageAdBannerPopADWindow:(MobiSageAdBanner*)adBanner;

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerHideADWindow:(MobiSageAdBanner*)adBanner;

@end

@interface MobiSageAdBanner : UIView {
    
}

/**
 *  @param delegate 该广告所使用的委托
 */
@property(nonatomic, assign) id<MobiSageAdBannerDelegate> delegate;

/**    
 *  初始化，并设置广告尺寸  
 *  @param adSize 广告视图大小  
 *  @param delegate 该广告所使用的委托
 */
- (id)initWithAdSize:(NSUInteger)adSize
        withDelegate:(id<MobiSageAdBannerDelegate>)delegate;


/**    
 *  设置广告刷新间隔时间  
 *  @param interval 广告刷新间隔时间，单位是“秒” 
 */
- (void)setInterval:(MSAdRefreshInterval)interval;

/**    
 *  设置多个广告之间过渡（切换）效果 
 *  @param switchAnimeType	多个广告之间过渡（切换）效果  
 */
- (void)setSwitchAnimeType:(MobiSageAnimeType)switchAnimeType;


@end

#pragma mark
#pragma mark MobiSageAdPoster

@class MobiSageAdPoster;

@protocol MobiSageAdPosterDelegate <MobiSageAdViewDelegate>

@required

- (UIViewController *)viewControllerToPresent;

@optional
/**
 *  AdPoster被点击
 *  @param adPoster
 */
- (void)mobiSageAdPosterClick:(MobiSageAdPoster*)adPoster;

/**
 *  AdPoster被关闭
 *  @param adPoster
 */
- (void)mobiSageAdPosterClose:(MobiSageAdPoster*)adPoster;

/**
 *  AdPoster请求成功
 *  @param adPoster
 */
- (void)mobiSageAdPosterSuccessToRequest:(MobiSageAdPoster*)adPoster;

/**
 *  AdPoster请求失败
 *  @param adPoster
 */
- (void)mobiSageAdPosterFaildToRequest:(MobiSageAdPoster*)adPoster;

@end


@interface MobiSageAdPoster : NSObject {
    
}

/**
 *  @param delegate 该广告所使用的委托
 */
@property(nonatomic, assign) id<MobiSageAdPosterDelegate> delegate;


/**    
 *  初始化，并设置广告尺寸  
 *  @param adSize 广告视图大小  
 *  @param delegate 该广告所使用的委托
 */
- (id)initWithAdSize:(NSUInteger)adSize
        withDelegate:(id<MobiSageAdPosterDelegate>)delegate;


/**
 *  展示广告
 */
- (void)show;

@end


#pragma mark
#pragma mark MobiSageAdSplash

@class MobiSageAdSplash;
@protocol MobiSageAdSplashDelegate <MobiSageAdViewDelegate>
@optional
/**
 *  AdSplash展示成功
 *  @param adSplash
 */
- (void)mobiSageAdSplashSuccessToShow:(MobiSageAdSplash*)adSplash;

/**
 *  AdSplash展示失败
 *  @param adSplash
 */
- (void)mobiSageAdSplashFaildToRequest:(MobiSageAdSplash*)adSplash;

/**
 *  AdSplash被点击
 *  @param adSplash
 */
- (void)mobiSageAdSplashClick:(MobiSageAdSplash*)adSplash;

/**
 *  AdSplash被关闭
 *  @param adSplash
 */
- (void)mobiSageAdSplashClose:(MobiSageAdSplash*)adSplash;
@end

@interface MobiSageAdSplash : NSObject {
    
}


/**
 *  开屏广告
 *  可以自定义广告方向
 */
@property(nonatomic, assign) id<MobiSageAdSplashDelegate> delegate;

/**
 *  初始化，并设置广告展示方向和背景
 *  @param Orientation  广告展示方向
 *  @param background   广告背景设置
 *  @param delegate     该广告所使用的委托
 */
- (id)initWithOrientation:(NSInteger)screenOrientation
               background:(UIColor*)bgColor
             withDelegate:(id<MobiSageAdSplashDelegate>)delegate;


/**
 * 开屏广告开始准备展示
 */
- (void)startSplash;

@end


#pragma mark
#pragma mark MobiSageAdWordBanner

@class MobiSageAdWordBanner;

@protocol MobiSageAdWordBannerDelegate <MobiSageAdViewDelegate>

@optional
/**
 *  AdWordBanner被点击
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerClick:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner被关闭
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerClose:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner被暂停
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerPause:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner继续轮播
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerContinue:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner请求广告并成功展示
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerSuccessToShowAd:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner请求广告失败
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerFaildToShowAd:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner被点击后弹出LandingPage
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerPopADWindow:(MobiSageAdWordBanner*)adWordBanner;
/**
 *  AdWordBanner弹出的LandingPage隐藏
 *  @param adWordBanner
 */
- (void)mobiSageAdWordBannerHideADWindow:(MobiSageAdWordBanner*)adWordBanner;

@end

/**
 *  文字链广告
 *  可以自定义任意尺寸、背景色、文字颜色、字体等
 */
@interface MobiSageAdWordBanner : UIView {
    
    
}


/**
 *  delegate 广告视图委托
 */
@property(nonatomic, assign) id<MobiSageAdWordBannerDelegate> delegate;

/**
 *  字体尺寸访问器
 */
@property(nonatomic,assign) NSInteger fontSize;
/**
 *  字体颜色访问器
 */
@property(nonatomic,retain) UIColor *textColor;
/**
 *  背景色访问器
 */
@property(nonatomic,retain) UIColor *backgroundColor;
/**
 *  HTML格式字体颜色访问器,例如#ff0000，或则rgba(0,0,255,1.0)
 */
@property(nonatomic, copy) NSString *textColorForHtml;
/**
 *  HTML格式背景色访问器,例如#ff0000，或则rgba(0,255,0,1.0)
 */
@property(nonatomic, copy) NSString *backgroundColorForHtml;


/**
 *  使用指定frame初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param delegate 该广告所使用的委托
 */
- (id)initWithFrame:(CGRect)frame
       withDelegate:(id<MobiSageAdWordBannerDelegate>)delegate;



/**    
 *  使用指定参数初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param delegate 该广告所使用的委托
 *  @param iFontSize 字体大小
 *  @param strTextColor HTML格式的字体颜色
 *  @param strBackgroundColor HTML格式的背景色
 *  @note 该方法可使用HTML中的颜色格式
 */
- (id)initWithFrame:(CGRect)frame
       withDelegate:(id<MobiSageAdWordBannerDelegate>)delegate
           fontSize:(NSInteger)iFontSize
   textColorForHtml:(NSString *)strTextColor
backgroundColorForHtml:(NSString *)strBackgroundColor;


/**    
 *  使用指定参数初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param delegate 该广告所使用的委托
 *  @param iFontSize 字体大小
 *  @param textColor 字体颜色
 *  @param backgroundcolor 背景色
 *  @note 该方法可使用iOS程序员熟悉的颜色格式
 */
- (id)initWithFrame:(CGRect)frame
       withDelegate:(id<MobiSageAdWordBannerDelegate>)delegate
           fontSize:(NSInteger)iFontSize
          textColor:(UIColor *)textColor
    backgroundColor:(UIColor *)backgroundcolor;


@end



#pragma mark - 荐计划广告
#pragma mark 

@protocol MobiSageRecommendDelegate <NSObject>

@required
/**
 *  嵌入应用推荐界面对象中实现Delegate
 */
- (UIViewController *)viewControllerForPresentingModalView;


@optional
/**
 *  应用推荐界面打开时调用
 */
- (void)MobiSageWillOpenRecommendModalView;
/**
 *  应用推荐界面打开失败时调用
 */
- (void)MobiSageFailToOpenRecommendModalView;
/**
 *  应用推荐界面关闭时调用
 */
- (void)MobiSageDidCloseRecommendModalView;

@end


//弹出式荐计划
@interface MobiSageRecommendView : UIControl
{
    
}

/**
 *  初始化应用推荐功能
 *  @param delegate	设置委托
 */
- (id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate;


/**
 *  初始化应用推荐功能
 *  @param delegate	设置委托
 *  @param image	设置点击图片
 */
- (id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate
                andImg:(UIImage*)image;


/**
 *  弹出应用推荐页面
 */
- (void)OpenAdSageRecmdModalView;

@end

//表格式荐计划
@interface MSRecommendContentView : UIView {
    
}

/**
 *  构造一个表格形式的荐计划
 *  @param delegate	表格荐计划的委托
 *  @param iWidth	表格荐计划视图的宽度
 *  @param iAdCount	表格荐计划展示的广告个数;每个广告高度是157,开发者根据选择的广告个数计算相应的高度
 */
- (id)initWithdelegate:(id<MobiSageRecommendDelegate>)delegate
                 width:(float)width
               adCount:(NSInteger)iAdCount;
@end


