//
//  XgwSevenManager.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/26.
//
//智能选股七期 交易接口

#import <Foundation/Foundation.h>

typedef void(^ReuqestCompletion)(BOOL isSuccess, id resultData);


@interface XgwSevenManager : NSObject
/**请求清仓股票列表*/
-(void)requestCleanStocksListWithParam:(NSDictionary *)param completion:(ReuqestCompletion)callBack;
/**请求清仓股票列表下一级列表   清仓交易*/
-(void)requestCleanStocksTradeWithParam: (NSDictionary *)param  completion:(ReuqestCompletion)callBack;
/**历史转账记录*/
-(void)requestHistoryRecordWithParam: (NSDictionary *)param completion:(ReuqestCompletion)callBack;
/**历史交易对账单列表*/
-(void)requestHistoryTreadListParam: (NSDictionary *)param completion:(ReuqestCompletion)callBack;
/**签署ST风险揭示书*/
- (void)signRiskCautionWithParam:(NSDictionary *)param completion:(ReuqestCompletion)callBack;

- (void)cancelAllDelegate;



@end
