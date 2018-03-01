//
//  EntrustListVO.m
//  stockscontest
//
//  Created by rxhui on 15/6/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "EntrustListVO.h"

@implementation EntrustListVO

//"0"未报,"1"待报,"2"已报,"7"部成,"C"正报（港股），是可以撤销
+(void)changeStatusStringWithItem:(EntrustListVO *)item {
    NSString *status = item.entrustStatus;
    if([status isEqualToString:@"0"]) {
        item.entrustStatus = @"未报";
        item.showWithdrawButton = YES;
    }
    else if ([status isEqualToString:@"1"]) {
        item.entrustStatus = @"待报";
        item.showWithdrawButton = YES;
    }
    else if ([status isEqualToString:@"2"]) {
        item.entrustStatus = @"已报";
        item.showWithdrawButton = YES;
    }
    else if ([status isEqualToString:@"3"]) {
        item.entrustStatus = @"已报待撤";
        item.showWithdrawButton = NO;
    }
    else if ([status isEqualToString:@"4"]) {
        item.entrustStatus = @"部成待撤";
        item.showWithdrawButton = NO;
    }
    else if ([status isEqualToString:@"5"]) {
        item.entrustStatus = @"部撤";
        item.showWithdrawButton = NO;
    }
    else if ([status isEqualToString:@"6"]) {
        item.entrustStatus = @"已撤";
        item.showWithdrawButton = NO;
    }
    else if ([status isEqualToString:@"7"]) {
        item.entrustStatus = @"部成";
        item.showWithdrawButton = YES;
    }
    else if ([status isEqualToString:@"8"]) {
        item.entrustStatus = @"已成";
        item.showWithdrawButton = NO;
    }
    else if ([status isEqualToString:@"9"]) {
        item.entrustStatus = @"废单";
        item.showWithdrawButton = NO;
    }
    else if ([status isEqualToString:@"C"]) {
        item.entrustStatus = @"正报";
        item.showWithdrawButton = YES;
    }
    else {
        item.showWithdrawButton = NO;
    }
}

-(NSComparisonResult)compare:(EntrustListVO *)otherVO {
    NSNumber *time1 = self.entrustDateTime;
    NSNumber *time2 = otherVO.entrustDateTime;
    NSComparisonResult result = [time1 compare:time2];
    return result == NSOrderedAscending;
}

+ (NSArray *)parseSimulateEntrustListWithData:(id)resultData {
    NSArray *resultList = resultData;
    if (![resultList isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *itemDic in resultList) {
        EntrustListVO *itemVO = [[EntrustListVO alloc]init];
        itemVO.entrustDateTime = [itemDic objectForKey:@"time"];
        itemVO.entrustBs = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"type"]];
        itemVO.stockName = [itemDic objectForKey:@"stockName"];
        itemVO.entrustPrice = [itemDic objectForKey:@"price"];
        itemVO.entrustAmount = [itemDic objectForKey:@"volume"];
        itemVO.entrustNo = [itemDic objectForKey:@"id"];
        [list addObject:itemVO];
    }
    return list.copy;
}

@end
