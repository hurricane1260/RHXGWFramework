//
//  STKRequestContext.m
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKRequestContext.h"

@implementation STKRequestContext

- (id)initWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler request:(STKData *)request;
{
    self = [super initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    if( self )
    {
        self.request = request;
    }
    return self;
}

@end
