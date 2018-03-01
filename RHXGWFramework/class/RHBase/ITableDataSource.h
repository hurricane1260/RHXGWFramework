//
//  ITableDataSource.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-21.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  列表的DataSource接口

#import <Foundation/Foundation.h>
#import "ITableVisible.h"

@protocol ITableDataSource <UITableViewDataSource, UITableViewDelegate>

@optional
/**
 *  列表数据
 */
@property (nonatomic, strong) NSArray *dataList;

/**
 *  数据源持有的代理对象，该对象定义了列表点击等交互的方法
 */
@property (nonatomic, weak) id<ITableVisible> delegate;

/**
 *  Cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  cell的itemView类名
 */
@property (nonatomic, copy) NSString *itemViewClassName;

/**
 *  cell描述
 */
@property (nonatomic, copy) NSString *cellIndentifier;

/**
 *  Cell间距
 */
@property (nonatomic, assign) CGFloat cellGap;

/**
 *  headerView高度
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  headerView的itemView类名
 */
@property (nonatomic, copy) NSString *itemheaderViewName;

/**
 *  headerView描述
 */
@property (nonatomic, copy) NSString *headerIndentifier;

/**
 *  headerView数据
 */
@property (nonatomic, strong) NSArray *headerList;

@end
