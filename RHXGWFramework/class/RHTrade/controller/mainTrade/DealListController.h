//
//  DealListController.h
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  成交/委托列表

@interface DealListController : BaseViewController

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, assign) TradeControllerType controllerType;

- (void)refreshDataList;

@end
