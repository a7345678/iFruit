//
//  GameResource.m
//  iFruit
//
//  Created by mac on 11-11-20.
//  Copyright 2011年 asiainfo-linkage. All rights reserved.
//

#import "GameResource.h"

static GameResource *resource = nil;

@implementation GameResource
@synthesize fruitImageArray,itemImageArray,itemPayArray,doubleClickBombArray,fourBombArray;
@synthesize fruitTextureArray,itemTextureArray;

+(GameResource *) shared {
    @synchronized(self) {
        if(resource==nil){
            resource = [[self alloc] init];
        }
    }
    return resource;
}

-(GameResource *) init {
    
    if ((self = [super init])) {
        
        fruitTextureArray = [[NSMutableArray alloc] init];
        if(isPad){
            fruitImageArray= [[NSArray alloc] initWithObjects:
                      @"fruit01_ipad.png",@"fruit02_ipad.png",@"fruit03_ipad.png",@"fruit04_ipad.png",
                      @"fruit05_ipad.png",@"fruit06_ipad.png",@"fruit07_ipad.png",@"fruit08_ipad.png",
                      @"fruit09_ipad.png", nil];
            
        }else{
            fruitImageArray= [[NSArray alloc] initWithObjects:
                              @"fruit01.png",@"fruit02.png",@"fruit03.png",@"fruit04.png",
                              @"fruit05.png",@"fruit06.png",@"fruit07.png",@"fruit08.png",
                              @"fruit09.png", nil];
        }
        
        for (int i=0; i<[fruitImageArray count]; i++) {
            [fruitTextureArray addObject:[[CCTextureCache sharedTextureCache]
                                         addImage:[fruitImageArray objectAtIndex:i]]];
        }
        
        itemImageArray = [[NSArray alloc] initWithObjects:@"bomb.png",@"refresh_button.png",@"x2.png",@"pause_time.png",@"tortoise_item.png",
            //@"bowitem.png", 
            nil];
        
        itemTextureArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[itemImageArray count]; i++) {
            [itemTextureArray addObject:[[CCTextureCache sharedTextureCache]
                                         addImage:[itemImageArray objectAtIndex:i]]];
        }
        
        // 爆竹 刷新 X2 时间 乌龟
        itemPayArray = [[NSArray alloc] initWithObjects:@"150",@"500",@"300",@"300",@"600",
                nil];
        
        doubleClickBombArray = [[NSArray alloc] initWithObjects:
                                [NSNumber numberWithInt:-1],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:-COL],[NSNumber numberWithInt:COL],nil];
        
        fourBombArray = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:-1],
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:0],
                         [NSNumber numberWithInt:-COL],
                         [NSNumber numberWithInt:COL],
                         [NSNumber numberWithInt:-COL-1],
                         [NSNumber numberWithInt:-COL+1],
                         [NSNumber numberWithInt:COL-1],
                         [NSNumber numberWithInt:COL+1],
                         nil];
    }
    return self;
}

- (CCTexture2D *)sharedStarBgTexture{
    if(starbgTexture==nil){
        starbgTexture = [[CCTextureCache sharedTextureCache] addImage:@"star_bg.png"];
    }
    return starbgTexture;
}

- (CCTexture2D *)sharedCoinTexture{
    if(coinTexture==nil){
        coinTexture = [[CCTextureCache sharedTextureCache] addImage:@"coin.png"];
    }
    return coinTexture;
}

- (CCTexture2D *)sharedContiuneTexture{
    if(contiuneTexture==nil){
        contiuneTexture = [[CCTextureCache sharedTextureCache] addImage:@"contine_button.png"];
    }
    return contiuneTexture;
}

- (CCTexture2D *)sharedRestartTexture{
    if(restartTexture==nil){
        restartTexture = [[CCTextureCache sharedTextureCache] addImage:@"restart.png"];
    }
    return restartTexture;
}

-(void)dealloc {
    [fruitImageArray release];
    [itemImageArray release];
    [fruitTextureArray release];
    [itemTextureArray release];
    [itemPayArray release];
    [doubleClickBombArray release];
    [fourBombArray release];
    [starbgTexture release];
    [coinTexture release];
    [contiuneTexture release];
    [restartTexture release];
    [super dealloc];
}
@end
