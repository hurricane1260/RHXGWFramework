//
//  SKRankItemVO.h
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseVO.h"

/**
 *  @brief 排行榜数据列表元素
 *
 *  wiki地址：https://trac.gemantic.com/wiki/desktop/StkData2#symbol2 所有预定的排行榜
 */
@interface SKRankItemVO : SKBaseVO

/// 股票代码
@property (nonatomic,retain) NSString *symbol;
/// 股票名称
@property (nonatomic,retain) NSString *name;
/// 最新
@property (nonatomic,assign) float price;
/// 涨跌
@property (nonatomic,assign) float change;
/// 涨幅
@property (nonatomic,assign) float raise;
/// 成交量(手）
@property (nonatomic,assign) float volume;
/// 成交额
@property (nonatomic,assign) float amount;


@end
