//
//  HTTPRequestManager.m
//  stockscontest
//
//  Created by rxhui on 15/3/25.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "HTTPRequestManager.h"
#import "CMHttpURLManager.h"
#import "TradeSessionManager.h"
#import "AccountTokenDataStore.h"
//#import "AccountDataManager.h"
#import "URLEncryptor.h"
#import "JHJRServerTime.h"

@implementation HTTPRequestManager

+(HTTPRequestService *)appendParamForHTTPRequest:(HTTPRequestService *)request {
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:request.reqParam];
    
    //为trade开头的request添加session
    BOOL hasTradeUrlPrefix = [request.urlString hasPrefix:[NSString stringWithFormat:@"%@",[CMHttpURLManager getHostIPWithServID:@"tradeUrl"]]];
    if (hasTradeUrlPrefix) {
        if (request.requestMethod == HTTRequestPOST) {//交易接口没有post全是get
            return request;
        }
        BOOL isCreateSession = [request.urlString hasSuffix:@"createSession"];
        NSString *sessionID = [TradeSessionManager shareInstance].sessionID;
        BOOL hasSessionID = (sessionID != nil);
        if (isCreateSession) {
            //            NSLog(@"---%@",request.urlString);
            return request;
        }
        if (!hasSessionID && !isCreateSession) {
            NSLog(@"sessionId为空,请求错误");
            [[TradeSessionManager shareInstance]stopPing];
        }
        if (!isCreateSession) {
            [param setValue:sessionID forKey:@"sessionId"];
            request.reqParam = param;
            return request;
        }
    }
    
    
    
    //增加针对理财接口的客户端认证
    NSString *fundUrl = [CMHttpURLManager getHostIPWithServID:@"followOrderFundUrl"];//理财前缀
    BOOL isFund = [request.urlString hasPrefix:fundUrl];
    if (isFund) {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        // AccountTokenDataStore *store = [[AccountTokenDataStore alloc]init];
        // NSString *clientToken = store.accountToken;
        NSString *client = @"iOS";
        [param setValue:client forKey:@"client"];
        [param setValue:version forKey:@"appVersion"];
        //[param setValue:clientToken forKey:@"clientToken"];
        [param setValue:@"CP140813001" forKey:@"productId"];
        //clientcheck 是避开理财后台签名验证的参数,如果线上环境需要去掉改参数
        //[param setValue:@"0" forKey:@"clientcheck"];
        //URLEncryptor *encryptor = [[URLEncryptor alloc]init];
        NSString *appKey = [JHJRServerTime getJHJRAppKey];
        NSString *appSecret = [JHJRServerTime getJHJRAppSecret];
        [UrlEncryptor setAppKey:appKey appSecret:appSecret];
        NSDictionary * newParams = [UrlEncryptor encryptPOSTParams:param timestamp:[JHJRServerTime currentServerTime]];
        //NSDictionary *newParams = [encryptor encryptParameters:param withAppKey:appKey appSecret:appSecret timeStamp:[JHJRServerTime currentServerTime]];
        request.reqParam = newParams;
        return request;
        
    }
    
    
    //给跟投王除交易外的接口加统计参数
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *productId = @"CP140813001";
//    AccountTokenDataStore *store = [[AccountTokenDataStore alloc]init];
    NSString *clientToken = [AccountTokenDataStore getAccountToken];
    NSString *client = @"iOS";
//
//    NSString *accessToken = nil;
//    AccountVO *accountVO = [AccountDataManager currentOnlineAccount];
//    if (accountVO && accountVO.accessToken) {
//        accessToken = accountVO.accessToken;
//    }
    [param setValue:client forKey:@"client"];
    [param setValue:version forKey:@"appVersion"];
    [param setValue:clientToken forKey:@"clientToken"];
    [param setValue:productId forKey:@"productId"];
//    if (accessToken) {
//        [param setValue:accessToken forKey:@"accessToken"];
//    }
    request.reqParam = param;
    return request;
}

@end
