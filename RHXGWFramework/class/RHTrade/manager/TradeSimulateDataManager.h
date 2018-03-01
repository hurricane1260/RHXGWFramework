//
//  TradeSimulateDataManager.h
//  stockscontest
//
//  Created by rxhui on 16/1/19.
//  Copyright © 2016年 方海龙. All rights reserved.
//  虚拟盘网络请求

#import <Foundation/Foundation.h>
#import "HTTPRequestService.h"

@interface TradeSimulateDataManager : NSObject

- (void)cancelAllRequest;

/**
 *  @brief 查询账户资金详情
 */
-(void)requestDetailFundWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 查询账户持仓列表
 */
-(void)requestHoldPositionListWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 查询账户持仓列表下一页
 */
-(void)requestHoldPositionListNextPageWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 执行模拟交易买卖
 */
-(void)sendTradeRequestWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 查询最大可买/可卖,说明：类型为买入时funds有值，maxSaleVol为空，卖出时反过来 
 */
-(void)requestMaxTradeAmountWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 查询委托列表
 */
-(void)requestEntrustListWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 撤销委托挂单
 */
-(void)sendWithdrawWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 历史交易
 */
-(void)requestHistoryTradeListWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 历史交易下一页
 */
-(void)requestHistoryTradeListNextPageWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 查询我的组合
 */
//-(void)requestMyInvestCoupleListWithCallBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 提交编辑的资料
 */
//-(void)sendEditedInvestInfoWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack;

@end
