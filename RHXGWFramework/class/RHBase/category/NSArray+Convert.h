//
//  NSArray+Convert.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Convert)

+(NSArray *)convertCharArrayToNSArrayWith:(const char **)charArray size:(NSUInteger)aSize;

@end
