//
//  SKUtils.h
//  iphone-stock
//
//  Created by ztian on 14-3-3.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STOCK_TYPE_SHA @"sha"
#define STOCK_TYPE_SZA @"sza"
#define STOCK_TYPE_HC @"hc"

/// 上证A股
#define TYPE_STOCK_SHA @"stock_sha"
/// 上证B股
#define TYPE_STOCK_SHB @"stock_shb"
/// 深证A股
#define TYPE_STOCK_SZA @"stock_sza"
/// 深证B股
#define TYPE_STOCK_SZB @"stock_szb"
/// 上海指数
#define TYPE_INDEX_SHA @"index_sha"
/// 深证指数
#define TYPE_INDEX_SZA @"index_sza"
/// 申万行业
#define TYPE_BLOCK_SW  @"block_sw"
/// 概念板块
#define TYPE_BLOCK_GN  @"block_gn"
/// 地域板块
#define TYPE_BLOCK_DY   @"block_dy"
/// 无法识别的类型或未用到的类型
#define TYPE_UNUSED @"unused"


@interface SKUtils : NSObject


/**
 *	@brief	将没有前缀的股票代码加上前缀，只能处理股票，板块和指数无效
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	加上前缀的股票代码
 */
+ (NSString *)fixSymbol:(NSString *)symbol;


/**
 *	@brief	根据股票代码获取类型信息
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	类型信息
 */
+ (NSString *)getTypeBySymbol:(NSString *)symbol;

/**
 *	@brief	根据股票代码获取Code信息
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	类型信息
 */
+ (NSString *)getCodeBySymbol:(NSString *)symbol;

/**
 *	@brief	是否是指数
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	YES如果是指数，NO如果不是
 */
+ (BOOL)isIndexBySymbol:(NSString *)symbol;


/**
 *	@brief	根据前缀和code返回类型信息
 *
 *	@param 	prefix 	前缀，如sha
 *	@param 	code 	code，如000001
 *
 *	@return	类型信息
 */
+ (NSString *)getTypeByPrefix:(NSString *)prefix code:(NSString *)code;


/**
 *	@brief	是否是板块
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	YES如果是指数，NO如果不是
 */
+ (BOOL)isBlockBySymbol:(NSString *)symbol;
/**
 *	@brief	是否是股票
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	YES如果是指数，NO如果不是
 */
+ (BOOL)isStockBySymbol:(NSString *)symbol;
/**
 *	@brief	是否是A股
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	YES如果是指数，NO如果不是
 */
+ (BOOL)isAStockBySymbol:(NSString *)symbol;
/**
 *	@brief	是否是B股
 *
 *	@param 	symbol 	股票代码
 *
 *	@return	YES如果是指数，NO如果不是
 */
+ (BOOL)isBStockBySymbol:(NSString *)symbol;


@end
