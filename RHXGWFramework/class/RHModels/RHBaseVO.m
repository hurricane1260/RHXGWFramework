//
//  RHBaseVO.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/13.
//
//

#import "RHBaseVO.h"

@implementation RHBaseVO

+ (id)generateWithDict:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key{
    
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
