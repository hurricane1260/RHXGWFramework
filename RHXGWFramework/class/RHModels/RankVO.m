//
//  RankPositionVO.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-21.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "RankVO.h"

@implementation RankVO

+ (id)generateWithDict:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
