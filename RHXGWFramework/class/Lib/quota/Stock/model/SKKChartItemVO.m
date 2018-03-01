//
//  SKKChartItemVO.m
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKKChartItemVO.h"

@implementation SKKChartItemVO

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.date = [data readInt];
        self.open = [data readCompressedInt]/100.0;
        self.high = [data readCompressedInt]/100.0;
        self.low = [data readCompressedInt]/100.0;
        self.close = [data readCompressedInt]/100.0;
        self.amount = [data readFloat];
        self.volume = [data readCompressedInt];
        self.preClose = [data readCompressedInt]/100.0;
        self.pe = [data readCompressedFloatWithRatio:100];
        [data readCompressedInt];
        self.open += self.preClose;
        self.high += self.preClose;
        self.low += self.preClose;
        self.close += self.preClose;
        self.time = [self getTimeByInt:self.date];
    }
    return self;
}

-(NSDictionary *)getJSONString
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithLong:self.amount] forKey:@"amount"];
    [dict setObject:[NSNumber numberWithFloat:self.preClose] forKey:@"preClose"];
    [dict setObject:[NSNumber numberWithFloat:self.close] forKey:@"close"];
    [dict setObject:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
    [dict setObject:[NSNumber numberWithFloat:self.low] forKey:@"low"];
    [dict setObject:[NSNumber numberWithFloat:self.high] forKey:@"high"];
    [dict setObject:[NSNumber numberWithLong:self.time] forKey:@"quoteTime"];
    [dict setObject:[NSNumber numberWithFloat:self.open] forKey:@"open"];
    
    //    NSError *err;
    //    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    
    //Data转换为JSON
    return dict;
}
-(long)getTimeByInt:(int)date
{
//    NSString *timeStr = [NSString stringWithFormat:@"%d-%d-%d 09:00:00",date/10000,(date%10000)/100,(date%100)];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//    NSDate *destDate= [dateFormatter dateFromString:timeStr];
//    long time = [destDate timeIntervalSince1970];
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:date/10000];
    [components setMonth:(date%10000)/100];
    [components setDay:(date%100)];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *dateMy = [gregorian dateFromComponents:components];
    long time = [dateMy timeIntervalSince1970];
    return time;
}


@end
