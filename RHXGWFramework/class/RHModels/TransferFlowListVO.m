//
//  TransferFlowListVO.m
//  stockscontest
//
//  Created by rxhui on 15/7/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TransferFlowListVO.h"

@implementation TransferFlowListVO

+(NSArray *)parseTransferFlowListWithData:(id)resultData {
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSDictionary *itemData in resultData) {
        TransferFlowListVO *item = [NSObject parseJsonToModel:itemData targetClass:[TransferFlowListVO class]];
//        item.date = [itemData objectForKey:@"initDate"];
        if ([item.entrustStatus isEqualToString:@"0"]) {
            item.entrustStatus = @"未报";
        }
        else if ([item.entrustStatus isEqualToString:@"1"]) {
            item.entrustStatus = @"已报";
        }
        else if ([item.entrustStatus isEqualToString:@"2"]) {
            item.entrustStatus = @"成功";
        }
        else if ([item.entrustStatus isEqualToString:@"3"]) {
            item.entrustStatus = @"作废";
//            item.entrustStatus = item.remark;
        }
        else if ([item.entrustStatus isEqualToString:@"4"]) {
            item.entrustStatus = @"待撤";
        }
        else if ([item.entrustStatus isEqualToString:@"5"]) {
            item.entrustStatus = @"撤销";
        }
        else if ([item.entrustStatus isEqualToString:@"7"]) {
            item.entrustStatus = @"待冲正";
        }
        else if ([item.entrustStatus isEqualToString:@"8"]) {
            item.entrustStatus = @"已冲正";
        }
        else if ([item.entrustStatus isEqualToString:@"A"]) {
            item.entrustStatus = @"待报";
        }
        else if ([item.entrustStatus isEqualToString:@"B"]) {
            item.entrustStatus = @"重发已报";
        }
        else if ([item.entrustStatus isEqualToString:@"C"]) {
            item.entrustStatus = @"重发超时";
        }
        else if ([item.entrustStatus isEqualToString:@"D"]) {
            item.entrustStatus = @"冲正超时";
        }
        else if ([item.entrustStatus isEqualToString:@"E"]) {
            item.entrustStatus = @"冲正失败";
        }
        else if ([item.entrustStatus isEqualToString:@"G"]) {
            item.entrustStatus = @"冲正待报";
        }
        else if ([item.entrustStatus isEqualToString:@"P"]) {
            item.entrustStatus = @"正报";
        }
        else if ([item.entrustStatus isEqualToString:@"Q"]) {
            item.entrustStatus = @"已确认";
        }
        else if ([item.entrustStatus isEqualToString:@"X"]) {
            item.entrustStatus = @"待确定";
        }
        [retArray addObject:item];
    };
    return retArray.copy;
}

@end
