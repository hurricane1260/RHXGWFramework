//
//  ListPageInfoVO.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-24.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  存储翻页信息

#import <Foundation/Foundation.h>

@interface ListPageInfoVO : NSObject

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) BOOL hasNextPage;

@end
