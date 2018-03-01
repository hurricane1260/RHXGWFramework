//
//  TradeSocketManager.m
//  stockscontest
//
//  Created by rxhui on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeSocketManager.h"
#import "SKAppointmentDelegate.h"
#import "SKReportDelegate.h"
#import "SKFiveReportVO.h"
#import "STKUtil.h"

@implementation TradeSocketManager

#pragma mark ---------------------------------------------------请求一次行情-------------------------------------------------------

-(void)requestStockMarketPriceWithParam:(NSDictionary *)param {
    //    NSLog(@"-exchangeType:%@,stockCode:%@-",tempExchangeType,code);
    NSString *code = [self getStockSymbleWithParam:param];
    SKReportDelegate *report = [[SKReportDelegate alloc]init];//只获取一次
    [report getFiveReportBySymbol:code target:self resultHandler:@selector(getReportResultHandler:) failHandler:@selector(getReportFailHandler)];
}

- (void)getReportResultHandler:(SKFiveReportVO *)result
{
    if (![result isKindOfClass:[SKFiveReportVO class]]) {
        NSLog(@"行情获取类型错误");
        return;
    }
    NSLog(@"---%@",result.name);
    if (!self.delegate) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(getStockMarketPriceSuccess:)]) {
        return;
    }
    [self.delegate getStockMarketPriceSuccess:result];
}

- (void)getReportFailHandler
{
    if (!self.delegate) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(getStockMarketPriceFail)]) {
        return;
    }
    [self.delegate getStockMarketPriceFail];
}

#pragma mark ---------------------------------------------------请求实时行情-------------------------------------------------------

-(void)requestStockRealtimePriceWithParam:(NSDictionary *)param {
    NSString *code = [self getStockSymbleWithParam:param];
    SKAppointmentDelegate * report = [[SKAppointmentDelegate alloc] init];//推送
    [report getAppointmentBySymbol:code target:self resultHandler:@selector(getRealtimeReportResultHandler:) failHandler:@selector(getRealtimeReportFailHandler)];
}

- (void)getRealtimeReportResultHandler:(SKFiveReportVO *)result
{
    if (![result isKindOfClass:[SKFiveReportVO class]]) {
        NSLog(@"行情获取类型错误");
        return;
    }
    NSLog(@"---%@",result.name);
    if (!self.delegate) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(getStockRealtimePriceSuccess:)]) {
        return;
    }
    [self.delegate getStockRealtimePriceSuccess:result];
}

- (void)getRealtimeReportFailHandler
{
    if (!self.delegate) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(getStockRealtimePriceFail)]) {
        return;
    }
    [self.delegate getStockRealtimePriceFail];
}

- (void)cancelStockMarketPriceWithParam:(NSDictionary *)param {
    SKAppointmentDelegate * report = [[SKAppointmentDelegate alloc] init];
    NSString *symbol = [self getStockSymbleWithParam:param];
    [report delAppointmentBySymbol:symbol target:self resultHandler:nil failHandler:nil];
}


#pragma mark -------------------------------------------------

- (NSString *)getStockSymbleWithParam:(NSDictionary *)param {
    
    NSString *tempStockCode = [param objectForKey:@"stockCode"];
    NSString *tempExchangeType = [param objectForKey:@"exchangeType"];
    NSString *code = nil;
    if (tempExchangeType) {
        if ([tempExchangeType isEqualToString:@"1"]) {//上海
            code = [NSString stringWithFormat:@"sha_%@",tempStockCode];
        }
        else if ([tempExchangeType isEqualToString:@"2"]) {//深圳
            code = [NSString stringWithFormat:@"sza_%@",tempStockCode];
        }
        else if ([tempExchangeType isEqualToString:@"D"]) {//上海B股
            code = [NSString stringWithFormat:@"sha_%@",tempStockCode];
        }
        else if ([tempExchangeType isEqualToString:@"H"]) {//深圳B股
            code = [NSString stringWithFormat:@"sza_%@",tempStockCode];
        }
        else {
            NSLog(@"fix stock code fail : %@ ,and type : %@" ,tempStockCode,tempExchangeType);
        }
    }
    else {
        code = [STKUtil fixSymbol:tempStockCode];
    }
    return code;
}

@end
