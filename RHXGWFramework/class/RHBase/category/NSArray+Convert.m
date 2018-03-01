//
//  NSArray+Convert.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "NSArray+Convert.h"

@implementation NSArray (Convert)

+(NSArray *)convertCharArrayToNSArrayWith:(const char *[])charArray size:(NSUInteger)aSize{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:aSize];
    
    for(int i=0; i<aSize; i++){
        const char *str = charArray[i];
        NSString *nsStr = [NSString stringWithUTF8String:str];
        [arr addObject:nsStr];
    }
    
    return arr;
}

@end
