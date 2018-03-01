//
//  ASIHttpTool.h
//  stockscontest
//
//  Created by 于子浩 on 16/7/6.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASIHttpTool : NSObject


/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(id)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


@end
