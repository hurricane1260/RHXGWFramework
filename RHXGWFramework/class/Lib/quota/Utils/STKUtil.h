//
//  STKUtil.h
//  stockscontest
//
//  Created by ztian on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "SKReportVO.h"

@interface STKUtil : SKReportVO

/// 将不带前缀的代码加上前缀
+ (NSString *) fixSymbol:(NSString *)symbol;
@end
