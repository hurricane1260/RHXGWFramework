//
//  SKStockDelegate.h
//  iphone-stock
//
//  Created by ztian on 14-2-26.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKBaseDelegate.h"

// https://trac.gemantic.com/wiki/desktop/StkData2#symbol2 预定义排行榜类型

// 全部a股
#define RANK_TYPE_HZA @"all stocks"
// 上证A股
#define RANK_TYPE_SHA @"sh"
// 深证A股
#define RANK_TYPE_SZA @"sz"
// 中小板
#define RANK_TYPE_ZXB @"zxb"
// 创业板
#define RANK_TYPE_CYB @"cyb"
// 沪深B股
#define RANK_TYPE_HZB @"hsbg"
// 上证B股
#define RANK_TYPE_SHB @"shb"
// 深证B股
#define RANK_TYPE_SZB @"szb"
// 申万行业
#define RANK_TYPE_SW @"sw2"
// 概念板块
#define RANK_TYPE_GN @"gnbk"
// 地区板块
#define RANK_TYPE_DQ @"dqbk"

#define RANK_TYPE_DP @"dp"



// https://trac.gemantic.com/wiki/desktop/StkData2#orderby 排序字段

// 按涨幅
#define ORDER_BY_RAISE @"raise"
// 按最新价
#define ORDER_BY_PRICE @"price"
// 按名称
#define ORDER_BY_NAME @"name"

/// 预定义，自定义排行榜请求代理
@interface SKRankListDelegate : SKBaseDelegate


/**
 *	@brief	按分页方式请求预定义排行榜
 *
 *	@param 	type 	自定义排行榜类型，上面有常量定义，参考https://trac.gemantic.com/wiki/desktop/StkData2#symbol2
 *	@param 	orderBy 	排序字段，上面有常量定义，参考https://trac.gemantic.com/wiki/desktop/StkData2#orderby
 *	@param 	thePage 	请求页码，从0开始
 *	@param 	theCount 	每页数量
 *	@param 	isDesc 	是否降序
 *	@param 	target 	回调对象
 *	@param 	resultHandler 	成功回调函数，参数为 SKRankListVO，元素为SKRankItemVO
 *
 *	@return	请求id
 *
 *  @see    SKRankItemVO
 */
- (UInt16)getRankListByType:(NSString *)type
                          orderBy:(NSString *)orderBy
                             page:(uint)thePage
                        pageCount:(uint)theCount
                           isDesc:(BOOL)isDesc
                           target:(id)target
                    resultHandler:(SEL)resultHandler
                      failHandler:(SEL)failHandler;


/**
 *	@brief	按起始索引方式请求预定义排行榜
 *
 *	@param 	type 	自定义排行榜类型，上面有常量定义，参考https://trac.gemantic.com/wiki/desktop/StkData2#symbol2
 *	@param 	orderBy 	排序字段，上面有常量定义，参考https://trac.gemantic.com/wiki/desktop/StkData2#orderby
 *	@param 	theStart 	起始位置，从0开始
 *	@param 	theCount 	请求数量
 *	@param 	isDesc 	是否倒序
 *	@param 	target 	回调对象
 *	@param 	resultHandler 	成功回调函数，参数为 SKRankListVO，元素为SKRankItemVO
 *	@param 	failHandler 失败回调
 *
 *	@return	请求id
 *
 *  @see    SKRankItemVO
 */
- (UInt16)getRankListByType:(NSString *)type
                          orderBy:(NSString *)orderBy
                             start:(uint)theStart
                             count:(uint)theCount
                           isDesc:(BOOL)isDesc
                           target:(id)target
                    resultHandler:(SEL)resultHandler
                      failHandler:(SEL)failHandler;


/**
 *	@brief	请求自定义排行版
 *
 *	@param 	symbols 	字符串数组，元素为symbol
 *	@param 	target      目标
 *	@param 	resultHandler 	回调函数，参数为SKPageListVO，元素为SKRankItemVO
 *	@param 	failHandler     失败回调
 *
 *	@return	请求id
 *
 *  @see    SKRankItemVO
 */
- (UInt16)getRankListBySymbols:(NSArray *)symbols
                          target:(id)target
                   resultHandler:(SEL)resultHandler
                     failHandler:(SEL)failHandler;



@end
