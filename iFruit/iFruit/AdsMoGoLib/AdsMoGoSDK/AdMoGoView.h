//
//  AdMoGoView.h
//  mogosdk
//
//  Created by MOGO on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "AdViewType.h"
#import "AdMoGoViewAnimationDelegate.h"
/*
  AdViewType 广告视图类型 不是配置信息请求type
 */

@interface AdMoGoView : UIView{
    
    BOOL isStop;
    
}
@property(nonatomic,assign) id<AdMoGoDelegate> delegate;



@property(nonatomic,assign) id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;

@property(nonatomic,assign) id<AdMoGoViewAnimationDelegate> adAnimationDelegate;

/*
    ak:开发appkey
    type:请求广告类型
    delegate:代理对象
 */
- (id) initWithAppKey:(NSString *)ak
               adType:(AdViewType)type
   adMoGoViewDelegate:(id<AdMoGoDelegate>) delegate;





@end


