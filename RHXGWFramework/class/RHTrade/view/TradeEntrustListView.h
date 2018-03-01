//
//  TradeEntrustListView.h
//  stockscontest
//
//  Created by rxhui on 15/6/10.
//  Programed by Tiger.Yin, from 15/6/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  委托的列表

#import <UIKit/UIKit.h>
#import "TradeEntrustTableViewCell.h"
#import "TradeController.h"

@protocol TradeEntrustViewDelegate <NSObject>

-(void)requestEntrustList;

-(void)requestEntrustListNextPage;

-(void)sendEntrustWithdrawWithParam:(NSMutableDictionary *)param;

@end

@interface TradeEntrustListView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, weak) id <TradeEntrustViewDelegate> delegate;

@property (nonatomic, strong) UITableView *tradeEntrustListView;

@property (nonatomic, assign) TradeControllerType viewType;

@property (nonatomic, assign) BOOL isSecondTrade;

//+(TradeEntrustListView *)instanceTradeEntrustListView;

//- (void)stopRefreshTableView;

@end
