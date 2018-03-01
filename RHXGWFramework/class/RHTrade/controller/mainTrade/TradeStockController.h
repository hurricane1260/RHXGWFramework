//
//  TradeStockController.h
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//  持股

@protocol TradeStockDelegate <NSObject>

- (void)navigateToBankTransferController;

- (void)tradeControllerSwitchTo:(TradeControllerViewIndex)viewIndex withStockName:(NSString *)stockName andStockCode:(NSString *)stockCode;

@end

@interface TradeStockController : BaseViewController

@property (nonatomic, weak) id <TradeStockDelegate> delegate;

@property (nonatomic, assign) TradeControllerType viewType;

@property (nonatomic, assign) BOOL isSecondTrade;

- (void)refreshData;

- (void)clearData;

@end
