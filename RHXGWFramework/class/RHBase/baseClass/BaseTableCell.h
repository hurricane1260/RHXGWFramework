//
//  BaseTableCell.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  UITableViewCell基类

#import <Foundation/Foundation.h>
#import "ITableCellItemView.h"

@interface BaseTableCell : UITableViewCell

/**
 *  列表展示数据的VIEW
 */
@property (nonatomic, strong) UIView<ITableCellItemView> *itemView;

@end
