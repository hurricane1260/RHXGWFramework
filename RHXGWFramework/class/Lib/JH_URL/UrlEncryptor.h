//
//  UrlEncryptor.h
//  UrlEncryptor
//
//  Created by mshqiu on 2017/4/19.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlEncryptor : NSObject

/*
 已有参数与appKey、appSecret、timestamp重名，会被覆盖
 */

// 设置加密用的key、secret
+ (void)setAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

// 用key、secret、timestamp对GET请求的url加密
+ (NSURL *)encryptGETUrl:(NSURL *)url withParams:(NSDictionary *)params timestamp:(NSString *)timestamp;

// 用key、secret、timestamp对POST请求的参数集加密
+ (NSDictionary *)encryptPOSTParams:(NSDictionary *)params timestamp:(NSString *)timestamp;

@end
