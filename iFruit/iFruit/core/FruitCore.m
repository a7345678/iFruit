//
//  FruitCore.m
//  Fruit
//
//  Created by mac on 11-6-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FruitCore.h"
#import "GameLayer.h"
#import "GCHelper.h"
#import "SoundUtils.h"
#import "GameResource.h"
#import "BannerAdViewController.h"
#import "FullAdViewController.h"

@implementation FruitCore
@synthesize view;
@synthesize bombMgr;
@synthesize fruitImageArray,itemImageArray,fruitArray,itemArray,tipArray,scoreArray,xArray;
@synthesize score = _score;
@synthesize level = _level;
@synthesize multiple = _multiple;
@synthesize percentNum = _percentNum;
@synthesize multipleTTF = _multipleTTF,multipleTTFBg = _multipleTTFBg;
@synthesize tempFruitArray;
@synthesize lastClickFruitIndex = _lastClickFruitIndex,curClickFruitIndex = _curClickFruitIndex;
@synthesize clickStatus,touchesNum;
@synthesize scoreValue,scoreValueBg,levelValue,levelScoreValue;
@synthesize autoMoveComplete;
@synthesize numUtils;
@synthesize helpNum;

-(void)dealloc {
    [fruitArray release];
    [itemArray release];
    [itemImageArray release];
    [tipArray release];
    [fruitImageArray release];
    [tempFruitArray release];
    [scoreArray release];
    [xArray release];
    [bombMgr release];
    [numUtils release];
    [scoreValue release];
    [scoreValueBg release];
    [levelScoreValue release];
    [view release];
    [super dealloc];
}

- (void) setCurClickFruitIndex:(NSInteger)index {
    
    if ([fruitArray count]<=index) return;
        
    if(abs(_curClickFruitIndex - index)==1 || abs(_curClickFruitIndex-index)==COL) {
        
        //行中的最后不允许与下行中的第一个水果交换
        if(_curClickFruitIndex!=-1){
            int maxIndex = MAX(_curClickFruitIndex, index);
            int minIndex = MIN(_curClickFruitIndex, index);
            if(maxIndex%COL==0 && maxIndex-minIndex!=COL) return;
        }
        
        _lastClickFruitIndex = _curClickFruitIndex;
    }else{
        _lastClickFruitIndex = -1;
    }

    if(((GameLayer *)view).soundCanPlay==1)
        [SoundUtils playEffect:@"click.caf" volume:1.0];
    
        //NSLog(@"_lastClickFruitIndex:%d,_curClickFruitIndex:%d index:%d",_lastClickFruitIndex,_curClickFruitIndex,index);
    
    if([self isDoubleClickBomb:index]) {
        //NSLog(@"bomb....");
        
        //十字炸弹
        NSArray *array = [[GameResource shared] doubleClickBombArray];
        [self bombAround:array index:index];
        
        _lastClickFruitIndex=-1;
        _curClickFruitIndex=-1;
        return;
    }
    
    _curClickFruitIndex = index;
}

-(void) bombAround:(NSArray *)array index:(int)index {
    NSMutableArray *bombArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<[array count]; i++) {
        int offset = [[array objectAtIndex:i] intValue];
        int calcIndex = index+offset;
        if(calcIndex>=0 && calcIndex<ROW*COL){
            [bombArray addObject:[NSNumber numberWithInt:calcIndex]];
        }
    }
    [self dropFruit:bombArray level:[NSNumber numberWithInt:1]];
}

//是否双击炸弹
-(BOOL) isDoubleClickBomb:(int)index{
    Fruit *fruit = [fruitArray objectAtIndex:index];
    //NSLog(@"_last:%d _cur:%d style:%d  count:%d",_curClickFruitIndex,index,fruit.style,[fruitImageArray count]-1);
    return _curClickFruitIndex!=-1 && _curClickFruitIndex == index && fruit.style == [fruitImageArray count]-1;
}

-(FruitCore * ) init :(CCLayer *)layer{
    self = [super init];
    if(self)
    {
        //　初始化游戏变量
        _score = 0;
        _level = 1;
        _multiple = SCORESCALE; //得分倍数
        _percentNum = 0;
        helpNum = HELPNUM;
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
        CCSprite *bottombg = [CCSpriteUtils createCCSprite:BOTTOM_BG location:ccp(0,BOTTOM_POINT_Y)];
        [view addChild:bottombg];
                
        fruitImageArray= [[GameResource shared] fruitImageArray];
        itemImageArray = [[GameResource shared] itemImageArray];
        
        tipArray = [[NSMutableArray alloc] init];
        
        if(isPad){
            xArray = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:68],
                      [NSNumber numberWithFloat:193],
                      [NSNumber numberWithFloat:316],
                      [NSNumber numberWithFloat:450],
                      [NSNumber numberWithFloat:574],
                      [NSNumber numberWithFloat:700],nil];
        }else{
            xArray = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:30],
                      [NSNumber numberWithFloat:82],
                      [NSNumber numberWithFloat:134],
                      [NSNumber numberWithFloat:186],
                      [NSNumber numberWithFloat:238],
                      [NSNumber numberWithFloat:290],nil];
        }
        
        tempFruitArray = [[NSMutableArray alloc] init];
        [self initTempFruit];

        //计算每种水果的得分情况
        scoreArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[fruitImageArray count]; i++) {
            [scoreArray addObject:[NSNumber numberWithInt:0]];
        }
    
        [self initFruit]; //初始化水果
        
        self.bombMgr = (BombMgr*)[[BombMgr alloc] init:view];
        
        self.numUtils = [[[NumUtils alloc] init:view] autorelease];
        
        CCSprite *topbg = [CCSpriteUtils createCCSprite:TOP_BG location:ccp(0,size.height)];
        [view addChild:topbg];
        
        /*****分数显示******/
        int scoreX=isPad?392:196,scoreY=isPad?890:450;
        
        coin = [CCSpriteUtils createCCSprite:@"coin.png" location:ccp(scoreX,scoreY+8)];
        [view addChild:coin];
        
        ccColor3B bgcolor = ccc3(255, 168, 0);
        ccColor3B textcolor = ccc3(255, 246, 0);
        
        CCLabelTTF *scoreLabelBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"] 
                                                      fontName:@"Arial" fontSize:isPad?40:20];
        scoreLabelBg.position =  ccp( scoreX+(isPad?30:15)+scoreLabelBg.contentSize.width/2 , scoreY-scoreLabelBg.contentSize.height/2 );
        scoreLabelBg.color=bgcolor;
        [view addChild: scoreLabelBg];
        
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X"] 
                                                    fontName:@"Arial" fontSize:isPad?40:20];
        scoreLabel.position =  ccp( scoreX+(isPad?32:17)+scoreLabel.contentSize.width/2 , scoreY+1-scoreLabel.contentSize.height/2 );
        scoreLabel.color=textcolor;
        [view addChild: scoreLabel];
        
        scoreValueBg = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lld",_score] 
                                          fontName:@"Arial" fontSize:isPad?48:24];
        scoreValueBg.position =  ccp( scoreX+(isPad?50:24)+scoreValueBg.contentSize.width/2 , scoreY+3-scoreValueBg.contentSize.height/2 );
        scoreValueBg.color=bgcolor;
        scoreValueBg.anchorPoint = CGPointMake(0, 0.5);
        [view addChild: scoreValueBg];
        
        scoreValue = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%lld",_score] 
                                        fontName:@"Arial" fontSize:isPad?48:24];
        scoreValue.position =  ccp( scoreX+(isPad?52:26)+scoreValue.contentSize.width/2 , scoreY+4-scoreValue.contentSize.height/2 );
        scoreValue.color=textcolor;
        scoreValue.anchorPoint = CGPointMake(0, 0.5);
        [view addChild: scoreValue];
        
        int LevelY = isPad?800:422;
        
        /***关卡***/
        CCLabelTTF *levellabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level:"]
                                                    fontName:@"Arial" fontSize:isPad?28:14];
        levellabel.position =  ccp(scoreX-(isPad?230:115)+levellabel.contentSize.width/2 , LevelY-levellabel.contentSize.height/2);
        levellabel.color=ccc3(130, 186, 0);
        [view addChild: levellabel];
        
        levelValue = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_level] 
                                             fontName:@"Arial" fontSize:isPad?28:14];
        levelValue.position =  ccp( scoreX-(isPad?150:75)+levelValue.contentSize.width/2 , LevelY-levelValue.contentSize.height/2);
        levelValue.anchorPoint = CGPointMake(0, 0.5);
        levelValue.color=ccc3(130, 186, 0);
        [view addChild: levelValue];
        /***过关分数***/

        
        /***过关分数***/
        CCLabelTTF *levelScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"LevelScore:"]
                                                    fontName:@"Arial" fontSize:isPad?28:14];
        levelScore.position =  ccp(scoreX+(isPad?48:-12)+scoreValue.contentSize.width/2 , LevelY-levelScore.contentSize.height/2);
        levelScore.color=textcolor;
        [view addChild: levelScore];
        
        levelScoreValue = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[self getLevelScore]] 
                                             fontName:@"Arial" fontSize:isPad?28:14];
        levelScoreValue.position =  ccp( scoreX+(isPad?132:28)+scoreValue.contentSize.width/2 , LevelY-levelScoreValue.contentSize.height/2);
        levelScoreValue.anchorPoint = CGPointMake(0, 0.5);
        levelScoreValue.color=textcolor;
        [view addChild: levelScoreValue];
        /***过关分数***/
                
        
        bombArrowArray = [[NSMutableArray alloc] init];
        for (int i=0; i<4; i++) {
            CCSprite *bomb = [CCSpriteUtils createCCSprite:@"fruit09s.png" location:ccp((isPad?600:258)+i*(isPad?36:12),isPad?770:398)];
            bomb.scale = isPad?1.0:0.6;
            [view addChild:bomb];
            [bombArrowArray addObject:bomb];
        }
        
        BannerAdViewController *controller = [BannerAdViewController sharedInstance];
        [[[CCDirector sharedDirector] openGLView] addSubview :controller.view];
        

//        FullAdViewController *fc = [FullAdViewController sharedInstance];
//        [fc showInterstitial:nil];
//        [[[CCDirector sharedDirector] openGLView]addSubview:fc.view];

        
        if(USEAD && (iPhone5 || isPad)){
            [controller setLocation:CGPointMake(0, 0)];
        }else{
            [controller setLocation:CGPointMake(size.width, 0)];
        }
        
        // 游戏开始
        [self performSelector:@selector(gameStart:) withObject:[NSNumber numberWithInteger:1] afterDelay:1.3];
    }
    return self;
}

-(void)gameStart:(NSNumber *)init {
    
    [self lockFruit];
    
    if([self hasItem:3]){
        [self autoUseItem:3];
        [((GameLayer *)view) addTime:GAMETIME/2];
    }
    
    if(_level==1){
        
        if([itemArray count]==0){
            [self addItem:2];
            [self addItem:3];
            [self addItem:4];
            [self addItem:1];
            [self addItem:0];
        }
        
        CCSprite *sprite = [bombArrowArray objectAtIndex:3];
        sprite.visible = false;
        CCSprite *clickForItemArrow = [CCSprite spriteWithFile:@"clickforitem_arrow.png"];
        clickForItemArrow.scaleX = -1;
        clickForItemArrow.position = ccp(isPad?584:254,CLICK_FOR_ITEM_Y);
        [view addChild:clickForItemArrow];
        
    }else if(_level == BOMB4LEVEL) {
        CCSprite *sprite = [bombArrowArray objectAtIndex:3];
        sprite.visible = true;
        sprite.scale = 3;
        id scaleAction = [CCScaleTo actionWithDuration:1 scale:0.6];
        [sprite runAction:scaleAction];
    }
    
    int stageX = isPad?360:120;
    if(_level>9) stageX = isPad?220:110;
    int stageY = 160;
    CCLayer *layer = [CCLayer node];
    layer.position = CGPointMake(-100, stageY);
    
    CCSprite *stage = [CCSprite spriteWithFile:@"stage.png"];
    stage.position = CGPointMake(0, 0);
    [layer addChild:stage];

    NSString *numstr = [NSString stringWithFormat:@"%d",_level];
    CGPoint pt = CGPointMake(isPad?200:100, 0);
    
    int num;
    for(int i=0; i<[numstr length]; i++){
        
        num = [[numstr substringWithRange:NSMakeRange(i, 1)] intValue];
        
        NSString *filename = [NSString stringWithFormat:@"s%d.png",num];
        CCSprite *numsp = [CCSprite spriteWithFile:filename];
        numsp.position = CGPointMake(pt.x+(i+1)*numsp.contentSize.width, pt.y);
        [layer addChild:numsp];
    }
    
    [view addChild:layer];
    
    if([init intValue]==1) [(GameLayer *)view howToPlay:nil];  //游戏提示
    
    id startdelay = [CCDelayTime actionWithDuration:0.5];
    id moveAction1  = [CCMoveTo actionWithDuration:0.3 position:CGPointMake(stageX+10, stageY)];
    id moveAction2 = [CCMoveTo actionWithDuration:0.1 position:CGPointMake(stageX-10, stageY)];
    id moveAction3 = [CCMoveTo actionWithDuration:0.05 position:CGPointMake(stageX, stageY)];
    id delay = [CCDelayTime actionWithDuration:1];
    id moveAction4 = [CCMoveTo actionWithDuration:0.2 position:CGPointMake(400, stageY)];
        
    id removeLayer = [CCCallFuncND actionWithTarget:self 
                                           selector:@selector(removeLayer:data:) data:layer];
    
    id checkAndMoveFruit = [CCCallFuncND actionWithTarget:self 
                                                 selector:@selector(checkAndMoveFruit:data:) data:[NSNumber numberWithInt:1]];
    
    [layer runAction:[CCSequence actions:startdelay,moveAction1,moveAction2,moveAction3,
                                    delay,moveAction4,removeLayer,checkAndMoveFruit,nil]];
}

-(void)removeLayer:(id)sender data:(CCLayer *)layer{
    [layer removeFromParentAndCleanup:NO];
}

/** 思路：
 从第一个开始遍历，遇到相同行则不处理，一次处理两个即可。纵向的水果依此方法判测即可。
 若未找到则，则使用三指模式寻找。找到一个就停止循环。
 **/
-(NSArray *) searchTip:(NSInteger *)type {
    if([self isLockFruit]) return NULL;
        
    int i1=-1,i2=-1,i3=-1;
    
    //划动的检测
    //横向
    for (int i=0; i<[fruitArray count]; i++) {
        
        //一行的第1个与行未两个水果比较　一行的第1,2水果与行未的水果比较
        //NSLog(@"iiiii:%d",i);
        if(i%ROW==0 && i+COL<ROW*COL){
            i1 = i;
            i2 = i+COL-1;
            i3 = i+COL-2;
            //NSLog(@"1111:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];          
            }
            i2 = i+COL-1;
            i3 = i+1;
            //NSLog(@"2222:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];          
            }
        }
        
        //当前列与i行上的后两个水果比较比较
        //   0 1 2 3
        // 3 X X X X  |
        // 2 X X X X  |
        // 1 X X X X  |
        // 0 X X X X  V>>>>
        for (int k=[self getCol:i]; k<[fruitArray count]; k+=COL) {
            if(k>=[fruitArray count]) break;
            if([self getRow:i]==[self getRow:k]) continue; //同一行不比较

            i1=k;
            
            //右三个
            if([self getCol:i]<COL-2){
                i2 = i+1;
                i3 = i+2;
                //NSLog(@"aaaa:i1:%d,i2:%d,i3:%d",i1,i2,i3);
                if([self isTheSame:i1 i2:i2 i3:i3]) {
                    return [self createTip:i1 i2:i2 i3:i3];
                }
            }
            
            //左中右
            if([self getCol:i]>1 && [self getCol:i]<COL-1){
                i2 = i-1;
                i3 = i+1;
                //NSLog(@"bbbb:i1:%d,i2:%d,i3:%d",i1,i2,i3);
                if([self isTheSame:i1 i2:i2 i3:i3]) {
                    return [self createTip:i1 i2:i2 i3:i3];                
                }
            }
            
            //左三个
            if([self getCol:i]>2){
                i2 = i-1;
                i3 = i-2;
                //NSLog(@"cccc:i1:%d,i2:%d,i3:%d",i1,i2,i3);
                if([self isTheSame:i1 i2:i2 i3:i3]) {
                    return [self createTip:i1 i2:i2 i3:i3];
                }
            }
        }
        
        //交换　当前水果交换后的上三个水果比较
        if([self getRow:i]<2){
            i1 = i;
            i2 = i+2*COL;
            i3 = i2+COL;
            //NSLog(@"xdddd:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];              
            }
        }
        
        //交换　与当前水果交换的水果与下三个水果的比较
        if([self getRow:i]>=2 && [self getRow:i]<=COL-2){
            i1 = i+COL;
            i2 = i-COL;
            i3 = i2-COL;
            //NSLog(@"xeeee:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];               
            }
        }
        
        //倒数二行的水果　下三个水果的比较
        if([self getRow:i]>COL-2){
            i1 = i;
            i2 = i-2*COL;
            i3 = i2-COL;
            
            //NSLog(@"xffff:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];          
            }
        }
    }
    
    //纵向
    for (int i=0; i<[fruitArray count]; i++) {
        
        //一列的第1个与列未两个水果比较　一列的第1,2水果与列未的水果比较
        if(i<COL){
            i1 = i;
            i2 = i+(ROW-1)*COL;
            i3 = i2-COL;
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];          
            }
            i3 = i+COL;
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];          
            }
        }

        //当前行与i列上的后两个水果比较比较
        //   0 1 2 3
        // 3 X X X X       ^
        // 2 X X X X       | 
        // 1 X X X X       | 
        // 0 X X X X  <<<<<<
        for (int k=[self getRowFrist:i]; k<[self getRowFrist:i]+COL; k++) {
            if(k>=[fruitArray count]) break;
            if([self getCol:i]==[self getCol:k]) continue; //同一列不比较
            
            i1=k;
            
            if([self getRow:i]<ROW-2){
                i2 = i+COL;
                i3 = i+2*COL;
                //NSLog(@"aaaa:i1:%d,i2:%d,i3:%d",i1,i2,i3);
                if([self isTheSame:i1 i2:i2 i3:i3]) {
                    return [self createTip:i1 i2:i2 i3:i3];
                }
            }
            
            if([self getRow:i]>1 && [self getRow:i]<ROW-1){
                i2 = i-COL;
                i3 = i+COL;
               // NSLog(@"bbbb:i1:%d,i2:%d,i3:%d",i1,i2,i3);
                if([self isTheSame:i1 i2:i2 i3:i3]) {
                    return [self createTip:i1 i2:i2 i3:i3];              
                }
            }
            
            if([self getRow:i]>2){
                i2 = i-COL;
                i3 = i-2*COL;
                //NSLog(@"cccc:i1:%d,i2:%d,i3:%d",i1,i2,i3);
                if([self isTheSame:i1 i2:i2 i3:i3]) {
                    return [self createTip:i1 i2:i2 i3:i3];
                }
            }
        }
        
        //交换　当前水果交换后的右三个水果比较
        if([self getCol:i]<2){
            i1 = i;
            i2 = i+2;
            i3 = i2+1;
            //NSLog(@"ydddd:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];                
            }
        }
        
        //交换　与当前水果交换的水果与左三个水果的比较
        if([self getCol:i]>=2 && [self getCol:i]<=COL-2){
            i1 = i+1;
            i2 = i-1;
            i3 = i2-1;
            //NSLog(@"yeeee:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];               
            }
        }
        
        //倒数二列的水果　左三个水果的比较
        if([self getCol:i]>COL-2){
            i1 = i;
            i2 = i-2;
            i3 = i2-1;
            //NSLog(@"yffff:i1:%d,i2:%d,i3:%d",i1,i2,i3);
            if([self isTheSame:i1 i2:i2 i3:i3]) {
                return [self createTip:i1 i2:i2 i3:i3];                
            }
        }
    }
    
    return NULL;
}

- (BOOL)isTheSame:(int)i1 i2:(int)i2 i3:(int)i3{
    int count = [fruitArray count];
    if(i1>=count || i2>=count || i3>=count) return NO;
    
    Fruit *fruit1 = [fruitArray objectAtIndex:i1];
    Fruit *fruit2 = [fruitArray objectAtIndex:i2];
    Fruit *fruit3 = [fruitArray objectAtIndex:i3];
    if(fruit1.style==fruit2.style && fruit2.style==fruit3.style)
        return YES;
    else return NO;
}

- (NSArray *)createTip:(int)i1 i2:(int)i2 i3:(int)i3{
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:i1],[NSNumber numberWithInt:i2],
            [NSNumber numberWithInt:i3],nil];
            
}

- (void)tip:(id)sender {
        
    if(tip) return;
    tip = true;
    NSArray *array  = [self searchTip:0];
    if (array==NULL || array==nil) { 
        tip = false; 
        return; 
    }

    for (int i=0; i<[array count]; i++) {
        int index = [[array objectAtIndex:i] intValue];
        CCSprite *sp = [CCSprite spriteWithFile:@"stop_tip.png"];
        Fruit *fruit = [fruitArray objectAtIndex:index];
        sp.position = ccp(fruit.position.x,fruit.position.y);
        [fruitLayer addChild:sp];
        [tipArray addObject:sp];
    }
    [view schedule:@selector(removeTip:) interval:0.8];
}

-(void)removeTip:(ccTime)dt{
    [view unschedule:@selector(removeTip:)];
    for (int i=0; i<[tipArray count]; i++) {
        CCSprite *sp = [tipArray objectAtIndex:i]; 
        [sp removeFromParentAndCleanup:NO];
    }
    if(tipArray!=nil) [tipArray removeAllObjects];
    tip = false;
}

-(int)getNoRepeatIndex:(int)index {
    int style = [CommUtils getRandom:0 to:[fruitImageArray count]];
    if(index==0) return style;

    Fruit *fruit,*fruit2;
    
    if(index<[fruitArray count]) {
        
        
        if(index-1==0){
            fruit = [fruitArray objectAtIndex:index-1];
            if(style==fruit.style) style = [self getNoRepeatIndex:index];
        }else if(index-2>=0){
            fruit = [fruitArray objectAtIndex:index-1];
            fruit2 = [fruitArray objectAtIndex:index-2];
            if(style==fruit.style || style==fruit2.style) style = [self getNoRepeatIndex:index];
        }
        
        if(index-COL>=0) {
            fruit = [fruitArray objectAtIndex:index-COL];
            if(style==fruit.style) style = [self getNoRepeatIndex:index];
        }else if(index-2*COL>=0){
            fruit = [fruitArray objectAtIndex:index-COL];
            fruit2 = [fruitArray objectAtIndex:index-2*COL];
            if(style==fruit.style || style==fruit2.style) style = [self getNoRepeatIndex:index];
        }
    }
    return style;
}

-(void) initFruit {
        
    if([fruitArray count]>0)
        [fruitArray removeAllObjects];
    
        for(int i=0; i<ROW*COL; i++) {
            int index = [self getNoRepeatIndex:i];
            Fruit *sp = [Fruit spriteWithTexture:[[GameResource shared].fruitTextureArray objectAtIndex:index]];
            //sp.anchorPoint = CGPointZero;
            sp.position = CGPointMake(i%COL*FRUITWIDTH+FRUITWIDTH/2, ((int)i/COL)*FRUITHEIGHT+FRUITHEIGHT/2);
            sp.style = index;
            sp.fruitCenter = sp.position;
            
//            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",i] fontName:@"Arial" fontSize:14];
//            [sp addChild:label];
            
            [fruitArray addObject:sp];
            [fruitLayer addChild:sp z:0 tag:1]; 
        }
    
    fruitLayer.position = ccp(STARTX,STARTX);
    [view addChild:fruitLayer];
}

-(void) initTempFruit {
    for (int i=0; i<COL; i++) {
        int index = [self getNoRepeatIndex:i];
        Fruit *sp = [Fruit spriteWithTexture:[[GameResource shared].fruitTextureArray objectAtIndex:index]];
        //sp.anchorPoint = CGPointZero;
        sp.position = CGPointMake(i%COL*FRUITWIDTH+FRUITWIDTH/2, ((int)i/COL)*FRUITHEIGHT+FRUITHEIGHT/2);
        sp.style = index;
        sp.fruitCenter = sp.position;
        [tempFruitArray addObject:sp];
        [fruitLayer addChild:sp z:0 tag:0]; 
    }
}

-(void)refreshFruit {
    
    if([self isLockFruit]) return;
    
    //[self test];

    [self lockFruit];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[fruitArray count]; i++) {
        Fruit *fruit = [fruitArray objectAtIndex:i];
        //重置水果的位置
        fruit.position = CGPointMake(i%COL*FRUITWIDTH+FRUITWIDTH/2, ((int)i/COL)*FRUITHEIGHT+FRUITHEIGHT/2);
        
        id animateDone = [CCCallFuncND actionWithTarget:self selector:@selector(changeFruit:data:) data:fruit];
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

-(void)refreshBombFruit {
    if([self isLockFruit]) return;
    
    [self lockFruit];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[fruitArray count]; i++) {
        Fruit *fruit = [fruitArray objectAtIndex:i];
        //重置水果的位置
        fruit.position = CGPointMake(i%COL*FRUITWIDTH+FRUITWIDTH/2, ((int)i/COL)*FRUITHEIGHT+FRUITHEIGHT/2);
        id animateDone = [CCCallFuncND actionWithTarget:self selector:@selector(changeBombFruit:data:) data:fruit];
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

//重置各水果种类的分数
- (void) resetScoreArray {
    for (int i=0; i<[scoreArray count]; i++) {
        [scoreArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }
}

- (void) resetPosition {
    for (int i=0; i<[[self fruitArray] count]; i++) {
        Fruit *fruit = [[self fruitArray] objectAtIndex:i];
        //fruit.fruitCenter = fruit.position;
        CGPoint point = CGPointMake(i%COL*FRUITWIDTH+FRUITWIDTH/2, ((int)i/COL)*FRUITHEIGHT+FRUITHEIGHT/2);
        if(fruit.position.x!=point.x || fruit.position.y!=point.y){
            NSLog(@"restPosition ss:%@",NSStringFromCGPoint(fruit.position));
        }
        fruit.fruitCenter = point;
        fruit.position = point;
    }
    [self resetTempFruitPosition];
}

- (void) resetTempFruitPosition {
    for (int i=0; i<[[self tempFruitArray] count]; i++) {
        Fruit *temp = [[self tempFruitArray] objectAtIndex:i];
        temp.position = ccp(-200,-200);
        temp.fruitCenter = temp.position;
    }
}


-(void)drawFruit:(NSMutableArray *)array {
    for (int i=0; i<[array count]; i++) {
        UIImageView *fruit =  [array objectAtIndex:i];
        [fruit.image drawAtPoint:CGPointMake(0, 0)];
    }
}

-(void)removeFruit:(NSMutableArray *)array {
    for (int i=0; i<[array count]; i++) {
        UIImageView *fruit =  [array objectAtIndex:i];
        fruit.alpha = 0;
        [fruit removeFromSuperview];
    }
}

-(NSString *)getDirection:(CGFloat)x y:(CGFloat)y {
    NSString *dir;
    if(clickStatus == 0)
        if(x>0) dir = @"left";
        else dir = @"right";
        else
            if(y>0) dir = @"up";
            else dir = @"down";
    return dir;
}

//复制单个水果
-(void) copyFruit:(int)index {

    if (index>=ROW*COL) return;

    Fruit *copyfruit = [fruitArray objectAtIndex:index];

        int tempIndex = -1;
        if(clickStatus == 0)
            tempIndex = index%COL;
        else if(clickStatus == 1)
            tempIndex = index/COL;
        
        if(tempIndex == -1) return;
        //NSLog(@"index:%d,,tempIndex:%d",index,tempIndex);
        
        Fruit *fruit = [tempFruitArray objectAtIndex:tempIndex];
        fruit.texture = copyfruit.texture;
        fruit.position = ccp(-200,-200);
        fruit.fruitCenter = copyfruit.fruitCenter;
        fruit.style = copyfruit.style;
        fruit.item = copyfruit.item;
}

//复制整行水果
-(void) copyRowFruit:(int)index {
    int m = [self getRowFrist:index];
    for(int i=m; i<m+COL; i++) {  
        [self copyFruit:i];
    }
}

//复制整列水果
-(void) copyColFruit:(int)index {
    int m = (int)(index%COL);
    for(int i=m; i<[fruitArray count]; i+=COL) {
        [self copyFruit:i];
    }
}


//移动整行水果 x>0　向左移动　　x<0　向右移动
-(void) moveRowFruit:(int)index x:(CGFloat)x y:(CGFloat)y {
    //NSLog(@"x:%f",x);
    
    
    //XXXXXXXX
    //XXXXXXXX
    //XXXXXXXX
    //OXXXXXXX
    //XXXXXXXX
    //XXXXXXXX
     
    if(index>=ROW*COL || index<0) return;
    
    int m = [self getRowFrist:index];
    int location = COL*FRUITWIDTH; //计算什么情况下无限滚动图片
    if(x>0) location = -location;  //滚动行的坐标
    
    NSLog(@"m:%d x:%f,y:%f　　location:%d  row:%d col:%d",m,x,y,location,ROW,COL);
    
    int tempIndex = 0;
    for(int i=m; i<m+COL; i++) {
        
        Fruit *fruit = [fruitArray objectAtIndex:i];

        int swaplocation;
        if (x>0){ //向左拖动 <<  0->53     
            swaplocation = (tempIndex+1)*FRUITWIDTH;
        }else{ //向右拖动 >>  53->0
            swaplocation = (COL-tempIndex)*FRUITWIDTH;
        }

        NSLog(@"M:%d NSCGPOINT:%@",i,NSStringFromCGPoint(fruit.position));
        if(abs(x)>=swaplocation){//x坐标大于行长度+一个水果的宽度时,重新计算该坐标
            [self moveFruit:fruit x:x+location y:0];
            
        }else{
            [self moveFruit:fruit x:x y:0]; //跟随触摸移动水果
        }

        if(tempIndex<COL){
            [self moveFruit:[tempFruitArray objectAtIndex:tempIndex] x:x+location y:0];
        }
        tempIndex++;
    }
}

//移动整列水果　y大于0 向左　y小于0向右
-(void) moveColFruit:(int)index x:(CGFloat)x y:(CGFloat)y {
    
    if(index>=ROW*COL) return;
    
    int m = [self getColFrist:index]; // 获取是第几列的水果
    int location = ROW*FRUITHEIGHT; //计算什么情况下无限滚动图片
    if(y>0) location = -location;
    
    //NSLog(@"m:%d x:%f,y:%f　　location:%d",m,x,y,location);
    int tempIndex = 0;
    for(int i=m; i<[fruitArray count]; i+=COL) {
        Fruit *fruit = [fruitArray objectAtIndex:i];
        
        int swaplocation;
        if (y>0){
            //往下拉
            swaplocation = (tempIndex+1)*FRUITHEIGHT;
        }else{
            //往上拉
            swaplocation = (ROW-tempIndex)*FRUITHEIGHT;
        }

        if(abs(y)>=swaplocation){
            [self moveFruit:fruit x:0 y:y+location];
            //NSLog(@"fruit.y:%f",fruit.position.y);
        }else{
            [self moveFruit:fruit x:0 y:y];
        }
        
        if(tempIndex<ROW)
            [self moveFruit:[tempFruitArray objectAtIndex:tempIndex] x:0 y:y+location];
        
         tempIndex++;
    }
}

//移动单个水果
-(void) moveFruit:(Fruit *)fruit x:(CGFloat)x y:(CGFloat)y {
    if(fruit!=NULL || fruit!=nil)
        fruit.position = ccp(fruit.fruitCenter.x - x,fruit.fruitCenter.y - y);
}

//触屏松开后，水果的位置自动对齐函数
-(void)autoMoveFruit:(NSInteger)index x:(CGFloat)x y:(CGFloat)y isOperate:(NSInteger)isOperate {  
        
    //clickStatus 0:横向 1:纵向
    if(clickStatus == ROW_OPER){
        _autoNum = isOperate==1?x:0;  // _autoNum 1:手工操作后，自动对齐 2:系统回滚,自动对齐
        _indexNum = [self getRowMoveNum:x];  //左右移了多少格
        _stopNum = _indexNum*FRUITWIDTH;//第N格的坐标
    }
    else if(clickStatus == COL_OPER){
        _autoNum = isOperate==1?y:0;
        _indexNum = [self getColMoveNum:y];
        _stopNum = _indexNum*FRUITHEIGHT;
    }
    
    _x = x;
    _y = y;
    _index = index;
    _isOperate = isOperate;
    
    //NSLog(@"clickStatus:%d x:%f y:%f,_autoNum:%d  indexNum:%d stopNum:%d",clickStatus,x,y,_autoNum,indexNum,stopNum);
        
    [view schedule:@selector(autoMove:) interval:0.01];
}


//水果自动对齐函数实现
-(void)autoMove:(ccTime)dt {
        
    //当前坐标大于停止的坐标就自增，不是则自减。
    int moveRange = MOVE_RANGE;
    if (_isOperate==1) moveRange = MOVE_RANGE;
    
    if (_autoNum>_stopNum) _autoNum-=moveRange;
    else if (_autoNum<_stopNum) _autoNum+=moveRange;
    
    //坐标为浮点数，界于停止位置左右1像素的特殊处理。
    if(abs(_autoNum-_stopNum)<=moveRange) _autoNum = _stopNum;

    //NSLog(@"indexNum:%d,stopNum:%d",indexNum,stopNum);

    if(clickStatus == 0){
        _x = _autoNum;
        _y = 0;
        [self moveRowFruit:_index x:_x y:_y];
    }
    else if(clickStatus == 1){
        _x = 0;
        _y = _autoNum;
        [self moveColFruit:_index x:_x y:_y];
    }
    
    //NSLog(@"_autoNum:::::::::::%d      stopNum.........:%d",_autoNum,stopNum);
    //自动对齐后，才可进行第二轮的移动。
    if(_autoNum==_stopNum) {
        [view unschedule:@selector(autoMove:)];

        if(clickStatus == 0){
            [self roundRowFruit:fruitArray index:_index limit:COL num:_indexNum];
        }else if(clickStatus == 1){
            [self roundColFruit:fruitArray index:_index low:0 upp:ROW num:_indexNum];
        }
               
        NSInteger num = 0;
        //手工操作才进行判测，若无可消除的水果，回退操作时不判测。
        if (_isOperate==1) {
            [self resetTempFruitPosition];
            num = [self checkAndMoveFruit:[NSNumber numberWithInt:0]]; //检则连接在一起的水果
        }
        
        //如果是手工操作的,消除水果的数量等于0，则要让系统自动回滚水果。
        if(num==0 && _isOperate==1){
            [self resetPosition];
            if(clickStatus == 0) [self copyRowFruit:_index];
            else if(clickStatus == 1) [self copyColFruit:_index];
            [self autoMoveFruit:_index x:-_x y:-_y isOperate:0];

        }else if(num==0 && _isOperate==0){
            [self initNextOper]; //初始化下一个操作
        }
    }
}

- (void) runBomb {
    if([self isLockFruit]) return;
    [self lockFruit];
    NSMutableArray *bombArray = [[NSMutableArray alloc] init];
    for (int i=0; i<COL; i++) {
        int rand = [CommUtils getRandom:0 to:ROW];
        [bombArray addObject:[NSNumber numberWithInt:i+rand*COL]];
    }
    [self bombFruit:bombArray];
}

//limit:旋转多少个　num:旋转多少次　行旋转一下数组
- (void) roundRowFruit:(NSMutableArray *)array index:(int)index limit:(int)limit num:(int)num { 
    if (num==0 || index>=ROW*COL) {
        return;
    }
    
    index = [self getRowFrist:index];
    
    for (int m=0; m<abs(num); m++) {
        if(num>0){
            //往下标越小的方向移
            for(int i=index; i<index+COL-1; i++){
                [array exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
        }else {
            //往下标越大的方向移
            for (int i=index+COL-1; i>index; i--) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:i-1];
            }
        }
    }
}

//无limit 列方向旋转一次数组
- (void) roundColFruit:(NSMutableArray *)array index:(int)index low:(int)low upp:(int)upp num:(int)num {
    
    if (num==0) return;
    index = [self getColFrist:index];
    
    if (num>0){
        for (int m=0; m<abs(num); m++) {
            //往下标越小的方向移
            for(int i=index+low*COL; i<upp*COL; i+=COL){
                // 0 1 2 3 4 index: 1 2 3 4 0
                // A B C D E value: B C D E A
                if(i+COL<[fruitArray count]){
                    [array exchangeObjectAtIndex:i withObjectAtIndex:i+COL];
                }
            }
        }
    }else{
        for (int m=0; m<abs(num); m++) {
            //往下标越大的方向移
            for(int i=upp*COL+index-COL; i>=index+low*COL; i-=COL){
                // 0 1 2 3 4 index: 1 2 3 4 0
                // A B C D E value: E A B C D
                if(i-COL>=index){
                    [array exchangeObjectAtIndex:i withObjectAtIndex:i-COL];
                }
            }
        }
    }
}

-(int)getCol:(int)index{
    return (int)index%COL;
}

-(int)getRow:(int)index{
    return index/COL;
}

-(int)getRowFrist:(int)index{
    return (index/COL)*COL;
}

-(int)getColFrist:(int)index{
    return (int)index%COL;
}

-(int)getLastRowIndex:(int)index{
    return [self getRowFrist:index]+COL;
}

-(int)getLastColIndex:(int)index{
    return (int)(ROW-1)*COL+index%COL;
}

//左右移动了几格
-(int)getRowMoveNum:(CGFloat)x{
    int indexNum = x/FRUITWIDTH;  // 左右移动格数
    if(abs((int)x%FRUITWIDTH)>FRUITWIDTH/2) indexNum+=(x>=0?1:-1);
    return indexNum;
}

//上下移动了几格
-(int)getColMoveNum:(CGFloat)y{
    int indexNum = y/FRUITHEIGHT;
    if(abs((int)y%FRUITHEIGHT)>FRUITHEIGHT/2) indexNum+=(y>=0?1:-1);
    return indexNum;
}

- (void) checkAndMoveFruit:(id)sender data:(NSNumber *)level{
    [self checkAndMoveFruit:level];
}

- (int) checkAndMoveFruit:(NSNumber *)level {
    
    int l = [level intValue];
    
    NSMutableArray *sameFruit = [self checkFruit]; //判断行上和列上的水果
    
    int num = [sameFruit count];
    _percentNum+=num;
    if(num<=0){
        if(l!=0){
            if(_percentNum>=9){
                [self calcScore:[NSNumber numberWithInt:88]]; //计算得分
                [self combo]; //combo动画
                
                if(((GameLayer *)view).soundCanPlay==1)
                [SoundUtils playEffect:@"combo.caf" volume:1.0];
                
                [(GameLayer *)view addTime:3];
            }else if(_percentNum>=6){
               [(GameLayer *)view addTime:2];
            }else if(_percentNum>=4){
                [(GameLayer *)view addTime:1];
            }
            
            if(l==1){
                if(helpNum>0){
                    [self tip:nil];
                    helpNum--;
                }
            }
            [self initNextOper];
        }
    }else{
        [self dropFruit:sameFruit level:level];
    }
    return num;
}

- (void)combo {
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *sp = [CCSprite spriteWithFile:@"combo.png"];
    sp.position = CGPointMake(size.width/2,180);
    [view addChild:sp];
    
    id actionMove = [CCMoveTo actionWithDuration:0.5 position:ccp(sp.position.x, sp.position.y+60)]; 
    id actionScaleX = [CCScaleTo actionWithDuration:0.5 scale:2];
    id actionFadeOut = [CCFadeTo actionWithDuration:0.5 opacity:0];
    id actionMoveDone = [CCCallFuncND actionWithTarget:self 
                                              selector:@selector(comboDone:data:) data:sp];
    [sp runAction:[CCSequence actions:actionMove,actionScaleX,actionFadeOut,actionMoveDone, nil]];
}

- (void)comboDone:(id)sender data:(CCSprite *)sp {
    [sp removeFromParentAndCleanup:YES];
}

- (void) initNextOper {
    _autoNum=0;
    _percentNum = 0;
    
    //重置水果的fruitCenter坐标
    [self resetPosition];
    [[self bombMgr] reset]; //重新计算index
    _curClickFruitIndex = -1;
    _lastClickFruitIndex = -1;
    self.clickStatus = -1;//拖动的方向初始为默认值。
    NSArray *array  = [self searchTip:0];
    if (array==NULL || array==nil) [self refreshFruit];
    
    [self unlockFruit];
}


// 检测可消除的水果列表
- (NSMutableArray *) checkFruit{
    
    NSMutableArray *sameFruit = [[NSMutableArray alloc] init];
    
    //横向
    for (int i=0; i<[fruitArray count]; i++){
        
        int sameNum = 1;
        Fruit *fruit1 = [fruitArray objectAtIndex:i];
        
        //列中的倒数两个不用判直接跳过
        int col = [self getCol:i];
        
        if(col>=COL-2) continue;
        
        //列上的水果与之后的水果做比较，如果相同计下水果的数量,相同数大于3时存入sameFruit
        for (int j=i+1; j<[self getRowFrist:i]+COL; j++){
            Fruit *fruit2 = [fruitArray objectAtIndex:j];
            if(fruit1.style == fruit2.style) sameNum++;
            else break;
        }
        
        if(sameNum>=3) {
            
            for (int k=i; k<i+sameNum; k++){
                if(![sameFruit containsObject:[NSNumber numberWithInt:k]])
                                    [sameFruit addObject:[NSNumber numberWithInt:k]];
            }
        }
        
    }
    
    //纵向
    for (int i=0; i<[fruitArray count]; i++){
        int sameNum = 1;
        Fruit *fruit1 = [fruitArray objectAtIndex:i];
        
        //行中的倒数两个不用判直接跳过
        int row = [self getRow:i];
        if(row>=ROW-2) continue;
        
        //获取之后几行的该列水果做比较
        for(int j=i+COL; j<[fruitArray count]; j+=COL) {
            Fruit *fruit2 = [fruitArray objectAtIndex:j];
            if(fruit1.style == fruit2.style) sameNum++;
            else break;
        }
        
        if(sameNum>=3) {
            for (int k=i; k<i+sameNum*COL; k+=COL){
                if(![sameFruit containsObject:[NSNumber numberWithInt:k]])
                    [sameFruit addObject:[NSNumber numberWithInt:k]];
            }
        }
    }
    return [sameFruit autorelease];
}


-(BOOL) hasItem:(int)itemIndex {
    BOOL b = false;
    for (int i = 0; i<[itemArray count]; i++){
        Item *item = [itemArray objectAtIndex:i];
        if(item.style == itemIndex){
            [self useItem:i];
            b = true;
            break;
        }
    }
    return b;
}
-(void) autoUseItem:(int)itemIndex {
    for (int i = 0; i<[itemArray count]; i++){
        Item *item = [itemArray objectAtIndex:i];
        if(item.style == itemIndex){
            [self useItem:i];
            return;
        }
    }
}

-(void) useItem:(int)itemNum {
    if(itemNum==-1 || !autoMoveComplete) return;
    
    Item *curItem = [itemArray objectAtIndex:itemNum];
    [itemArray removeObject:curItem];
    [curItem removeFromParentAndCleanup:YES];
    if(((GameLayer *)view).soundCanPlay==1)
    [SoundUtils playEffect:@"sea_sound.caf" volume:0.5];
    
    if([itemArray count]>0){
        for (int i = itemNum; i<[itemArray count]; i++){
            Item *item = [itemArray objectAtIndex:i];
            if(i>=6) break;
            float x =  [[xArray objectAtIndex:i] floatValue];
            [item runAction:[CCMoveTo actionWithDuration:0.2 position:ccp(x,ITEM_ARRAY_Y)]];
        }
    }
}

-(void) useAndAddItem:(int)itemNum {
    [self lockFruit];
    Item *curItem = [itemArray objectAtIndex:0];
    [itemArray removeObject:curItem];
    [curItem removeFromParentAndCleanup:YES]; 
    
    if([itemArray count]>0){
        for (int i = 0; i<[itemArray count]; i++){
            Item *item = [itemArray objectAtIndex:i];
            if(i>=6) break;
            float x =  [[xArray objectAtIndex:i] floatValue];
            id moveAction = [CCMoveTo actionWithDuration:0.2 position:ccp(x,ITEM_ARRAY_Y)];
            if(i==[itemArray count]-1){
                id moveActionDone = [CCCallFuncND actionWithTarget:self selector:@selector(addAfterItem:data:) data:[NSNumber numberWithInt:itemNum]];
                [item runAction:[CCSequence actions:moveAction,moveActionDone, nil]];
            }else{
                [item runAction:moveAction];
            }
        }
    }
}
                                  
-(void)addAfterItem:(id)sender data:(NSNumber *)itemNum {
    //int imageIndex = [CommUtils getRandom:0 to:[itemImageArray count]];
    Item *item = [Item spriteWithFile:[itemImageArray objectAtIndex:[itemNum intValue]]];
    [itemArray addObject:item];
    item.style = [itemNum intValue];
    [item SetCanTrack:YES];
    float x = [[xArray objectAtIndex:[itemArray count]-1] floatValue];
    item.position = ccp(x,ITEM_ARRAY_Y);
    [view addChild:item];
    [self unlockFruit];
}

//添加道具
-(void)addItem:(int)imageIndex {
    @synchronized(itemArray){
        if([itemArray count]<6){
            Item *item = [Item spriteWithFile:[itemImageArray objectAtIndex:imageIndex]];
            [itemArray addObject:item];
            [item SetCanTrack:YES];
            item.style = imageIndex;
            float x = [[xArray objectAtIndex:[itemArray count]-1] floatValue];
            item.position = ccp(x,ITEM_ARRAY_Y);
            [view addChild:item];
        }else{
            //NSLog(@"useAndItem");
            [self useAndAddItem:imageIndex];
        }
    }
}
//生成道具
-(void)createItem {
     @synchronized(itemArray) {
        int imageIndex = [CommUtils getRandom:0 to:[itemImageArray count]];
         if(imageIndex >= [itemImageArray count]-1) {
             imageIndex = [CommUtils getRandom:0 to:[itemImageArray count]]; //降低乌龟的机率
         }
        [self addItem:imageIndex];
     }
}

-(void)scoreAndItem:(NSArray *)array num:(int)sameNum index:(int)index level:(int)level{
    
    if([(GameLayer *)view gamePlaying]){
        
        int bombcount = 0;
        int calcScore = 0;
        int score = 0;
        for (int i=0; i<[array count]; i++) {
            Fruit *fruit = [fruitArray objectAtIndex:[[array objectAtIndex:i] intValue]];
            if(fruit.style>=[fruitImageArray count]-1){
                bombcount++;
            }
            
            //计算水果个数
            int curNum = [[scoreArray objectAtIndex:fruit.style] intValue];
            [scoreArray replaceObjectAtIndex:fruit.style 
                                  withObject:[NSNumber numberWithInt:curNum+1]];
            
            //得分动画
            CGPoint pt; 
            if(sameNum==1) pt = CGPointMake([self getCol:index]*FRUITWIDTH,[self getRow:index]*FRUITHEIGHT);
            else pt = fruit.position;
            
            calcScore = _multiple*(level+1)*sameNum;
            score +=calcScore;
            NumUtils *util = [[[NumUtils alloc] init:view] autorelease];
            [util drawScore:view beginPoint:pt
                   endPoint:ccp(coin.position.x,coin.position.y) num:[NSString stringWithFormat:@"%d",calcScore]];
        }
        

        // 一次只生成一个道具
        if(bombcount>=3) [self createItem];
        
        //计算得分
        //[self calcScore:score];
        [self performSelector:@selector(calcScore:) 
                   withObject:[NSNumber numberWithInt:score] afterDelay:1];
    }
}

//　原地消除消除水果动画
- (void)fruitBomb:(NSMutableArray *)array complete:(BOOL)complete {
    
    if([array count]==0) return;
    
    for (int i=0; i<[array count]; i++){
        int index = [[array objectAtIndex:i] intValue];
        
        //NSLog(@"fruitBomb index:%d",index);
        Fruit *fruit = [fruitArray objectAtIndex:index];
        
        if(i==0){
            [self scoreAndItem:array num:[array count] index:index level:1];
            if(((GameLayer *)view).soundCanPlay==1){
                [SoundUtils playEffect:@"bombflower.caf" volume:1.0];
            }
        }
    
        fruit.visible = false;
        Adventurer *adventurer = [bombMgr getBomb];
        //[view reorderChild:adventurer z:9];
        if(adventurer!=nil){
            NSMutableArray *idArray = [[NSMutableArray alloc] init];
            adventurer.charSprite.position = fruit.position;
            id bombWalkAction = adventurer.walkAction;
            if(idArray!=nil)
            [idArray addObject:bombWalkAction];
            id bombWalkComplete = [CCCallFuncN actionWithTarget:self selector:@selector(bombWalkComplete:)];
            [idArray addObject:bombWalkComplete];
            id animateDone = [CCCallFuncND actionWithTarget:self selector:@selector(changeFruit:data:) data:fruit];
            [idArray addObject:animateDone];
            
            if(i==[array count]-1 && complete){
                id checkAndMoveFruit = [CCCallFuncND actionWithTarget:self 
                                                           selector:@selector(checkAndMoveFruit:data:) data:[NSNumber numberWithInt:1]];
                [idArray addObject:checkAndMoveFruit];
            }
            
            [adventurer.charSprite runAction:[CCSequence actionWithArray:idArray]];
            [idArray release];
        }
    }
}

// 更换精灵图片
- (void)changeFruit:(id)sender data:(Fruit *)param {
    
    Fruit *fruit = param;
    
    int index = [self getNoRepeatIndex:0];
    
    fruit.texture = [[GameResource shared].fruitTextureArray objectAtIndex:index];

    fruit.style = index;
    fruit.visible = true;
}

// 更换精灵图片
- (void)changeBombFruit:(id)sender data:(Fruit *)param {
    
    Fruit *fruit = param;
    
    int index = [fruitImageArray count]-1;
    int ii = [CommUtils getRandom:0 to:6];
    if(ii<5) {
        index = [self getNoRepeatIndex:0];
    }
    
    fruit.texture = [[GameResource shared].fruitTextureArray objectAtIndex:index];
    
    fruit.style = index;
    fruit.visible = true;
}

- (void) swapFruit:(int)aIndex to:(int)bIndex isOperate:(BOOL)isOperate {
    
    if(isOperate && [self isLockFruit]) return;
    if(isOperate) [self lockFruit];

    Fruit *aFruit = [fruitArray objectAtIndex:aIndex];
    Fruit *bFruit = [fruitArray objectAtIndex:bIndex];
    
    //上下移动
    id actionDownMove = [CCMoveTo actionWithDuration:0.2 position:ccp(bFruit.position.x, bFruit.position.y)]; 
    
    [aFruit runAction:[CCSequence actions:actionDownMove, nil]];
    
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    id actionUpMove = [CCMoveTo actionWithDuration:0.2 position:ccp(aFruit.position.x, aFruit.position.y)];
    [idArray addObject:actionUpMove];
    
    
    //交换水果下标
    id swapFruitIndex = [CCCallFuncND actionWithTarget:self selector:@selector(swapFruitIndex:data:) 
            data:[[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:aIndex],
                    [NSNumber numberWithInt:bIndex],nil]];
    [idArray addObject:swapFruitIndex];


    if(isOperate){
        //手工操作调用
        id swapFruitComplete = [CCCallFuncND actionWithTarget:self selector:@selector(swapFruitComplete:data:) 
            data:[[NSArray alloc] initWithObjects:
                  [NSNumber numberWithInt:aIndex],
                  [NSNumber numberWithInt:bIndex],nil]];
        [idArray addObject:swapFruitComplete];
    }else{
        //自动回滚调用
        id initNextOper = [CCCallFuncN actionWithTarget:self selector:@selector(initNextOper)]; 
        [idArray addObject:initNextOper];
    }
    
    [bFruit runAction:[CCSequence actionWithArray:idArray]];
    [idArray release];
}

-(void)swapFruitIndex:(id)sender data:(NSArray *)param {
    int aIndex = [[param objectAtIndex:0] intValue];
    int bIndex = [[param objectAtIndex:1] intValue];
    [fruitArray exchangeObjectAtIndex:aIndex withObjectAtIndex:bIndex];
    [param release];
}

-(BOOL)isLockFruit{
    return !autoMoveComplete;
}

-(void)lockFruit {
    autoMoveComplete = FALSE;
}
-(void)unlockFruit {
    autoMoveComplete = TRUE;
}

//交换水果结束时，触发该函数
- (int)swapFruitComplete:(id)sender data:(NSArray *)param {
    int aIndex = [[param objectAtIndex:0] intValue];
    int bIndex = [[param objectAtIndex:1] intValue];
    
    NSMutableArray *sameFruit = [self checkFruit]; //判断行上和列上的水果
    
    if([sameFruit count]<=0){
        [self swapFruit:bIndex to:aIndex isOperate:NO];
    }else{
        [self checkAndMoveFruit:[NSNumber numberWithInt:0]];
    }
    [param release];
    return [sameFruit count];
}

- (void)bombWalkComplete:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    sprite.position = ccp(-100,-100);
}

- (void) dropFruit:(NSMutableArray *) sameFruit level:(NSNumber *)level{
    if([sameFruit count]==0) return;
    
    [self lockFruit];
    
    //将要消除的水果进行排序
    [sameFruit sortUsingSelector:@selector(compare:)];

    //进行得分计算
    int fIndex = [[sameFruit objectAtIndex:0] intValue];
    //Fruit *fruit = [fruitArray objectAtIndex:fIndex];
    [self scoreAndItem:sameFruit num:[sameFruit count] index:fIndex level:[level intValue]];
    if(((GameLayer *)view).soundCanPlay==1){
        [SoundUtils playEffect:@"bombflower.caf" volume:1.0];
    }
    
    //生成爆炸效果
    for (int i=0; i<[sameFruit count]; i++) {
        int index = [[sameFruit objectAtIndex:i] intValue];
        Fruit *fruit = [fruitArray objectAtIndex:index];
        
        Adventurer *adventurer = [bombMgr getBomb];
        //[view reorderChild:adventurer z:9];
        if(adventurer!=nil){
            adventurer.charSprite.position = fruit.position;
            //爆炸动画
            id bombWalkAction = adventurer.walkAction;
            //动画执行后将精灵坐标赋值为-100,-100
            id bombWalkComplete = [CCCallFuncN actionWithTarget:self selector:@selector(bombWalkComplete:)];
            [adventurer.charSprite runAction:[CCSequence actions:bombWalkAction,bombWalkComplete, nil]];
        }
    }
    
    // 计算列上被消除了多少个水果
    for (int i=0; i<COL; i++) {
        
        //获取该列上被消除的水果
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int j= 0; j<[sameFruit count]; j++){
            int temp =  [[sameFruit objectAtIndex:j] intValue];
            if(temp%COL==i) [array addObject:[NSNumber numberWithInt:temp]];
        }
                
        //如果列上的数目大于0则进入转换逻辑
        int deltaY = 0; // 向上偏移量
        
        if([array count]>0) {
            //获取当前列最后一个水果,将水果的位置放在其之上，若多个水果则按数量计算位置
            //Fruit *lastColFruit =[fruitArray objectAtIndex:[self getLastColIndex:i]];
            //NSLog(@"lastColFruit:%f",lastColFruit.position.y );
            for (int k=0; k<[array count]; k++) {
                int index =[[array objectAtIndex:k] intValue];
                Fruit *obj = [fruitArray objectAtIndex:index];
                deltaY+=FRUITHEIGHT;
                obj.position = ccp(obj.position.x,FRUITHEIGHT/2+ROW*FRUITHEIGHT+deltaY);
                [self changeFruit:nil data:obj]; //更换精灵图片
                
                //XXXXXXX  XXXXXX     XXXXXX    XXXXXX
                //XXXX0XX  XX000X  -> XXXXXX -> XXXXXX
                //XXX000X  XXXXXX     XX000X    XXXXXX
                //XXXX0XX  XX000X     XXXXXX    XXXXXX
                //转换下标,如果中间的水果被消除按个数旋转,若是最后一行水果则不转换
                [self roundColFruit:fruitArray index:index low:[self getRow:index] upp:ROW num:1];
                    
                    //旋转了数组,列上后几个水果相应的减少下标。
                    for (int l=k; l<[array count]; l++) {
                        int tempIndex = [[array objectAtIndex:l] intValue];
                        [array replaceObjectAtIndex:l withObject:[NSNumber numberWithInt:tempIndex-COL]];
                    }
            }
            
            //上述程序将水果生成列之上了,接下来就是要将生成的水果落入矩阵中。
            for (int s=i; s<ROW*COL; s+=COL){
                Fruit *obj = [fruitArray objectAtIndex:s];
                obj.fruitCenter = CGPointMake(obj.position.x, FRUITHEIGHT/2+[self getRow:s]*FRUITHEIGHT);
                
                id actionMove = [CCMoveTo actionWithDuration:0.3 position:ccp(obj.position.x, FRUITHEIGHT/2+[self getRow:s]*FRUITHEIGHT)];

                if(s+COL>=ROW*COL) {
                    
                    id actionMoveDone = [CCCallFuncND actionWithTarget:self selector:@selector(checkAndMoveFruit:data:) data:[NSNumber numberWithInt:1]];
                    
                    [obj runAction:[CCSequence actions:actionMove,[CCDelayTime actionWithDuration:0.1],actionMoveDone, nil]];
                }else
                    [obj runAction:actionMove];
            }
        }
    }
    

}

// 使用bomb道具爆炸水果
- (void) bombFruit:(NSMutableArray *) sameFruit {
    
    //多点触摸都有触摸到点时触发
    if([sameFruit count]>=SAMENUM) {
        [self lockFruit];
        //排序
        [sameFruit sortUsingSelector:@selector(compare:)];
        
        [self roundColMove:nil data:[NSMutableArray arrayWithObjects:sameFruit,[NSNumber numberWithInt:0], nil]];
    }
}

-(void)roundColMove:(id)sender data:(NSArray *)param {
    
    NSArray *sameFruit = [param objectAtIndex:0];
    int index = [[param objectAtIndex:1] intValue]; //当前执行的是第几列水果
    int curIndex = [[sameFruit objectAtIndex:index] intValue];
    
    //取消最后一列的水果，其实就是将坐标移出界面，坐标取最后一列水果的坐标+当前水果坐标
    Fruit *lastColFruit =[fruitArray objectAtIndex:[self getLastColIndex:curIndex]];
    Fruit *obj = [fruitArray objectAtIndex:curIndex];
    
    
    Adventurer *adventurer = [bombMgr getBomb];
    if(adventurer!=nil){
        adventurer.charSprite.position = ccp(obj.position.x,obj.position.y);
        id bombWalkAction = adventurer.walkAction;
        id bombWalkComplete = [CCCallFuncN actionWithTarget:self selector:@selector(bombWalkComplete:)];
        [adventurer.charSprite runAction:[CCSequence actions:bombWalkAction,bombWalkComplete, nil]];
    }
    
    //如果是列中的最后一个水果，取只需要更换一个水果即可。
    int height = 0;
    if([self getColFrist:curIndex]!=[self getLastColIndex:curIndex])
        height = FRUITHEIGHT;
    
    obj.position = ccp(obj.position.x,lastColFruit.position.y+height);
    obj.fruitCenter = obj.position;
    [self changeFruit:nil data:obj];
    
    for (int k=curIndex; k<ROW*COL; k+=COL) {
        
        NSMutableArray *idArray = [[NSMutableArray alloc] init];
        
        Fruit *fruit = [fruitArray objectAtIndex:k];
        
        id delay = [CCDelayTime actionWithDuration:0.1];
        [idArray addObject:delay];
        
        id actionMove = [CCMoveTo actionWithDuration:0.2 
                                            position:ccp(fruit.position.x, fruit.position.y-height)];
        [idArray addObject:actionMove];
        
        if(k+COL>=ROW*COL){
            [self scoreAndItem:[NSArray arrayWithObject:[NSNumber numberWithInt:curIndex]] 
                           num:1 index:curIndex level:23];
            
            id actionMoveDone = [CCCallFuncND actionWithTarget:self selector:@selector(bombFruitFinished:data:) data:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:curIndex],[NSNumber numberWithInt:1], nil]];
            [idArray addObject:actionMoveDone];
            
            
            if(index<[sameFruit count]-1){
                id dropFruitDone = [CCCallFuncND actionWithTarget:self selector:@selector(roundColMove:data:) data:[[NSMutableArray alloc] initWithObjects:sameFruit,[NSNumber numberWithInt:++index], nil]];
                [idArray addObject:dropFruitDone];
            }else{
                //所有水果执行后，检测水果
                id dropAllDone = [CCCallFuncND actionWithTarget:self selector:@selector(checkAndMoveFruit:data:) data:[NSNumber numberWithInt:1]];
                [idArray addObject:dropAllDone];
            }
        }
        
        [fruit runAction:[CCSequence actionWithArray:idArray]];
        [idArray release];
    }
}
    
-(void)bombFruitFinished:(id)sender data:(NSMutableArray *)param {   
        
        int min = [[param objectAtIndex:0] intValue];
        int num = [[param objectAtIndex:1] intValue];
        //转换下标
        [self roundColFruit:fruitArray index:min low:[self getRow:min] upp:ROW num:num];
} 

         
-(void)calcScore:(NSNumber *)num{
  _score+=[num intValue];
 [view schedule:@selector(scoreAnimal:) interval:0.01];
}
 
 -(void)scoreAnimal:(ccTime)dt {

     int curScore = [[scoreValue string] intValue];
     
     int tmp = _score-curScore;
     if(tmp<10) curScore++;
     else if(tmp<100) curScore+=6;
     else curScore+=12;
     
     [scoreValue setString:[NSString stringWithFormat:@"%d",curScore]];
     [scoreValueBg setString:[NSString stringWithFormat:@"%d",curScore]];
     if(curScore>=_score)
         [view unschedule:@selector(scoreAnimal:)];
 }

-(void)stopScoreAnimal {
    [view unschedule:@selector(scoreAnimal:)];
}

- (int) getLevelScore {
    int levelScore = 0;
    for(int i=1; i<=_level; i++){
        levelScore+=i*LEVELSCORE;
    }
    return levelScore;
}
- (BOOL)levelup {
    BOOL b = _score>=[self getLevelScore];
    return b;
}

@end
