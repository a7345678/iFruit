//
//  AdwoAdSDK.h
//  Adwo SDK 5.0
//
//  Created by zenny_chen on 12-8-17.
//  Copyright (c) 2012年Adwo. All rights reserved.
//
/////////////////////// NOTES /////////////////////////////

/**
 * !!IMPORTANT!!
 * 本次SDK将仅支持XCode4.5或更高版本，支持iOS 6.0，并且最低支持iOS 4.3系统。
 * 注意！本SDK以及附属的Demo属于本公司机密，未经许可不得擅自发布！
 * Release Notes：
 * 添加了Social.framework框架，此框架必须设置为可选的（Optional），否则如果以默认的Required加入会导致iOS6.0以下系统运行崩溃。
 * 在AWAdViewDelegate中增加了必须实现的adwoGetBaseViewController接口。
 
 * 必须添加的框架：
 * AddressBook.framework
 * AdSupport.framework
 * AudioToolbox.framework
 * AVFoundation.framework
 * CoreMedia.framework
 * CoreTelephony.framework
 * EventKit.framework
 * PassKit.framework
 * QuartzCore.framework
 * StoreKit.framework
 * SystemConfiguration.framework
 * Social.framework（将required变为optional）
*/

#import <UIKit/UIKit.h>


// Adwo Ad SDK版本号的数值表示
#define ADWO_SDK_VERSION                    0x50

// Adwo Ad SDK版本号的字符串表示
#define ADWO_SDK_VERSION_STRING             @"5.0"

// Adwo Ad SDK Binary Bit
#define ADWO_SDK_BINARY_BIT                 32


// 如果你的程序工程中没有包含CoreLocation.frameowrk，
// 那么把下面这个宏写到你的AppDelegate.m或ViewController.m中类实现的上面空白处。
// 如果已经包含了CoreLocation.framework，那么请不要在其它地方写这个宏。
// 注意：这个宏不能写在类中，也不能写在函数或方法中。详细用法请参考AdwoSDKBasic这个Demo～
#define ADWO_SDK_WITHOUT_CORE_LOCATION_FRAMEWORK(...)    \
@interface CLLocationManager : NSObject             \
                                                    \
@end                                                \
                                                    \
@implementation CLLocationManager                   \
                                                    \
@end                                                \
                                                    \
double kCLLocationAccuracyBest = 0.0;

// 如果你不想添加PassKit.framework，那么需要在你的ViewController.m或AppDelegate.m中加入这个宏
// 详细用法请参考AdwoSDKBasic这个Demo～
#define ADWO_SDK_WITHOUT_PASSKIT_FRAMEWORK(...)     \
@interface PKAddPassesViewController : NSObject     \
@end                                                \
                                                    \
@implementation PKAddPassesViewController           \
@end                                                \
                                                    \
@interface PKPass : NSObject                        \
                                                    \
@end                                                \
                                                    \
@implementation PKPass                              \
                                                    \
@end


#define ADWOSDK_DUMMYLAUNCHINGAD_VIEW_TAG           0x542B

enum ADWO_ADSDK_ERROR_CODE
{
    // General error code
    ADWO_ADSDK_ERROR_CODE_SUCCESS,                  // 操作成功
    ADWO_ADSDK_ERROR_CODE_INIT_FAILED,              // 广告对象初始化失败
    ADWO_ADSDK_ERROR_CODE_AD_HAS_BEEN_LOADED,       // 已经用当前广告对象调用了加载接口
    ADWO_ADSDK_ERROR_CODE_NULL_PARAMS,              // 不该为空的参数为空
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_PARAMETER,        // 参数值非法
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_HANDLE,           // 非法广告对象句柄
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_DELEGATE,         // 代理为空或adwoGetBaseViewController方法没实现
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_ADVIEW_RETAIN_COUNT,  // 非法的广告对象句柄引用计数
    ADWO_ADSDK_ERROR_CODE_UNEXPECTED_ERROR,         // 意料之外的错误
    ADWO_ADSDK_ERROR_CODE_TOO_MANY_BANNERS,         // 已创建了过多的Banner广告，无法继续创建
    ADWO_ADSDK_ERROR_CODE_LOAD_AD_FAILED,           // 广告加载失败
    ADWO_ADSDK_ERROR_CODE_FS_AD_HAS_BEEN_SHOWN,     // 全屏广告已经被展示过
    ADWO_ADSDK_ERROR_CODE_FS_AD_NOT_READY_TO_SHOW,  // 全屏广告还没准备好展示
    ADWO_ADSDK_ERROR_CODE_FS_RESOURCE_DAMAGED,      // 全屏广告资源破损
    ADWO_ADSDK_ERROR_CODE_FS_LAUNCHING_AD_REQUESTING,    // 开屏全屏广告正在请求
    ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW,     // 当前全屏已设置为自动展示
    
    // Server request relevant error code
    ADWO_ADSDK_ERROR_CODE_REQUEST_SERVER_BUSY,      // 服务器繁忙
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD,            // 当前没有广告
    ADWO_ADSDK_ERROR_CODE_REQUEST_UNKNOWN_ERROR,    // 未知请求错误
    ADWO_ADSDK_ERROR_CODE_REQUEST_INEXIST_PID,      // PID不存在
    ADWO_ADSDK_ERROR_CODE_REQUEST_INACTIVE_PID,     // PID未被激活
    ADWO_ADSDK_ERROR_CODE_REQUEST_REQUEST_DATA,     // 请求数据有问题
    ADWO_ADSDK_ERROR_CODE_REQUEST_RECEIVED_DATA,    // 接收到的数据有问题
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_IP,         // 当前IP下广告已经投放完
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_POOL,       // 当前广告都已经投放完
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_LOW_RANK,   // 没有低优先级广告
    ADWO_ADSDK_ERROR_CODE_REQUEST_BUNDLE_ID,        // 开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致
    ADWO_ADSDK_ERROR_CODE_REQUEST_RESPONSE_ERROR,   // 服务器响应出错
    ADWO_ADSDK_ERROR_CODE_REQUEST_NETWORK_CONNECT,  // 设备当前没连网络，或网络信号不好
    ADWO_ADSDK_ERROR_CODE_REQUEST_INVALID_REQUEST_URL, // 请求URL出错
    ADWOSDK_REQUEST_ERROR_CODE_INIT_ERROR// 初始化出错
};

enum ADWO_ADSDK_BANNER_SIZE
{
    /** Banner types */
    // For normal banner(320x50)
    ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER = 1,
    
    // For banner on iPad
    ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50 = 10,
    ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110
};

enum ADWOSDK_SPREAD_CHANNEL
{
    ADWOSDK_SPREAD_CHANNEL_APP_STORE,
    ADWOSDK_SPREAD_CHANNEL_91_STORE
};

enum ADWOSDK_AGGREGATION_CHANNEL
{
    ADWOSDK_AGGREGATION_CHANNEL_NONE,
    ADWOSDK_AGGREGATION_CHANNEL_GUOHEAD,
    ADWOSDK_AGGREGATION_CHANNEL_ADVIEW,
    ADWOSDK_AGGREGATION_CHANNEL_MOGO,
    ADWOSDK_AGGREGATION_CHANNEL_ADWHIRL,
    ADWOSDK_AGGREGATION_CHANNEL_ADSAGE,
    ADWOSDK_AGGREGATION_CHANNEL_ADMOB
};

// 全屏广告展示形式ID
enum ADWOSDK_FSAD_SHOW_FORM
{
    ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND,   // App Fun插页式全屏广告加品牌全屏广告（App Fun优先）
    ADWOSDK_FSAD_SHOW_FORM_LAUNCHING,           // 应用启动后立即展示全屏广告
    ADWOSDK_FSAD_SHOW_FORM_GROUND_SWITCH,       // 后台切换到前台后立即显示全屏广告
    ADWOSDK_FSAD_SHOW_FORM_APPFUN,              // App Fun插页式全屏广告
    ADWOSDK_FSAD_SHOW_FORM_BRAND                // 品牌插页式全屏
};

// 调用loadAd方法后的参数值
enum ADWOSDK_LOAD_AD_STATUS
{
    ADWOSDK_LOAD_AD_STATUS_LOAD_AD_FAILED,          // 广告加载失败，可能由于广告已请求或PID、广告类型不正确，或当前网络连接不成功
    ADWOSDK_LOAD_AD_STATUS_LOAD_AD_SUCCESSFUL,      // 广告加载成功
    ADWOSDK_LOAD_AD_STATUS_REQUEST_LAUNCHING_FSAD   // 准备请求开屏全屏广告资源
};

// Banner动画类型
enum ADWO_ANIMATION_TYPE
{
    // Animation moving
    ADWO_ANIMATION_TYPE_AUTO,                   // 由Adwo服务器来控制动画类型
    ADWO_ANIMATION_TYPE_NONE,                   // 无动画，直接切换
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_LEFT,   // 从左到右的推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_RIGHT,  // 从右到左推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_BOTTOM, // 从下到上推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_TOP,    // 从上到下推移
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_LEFT,  // 新广告从左到右移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_RIGHT, // 新广告从右到左移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_BOTTOM,// 新广告从下到上移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_TOP,   // 新广告从上到下移动，并覆盖在老广告条上
    
    ADWO_ANIMATION_TYPE_CROSS_DISSOLVE,         // 淡入淡出
    
    // Animation transition
    ADWO_ANIMATION_TYPE_CURL_UP,                // 向上翻页
    ADWO_ANIMATION_TYPE_CURL_DOWN,              // 向下翻页
    ADWO_ANIMATION_TYPE_FLIP_FROMLEFT,          // 从左到右翻页
    ADWO_ANIMATION_TYPE_FLIP_FROMRIGHT          // 从右到左翻页
};

// 全屏广告动画类型
enum ADWO_SDK_FULLSCREEN_ANIMATION_TYPE
{
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_AUTO,    // 由Adwo服务器来控制动画类型
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE,    // 无动画，直接出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_LEFT_TO_RIGHT, // 从左到右出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_RIGHT_TO_LEFT, // 从右到左出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_BOTTOM_TO_TOP, // 从底到顶出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_TOP_TO_BOTTOM, // 从顶到底出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_LEFT_RIGHT,        // 水平方向伸缩出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_TOP_BOTTOM,        // 垂直方向伸缩出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_CROSS_DISSOLVE,          // 淡入淡出
};


@protocol AWAdViewDelegate <NSObject>

@required

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
*/
- (UIViewController*)adwoGetBaseViewController;

@optional

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
*/
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView;

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
*/
- (void)adwoAdViewDidLoadAd:(UIView*)adView;

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
*/
- (void)adwoFullScreenAdDismissed:(UIView*)adView;

/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
*/
- (void)adwoDidPresentModalViewForAd:(UIView*)adView;

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
*/
- (void)adwoDidDismissModalViewForAd:(UIView*)adView;

@end


// 偏好属性设置
struct AdwoAdPreferenceSettings
{    
    int adSlotID;
    unsigned animationType;
    enum ADWOSDK_SPREAD_CHANNEL spreadChannel;
    BOOL disableGPS;
};

/**
 * 描述：创建一条Banner广告
 * 参数：
 * pid——申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * showFormalAd——是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * delegate——AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。
 * 返回：如果返回为空，表示广告初始化创建失败，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。如果创建成功，则返回一个UIView对象，作为广告对象句柄。
*/
extern UIView* AdwoAdCreateBanner(NSString *pid, BOOL showFormalAd, NSObject<AWAdViewDelegate> *delegate);


/**
 * 描述：移除并销毁Banner广告
 * 参数：
 * adView——Banner对象句柄
 * 返回：如果销毁成功，返回YES；否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdRemoveAndDestroyBanner(UIView *adView);

/**
 * 描述：设置banner请求间隔时间
 * 参数：
 * interval——请求间隔时间（单位为秒）
 * 这个接口应该在调用AdwoAdLoadBannerAd之前调用。
 * 另外，如果请求间隔时间少于服务器指定的请求间隔时间，则以服务器指定的请求间隔进行操作
*/
extern void AdwoAdSetBannerRequestInterval(NSInteger interval);

/**
 * 描述：当完成初始化和相关设置之后，调用此方法来加载Banner广告。
 * 参数：
 * adView——Banner对象句柄
 * bannerSize——指定当前的Banner尺寸。如果是用于iPhone、iPod Touch，那么使用ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER即可，该尺寸为320x50；如果是用于iPad，那么可以指定ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50和ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110两种尺寸。
 * 返回：如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。当这个接口返回后，Banner未必加载成功，开发者必须通过AWAdViewDelegate代理中的adwoAdViewDidLoadAd方法来捕获Banner是否加载成功。
 * 这里要注意的是，广告对象应该被加到一个控制器的根视图中，即其大小撑满整个屏幕，否则某些广告展示形式可能会影响父视图的尺寸。
*/
extern BOOL AdwoAdLoadBannerAd(UIView *adView, enum ADWO_ADSDK_BANNER_SIZE bannerSize);

/**
 * 描述：暂停当前AWAdView的广告请求。
 * 参数：
 * adView——Banner对象句柄
 * 返回：如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdPauseBannerRequest(UIView *adView);

/**
 * 描述：若当前的Banner对象处于暂停请求状态，那么将恢复请求。否则，无效果。
 * 参数：
 * adView——Banner对象句柄
 * 返回：如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdResumeBannerRequest(UIView *adView);

/**
 * 获取全屏广告对象句柄
 * 参数：
 * pid——申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * showFormalAd——是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * delegate——AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。
 * fsAdForm——全屏广告类型。详情可见ADWOSDK_FSAD_SHOW_FORM枚举在值的定义
 * 返回：全屏广告句柄。
 * 这个接口由SDK自动管理全屏广告对象，因此开发者不需要自己释放全屏广告对象
*/
extern UIView* AdwoAdGetFullScreenAdHandle(NSString *pid, BOOL showFormalAd, NSObject<AWAdViewDelegate> *delegate, enum ADWOSDK_FSAD_SHOW_FORM fsAdForm);

/**
 * 加载全屏广告
 * 参数：
 * fsAd——全屏广告对象句柄
 * orientationLocked——应用是否锁定了屏幕方向。如果当前应用在展示全屏广告的时候仅支持横屏或竖屏，那么传YES；如果横竖屏都支持且会切换，则传NO
 * 返回：若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * 如果fsAdForm为ADWOSDK_FSAD_SHOW_FORM_LAUNCHING，那么错误码可能为ADWO_ADSDK_ERROR_CODE_FS_LAUNCHING_AD_REQUESTING。
 这表示当前SDK正在请求开屏全屏广告资源，因此开发者不需要等待广告加载，可以直接做自己后面的作业；如果返回YES，说明开屏全屏广告已经有加载好的资源，此时可以进行展示
 */
extern BOOL AdwoAdLoadFullScreenAd(UIView *fsAd, BOOL orientationLocked);

/**
 * 展示全屏广告
 * 参数:
 * fsAd——全屏广告对象句柄
 * 返回：若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdShowFullScreenAd(UIView *fsAd);

/**
 * 设置是否自动展示后台切换到前台全屏广告
 * 参数:
 * fsAd——全屏广告对象句柄
 * autoToShow——是否自动展示。如果为YES，则当应用从后台切换到前台时，倘若此时后台切换到前台全屏广告已加载好，则由SDK自动展示；若为NO，则SDK不会自动展示，交给开发者来调用AdwoAdShowFullScreenAd接口展示全屏
 * 返回：若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * 默认情况下，SDK会自动展示后台切换到前台广告。若当前为自动展示，那么开发者手工对后台切换到前台调用AdwoAdShowFullScreenAd接口将会返回NO，同时给出ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW的错误码
*/
extern BOOL AdwoAdSetGroundSwitchAdAutoToShow(UIView *fsAd, BOOL autoToShow);

/**
 * 获取最近的错误码。具体错误码请参考ADWO_ADSDK_ERROR_CODE
*/
extern enum ADWO_ADSDK_ERROR_CODE AdwoAdGetLatestErrorCode(void);

/**
 * 设置广告对象属性。这个接口对所有广告类型（包括Banner和各类全屏）都适用
 * 参数：
 * adView——广告对象句柄
 * settings——设置结构体
 * 返回：如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * 该接口应该在广告加载之前使用。
*/
extern BOOL AdwoAdSetAdAttributes(UIView *adView, const struct AdwoAdPreferenceSettings *settings);

/**
 * 设置关键字。关键字一般由应用自己决定，并且一般需要与本SDK进行一个合作交互。
 * 因此普通开发者可以不用关心此接口
 * 参数：
 * adView——广告对象句柄
 * keywords——关键字字符串
 * 返回：如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * 该接口应该在广告加载之前使用。此外，keywords对象会被retain，因此调用好这个接口之后，如果你的keywords是被alloc出来的，则需要调用一次release。
*/
extern BOOL __attribute__((overloadable)) AdwoAdSetKeywords(UIView *adView, NSString *keywords);

/**
 * 从关键字字典获取关键字字符串
 * 以字典来设置关键字的方式方便开发者进行数据处理，此接口允许开发者传定义好的字典对象
 * 参数：
 * keywordsDict——关键字字典对象
 * 返回：如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * 该接口应该在广告加载之前使用。此外，keywords对象会被retain，因此调用好这个接口之后，如果你的keywords是被alloc出来的，则需要调用一次release。
*/
extern BOOL __attribute__((overloadable)) AdwoAdSetKeywords(UIView *adView, NSDictionary *keywords);

