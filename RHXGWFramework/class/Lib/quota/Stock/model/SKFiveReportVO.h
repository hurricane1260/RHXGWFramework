//
//  SKFiveReportVO.h
//  iphone-stock
//
//  Created by ztian on 15/6/17.
//  Copyright (c) 2015年 RHJX Inc. All rights reserved.
//

#import "SKReportVO.h"

@interface SKFiveReportVO : SKReportVO

/// 买5
@property (nonatomic,retain) NSMutableArray *buys;
/// 买5量
@property (nonatomic,retain) NSMutableArray *buyVolumns;
/// 卖5
@property (nonatomic,retain) NSMutableArray *sells;
/// 卖5量
@property (nonatomic,retain) NSMutableArray *sellVolumns;
/// 涨跌
@property (nonatomic,assign) CGFloat change;
/// 涨跌幅
@property (nonatomic,assign) CGFloat rise;

@end
