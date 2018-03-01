//
//  TradeBuySellController.h
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//  买卖

@interface TradeBuySellController : BaseViewController

///区分是模拟还是实盘
@property (nonatomic, assign) TradeControllerType controllerType;

///区分买卖
@property (nonatomic, assign) TradeBuySellViewType viewType;

@property (nonatomic,copy) NSString *viewStockCode;

@property (nonatomic,copy) NSString *viewStockName;

@property (nonatomic, assign) BOOL isSecondTrade;

- (void)refreshData;

- (void)clearData;

- (void)stopReceivePushData;

@end
