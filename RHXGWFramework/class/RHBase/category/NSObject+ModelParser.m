//
//  NSObject+ModelParser.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "NSObject+ModelParser.h"
#import <objc/runtime.h>

@implementation NSObject (ModelParser)

////重写方法，控制台输出错误的赋值
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    NSLog(@"%s,key=%@,value=%@",__func__,key,value);
//}

+(id)parseJsonToModel:(id)jsonData targetClass:(Class)clazz{
    unsigned int count = 0;
    objc_property_t *popertylist = class_copyPropertyList(clazz, &count);
    
    id model = [[clazz alloc] init];
    if (count == 0) {
        return nil;
    }
    for(int i = 0; i < count; i++){
        objc_property_t property = popertylist[i];
        const char * name = property_getName(property);
        NSString *proName = [NSString stringWithUTF8String:name];
        id proValue = [jsonData valueForKey:proName];
        if(proValue){
            [model setValue:proValue forKey:proName];
        }
        
    }
    
    free(popertylist);//否则内存泄漏
    
    return model;
}

+(NSArray *)parseJsonToModelList:(id)jsonData listItemClass:(Class)clazz{
    if(!jsonData && ![jsonData isKindOfClass:[NSArray class]]){
        return @[];
    }
    
    NSArray *jsonList = (NSArray *)jsonData;
    NSMutableArray *itemList = [NSMutableArray arrayWithCapacity:jsonList.count];
    
    for(id jsonObject in jsonList){
        id itemvo = [NSObject parseJsonToModel:jsonObject targetClass:clazz];
        [itemList addObject:itemvo];
    }
    
    return itemList;
}

@end
