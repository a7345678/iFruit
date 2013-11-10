//
//  TestViewController.m
//  Test
//
//  Created by mac on 12-1-1.
//  Copyright 2012年 asiainfo-linkage. All rights reserved.
//

#import "TextViewController.h"

@implementation TextViewController

//static TextViewController *controller = nil;
//
//+ (TextViewController *)getInstance {
//    if(controller == nil){
//        controller = [[TextViewController alloc] init];
//    }
//    return controller;
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ((alertView.tag==1 || alertView.tag==2) && (buttonIndex == 1)) {
//        if (flow==1) {
//            int status = [WPlusUtils checkIn:code.text];
//            NSString *title=@"邀请码校验信息";
//            if(status==200){
//                [self showAlertView:title message:@"恭喜您，邀请码注册成功!"];
//            }else if(status==201){
//                [WPlusUtils showRegistView];
//            }else if(status==202){
//                [self showNicknameView];
//                flow = 2;
//            }else {
//                NSString *str;
//                if(status == 405)  str=@"邀请码错误";
//                else if(status ==  406) str =@"该设备已经被邀请过";
//                else if(status == 407) str = @"该邀请码由本机发出,校验失败";
//                [self showAlertView:title message:str];
//                //[self showInvitCodeView];
//            }
//        }else if(flow==2){
//            NSString *title=@"请输入昵称:";
//            if(nickname.text==NULL || nickname.text==nil || nickname.text==@"") { 
//                [nickname setText:@"游客"];
//            }
//            int nicknameSuc = [WPlusUtils registerNickname:nickname.text];
//            if(nicknameSuc==200){
//                [self showAlertView:title message:@"昵称注册成功!"];
//                return;
//            }else{
//                [self showAlertView:title message:@"昵称注册失败!"];
//            }
//        }
//	} else {
//		NSLog(@"user pressed Cancel");
//	}
}

-(void)viewDidLoad {
    [super viewDidLoad];
    flow = 1;
    [self showInvitCodeView];
}
-(void)showInvitCodeView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邀请码注册:" message:@"\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag=1;
    alert.frame = CGRectMake(200, 200,500, 500);
    code = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
    [code setBackgroundColor:[UIColor whiteColor]];
    code.placeholder = @"请输入邀请码";
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    code.keyboardType = UIKeyboardTypeNumberPad;
    code.keyboardAppearance = UIKeyboardAppearanceAlert;
    code.autocapitalizationType = UITextAutocapitalizationTypeWords;
    code.autocorrectionType = UITextAutocorrectionTypeNo;
    [alert addSubview:code];
    
    [alert show];
    [alert release];
}
-(void)showNicknameView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入昵称:" message:@"\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag=2;
    alert.frame = CGRectMake(200, 200,500, 500);
    nickname = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];    
    [nickname setBackgroundColor:[UIColor whiteColor]];
    nickname.placeholder = @"请输入昵称";
    nickname.clearButtonMode = UITextFieldViewModeWhileEditing;
    nickname.keyboardAppearance = UIKeyboardAppearanceAlert;
    nickname.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nickname.autocorrectionType = UITextAutocorrectionTypeNo;
    [alert addSubview:nickname];
    
    [alert show];
    [alert release];
}
-(void)showAlertView:(NSString *)title message:(NSString *)message {
    UIAlertView *baseAlert =  [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [baseAlert show];
    [baseAlert release];
}

- (void)dealloc
{
    [super dealloc];
}
@end
