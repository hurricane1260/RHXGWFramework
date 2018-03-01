//
//  STKManager.h
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKSocket.h"
#import "STKCallbackInfo.h"
#import "STKAddress.h"

@interface STKManager : NSObject

+ (STKManager *)defaultManager;

+ (void)destroyManager;

- (STKSocket *)getSocketByAddress:(NSString *)address;

- (void)configSocketWithAddress:(STKAddress *)config;

- (void)clearByteCache;

- (void)cutOffSocket;

@end

