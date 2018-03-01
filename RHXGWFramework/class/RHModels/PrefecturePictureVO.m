//
//  PrefecturePictureVO.m
//  stockscontest
//
//  Created by Zzbei on 15/12/8.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "PrefecturePictureVO.h"

@implementation PrefecturePictureVO

+ (id)pictureWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
