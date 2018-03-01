//
//  SKRankItemVO.m
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKRankItemVO.h"

@implementation SKRankItemVO

// https://trac.gemantic.com/wiki/desktop/StkData2#a44.预定义手机版排行榜

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if ( self ) {
        self.symbol = [data readString];
        self.name = [data readString];
        self.price = [data readCompressedFloat];
        self.change = [data readCompressedFloat];
        self.raise = [data readCompressedFloatWithRatio:10000] * 100;
        self.volume = [data readCompressedFloatWithRatio:1];
        self.amount = [data readCompressedFloatWithRatio:1];
        [data readCompressedInt];
        [data readCompressedInt];
        [data readCompressedInt];
        [data readCompressedInt];
        [data readCompressedInt];
    }
    return self;
}

@end
