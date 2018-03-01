//
//  ITableVisible.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-21.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  UITableView的显示容器协议

#import <Foundation/Foundation.h>

@protocol ITableVisible <NSObject>

@optional

@property (nonatomic, readonly) UITableView *visibleTableView;

/**
 *  列表cell点击处理方法
 *
 *  @param data 列表Cell包含的数据
 */
-(void)tableCellDidSelectedWithData:(id)data;

/**
 *  列表cell点击处理方法
 *
 *  @param index 序号
 */
-(void)tableCellDidSelectedWithIndexPath:(id)index;


/**
 *  下拉刷新处理方法
 */
-(void)pullRefreshDataHandler;

/**
 *  加载下一页处理方法
 */
-(void)loadNextPageDataHandler;

/**
 *  delegate随tableView一起滚动
 *
 *  @param tableView 滚动的tableView
 */
- (void)tableViewDidScroll:(UIScrollView *)tableView;

- (void)setTableViewCellHeight:(CGFloat)cellHeight;

@end
