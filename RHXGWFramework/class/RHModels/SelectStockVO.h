//
//  SelectStockVO.h
//  stockscontest
//
//  Created by rxhui on 15/8/11.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectStockVO : NSObject

@property (nonatomic, copy) NSString *stockCode;

@property (nonatomic, copy) NSString *stockName;

/*! @brief 买入信号 */
@property (nonatomic, copy) NSNumber *buySignal;

/*! @brief 卖出信号 */
@property (nonatomic, copy) NSNumber *sellSignal;

/*! @brief 现价 */
@property (nonatomic, copy) NSNumber *latestPrice;

/*! @brief 涨幅/跌幅 */
@property (nonatomic, assign) CGFloat inc;

/*! @brief 涨/跌 */
@property (nonatomic, copy) NSString *change;

/*! @brief 股票标记 */
@property (nonatomic, copy) NSString *tagName;

/*! @brief 买卖信号 */
@property (nonatomic, copy) NSString *entrustBs;

/*! @brief 信号发出时间 */
@property (nonatomic, copy) NSNumber *happenTime;

/*! @brief 系统时间 */
@property (nonatomic,copy) NSNumber *systemTime;

/*! @brief 历史收益 */
@property (nonatomic, copy) NSNumber *profitRate;

/*! @brief 是否为推送数据 */
@property (nonatomic,assign) BOOL reportData;

+ (id)selectWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dict;

@end
