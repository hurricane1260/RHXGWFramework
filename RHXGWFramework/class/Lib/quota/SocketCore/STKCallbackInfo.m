//
//  STKCallbackInfo.m
//  iphone-stock
//
//  Created by ztian on 14-2-28.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKCallbackInfo.h"

@implementation STKCallbackInfo

- (id)initWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler
{
    self = [super init];
    if( self )
    {
        self.target = target;
        self.resultHandler = resultHandler;
        self.failHandler = failHandler;
    }
    return self;
}

- (void)performResultHandlerWithObject:(id)object
{
    if (self.target && self.resultHandler) {
        [self.target performSelector:self.resultHandler withObject:object];
    }
}

- (void)performFailHandlerWithObject:(id)object
{
    if (self.target && self.failHandler) {
        [self.target performSelector:self.failHandler withObject:object];
    }
}

- (void)performResultHandler
{
    if (self.target && self.resultHandler) {
        [self.target performSelector:self.resultHandler];
    }
}

- (void)performFailHandler
{
    if (self.target && self.failHandler) {
        [self.target performSelector:self.failHandler ];
    }
}


@end
