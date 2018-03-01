//
//  STKManager.m
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKManager.h"
#import "STKSocket.h"


@interface STKManager()
{
    NSMutableDictionary *_socketCache;
}
@end

@implementation STKManager

static STKManager *_defautManager;

+ (STKManager *)defaultManager
{
    if (!_defautManager) {
        _defautManager = [[STKManager alloc] init];
    }
    return _defautManager;
}

+ (void)destroyManager
{
    if (_defautManager) {
        _defautManager = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _socketCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}


// adress格式 host:port 字符串
- (STKSocket *)getSocketByAddress:(NSString *)address
{
    return [_socketCache objectForKey:address];
}


- (void)configSocketWithAddress:(STKAddress *)address
{
    STKSocket *socket = [[STKSocket alloc] initWithAddress:address];
    [socket connect];
    [_socketCache setObject:socket  forKey:address.description];
}

- (void)clearByteCache
{
    STKAddress *address = [[STKAddress alloc] initWithHost:@"phone.jinhui123.com" port:9002];
    STKSocket *socket = [[STKManager defaultManager] getSocketByAddress:address.description];
    [socket clearByteCache];
}


- (void)cutOffSocket
{
    STKAddress *address = [[STKAddress alloc] initWithHost:@"phone.jinhui123.com" port:9002];
    STKSocket *socket = [[STKManager defaultManager] getSocketByAddress:address.description];
    [socket cutOffSocket];
}


@end

