//
//  GameResource.h
//  iFruit
//
//  Created by mac on 11-11-20.
//  Copyright 2011年 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommUtils.h"



@interface GameResource : NSObject {
    NSArray *fruitImageArray,*itemImageArray;
    NSMutableArray *fruitTextureArray,*itemTextureArray;
    NSArray *itemPayArray;
    
    NSArray *doubleClickBombArray;
    NSArray *fourBombArray;
    
    CCTexture2D *starbgTexture,*coinTexture,*contiuneTexture,*restartTexture;
}

+(GameResource *) shared;
- (CCTexture2D *)sharedStarBgTexture;
- (CCTexture2D *)sharedCoinTexture;
- (CCTexture2D *)sharedContiuneTexture;
- (CCTexture2D *)sharedRestartTexture;

@property (nonatomic,retain) NSArray *fruitImageArray,*itemImageArray,*itemPayArray,*doubleClickBombArray,*fourBombArray;
@property (nonatomic,retain) NSMutableArray *fruitTextureArray,*itemTextureArray;

@end
