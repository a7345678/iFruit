//
//  TipCore.m
//  iFruit
//
//  Created by mac on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipCore.h"
#import "GameResource.h"


@implementation TipCore


-(FruitCore * ) init :(CCLayer *)layer{
    self = [super init];
    if(self)
    {
        //　初始化游戏变量
        _score = 0;
        _level = 1;
        _multiple = SCORESCALE; //得分倍数
        self.lastClickFruitIndex = -1;
        self.curClickFruitIndex = -1;
        self.clickStatus = -1;
        self.autoMoveComplete = true;
        self.touchesNum = 1;
        tip = false; //是否正在提示
        view = layer;
        self.fruitArray = [[NSMutableArray alloc] init]; 
        self.itemArray = [Item itemArray];
        fruitLayer = [CCLayer node];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *bottombg = [CCSpriteUtils createCCSprite:@"bottom_bg.jpg" location:ccp(0,size.height-160+1)];
        [view addChild:bottombg];
                
        //        fruitImageArray= [[NSMutableArray alloc] initWithObjects:
        //                          @"image 132.png",@"image 135.png",@"image 138.png",@"image 141.png",
        //                          @"image 144.png",@"image 147.png",@"image 150.png",
        //                          @"image 153.png",@"image 191.png", nil];
        
        fruitImageArray= [[GameResource shared] fruitImageArray];        
        itemImageArray = [[GameResource shared] itemImageArray];
        
        xArray = [[NSArray alloc] initWithObjects:
                  [NSNumber numberWithFloat:30],
                  [NSNumber numberWithFloat:82],
                  [NSNumber numberWithFloat:134],
                  [NSNumber numberWithFloat:186],
                  [NSNumber numberWithFloat:238],
                  [NSNumber numberWithFloat:290],nil];
        
        tipIndexArray = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:8],[NSNumber numberWithInt:1],[NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:7],[NSNumber numberWithInt:0],[NSNumber numberWithInt:3],
                         
                         [NSNumber numberWithInt:3],[NSNumber numberWithInt:5],[NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:0],[NSNumber numberWithInt:6],[NSNumber numberWithInt:1],
                         
                         [NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:8],
                         
                         [NSNumber numberWithInt:0],[NSNumber numberWithInt:5],[NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:7],
                         
                         [NSNumber numberWithInt:4],[NSNumber numberWithInt:7],[NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:6],[NSNumber numberWithInt:1],[NSNumber numberWithInt:7],
                         
                         [NSNumber numberWithInt:5],[NSNumber numberWithInt:4],[NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:7],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],
                         
                         [NSNumber numberWithInt:4],[NSNumber numberWithInt:1],[NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:8],[NSNumber numberWithInt:0],[NSNumber numberWithInt:3],
                         nil];
        
        tempFruitArray = [[NSMutableArray alloc] init];
        [self initTempFruit];
        
        //计算每种水果的得分情况
        scoreArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[fruitImageArray count]; i++) {
            [scoreArray addObject:[NSNumber numberWithInt:0]];
        }
        
        [self initFruit]; //初始化水果
        
        self.bombMgr = (BombMgr*)[[BombMgr alloc] init:view];
        
        self.numUtils = [[NumUtils alloc] init:view];
        
        CCSprite *topbg = [CCSpriteUtils createCCSprite:@"top_bg.jpg" location:ccp(0,size.height)];
        [view addChild:topbg];
        
    }
    return self;
}


-(void) initFruit {
        
    for(int i=0; i<ROW*COL; i++) {
        int index = [[tipIndexArray objectAtIndex:i] intValue];
        Fruit *sp = [Fruit spriteWithFile:[fruitImageArray objectAtIndex:index]];
        //sp.anchorPoint = CGPointZero;
        sp.position = CGPointMake(i%ROW*FRUITWIDTH+FRUITWIDTH/2, ((int)i/ROW)*FRUITHEIGHT+FRUITHEIGHT/2);
        sp.style = index;
        sp.fruitCenter = sp.position;
        [fruitArray addObject:sp];
        [fruitLayer addChild:sp z:0 tag:1]; 
    }
    fruitLayer.position = ccp(fruitLayer.position.x+STARTX,fruitLayer.position.y+STARTY);
    [view addChild:fruitLayer];
}

-(void)refreshFruit {
    if(!autoMoveComplete) return;
    
    //[self test];
    
    autoMoveComplete = false;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[fruitArray count]; i++) {
        Fruit *fruit = [fruitArray objectAtIndex:i];
        //重置水果的位置
        fruit.position = CGPointMake(i%ROW*FRUITWIDTH+FRUITWIDTH/2, ((int)i/ROW)*FRUITHEIGHT+FRUITHEIGHT/2);
        id animateDone = [CCCallFuncN actionWithTarget:self selector:@selector(resetFruit:)];
        [array addObject:[CCDelayTime actionWithDuration: 0.02]];
        [array addObject:animateDone];
    }
    
    id changeFruitDone = [CCCallFuncND actionWithTarget:self 
                                               selector:@selector(checkAndMoveFruit:data:) data:[NSNumber numberWithInt:0]];
    [array addObject:changeFruitDone];
    
    id unlockFruit = [CCCallFunc actionWithTarget:self selector:@selector(unlockFruit)];
    [array addObject:unlockFruit];
    
    Fruit *fruit = [fruitArray objectAtIndex:0];
    [fruit runAction:[CCSequence actionWithArray:array]];
    [array release];
}

-(void)resetFruit:(id)sender {
    for(int i=0; i<ROW*COL; i++) {
        int index = [[tipIndexArray objectAtIndex:i] intValue];
        NSString *filename = [[self fruitImageArray] objectAtIndex:index];
        //fruit.texture = [[CCTextureCache sharedTextureCache] addImage:filename];  
        
        Fruit *fruit = [fruitArray objectAtIndex:i];
        CCTexture2D *newTexture= [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:filename]];
        [fruit setTexture:newTexture];
        fruit.style = index;
        fruit.visible = true; 
        
        [newTexture release];
    }
}

- (int) checkAndMoveFruit:(NSNumber *)level {
    
    int l = [level intValue];
    
    NSMutableArray *sameFruit = [self checkFruit]; //判断行上和列上的水果
    
    int num = [sameFruit count];
    if(num<=0){
        if(l!=0){
            [self initNextOper];
        }
    }else{
            //[self fruitBomb:sameFruit complete:YES];
        [self dropFruit:sameFruit level:level];
    }
    return num;
}

-(void)dealloc{
    [tipIndexArray release];
    [super dealloc];
}

@end
