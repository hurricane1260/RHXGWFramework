//
//  NSObject+ModelParser.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ModelParser)

+(id)parseJsonToModel:(id)jsonData targetClass:(Class)clazz;

+(NSArray *)parseJsonToModelList:(id)jsonData listItemClass:(Class)clazz;

@end
