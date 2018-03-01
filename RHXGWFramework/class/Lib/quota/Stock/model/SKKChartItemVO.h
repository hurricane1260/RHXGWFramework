//
//  SKKChartItemVO.h
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseVO.h"

/// K线图数据元素
@interface SKKChartItemVO : SKBaseVO

/// 日期，YYYYMMDD格式
@property (nonatomic,assign) int date;

@property (nonatomic,assign) long time;
/// 开盘
@property (nonatomic,assign) float open;
/// 最高
@property (nonatomic,assign) float high;
/// 最低
@property (nonatomic,assign) float low;
/// 收盘/最新
@property (nonatomic,assign) float close;
/// 成交额
@property (nonatomic,assign) float amount;
/// 成交量
@property (nonatomic,assign) float volume;
/// 昨收
@property (nonatomic,assign) float preClose;
/// pe
@property (nonatomic,assign) float pe;

-(NSDictionary *)getJSONString;

@end
