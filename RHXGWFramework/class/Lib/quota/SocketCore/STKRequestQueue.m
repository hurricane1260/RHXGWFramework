//
//  STKRequestQueue.m
//  iphone-stock
//
//  Created by ztian on 14-3-7.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKRequestQueue.h"

@interface STKRequestQueue()
{
    NSMutableArray *_requestList;
    NSMutableDictionary *_requestDict;
}

@end

@implementation STKRequestQueue

- (id)init
{
    self = [super init];
    if (self) {
        _requestList = [[NSMutableArray alloc] init];
        _requestDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (STKRequestContext *)deQueue
{
    if (_requestList.count > 0) {
        STKRequestContext *context = [_requestList firstObject];
        [_requestList removeObject:context];
        return  context;
    }
    return nil;
}

- (void)enQueue:(STKRequestContext *)context
{
    [_requestList addObject:context];
}

- (void)setContext:(STKRequestContext *)context byId:(int)rid{
    [_requestDict setObject:context forKey:[NSString stringWithFormat:@"%d",rid]];
}

- (STKRequestContext *)getContextById:(int)rid{
    return [_requestDict objectForKey:[NSString stringWithFormat:@"%d",rid]];
}

- (void)removeContextById:(int)rid{
    [_requestDict removeObjectForKey:[NSString stringWithFormat:@"%d",rid]];
}

@end
