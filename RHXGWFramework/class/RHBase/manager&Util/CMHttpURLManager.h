//
//  CMHttpURLManager.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-6.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  解析配置url地址配置文件，为网络请求提供URL字符串
//

#import <Foundation/Foundation.h>

@interface CMHttpURLManager : NSObject{
    @private
    NSMutableDictionary *_hostMap;
    NSMutableDictionary *_serviceUrlMap;
}

/**
 *  根据配置文件路径初始化配置
 */
+(void)initConfigureWithHostPath:(NSString *)hPath suffixPath:(NSString *)spath;


/**
 *  根据参数的ID，返回对应的URL地址字符串
 */
+(NSString *)urlStringWithServID:(NSString *)servID;

/**
 *仅返回url前缀
 */
+(NSString *)getHostIPWithServID:(NSString *)servID;

/**
 *返回当前的运行环境 测试ISSTAGING 开发ISDEV 线上ISPRODUCTION
 */
+(NSString *)getCurrentConfig;
@end
