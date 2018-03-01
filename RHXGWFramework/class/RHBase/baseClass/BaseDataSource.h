//
//  BaseDataSource.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITableCellItemView.h"
#import "ITableDataSource.h"

@interface BaseDataSource : NSObject<ITableDataSource>

-(UIView<ITableCellItemView> *)didBuildItemView;

@end
