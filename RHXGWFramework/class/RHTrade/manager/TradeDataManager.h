//
//  TradeDataManager.h
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TradeDataManagerDelegate <NSObject>

@optional
/**
 *  @brief 登录返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)loginResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询股票列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
//-(void)getStockListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 买卖返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)tradeResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 确认股票价格返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
//-(void)getStockPriceResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 确认股票数量返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getStockCountResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询股票行情返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
//-(void)getStockMarketPriceResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询账户资金详情返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getDetailFundResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询账户持仓列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getHoldPositionListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询委托撤单列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getEntrustWithdrawListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询下一页委托撤单列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getNextPageEntrustWithdrawListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 委托撤单请求列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)sendWithdrawRequestResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询成交列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)requestDealListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询成交历史列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)requestDealHistoryListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询账户的股东账号返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)requestShareHolderAccountNumberResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询账户的股东账号返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getStockExchangeTypeResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 请求验证码返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getMagicCodeResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 请求银行账号返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getBankAccountResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 请求银行余额返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getBankMoneyResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 根据流水取余额返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)getBankMoneySerialResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 转账请求返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)sendTransferRequestResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询转账流水列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)requestTransferFlowListResultHandler:(id)resultData andSuccess:(BOOL)success;

/**
 *  @brief 查询历史转账列表返回
 *  @param resultData 返回的数据
 *  @param success 是否成功，若不成功，返回提示信息
 */
-(void)requestTransferHistoryListResultHandler:(id)resultData andSuccess:(BOOL)success;

@end



@interface TradeDataManager : NSObject

@property (nonatomic,weak)id <TradeDataManagerDelegate> delegate;

-(void)cancelAllRequest;

/**
 *  @brief 登录请求
 *  @param param 必要的参数，password，accountContent账号
 */
-(void)sendLoginRequestWithParam:(id)param;

/**
 *  @brief 查询股票列表
 *  @param param 必要的参数，query查询字段
 */
//-(void)requestStockListWithPatam:(id)param;

///**
// *  @brief 取消键盘精灵的请求
// */
//-(void)cancelStockListRequest;

/**
 *  @brief 交易请求，买入/卖出
 *  @param param 必要的参数，stockCode，entrustAmount，entrustPrice，entrustBs。
 *  entrustBs买卖方向：1买入，2卖出。
 */
-(void)sendTradeRequestWithPatam:(id)param;

/**
 *  @brief 输入股票代码，确认股票价格信息，最新价，上下限价格等
 *  @param param 必要的参数，stockCode
 */
//-(void)requestStockPriceWithPatam:(id)param;

/**
 *  @brief 输入股票代码，委托价格，确认可购买的数量
 *  @param param 必要的参数，stockCode，entrustPrice
 */
-(void)requestStockCountWithPatam:(id)param;

/**
 *  @brief 输入股票代码，查询股票行情
 *  @param param 必要的参数，stockCode
 */
//-(void)requestMarketPriceWithPatam:(id)param;

/**
 *  @brief 查询账户资金详情
 */
-(void)requestDetailFund;

/**
 *  @brief 查询账户持仓列表
 */
-(void)requestHoldPositionList;

/**
 *  @brief 查询下一页账户持仓列表
 */
-(void)requestHoldListNextPage;

/**
 *  @brief 查询账户委托撤单列表
 */
-(void)requestEntrustWithdrawList;

/**
 *  @brief 查询下一页账户委托撤单列表
 */
-(void)requestNextPageEntrustWithdrawList;

/**
 *  @brief 发送撤单请求
 *  @param param 必要的参数，exchangeType交易类别,空格，entrustNo委托编号
 */
-(void)sendWithdrawRequestWith:(id)param;

/**
 *  @brief 查询账户成交列表
 */
-(void)requestDealList;

/**
 *  @brief 查询下一页账户成交列表
 */
//-(void)requestDealListForNextPage;

/**
 *  @brief 查询账户历史成交列表
 */
-(void)requestDealHistoryListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 *  @brief 查询账户下一页历史成交列表
 */
//-(void)requestDealHistoryListForNextPage;

/**
 *  @brief 查询某时间段的历史成交列表
 */
//-(void)requestDealHistoryListStart:(NSString *)startDate end:(NSString *)endDate callBack:(RequestCompletionCallback)callBack;

/**
 *  @brief 查询当前帐户的股东账号
 */
-(void)requestShareHolderAccountNumber;

/**
 *  @brief 查询某一股票的exchangeType
 *  @param param 必要的参数，stockCode
 */
-(void)requestStockExchangeTypeWithPatam:(id)param;

/**
 *  @brief 请求验证码
 */
-(void)requestMagicCode;

/**
 *  @brief 请求银行账号
 */
-(void)requestBankAccount;

/**
 *  @brief 请求银行账户余额
 *  @param param 必要的参数,fundPassword资金密码，bankPassword银行密码,moneyType,bankNo
 */
-(void)requestBankMoneyWithParam:(NSMutableDictionary *)param;

/**
 *  @brief 根据流水号取余额
 *  @param param 必要的参数,entrustNo，bankNo
 */
-(void)requestBankSerialMoneyWithParam:(NSMutableDictionary *)param;

/**
 *  @brief 发送提现请求
 *  @param param 必要的参数：bankNo，moneyType，transferDirection(1–银行转证券 2- 证券转银行)，occurBalance，fundPassword，bankPassword
 */
-(void)sendTransferRequestWithParam:(NSMutableDictionary *)param;

/**
 *  @brief 请求交易流水
 *  @param param 必要的参数：bankNo
 */
-(void)requestTransferFlowListWithParam:(NSMutableDictionary *)param;

/**
 *  @brief 请求历史交易流水
 *  @param param 必要的参数：bankNo
 */
-(void)requestTransferHistoryListWithParam:(NSMutableDictionary *)param;

/**
 *  @brief 请求历史交易流水的下一页
 *  @param param 必要的参数：bankNo
 */
-(void)requestTransferHistoryListNextPageWithParam:(NSMutableDictionary *)param;
@end
