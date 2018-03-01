//
//  SKTBaseDelegate.h
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 rxhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKSocket.h"


@interface STKBaseDelegate : NSObject <AsyncSocketDelegate>

- (UInt16)requestWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler requestType:(UInt16)requestType params:(NSData *)params;

- (id)initWithHost:(NSString *)host port:(int)port;

- (void)addCallbackInfo:(STKCallbackInfo *)callback byRequestId:(int)rid;

- (STKCallbackInfo *)getCallbackInfoByRequestId:(int)rid;

- (void)removeCallbackInfoByRequestId:(int)rid;

@end
