//
//  SKMChartItemVO.h
//  iphone-stock
//
//  Created by ztian on 14-2-28.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseVO.h"

/// 分时图数据元素
@interface SKMChartItemVO : SKBaseVO

- (id)initWithNSData:(NSData *)data;

/// 1970开始的秒数
@property (nonatomic,assign) long time;
/// 当前价格
@property (nonatomic,assign) float price;
/// 成交额
@property (nonatomic,assign) float amount;
/// 成交量
@property (nonatomic,assign) float volume;
/// 总成交量
@property (nonatomic,assign) float totalVolume;
/// 总成交额
@property (nonatomic,assign) float totalAmount;
/// 均线
@property (nonatomic,assign) float average;

-(NSDictionary *)getJSONString;

@end
