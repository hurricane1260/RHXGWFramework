//
//  DealListViewCell.h
//  stockscontest
//
//  Created by Tiger on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  成交

#import <UIKit/UIKit.h>

@interface DealListViewCell : UITableViewCell

@property (nonatomic, strong) id itemVO;

@property (nonatomic, assign) TradeControllerType viewType;

@end
