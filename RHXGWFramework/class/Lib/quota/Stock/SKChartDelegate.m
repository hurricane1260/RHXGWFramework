//
//  SKMChartDelegate.m
//  iphone-stock
//
//  Created by ztian on 14-2-28.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKChartDelegate.h"
#import "SKFiveReportVO.h"


@implementation SKChartDelegate

/// wiki地址:https://trac.gemantic.com/wiki/desktop/StkData2#a42.MinData2

- (int)getMDataBySymbol:(NSString *)symbol
                        time:(long)time
                      target:(id)target
               resultHandler:(SEL)resultHandler
                 failHandler:(SEL)failHandler
{
    
    NSMutableData *params = [[NSMutableData alloc] init];
    [params appendStringWith0:symbol];
    [params appendInt:(int)time];
    [params appendInt:1];
    

    STKCallbackInfo *mCallbackInfo =[[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:self
                     resultHandler:@selector(getMDataResultHandler:)
                       failHandler:@selector(getMDataFailHandler:)
                       requestType:DEF_MIN_DATA_RQ2
                            params:params];
    
    [self addCallbackInfo:mCallbackInfo byRequestId:rid];
    
    return rid;
}



- (void)getMDataResultHandler:(STKData *)stkData
{
    NSData *response = stkData.params;
    NSString *symbol = [response readString];
    SKPageListVO *listVO = [[SKPageListVO alloc] init];
    listVO.symbol = symbol;
    int count = [response readCompressedInt];
    
    STKCallbackInfo *mCallbackInfo = [self getCallbackInfoByRequestId:stkData.rid];
    
    for (int i = 0 ; i < count; i++) {
        SKMChartItemVO *itemVO = [[SKMChartItemVO alloc] initWithNSData:response];
        [listVO addItem:itemVO];
    }
    [mCallbackInfo performResultHandlerWithObject:listVO];
}

- (void)getMDataFailHandler:(STKData *)stkData
{
    
}


/// wiki地址:https://trac.gemantic.com/wiki/desktop/StkData2#a7.K线

- (int)getKDataBySymbol:(NSString *)symbol
                    daystamp:(int)time
                    dayCount:(short)dayCount
                   isForward:(BOOL)isForward
                      period:(short)period
                      target:(id)target
               resultHandler:(SEL)resultHandler
                 failHandler:(SEL)failHandler
{
    NSMutableData *params = [[NSMutableData alloc] init];
    [params appendStringWith0:symbol];
    [params appendInt:time];
    [params appendShort:dayCount];
    [params appendByte:(isForward ? 1 : 0)];
    [params appendShort:period];
    [params appendShort:0];
    
    STKCallbackInfo *kCallbackInfo = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    int rid = [self requestWithTarget:self resultHandler:@selector(getKDataResultHandler:) failHandler:@selector(getKDataFailHandler:) requestType:DEF_KDATA_RQ params:params];;
    
    [self addCallbackInfo:kCallbackInfo byRequestId:rid];
    return rid;
}

- (void)getKDataResultHandler:(STKData *)stkData
{
    if (![stkData isKindOfClass:[STKData class]]) {
        return;
    }
    NSData *response = stkData.params;
    SKPageListVO *pageListVO = [[SKPageListVO alloc] init];
    pageListVO.symbol = [response readString];
    int count = [response readCompressedInt];
    
    for( int i = 0 ; i < count ; i ++ )
    {
        [pageListVO addItem:[[SKKChartItemVO alloc] initWithNSData:response]];
    }
    
    STKCallbackInfo *kCallbackInfo = [self getCallbackInfoByRequestId:stkData.rid];
    [kCallbackInfo performResultHandlerWithObject:pageListVO];
}

- (void)getKDataFailHandler:(STKData *)stkData
{
    
}

/// https://trac.gemantic.com/wiki/desktop/StkData2#a47.单条除权除息

- (int)getCQCXBySymbol:(NSString *)symbol
                target:(id)target
         resultHandler:(SEL)resultHandler
           failHandler:(SEL)failHandler
{
    NSMutableData *params = [[NSMutableData alloc] init];
    [params appendStringWith0:symbol];
    [params appendWithLength:12];
    
    STKCallbackInfo *cqcxCallbackInfo = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    int rid = [self requestWithTarget:self resultHandler:@selector(getCQCXResultHandler:) failHandler:@selector(getCQCXFailHandler:) requestType:DEF_MO_EXACT_DR_RQ params:params];;
    
    [self addCallbackInfo:cqcxCallbackInfo byRequestId:rid];
    return rid;
}


- (void)getCQCXResultHandler:(STKData *)data
{
    NSData *response = data.params;
    CQCXSymbolVO *cqcxSymbolVO = [[CQCXSymbolVO alloc] initWithNSData:response];
    STKCallbackInfo *cqcxCallbackInfo = [self getCallbackInfoByRequestId:data.rid];
    [cqcxCallbackInfo performResultHandlerWithObject:cqcxSymbolVO];
}

- (void)getCQCXFailHandler:(STKData *)data
{
    
}

@end
