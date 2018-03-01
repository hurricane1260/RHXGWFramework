//
//  SKPageListVO.h
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBaseVO.h"

/// 带symbol的数据列表，可选分页功能
@interface SKPageListVO : SKBaseVO

/// 股票代码
@property (nonatomic,retain) NSString *symbol;
/// 分类
@property (nonatomic,retain) NSString *type;
/// 当前页
@property (nonatomic,assign) uint currentPage;
/// 总数量
@property (nonatomic,assign) uint totalCount;
/// 总页数
@property (nonatomic,assign) uint totalPage;
/// 当前数量
@property (nonatomic,readonly) uint count;
/// 列表
@property (nonatomic,readonly) NSMutableArray *list;
/// 起始位置
@property (nonatomic,assign) uint start;


/**
 *	@brief	添加元素
 *
 */
- (void)addItem:(id)item;


/**
 *	@brief	根据索引获取元素
 *
 *	@param 	index 	索引
 *
 *	@return	index对应元素
 */
- (id)getItem:(int)index;


@end
