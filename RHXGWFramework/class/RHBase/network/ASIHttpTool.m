//
//  ASIHttpTool.m
//  stockscontest
//
//  Created by 于子浩 on 16/7/6.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "ASIHttpTool.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "JSONKit.h"
#import "CMHttpURLManager.h"
#import "HTTPRequestParamFactory.h"
@implementation ASIHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    NSURL *urlStr = [NSURL URLWithString:url];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:urlStr];
    request.timeOutSeconds = 30;
    request.shouldAttemptPersistentConnection=NO;
    //[request setDelegate:self];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (NSString *key in params) {
        [request addPostValue:params[key] forKey:key];
    }
    __weak ASIFormDataRequest *requstback = request;
    [request setCompletionBlock:^{
        [requstback cancel];
        [requstback clearDelegatesAndCancel];
        // 请求响应结束，返回 responseString
        [requstback setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [requstback responseString ];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n"withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n"withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t"withString:@""];
        // 对于 2 进制数据，使用 NSData 返回NSData *responseData = [request responseData];
//        NSDictionary *requestDic=   [responseString objectFromJSONString];
        
        NSData *responseData = [requstback responseData];
        
        NSMutableDictionary* jsonoObj = [[CJSONDeserializer deserializer] deserialize:responseData error:nil];
        
        
        if (!jsonoObj) {
            jsonoObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        }
    
        if (success) {
            success(jsonoObj);
        }
        
    }];
    [request setFailedBlock :^{
        [requstback cancel];
        [requstback clearDelegatesAndCancel];
        // 请求响应失败，返回错误信息
        NSError *error = [requstback error];
        if (failure) {
            failure(error);
        }
    }];
    
    [request startAsynchronous];
}


+ (void)getWithURL:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *finalUrlString = [HTTPRequestParamFactory didBuildRequestQueryStringWithUrlString:[CMHttpURLManager urlStringWithServID:url] reqParam:params];
    
    NSLog(@"请求地址 == %@",finalUrlString);

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)finalUrlString,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    
    NSURL *urlStr = [NSURL URLWithString:encodedString];
    
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:urlStr];
//        request.shouldAttemptPersistentConnection=NO;
    //[request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setStringEncoding:NSUTF8StringEncoding];
    __weak ASIFormDataRequest *requstback = request;
    [request setCompletionBlock:^{
        [requstback cancel];
        [requstback clearDelegatesAndCancel];
        // 请求响应结束，返回 responseString
        [requstback setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [requstback responseString ];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n"withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n"withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t"withString:@""];
        // 对于 2 进制数据，使用 NSData 返回 NSData *responseData = [request responseData];
//        NSDictionary *requestDic=   [responseString objectFromJSONString];
         NSData *responseData = [requstback responseData];
         NSMutableDictionary* jsonoObj = [[CJSONDeserializer deserializer] deserialize:responseData error:nil];
            if (!jsonoObj) {
                  jsonoObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
               }
        
        if (success) {
            success(jsonoObj);
        }
        
    }];
    [request setFailedBlock :^{
        [requstback cancel];
        [requstback clearDelegatesAndCancel];
        // 请求响应失败，返回错误信息
        NSError *error = [requstback error];
        if (failure) {
            failure(error);
        }
    }];
    
    [request startAsynchronous];
}


@end
