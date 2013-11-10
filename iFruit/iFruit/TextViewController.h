//
//  TestViewController.h
//  Test
//
//  Created by mac on 12-1-1.
//  Copyright 2012年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate> {
    UIAlertView *_alertView;
    UITextField *usernameField,*passwordField;
    
    UITextField *code,*nickname;
    int flow; //1 输入邀请码 2 输入昵称
}
//+ (TextViewController *)getInstance;
-(void)showInvitCodeView;
-(void)showNicknameView;
-(void)showAlertView:(NSString *)title message:(NSString *)message;

@end
