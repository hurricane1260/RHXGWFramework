//
//  SKReportVO.m
//  iphone-stock
//
//  Created by ztian on 14-3-3.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKReportVO.h"

@implementation SKReportVO

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.time = [data readInt];
        self.symbol = [data readString];
        self.name = [data readString];
        self.lastClose = [data readCompressedFloat];
        self.open = self.lastClose + [data readCompressedFloat];
        self.high = self.open + [data readCompressedFloat];
        self.low = self.open + [data readCompressedFloat];
        self.close = self.open + [data readCompressedFloat];
        self.volume = [data readCompressedFloatWithRatio:1];
        self.amount = [data readCompressedFloatWithRatio:1];
        
        [data readMultiCompressedInt:4];
        
        self.pe = [data readCompressedFloatWithRatio:100];
        
        [data readCompressedFloat];
        [data readMultiCompressedInt:5];
    }
    return self;
}

// 多股报价接口解析
- (id)initWithNSData2:(NSData *)data
{
    self = [super init];
    if (self) {
        self.time = [data readInt];
        self.symbol = [data readString];
        self.name = [data readString];
        self.lastClose = [data readCompressedFloat];
        self.open = self.lastClose + [data readCompressedFloat];
        self.high = self.open + [data readCompressedFloat];
        self.low = self.open + [data readCompressedFloat];
        self.close = self.open + [data readCompressedFloat];
        self.volume = [data readCompressedFloatWithRatio:1];
        self.amount = [data readCompressedFloatWithRatio:1];
        
        [data readMultiCompressedInt:5];
    }
    return self;
}


@end
