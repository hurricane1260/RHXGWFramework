//
//  TradeEntrustTableViewCell.h
//  stockscontest
//
//  Created by Tiger on 15/6/13.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  撤单

#import <UIKit/UIKit.h>
#import "EntrustListVO.h"

@interface TradeEntrustTableViewCell : UITableViewCell 

@property (strong, nonatomic) EntrustListVO *itemVO;

@property (nonatomic, assign) TradeControllerType viewType;

@end
