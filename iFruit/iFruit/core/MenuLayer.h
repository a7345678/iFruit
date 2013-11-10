//
//  SysMenu.h
//  G03
//
//  Created by Mac Admin on 15/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SceneManager.h"

@interface MenuLayer : CCLayer {
   int musicCanPlay,soundCanPlay,howToPlay;
    CCSprite *unReadedSprite;
}

- (void)onNewGame:(id)sender;
+ (CCScene *) scene;

@end
