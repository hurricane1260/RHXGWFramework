//
//  STKSocketConfig.m
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKAddress.h"

@implementation STKAddress



- (id)initWithHost:(NSString *)host port:(int)port
{
    self = [super init];
    if (self) {
        self.host = host;
        self.port = port;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:%d",self.host,self.port];
}

@end
