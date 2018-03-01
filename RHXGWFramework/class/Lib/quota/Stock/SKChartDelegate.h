//
//  SKMChartDelegate.h
//  iphone-stock
//
//  Created by ztian on 14-2-28.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKBaseDelegate.h"
#import "CQCXSymbolVO.h"
#import "SKMChartItemVO.h"
#import "SKPageListVO.h"
#import "SKKChartItemVO.h"
#import "CQCXSymbolVO.h"

/// K线周期
#define PERIOD_DAY 0
#define PERIOD_WEEK 1
#define PERIOD_MONTH 2
#define PERIOD_YEAR 3

/// K线请求类型
#define DEF_KDATA_RQ (DEF_STKDATA_BASE + 17)
/// 分时线请求类型
#define DEF_MIN_DATA_RQ2 (DEF_STKDATA_BASE + 63)
/// 单条除权除息
#define DEF_MO_EXACT_DR_RQ (DEF_STKDATA_BASE + 73)

/// 分时，K线等图表数据代理类
@interface SKChartDelegate : SKBaseDelegate


/**
 *	@brief	根据symbol获取分时数据
 *
 *	@param 	symbol 	股票代码
 *	@param 	time 	1970开始的秒数，数据开始时间。0表示全部
 *  @param 	resultHandler 	参数为SKPageListVO，元素为SKMChartItemVO
 *
 *	@return	请求id
 *
 *  @see    SKPageListVO
 *  @see    SKMChartItemVO
 */

- (int)getMDataBySymbol:(NSString *)symbol
                        time:(long)time
                      target:(id)target
               resultHandler:(SEL)resultHandler
                 failHandler:(SEL)failHandler;




/**
 *	@brief	根据symbol获取K线数据
 *
 *	@param 	symbol 	股票代码
 *	@param 	time 	从哪天开始请求，格式为YYYYMMDD
 *	@param 	dayCount 	补充的数
 *	@param 	isForward 	是否向前补充
 *	@param 	period 	请求周期
 *  @param 	resultHandler 	参数为SKPageListVO，元素为SKKChartItemVO
 *
 *	@return	请求id
 *
 *  @see    SKPageListVO
 *  @see    SKMChartItemVO
 */
- (int)getKDataBySymbol:(NSString *)symbol
                    daystamp:(int)time
                    dayCount:(short)dayCount
                   isForward:(BOOL)isForward
                      period:(short)period
                      target:(id)target
               resultHandler:(SEL)resultHandler
                 failHandler:(SEL)failHandler;


/**
 *	@brief	获取某只股票的除权除息信息
 *
 *	@param 	symbol 	股票代码
 *	@param 	target  目标
 *	@param 	resultHandler   参数为CQCXSymbolVO
 *	@param 	failHandler     失败回调
 *
 *	@return	请求id
 */
- (int)getCQCXBySymbol:(NSString *)symbol
                target:(id)target
         resultHandler:(SEL)resultHandler
           failHandler:(SEL)failHandler;



@end
