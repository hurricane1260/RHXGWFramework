//
//  PositionVO.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-21.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  持仓对象

#import <Foundation/Foundation.h>

@interface PositionVO : NSObject

/**
 *  用户ID
 */
//@property (nonatomic, copy) NSString *userID;

/**
 *  市场代码
 */
//@property (nonatomic, copy) NSString *exchangeType;

/**
 *  股票代码
 */
@property (nonatomic, copy) NSString *stockCode;

/**
 *  股票名称
 */
@property (nonatomic, copy) NSString *stockName;

/**
 *  最新价
 */
//@property (nonatomic, copy) NSNumber *lastPrice;

/**
 *  成本价
 */
//@property (nonatomic, copy) NSNumber *costPrice;

/**
 *  保本价
 */
//@property (nonatomic, copy) NSNumber *keepCostPrice;

/**
 *  创建时间
 */
//@property (nonatomic, copy) NSNumber *createTime;

/**
 *  日期yyyy-MM-dd
 */
//@property (nonatomic, copy) NSString *dateString;

@end
