//
//  SKStockDelegate.m
//  iphone-stock
//
//  Created by ztian on 14-2-26.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKRankListDelegate.h"
#import "SKRankListVO.h"
#import "STKCallbackInfo.h"
#import "SKRankItemVO.h"


// 获取大盘、板块、个股盘口数据
#define DEF_MO_REPORT1_RQ (DEF_STKDATA_BASE + 67)

// 预定义手机排行榜
#define DEF_MO_RANKING1_RQ (DEF_STKDATA_BASE + 69)

// 自定义多股排名接口
#define DEF_MO_RANKING1_ITEMS_RQ (DEF_STKDATA_BASE + 71)

@implementation SKRankListDelegate


#pragma mark -
#pragma mark 预定义排行榜

// https://trac.gemantic.com/wiki/desktop/StkData2#a44.预定义手机版排行榜

- (UInt16)getRankListByType:(NSString *)type
                          orderBy:(NSString *)orderBy
                             page:(uint)thePage
                        pageCount:(uint)theCount
                           isDesc:(BOOL)isDesc
                           target:(id)target
                    resultHandler:(SEL)resultHandler
                      failHandler:(SEL)failHandler
{
    return [self getRankListByType:type orderBy:orderBy start:thePage*theCount count:theCount isDesc:YES target:target resultHandler:resultHandler failHandler:failHandler];
}

- (UInt16)getRankListByType:(NSString *)type
                          orderBy:(NSString *)orderBy
                            start:(uint)theStart
                            count:(uint)theCount
                           isDesc:(BOOL)isDesc
                           target:(id)target
                    resultHandler:(SEL)resultHandler
                      failHandler:(SEL)failHandler
{
    NSMutableData *params = [[NSMutableData alloc] init];
    [params appendStringWith0:type];
    [params appendStringWith0:orderBy];
    [params appendInt:theStart];
    [params appendInt:theCount];
    [params appendInt:(isDesc ? 0 : 1)];
    [params appendInt:0];
    [params appendWithLength:12];
    
    int requestId = [self requestWithTarget:self
                     resultHandler:@selector(getRankListByTypeResultHandler:)
                       failHandler:@selector(getRankListByTypeFailHandler:)
                       requestType:DEF_MO_RANKING1_RQ
                            params:params];
    
    STKCallbackInfo *getRankListCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    [self addCallbackInfo:getRankListCallback byRequestId:requestId];
    return requestId;
}



- (void)getRankListByTypeResultHandler:(STKData *)stkData
{
    NSData *response = stkData.params;
    SKRankListVO *listVO = [[SKRankListVO alloc] initWithNSData:response];
    
    STKCallbackInfo *getRankListCallback =[self getCallbackInfoByRequestId:stkData.rid];
    [getRankListCallback performResultHandlerWithObject:listVO];
}

- (void)getRankListByTypeFailHandler:(STKData *)stkData
{
    
}

#pragma mark -
#pragma mark 自定义排行榜

// https://trac.gemantic.com/wiki/desktop/StkData2#a45.自定义手机版排行榜
- (UInt16)getRankListBySymbols:(NSArray *)symbols
                          target:(id)target
                   resultHandler:(SEL)resultHandler
                     failHandler:(SEL)failHandler
{
    STKCallbackInfo *getRankListCallback =[[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    // 拼装请求参数
    NSMutableData *params = [[NSMutableData alloc] init];
    [params appendInt:0];
    [params appendInt:0];
    [params appendInt:(int)symbols.count];
    for ( NSString *symbol in symbols ) {
        [params appendStringWith0:symbol];
    }
    
    int rid = [self requestWithTarget:self resultHandler:@selector(getRankListBySymbolResultHandler:) failHandler:nil requestType:DEF_MO_RANKING1_ITEMS_RQ params:params];
    [self addCallbackInfo:getRankListCallback byRequestId:rid];
    return rid;
}

- (void)getRankListBySymbolResultHandler:(STKData *)stkData
{
    NSData *respones = stkData.params;
    [respones readCompressedInt];
    [respones readCompressedInt];
    [respones readCompressedInt];
    [respones readCompressedInt];
    [respones readCompressedInt];
    int count = [respones readCompressedInt];
    SKPageListVO *listVO = [[SKPageListVO alloc] init];
    for (int i = 0; i < count; i++) {
        SKRankItemVO *item = [[SKRankItemVO alloc] initWithNSData:respones];
        [listVO addItem:item];
    }
    STKCallbackInfo *callback = [self getCallbackInfoByRequestId:stkData.rid];
    [callback performResultHandlerWithObject:listVO];
}


@end
