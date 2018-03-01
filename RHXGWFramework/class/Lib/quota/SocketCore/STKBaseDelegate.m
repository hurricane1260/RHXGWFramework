//
//  SKTBaseDelegate.m
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 rxhui. All rights reserved.
//

#import "STKBaseDelegate.h"
#import "STKManager.h"
#import "STKSocket.h"

@interface STKBaseDelegate()
{
    STKSocket *_socket;
    NSMutableDictionary *_callbackDict;
}
@end


@implementation STKBaseDelegate

- (UInt16)requestWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler requestType:(UInt16)requestType params:(NSData *)params
{
    STKData *request = [[STKData alloc] initWithRequestType:requestType params:params];
    STKRequestContext *requestContext = [[STKRequestContext alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler request:request];
    
    if (requestType == 10011) {
        requestContext.request.rid = 0;
    }
    [_socket request:requestContext];
    return request.rid;
}


- (id)initWithHost:(NSString *)host port:(int)port
{
    self = [super init];
    if (self) {
        STKAddress *address = [[STKAddress alloc] initWithHost:host port:port];
        _socket = [[STKManager defaultManager] getSocketByAddress:address.description];
        _callbackDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addCallbackInfo:(STKCallbackInfo *)callback byRequestId:(int)rid
{
    [_callbackDict setObject:callback forKey:[NSString stringWithFormat:@"%d",rid]];
}

- (STKCallbackInfo *)getCallbackInfoByRequestId:(int)rid;
{
    STKCallbackInfo *callback = (STKCallbackInfo *)[_callbackDict objectForKey:[NSString stringWithFormat:@"%d",rid]];
    if (callback) {
        [_callbackDict removeObjectForKey:[NSString stringWithFormat:@"%d",rid]];
    }
    return callback;
}

- (void)removeCallbackInfoByRequestId:(int)rid
{
    [_callbackDict removeObjectForKey:[NSString stringWithFormat:@"%d",rid]];
}

@end
