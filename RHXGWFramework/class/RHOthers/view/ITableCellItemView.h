//
//  ITableCellItemView.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  列表CELL接口

#import <Foundation/Foundation.h>

@protocol ITableCellItemView <NSObject>

@optional
/**
 *  传递给列表cell的数据
 */
@property (nonatomic, strong) id itemData;


/**
 *  如果列表需要图片，则需要实现该方法
 */
@property (nonatomic, strong) UIImage *flagImage;

@property (nonatomic, assign) CompeteListType listType;

@property (nonatomic, assign) SortListType sortType;

@property (nonatomic, strong) NSNumber * rankNum;

@property (nonatomic, strong) id lineChartArray;//折线图

- (void)loadDataWithModel:(id)model;

- (void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row;

@end
