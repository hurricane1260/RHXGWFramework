//
//  SKCodeTable.h
//  iphone-stock
//
//  Created by ztian on 14-3-7.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKCodeItemVO.h"

//http://quota.zq88.cn/getCodetable 码表地址
typedef NS_ENUM(NSInteger, getCodeItemListType)
{
    allData,    //取所有股票数据
    tradeData,  //取交易数据
    adviserData, //取投顾数据
    searchData  //取搜索数据
};

@interface SKCodeTable : NSObject


+ (SKCodeTable *)instance;

/// 加载代码表
- (void)loadCodeTable;


/**
 *	@brief	根据股票代码获取SKCodeItemVO
 *
 *	@param 	symbol 	股票代码，格式为sha_000001
 *
 *	@return	对应的SKCodeItemVO
 */
- (SKCodeItemVO *)getCodeItemBySymbol:(NSString *)symbol;


/**
 *	@brief	根据多个股票代码获取多个SKCodeItemVO
 *
 *	@param 	symbols 	NSArray，元素为字符串，格式为sha_000001
 *
 *	@return	数组，元素为SKCodeItemVO
 */
- (NSArray *)getCodeItemsBySymbols:(NSArray *)symbols;



/**
 *	@brief	根据关键字搜索代码
 *
 *	@param 	keyword 	关键字，可以是中文名称，代码，中文拼音
 *
 *  @param 	type 	关键字，请求数据要全量还是可交易的
 *
 *	@return	NSArray，元素为SKCodeItemVO
 */
- (NSArray *)getCodeItemListByKeyword:(NSString *)keyword type:(NSInteger)type;


@end
