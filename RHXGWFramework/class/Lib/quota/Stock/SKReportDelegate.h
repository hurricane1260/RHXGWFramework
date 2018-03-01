//
//  SKReportDelegate.h
//  iphone-stock
//
//  Created by ztian on 14-3-3.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKBaseDelegate.h"

// 一只股票报价
#define DEF_MO_REPORT1_RQ (DEF_STKDATA_BASE + 67)
// 多股报价
#define DEF_MULTI_REPORT2_RQ (DEF_STKDATA_BASE + 39)

// 5档实时报价数据
#define DEF_REPORT_RQ_Ex (DEF_STKDATA_BASE +5)
#define DEF_REPORT_RS_Ex (DEF_STKDATA_BASE +6)

/// 报价请求代理
@interface SKReportDelegate :SKBaseDelegate

/**
 *  @brief 根据symbol获取五档报价数据
 */
- (int)getFiveReportBySymbol:(NSString *)symbol
                      target:(id)target
               resultHandler:(SEL)resultHandler
                 failHandler:(SEL)failHandler;

/**
 *	@brief	根据symbol获取报价数据
 *
 *	@param 	symbol 	股票代码
 *  @param 	resultHandler 	成功回调函数，参数为SKReportVO
 *
 *	@return	请求id
 *
 *  @see    SKReportVO
 */

- (int)getReportBySymbol:(NSString *)symbol
                  target:(id)target
           resultHandler:(SEL)resultHandler
             failHandler:(SEL)failHandler;


/**
 *	@brief	根据多个symbol获取多只股票的报价数据
 *
 *	@param 	symbols 	字符串数组，元素为股票代码
 *	@param 	target      目标
 *	@param 	resultHandler 	回调函数，参数为NSArray，元素为SKReportVO
 *	@param 	failHandler     失败回调
 *
 *	@return	NSArray，元素为SKReportVO
 */
- (int)getMultiReportsBySymbols:(NSArray *)symbols
                         target:(id)target
                  resultHandler:(SEL)resultHandler
                    failHandler:(SEL)failHandler;


@end
