//
//  FruitCore.h
//  Fruit
//
//  Created by mac on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fruit.h"
#import "Item.h"
#import "NumUtils.h"
#import "BombMgr.h"
#import "CommUtils.h"x
#import "CCSpriteUtils.h"
#import "SimpleAudioEngine.h"


//单指 两个水果间的转换
//双指 整行整列的水果转换
//三指及三指以上 不同行列间的直接消除

@interface FruitCore : NSObject {
    CCLayer *view;
    CCLayer *fruitLayer;
    BombMgr *bombMgr;
    NSMutableArray *fruitArray,*itemArray,*tipArray,*tempFruitArray,*scoreArray;
    NSArray *fruitImageArray,*itemImageArray;
    NSInteger _lastClickFruitIndex,_curClickFruitIndex,clickStatus,touchesNum;
    CGFloat moveNum;
    BOOL autoMoveComplete,tip;
    NSTimer *theTimer;
    NumUtils *numUtils;
    CCSprite *coin;
    int64_t _score;
    int _multiple,_level; //等级;
    CCLabelTTF *_multipleTTF,*_multipleTTFBg;
    int _percentNum; //每个回合消掉多少个水果
    
    CCLabelTTF *scoreValue,*scoreValueBg;
    CCLabelTTF *levelValue,*levelScoreValue;
        
    CGPoint gestureStartPoint;
    NSArray *xArray; //道具坐标
    
    int helpNum; //刚开始游戏提示三次  
    
    // x,y供计算中间使用。
    CGFloat _x,_y;
    NSInteger _index,_autoNum; //autoNum　自动拖动的长度
    NSInteger _stopNum,_indexNum,_isOperate;  //水果应该停止的位置x,y坐标   上下左右移了几格   是手工拖动的吗
    
    
    NSMutableArray *bombArrowArray;
}

@property (nonatomic,retain) CCLayer *view;
@property (nonatomic,retain) BombMgr *bombMgr;
@property (nonatomic,retain) NSMutableArray *fruitArray,*itemArray,*tipArray,*scoreArray;
@property (nonatomic,retain) NSArray *fruitImageArray,*itemImageArray,*xArray;
@property (assign) int64_t score;
@property (nonatomic,retain) NSMutableArray *tempFruitArray;
@property (nonatomic) NSInteger lastClickFruitIndex,curClickFruitIndex,clickStatus,touchesNum; //当前正在点击的水果
@property (nonatomic,retain) CCLabelTTF *scoreValue,*scoreValueBg,*levelValue,*levelScoreValue;
@property BOOL autoMoveComplete; //自动对齐标识
@property int level,multiple,percentNum;
@property (nonatomic,retain) CCLabelTTF *multipleTTF,*multipleTTFBg;
@property (nonatomic,retain) NumUtils *numUtils;
@property (nonatomic) int helpNum;

-(FruitCore * ) init :(CCLayer *)layer;
-(void) initFruit;
-(void) initTempFruit;
-(void) refreshFruit;
-(void)refreshBombFruit;
-(void) drawFruit:(NSMutableArray *)fruitArray;
-(void) removeFruit:(NSMutableArray *)fruitArray;

-(void) copyRowFruit:(int)index;
-(void) copyColFruit:(int)index;
-(void) copyFruit:(int)index;

-(void) moveRowFruit:(int)index x:(CGFloat)x y:(CGFloat)y;
-(void) moveColFruit:(int)index x:(CGFloat)x y:(CGFloat)y;
-(void) moveFruit:(Fruit *)fruit x:(CGFloat)x y:(CGFloat)y;

- (void) roundRowFruit:(NSMutableArray *)array index:(int)index limit:(int)limit num:(int)num;
- (void) roundColFruit:(NSMutableArray *)array index:(int)index low:(int)low upp:(int)upp num:(int)num;

-(NSString *) getDirection:(CGFloat)x y:(CGFloat)y; //获取拖动方向

-(void)autoMoveFruit:(NSInteger)index x:(CGFloat)x y:(CGFloat)y isOperate:(NSInteger)isOperate;
-(void)autoMove:(ccTime)dt;

-(int)getRow:(int)index;
-(int)getCol:(int)index;
-(int)getRowFrist:(int)index;
-(int)getColFrist:(int)index;
-(int)getLastRowIndex:(int)index;
-(int)getLastColIndex:(int)index;

-(int)getRowMoveNum:(CGFloat)x; //左右移动了几格
-(int)getColMoveNum:(CGFloat)y; //上下移动了几格

- (void) checkAndMoveFruit:(id)sender data:(NSNumber *)level;
- (int) checkAndMoveFruit:(NSNumber *)level;
- (NSMutableArray *) checkFruit;
- (void)scoreAndItem:(NSArray *)array num:(int)sameNum index:(int)index level:(int)level;
- (void) calcScore:(NSNumber *)num;
- (void)combo;

- (void) dropFruit:(NSMutableArray *) sameFruit level:(NSNumber *)level;
- (void) bombFruit:(NSMutableArray *) sameFruit; 
- (void)changeFruit:(id)sender data:(Fruit *)param; //更换精灵
- (void)changeBombFruit:(id)sender data:(Fruit *)param;

- (void) resetPosition;
- (void) resetTempFruitPosition;

- (void) swapFruit:(int)aIndex to:(int)bIndex isOperate:(BOOL)isOperate;
- (int)swapFruitComplete:(id)sender data:(NSArray *)param;

- (void) resetScoreArray;

- (void)scoreAnimal:(ccTime)dt;
-(void)stopScoreAnimal;

- (int) getLevelScore;
- (BOOL)levelup;
- (void)fruitBomb:(NSMutableArray *)array complete:(BOOL)complete;

//返回锁定状态
-(BOOL)isLockFruit;
//锁定水果
- (void)lockFruit;
//解销水果
- (void)unlockFruit;

- (void) initNextOper;

-(void)bombFruitFinished:(id)sender data:(NSMutableArray *)param;
-(void)roundColMove:(id)sender data:(NSArray *)param;
- (void) runBomb;
-(BOOL) hasItem:(int)itemIndex;
-(void) autoUseItem:(int)itemIndex;
-(void) useItem:(int)itemNum;
-(void)gameStart:(NSNumber *)init;

- (void)tip:(id)sender;
- (BOOL)isTheSame:(int)i1 i2:(int)i2 i3:(int)i3;
- (NSArray *)createTip:(int)i1 i2:(int)i2 i3:(int)i3;
-(void)removeTip:(ccTime)dt;
-(void)createItem;
-(void)addItem:(int)imageIndex;


-(BOOL) isDoubleClickBomb:(int)index;
-(void) bombAround:(NSArray *)array index:(int)index;
@end
