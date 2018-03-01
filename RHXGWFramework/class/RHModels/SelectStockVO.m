//
//  SelectStockVO.m
//  stockscontest
//
//  Created by rxhui on 15/8/11.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "SelectStockVO.h"

@implementation SelectStockVO

+ (id)selectWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSString * inc = dict[@"inc"];
        self.inc = [inc floatValue];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
