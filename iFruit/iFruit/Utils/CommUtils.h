//
//  CommUtils.h
//  TurnTableLottery
//
//  Created by mac on 11-6-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "math.h"
#import "cocos2d.h"

@interface CommUtils : NSObject {
}

+(void) showText:(CCLayer *)view text:(NSString *)text position:(CGPoint)position;
+(void) showText:(CCLayer *)view text:(NSString *)text position:(CGPoint)position 
         labelBg:(CCLabelTTF *)labelBg label:(CCLabelTTF *)label;
+(void) showUnReadedCount:(CCLayer *)view sprite:(CCSprite *)sprite count:(int)count position:(CGPoint)position;
+(void) updateUnReadCount:(CCLayer *)view sprite:(CCSprite *)sprite count:(int)count;
+(NSInteger)SomethingWasTouched:(NSArray *)array pos:(CGPoint)pos;
+ (CGRect) getRect:(CCSprite *)sprite;
+(float)getRandom:(long)beginNum to:(long)endNum;
+(double)getDoubleRandom:(long)beginNum to:(long)endNum;
+(CGPoint) movePoint:(CGPoint)pt centerPoint:(CGPoint)center rotation:(int)angle;
//+（UIColor　*)randomColor;
NSNumber *StringToNumber(NSString *string);
NSString *NumberToString(NSNumber *number);

- (UIImageView *)getUIImageView:(NSString *)filename rect:(CGRect)rect;

+ (void)setGameValue:(NSString *)key value:(NSObject *)value;
+ (int)getGameValue:(NSString *)key;

@end
