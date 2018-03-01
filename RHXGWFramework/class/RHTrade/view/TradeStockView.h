//
//  TradeStockView.h
//  stockscontest
//
//  Created by rxhui on 15/6/10.
//  Programed by Tiger.Yin on 15/6/11
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  持仓的view

#import <UIKit/UIKit.h>

@protocol TradeControllerSwitchViewDelegate <NSObject>

// 交易视图控制器实现本方法，来针对某只股票跳转到相应窗口。
// viewIndex取枚举值，对应相应目的View。
-(void)tradeControllerSwitchTo:(TradeControllerViewIndex)viewIndex withStockName:(NSString *)stockName andStockCode:(NSString *)stockCode;

- (void)navigateToBankTransferController;

- (void)refreshStockView;

- (void)stockViewNextPage;

@end

@interface TradeStockView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) TradeControllerType viewType;

@property (nonatomic,strong) NSArray *stockList;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong)  UITableView *tradeStockTableView;

@property (weak, nonatomic) id<TradeControllerSwitchViewDelegate> tradeControllerDelegate;

@property (nonatomic, assign) BOOL isSecondTrade;

-(void)onGetDetailFundResult;
-(void)onGetHoldPositionListResult;

//- (void)stopRefreshTableView;

@end
