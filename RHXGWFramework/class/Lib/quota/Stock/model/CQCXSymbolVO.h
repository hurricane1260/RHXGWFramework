//
//  CQCXItemVO.h
//  iphone-stock
//
//  Created by ztian on 14-3-7.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKBaseVO.h"

/// 某一天的除权除息信息
@interface CQCXItemVO : SKBaseVO


/// 发生日期YYYYMMDD，不压缩
@property (nonatomic,assign) int day;
/// 送股
@property (nonatomic,assign) float sg;
/// 转增股
@property (nonatomic,assign) float zzg;
/// 派现
@property (nonatomic,assign) float px;
/// 配股
@property (nonatomic,assign) float pg;
/// 配股价
@property (nonatomic,assign) float pgj;

//后复权系数
@property (nonatomic,assign) float wlhfqxs;
//后复权常数
@property (nonatomic,assign) float wlhfqcs;
//前复权系数
@property (nonatomic,assign) float wlqfqxs;
//前复权常数
@property (nonatomic,assign) float wlqfqcs;

@end

/// 某只股票的除权除息信息
@interface CQCXSymbolVO : SKBaseVO

/// 股票代码
@property (nonatomic,retain) NSString *symbol;

/**
 *	@brief	除权除息元素列表
 * 
 */
@property (nonatomic,retain) NSArray *items;


@end
