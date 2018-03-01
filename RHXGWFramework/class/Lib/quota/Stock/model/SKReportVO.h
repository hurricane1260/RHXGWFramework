//
//  SKReportVO.h
//  iphone-stock
//
//  Created by ztian on 14-3-3.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseVO.h"

/// 报价数据
@interface SKReportVO : SKBaseVO

/// 交易时间
@property (nonatomic,assign) NSInteger time;
/// 股票代码
@property (nonatomic,copy) NSString *symbol;
/// 股票名称
@property (nonatomic,copy) NSString *name;
/// 昨收
@property (nonatomic,assign) CGFloat lastClose;
/// 开盘
@property (nonatomic,assign) CGFloat open;
/// 最高
@property (nonatomic,assign) CGFloat high;
/// 最低
@property (nonatomic,assign) CGFloat low;
/// 收盘
@property (nonatomic,assign) CGFloat close;
/// 成交量
@property (nonatomic,assign) CGFloat volume;
/// 成交额
@property (nonatomic,assign) CGFloat amount;
/// pe
@property (nonatomic,assign) CGFloat pe;

// 多股报价接口解析
- (id)initWithNSData2:(NSData *)data;
@end
