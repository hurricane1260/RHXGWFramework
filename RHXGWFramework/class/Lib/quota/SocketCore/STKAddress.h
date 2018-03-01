//
//  STKSocketConfig.h
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKAddress : NSObject

@property (nonatomic,retain) NSString *host;

@property (nonatomic,assign) int port;

- (id)initWithHost:(NSString *)host port:(int)port;

@end
