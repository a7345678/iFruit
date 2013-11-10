//
//  CommUtils.m
//  TurnTableLottery
//
//  Created by mac on 11-6-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommUtils.h"

@implementation CommUtils

+(void) showText:(CCLayer *)view text:(NSString *)text position:(CGPoint)position {
    ccColor3B bgcolor = ccc3(255, 168, 0);
    ccColor3B textcolor = ccc3(255, 246, 0);
    
    CCLabelTTF *labelBg = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:22];
    labelBg.position =  position;
    labelBg.anchorPoint = ccp(0,0.5);
    labelBg.color=bgcolor;
    [view addChild: labelBg];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:22];
    label.position =  ccpAdd(labelBg.position,ccp(1,2));
    label.anchorPoint = ccp(0,0.5);
    label.color=textcolor;
    [view addChild: label];
}

+(void) showText:(CCLayer *)view text:(NSString *)text position:(CGPoint)position 
         labelBg:(CCLabelTTF *)labelBg label:(CCLabelTTF *)label{
    ccColor3B bgcolor = ccc3(255, 168, 0);
    ccColor3B textcolor = ccc3(255, 246, 0);
    
    labelBg = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:22];
    labelBg.position =  position;
    labelBg.anchorPoint = ccp(0,0);
    labelBg.color=bgcolor;
    [view addChild:labelBg];
    
    label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:22];
    label.position =  ccpAdd(labelBg.position,ccp(1,2));
    label.anchorPoint = ccp(0,0);
    label.color=textcolor;
    [view addChild:label];
}

+(void) updateUnReadCount:(CCLayer *)view sprite:(CCSprite *)sprite count:(int)count {
    [view removeChild:sprite cleanup:YES];
}
+(void) showUnReadedCount:(CCLayer *)view sprite:(CCSprite *)sprite count:(int)count position:(CGPoint)position {
    //if(count==0) return;
    sprite = [CCSprite spriteWithFile:@"badge.png"];
    sprite.position = position;
    [view addChild:sprite];
    NSString *str;
    if(count>9) str = @"..";
    else str = [NSString stringWithFormat:@"%d",count];
    CCLabelTTF *countLabel =  [CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:13];
    countLabel.position = ccp(11,11);
    [sprite addChild:countLabel];
}

+ (NSInteger)SomethingWasTouched:(NSArray *)array pos:(CGPoint)pos {
	NSUInteger i, count = [array count];
    NSInteger index = -1;
	for(i=0; i<count; i++){
		CCSprite *obj = [array objectAtIndex:i];
        NSLog(@"obj.x:%f obj.y:%f",obj.position.x,obj.position.y);
        NSLog(@"pos.x:%f pos.y:%f",pos.x,pos.y);
        if(obj!=nil){
            if(CGRectContainsPoint([CommUtils getRect:obj], pos)){
                index = i;
            }
        }
	}
	return index;
}

+ (CGRect) getRect:(CCSprite *)sprite {
	float w = [sprite contentSize].width;
	float h = [sprite contentSize].height;
	CGPoint point = CGPointMake([sprite position].x - (w/2), [sprite position].y - (h/2));
	return CGRectMake(point.x,point.y,w,h);
}


+ (float)getRandom:(long)beginNum to:(long)endNum {
    int value = (arc4random() % endNum)+beginNum; 
    return value;
}

//　获取浮点数的随机数
+ (double)getDoubleRandom:(long)beginNum to:(long)endNum {
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) * endNum*100)/100 + beginNum;
}


//当前坐标　current　圆心坐标 center　旋转角度　30 * (-1)
+ (CGPoint) movePoint:(CGPoint)pt centerPoint:(CGPoint)center rotation:(int)angle 
{
    //求出半径
    //float r = sqrt(pt.x*pt.x + pt.y*pt.y);
    //求出弧度
    float l = ((angle * 3.14159265)/180);
    //得出新坐标
    float newX = (pt.x - center.x) * cos(l) + (pt.y - center.y) * sin(l) + center.x;
    float newY = -(pt.x - center.x) * sin(l) + (pt.y - center.y) * cos(l) + center.y;
    return CGPointMake(newX, newY);
}

double radians(float degrees) {
    return ( degrees * 3.14159265 ) / 180.0;
}

// 判断邮箱输入的是否正确
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:candidate];
}

//如何把当前的视图作为照片保存到相册中去
- (void) printScreen {
    //#import <QuartzCore/QuartzCore.h>
//    UIGraphicsBeginImageContext(currentView.bounds.size);     //currentView 当前的view
//    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}


//-(NSString *)getAddress {
//    NSHost *currentHost =[NSHost currentHost];
//    NSString *ip = [[currentHost addresses] objectAtIndex:1];
//    return ip;
//}

//-(NSString*)getAddress {
//    char iphone_ip[255];
//    strcpy(iphone_ip,”127.0.0.1″);
//    NSHost* myhost =[NSHost currentHost];
//    if (myhost)
//    {
//        NSString *ad = [myhost address];
//        if (ad)
//            strcpy(iphone_ip,[ad cStringUsingEncoding: NSISOLatin1StringEncoding]);
//    }
//    return [NSString stringWithFormat:@"%s",iphone_ip];
//}

NSNumber *StringToNumber(NSString *string)
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [numberFormatter numberFromString:string];
    [numberFormatter release];
    return number;
}

NSString *NumberToString(NSNumber *number)
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *string = [numberFormatter stringFromNumber:number];
    [numberFormatter release];
    return string;
}

- (UIImageView *)getUIImageView:(NSString *)filename rect:(CGRect)rect{
    UIImageView *image = [[UIImageView alloc] initWithFrame:rect];
    [image setImage:[UIImage imageNamed:filename]];
    image.opaque = YES;//opaque是否透明
    return [image autorelease];
}

//将UIColor转换为RGB值
- (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    int r = [[RGBArr objectAtIndex:1] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    int g = [[RGBArr objectAtIndex:2] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    int b = [[RGBArr objectAtIndex:3] intValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%d",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return [RGBStrValueArr autorelease];
}

//UILable自动换行，调整高度.   
//
//UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
//label.numberOfLines = 10;
//label.text = @"ddd0dsdsdsadsddddddddd";
//CGSize size = CGSizeMake(60, 1000);
//CGSize labelSize = [label.text sizeWithFont:label.font 
//                          constrainedToSize:size
//                              lineBreakMode:UILineBreakModeClip];
//label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y,
//                         label.frame.size.width, labelSize.height);
//[self.view addSubview:label];
//[label release];


+ (void)setGameValue:(NSString *)key value:(NSObject *)value {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
}

+ (int)getGameValue:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    int value = 1;
    NSNumber *num =[ud objectForKey:key];
    if(num != nil){
        value = [num intValue];
    }
    return value;
}

- (void)dealloc {
    [super dealloc];
}

@end
