//
//  Fruit.h
//  Fruit
//
//  Created by mac on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Fruit : CCSprite {
    NSInteger status; // 0:正常状态　1:选中状态
    CGPoint fruitCenter;
    int style,moveNum,item;
    BOOL canTrack;
    
    //仅供教学模式使用
    int index;
}

+(NSInteger)SomethingWasTouched:(NSArray *)array pos:(CGPoint)pos;
+(Fruit *) FindByTag:(NSArray *)allMySprites tag:(int) tagVar;
-(CGRect) rect;
-(void)SetCanTrack:(BOOL) val;
-(BOOL)GetCanTrack;

@property CGPoint fruitCenter;
@property int style,moveNum,item;
@property int index;

@end
