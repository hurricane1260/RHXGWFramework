//
//  TradeWithdrawController.h
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//  撤单

@interface TradeWithdrawController : BaseViewController

@property (nonatomic, assign) TradeControllerType viewType;

@property (nonatomic, assign) BOOL isSecondTrade;

- (void)refreshData;

- (void)clearData;

@end
