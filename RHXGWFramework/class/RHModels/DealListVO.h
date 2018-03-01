//
//  DealListVO.h
//  stockscontest
//
//  Created by rxhui on 15/6/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealListVO : NSObject

@property (nonatomic,copy) NSString *stockName;

/**
 *  委托方向,1买入,2卖出
 */
@property (nonatomic,copy) NSString *entrustBs;

@property (nonatomic,strong) NSNumber *businessBalance;

@property (nonatomic,strong) NSNumber *businessTime;

@property (nonatomic,strong) NSNumber *businessPrice;

@property (nonatomic,strong) NSNumber *businessAmount;

@property (nonatomic, strong) NSString *positionStr;

@property (nonatomic, strong) NSNumber *date;

@end
