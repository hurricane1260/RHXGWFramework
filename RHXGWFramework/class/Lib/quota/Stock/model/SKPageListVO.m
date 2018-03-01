//
//  SKPageListVO.m
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKPageListVO.h"

@implementation SKPageListVO

@synthesize list = _list;

- (id)initWithNSData:(NSData *)data
{
    self =  [self init];
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addItem:(id)item
{
    [_list addObject:item];
}


- (id)getItem:(int)index
{
    if (_list) {
        return [_list objectAtIndex:index];
    }
    return nil;
}

- (uint)count
{
    if (_list) {
        return (uint)_list.count;
    }
    return 0;
}

@end
