//
//  StockListSocketManager.m
//  stockscontest
//
//  Created by rxhui on 15/8/14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "StockListSocketManager.h"
#import "SKAppointmentDelegate.h"
#import "SKReportDelegate.h"
#import "SKFiveReportVO.h"
#import "SKCodeTable.h"

@implementation StockListSocketManager

/**
 *  根据股票代码查询五档详情
 *
 *  @param param 股票代码、exchangeType
 */
-(void)requestStockMarketPriceWithParam:(NSDictionary *)param{
    NSString *code = [param objectForKey:@"symbol"];
    NSString *symbol = [self addPrefixWithCode:code];
    SKReportDelegate *report = [[SKReportDelegate alloc]init];//只获取一次
    [report getFiveReportBySymbol:symbol target:self resultHandler:@selector(getReportResultHandler:) failHandler:@selector(getReportFailHandler)];
}

- (void)getReportResultHandler:(SKFiveReportVO *)result
{
    if (![result isKindOfClass:[SKFiveReportVO class]]) {
        return;
    }
    NSLog(@"-%@--",result.name);
    if (self.delegate && [self.delegate respondsToSelector:@selector(getRequestStockData:)]) {
        [self.delegate getRequestStockData:result];
    }
}

- (void)getReportFailHandler
{
    NSLog(@"查询五档详情失败");
}

/**
 *  根据股票代码订阅，自动推送
 *
 *  @param param sha_60xxxx
 */
-(void)requestStockRealtimePriceWithParam:(NSDictionary *)param {
    NSString *code = [param objectForKey:@"symbol"];
    NSString *symbol = [self addPrefixWithCode:code];
    SKAppointmentDelegate * report = [[SKAppointmentDelegate alloc] init];//推送
    [report getAppointmentBySymbol:symbol target:self resultHandler:@selector(getRealtimeReportResultHandler:) failHandler:@selector(getRealtimeReportFailHandler)];
}

/**
 *  取消订阅
 *
 *  @param param sha_60xxxx
 */
- (void)cancelStockMarketPriceWithParam:(NSDictionary *)param {
    NSString *code = [param objectForKey:@"symbol"];
    NSString *symbol = [self addPrefixWithCode:code];
    SKAppointmentDelegate * report = [[SKAppointmentDelegate alloc] init];
    [report delAppointmentBySymbol:symbol target:self resultHandler:nil failHandler:nil];
}

- (void)getRealtimeReportResultHandler:(SKFiveReportVO *)result
{
    if (![result isKindOfClass:[SKFiveReportVO class]]) {
        return;
    }
    NSLog(@"---%@",result.name);
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockReportData:)]) {
        [self.delegate getStockReportData:result];
    }
}

- (void)getRealtimeReportFailHandler
{
    NSLog(@"订阅错误");
}

- (NSString *)addPrefixWithCode:(NSString *)code {
    
    NSString * symbol;
    if (code.length == 6) {
        NSArray * array = [[SKCodeTable instance] getCodeItemListByKeyword:code type:tradeData];
        if (array.count > 0) {
            SKCodeItemVO * stockVO = array[0];
            symbol = stockVO.symbol;
        }
    } else {
        symbol = code;
    }
    return symbol;
}
@end
