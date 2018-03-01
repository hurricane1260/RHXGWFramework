//
//  BuyViewStockListCellTableViewCell.h
//  stockscontest
//
//  Created by rxhui on 15/6/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  买卖－键盘精灵

#import <UIKit/UIKit.h>

@interface BuyViewStockListCell : UITableViewCell

@property (nonatomic,copy) NSString *stockString;

@property (nonatomic,strong) id cellData;

-(void)applyStringColorWithQueryString:(NSString *)queryString;

@end
