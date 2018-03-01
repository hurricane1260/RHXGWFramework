//
//  SKReportDelegate.m
//  iphone-stock
//
//  Created by ztian on 14-3-3.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKReportDelegate.h"
#import "STKCallbackInfo.h"
#import "SKReportVO.h"
#import "SKFiveReportVO.h"


@implementation SKReportDelegate

#pragma mark -
#pragma mark 一支股票报价、带5档行情
/// https://trac.gemantic.com/wiki/desktop/StkData2#a6.报价Report
- (int)getFiveReportBySymbol:(NSString *)symbol
                  target:(id)target
           resultHandler:(SEL)resultHandler
             failHandler:(SEL)failHandler
{
    NSMutableData *param = [[NSMutableData alloc] init];
    [param appendStringWith0:symbol];
//    [param appendStringWithOut0:symbol];
//    [param appendByte:0];
    [param appendInt:0];
    [param appendInt:0];
    
    STKCallbackInfo *getReportCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:self resultHandler:@selector(getFiveReportResultHandler:) failHandler:@selector(getFiveReportFailHandler:) requestType:DEF_REPORT_RQ_Ex params:param];
    [self addCallbackInfo:getReportCallback byRequestId:rid];
    return rid;
}

- (void)getFiveReportResultHandler:(STKData *)data
{
    NSData *result = data.params;
    SKFiveReportVO *report = [[SKFiveReportVO alloc] initWithNSData:result];
    STKCallbackInfo *getReportCallback = [self getCallbackInfoByRequestId:data.rid];
    [getReportCallback performResultHandlerWithObject:report];
}

- (void)getFiveReportFailHandler:(STKData *)data
{
    
}


#pragma mark -
#pragma mark 一支股票报价
/// https://trac.gemantic.com/wiki/desktop/StkData2#a43.手机版Report
- (int)getReportBySymbol:(NSString *)symbol
                  target:(id)target
           resultHandler:(SEL)resultHandler
             failHandler:(SEL)failHandler
{
    NSMutableData *param = [[NSMutableData alloc] init];
    [param appendStringWith0:symbol];
    [param appendInt:0];
    [param appendInt:0];
    
    STKCallbackInfo *getReportCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:self resultHandler:@selector(getReportResultHandler:) failHandler:@selector(getReportFailHandler:) requestType:DEF_MO_REPORT1_RQ params:param];
    [self addCallbackInfo:getReportCallback byRequestId:rid];
    return rid;
}

- (void)getReportResultHandler:(STKData *)data
{
    NSData *result = data.params;
    SKReportVO *report = [[SKReportVO alloc] initWithNSData:result];
    STKCallbackInfo *getReportCallback = [self getCallbackInfoByRequestId:data.rid];
    [getReportCallback performResultHandlerWithObject:report];
}

- (void)getReportFailHandler:(STKData *)data
{
    
}

#pragma mark -
#pragma mark 多股票报价
///https://trac.gemantic.com/wiki/desktop/StkData2#a22.多股报价
- (int)getMultiReportsBySymbols:(NSArray *)symbols
                         target:(id)target
                  resultHandler:(SEL)resultHandler
                    failHandler:(SEL)failHandler
{
    NSMutableData *param = [[NSMutableData alloc] init];
    [param appendInt:(int)symbols.count];
    for ( NSString *symbol in symbols ) {
        [param appendStringWith0:symbol];
    }
    [param appendInt:0];
    
    STKCallbackInfo *getReportsCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:self resultHandler:@selector(getReportsResultHandler:) failHandler:nil requestType:DEF_MULTI_REPORT2_RQ params:param];
    [self addCallbackInfo:getReportsCallback byRequestId:rid];
    return rid;
}

- (void)getReportsResultHandler:(STKData *)data
{
    NSData *result = data.params;
    int count = [result readCompressedInt];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < count; i++ ) {
        SKReportVO *item = [[SKReportVO alloc] initWithNSData2:result];
        [array addObject:item];
    }
    STKCallbackInfo *getReportsCallback = [self getCallbackInfoByRequestId:data.rid];
    [getReportsCallback performResultHandlerWithObject:array];
}

- (void)cancelAllRequest
{
    
}

@end
