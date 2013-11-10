//
//  DMTools.h
//
//  Copyright (c) 2013 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTools : NSObject

// init user tool
- (id)initWithPublisherId:(NSString *)publisherId;

// check rate information
- (void)checkRateInfo;

@end