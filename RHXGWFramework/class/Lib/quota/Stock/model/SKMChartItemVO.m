
//
//  SKMChartItemVO.m
//  iphone-stock
//
//  Created by ztian on 14-2-28.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKMChartItemVO.h"

@implementation SKMChartItemVO

- (id)initWithNSData:(NSData *)data;
{
    self = [super init];
    if (self) {
        self.time = [data readInt];
        self.price = [data readCompressedFloat];
        self.amount = [data readCompressedFloatWithRatio:1];
        self.volume = [data readCompressedFloatWithRatio:1];
        [data readCompressedInt];
        [data readCompressedInt];
        self.average = self.amount  / self.volume;
    }
    return self;
}

-(NSDictionary *)getJSONString
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithLong:self.time] forKey:@"time"];
    [dict setObject:[NSNumber numberWithFloat:self.amount] forKey:@"amount"];
    [dict setObject:[NSNumber numberWithFloat:self.price] forKey:@"close"];
    [dict setObject:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
    [dict setObject:[NSNumber numberWithFloat:self.totalVolume] forKey:@"totalVolume"];
    [dict setObject:[NSNumber numberWithFloat:self.average] forKey:@"average"];
    [dict setObject:[NSNumber numberWithFloat:self.totalAmount] forKey:@"totalAmount"];
    
    //Data转换为JSON
    return dict;
}
@end
