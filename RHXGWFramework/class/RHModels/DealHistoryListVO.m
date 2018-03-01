//
//  DealHistoryListVO.m
//  stockscontest
//
//  Created by rxhui on 15/7/3.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "DealHistoryListVO.h"

@implementation DealHistoryListVO

+(NSArray *)parseDealHistoryVOWithData:(NSArray *)results {
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSDictionary *itemData in results) {
        DealHistoryListVO *item = [NSObject parseJsonToModel:itemData targetClass:[DealHistoryListVO class]];
        item.date = [itemData objectForKey:@"initDate"];
        item.businessAmount = item.occurAmount;
//        NSLog(@"--%@",item.remark);
        if ([item.remark isEqualToString:@"股息入帐"] || [item.remark isEqualToString:@"登记指定"] || [item.remark isEqualToString:@"指定交易"]) {
            continue ;
        }
        [retArray addObject:item];
    }
    return retArray.copy;
}

+ (NSArray *)parseSimulateDealHistoryWithData:(id)resultData {
    NSArray *resultList = resultData;
    if (![resultList isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSDictionary *itemData in resultList) {
        DealHistoryListVO *item = [[DealHistoryListVO alloc]init];
        item.date = [itemData objectForKey:@"tradeDate"];
        item.entrustBs = [NSString stringWithFormat:@"%@",[itemData objectForKey:@"businessType"]];
        item.stockName = [itemData objectForKey:@"stockName"];
        item.businessPrice = [itemData objectForKey:@"price"];
        item.businessAmount = [itemData objectForKey:@"vol"];
        item.businessBalance = [itemData objectForKey:@"amount"];
        [retArray addObject:item];
    }
    return retArray.copy;
}

@end
