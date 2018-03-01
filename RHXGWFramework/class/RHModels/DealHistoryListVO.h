//
//  DealHistoryListVO.h
//  stockscontest
//
//  Created by rxhui on 15/7/3.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealHistoryListVO : NSObject

@property (nonatomic, copy) NSString *stockName;

/**
 *  委托方向,1买入,2卖出
 */
@property (nonatomic, copy) NSString *entrustBs;

@property (nonatomic, strong) NSNumber *businessBalance;

@property (nonatomic, strong) NSNumber *businessTime;

@property (nonatomic, strong) NSNumber *businessPrice;

///发生数量
@property (nonatomic, strong) NSNumber *occurAmount;

@property (nonatomic, copy) NSString *positionStr;

///收到的的是initDate
@property (nonatomic, strong) NSNumber *date;

@property (nonatomic, strong) NSNumber *businessAmount;

//佣金
@property (nonatomic, strong)NSNumber * fare0;
//印花税
@property (nonatomic, strong)NSNumber * fare1;
//过户费
@property (nonatomic, strong)NSNumber * fare2;


///备注，需要过滤
@property (nonatomic, copy) NSString *remark;

+(NSArray *)parseDealHistoryVOWithData:(NSArray *)results;

+ (NSArray *)parseSimulateDealHistoryWithData:(id)resultData;

@end
