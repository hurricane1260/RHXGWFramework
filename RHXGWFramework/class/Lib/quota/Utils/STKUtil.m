//
//  STKUtil.m
//  stockscontest
//
//  Created by ztian on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "STKUtil.h"

@implementation STKUtil

+ (NSString *) fixSymbol:(NSString *)symbol
{
    if([symbol indexOf:@"_"] >= 0){
        return symbol;
    }
    if ([symbol indexOf:@"60"] == 0) {
        // 上证a股
        return [NSString stringWithFormat:@"sha_%@", symbol];
    }
    // 深证a股
    return [NSString stringWithFormat:@"sza_%@", symbol];
}

@end
