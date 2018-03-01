//
//  SKFiveReportVO.m
//  iphone-stock
//
//  Created by ztian on 15/6/17.
//  Copyright (c) 2015年 RHJX Inc. All rights reserved.
//

#import "SKFiveReportVO.h"

@implementation SKFiveReportVO

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if (self) {
        [data readCompressedInt];
        self.time = [data readInt];
        [data readShort];
        self.symbol = [data readString];
        self.name = [data readString];
        self.lastClose = [data readCompressedFloat];
        self.open = self.lastClose + [data readCompressedFloat];
        self.high = self.open + [data readCompressedFloat];
        self.low = self.open + [data readCompressedFloat];
        self.close = self.open + [data readCompressedFloat];
        self.volume = [data readCompressedFloatWithRatio:1];
        self.amount = [data readCompressedFloatWithRatio:1];
        
        self.buys = [[NSMutableArray alloc] init];
        [self.buys addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + self.close]];
        [self.buys addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.buys[0]).floatValue]];
        [self.buys addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.buys[0]).floatValue]];
        
        NSInteger unit = 100;
        if ([[self.symbol substringToIndex:3] isEqualToString:@"131"] || [[self.symbol substringToIndex:3] isEqualToString:@"204"]) {
            unit = 10;
        }
        
        self.buyVolumns = [[NSMutableArray alloc] init];
        [self.buyVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        [self.buyVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        [self.buyVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        
        self.sells = [[NSMutableArray alloc] init];
        [self.sells addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + self.close]];
        [self.sells addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.sells[0]).floatValue]];
        [self.sells addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.sells[0]).floatValue]];
        
        self.sellVolumns = [[NSMutableArray alloc] init];
        [self.sellVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        [self.sellVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        [self.sellVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        
        [self.buys addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.buys[0]).floatValue]];
        [self.buyVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        [self.sells addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.sells[0]).floatValue]];
        [self.sellVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        
        [self.buys addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.buys[0]).floatValue]];
        [self.buyVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        [self.sells addObject:[NSNumber numberWithFloat:[data readCompressedFloat] + ((NSNumber *)self.sells[0]).floatValue]];
        [self.sellVolumns addObject:[NSNumber numberWithInt:[data readCompressedInt]/unit]];
        
        self.pe = [data readCompressedFloatWithRatio:100];

        [self allDataFormatting];
        [self addRiseString];
    }
    return self;
}

- (void)addRiseString
{
    if (([self.buys[0] floatValue] == [self.sells[0] floatValue]) && ([self.buys[0] floatValue] != 0) && !(([self.symbol isEqualToString:@"000001"] && [self.name isEqualToString:@"上证指数"]) || [self.symbol isEqualToString:@"399001"] || [self.symbol isEqualToString:@"399006"]))
    {
        self.close = [self.buys[0] floatValue];
    }
    
    NSString * hourString = [TimeUtils getTimeStringWithNumber:[NSNumber numberWithInteger:self.time * 1000] formatString:@"HH"];
    NSString * minuteString = [TimeUtils getTimeStringWithNumber:[NSNumber numberWithInteger:self.time * 1000] formatString:@"mm"];
    if ([hourString isEqualToString:@"09"] && minuteString.integerValue >= 15 && minuteString.integerValue <= 25) {
        if (([self.buys[0] floatValue] == 0) && ([self.sells[0] floatValue] != 0))
        {
            self.close = [self.sells[0] floatValue];
        }
        if (([self.buys[0] floatValue] != 0) && ([self.sells[0] floatValue] == 0))
        {
            self.close = [self.buys[0] floatValue];
        }
        if (([self.buys[0] floatValue] == [self.sells[0] floatValue]) && ([self.buys[0] floatValue] == 0))
        {
            self.close = self.lastClose;
        }
    }
    
    if (self.close == 0) {
        self.close = self.lastClose;
    }
    
    self.change = self.close - self.lastClose;
    CGFloat rate = (self.close - self.lastClose) / self.lastClose * 100.0f;
    self.rise = rate;

}
         
- (void)allDataFormatting
{
    for (int i = 0; i < self.buys.count; i++) {
        self.buys[i] = [NSNumber numberWithFloat:[self formatting:[self.buys[i] floatValue]]];
    }
    for (int i = 0; i < self.sells.count; i++) {
        self.sells[i] = [NSNumber numberWithFloat:[self formatting:[self.sells[i] floatValue]]];
    }
    self.lastClose = [self formatting:self.lastClose];
    self.open = [self formatting:self.open];
    self.high = [self formatting:self.high];
    self.low = [self formatting:self.low];
    self.close = [self formatting:self.close];
    self.pe = [self formatting:self.pe];
}

- (CGFloat)formatting:(CGFloat)cgData;
{
    float floatData = cgData;
    NSString * string = [NSString stringWithFormat:@"%.3f",floatData];
    return string.floatValue;
}

- (void)printfLog
{
    NSLog(@"股票名称代码   %@%@",self.name,self.symbol);
    NSLog(@"推送数据close %f",self.close);
    NSLog(@"推送数据buy5  %@",self.buys[4]);
    NSLog(@"推送数据buy4  %@",self.buys[3]);
    NSLog(@"推送数据buy3  %@",self.buys[2]);
    NSLog(@"推送数据buy2  %@",self.buys[1]);
    NSLog(@"推送数据buy1  %@",self.buys[0]);
    NSLog(@"推送数据sell1 %@",self.sells[0]);
    NSLog(@"推送数据sell2 %@",self.sells[1]);
    NSLog(@"推送数据sell3 %@",self.sells[2]);
    NSLog(@"推送数据sell4 %@",self.sells[3]);
    NSLog(@"推送数据sell5 %@",self.sells[4]);

}

@end
