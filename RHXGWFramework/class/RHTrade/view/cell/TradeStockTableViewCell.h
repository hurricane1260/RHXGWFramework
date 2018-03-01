//
//  TradeStockTableViewCell.h
//  stockscontest
//
//  Created by Tiger on 15/6/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  持仓

#import <UIKit/UIKit.h>
#import "StockListVO.h"
#import "TradeStockView.h"

@interface TradeStockTableViewCell : UITableViewCell

@property (nonatomic, assign) TradeControllerType cellType;

@property (nonatomic, strong) UIView *actionView;

@property (nonatomic, strong) StockListVO *stockVO;

@property (nonatomic, weak) id<TradeControllerSwitchViewDelegate> delegate;

- (void)onBuy:(id)sender;
- (void)onSell:(id)sender;
- (void)onLearnMarket:(id)sender;

@end
