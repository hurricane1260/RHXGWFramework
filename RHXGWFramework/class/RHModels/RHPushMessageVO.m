//
//  RHPushMessageVO.m
//  TZYJ_IPhone
//
//  Created by liyan on 16/4/29.
//
//

#import "RHPushMessageVO.h"

@implementation RHPushMessageVO

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
