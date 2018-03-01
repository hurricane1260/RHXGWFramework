//
//  TradeController.h
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  交易首页，持仓，买卖，委托，成交

typedef void (^TradeCallBack)(void);
typedef void (^TradeCallBackWithParams)(NSDictionary *params);

@interface TradeController : BaseViewController

@property (nonatomic, assign) BOOL isSecondTrade;

///跳转到个股详情页
///参数举例：{@"stockCode":@"sha_600004"}
@property (nonatomic, copy) TradeCallBackWithParams navigationToStockDetailBlock;

@end
