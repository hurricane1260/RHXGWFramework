//
//  HTTPRequestService.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "HTTPRequestService.h"
#import "HTTPRequestParamFactory.h"
#import "CJSONDeserializer.h"
#import "HTTPRequestManager.h"
#import "CMHttpURLManager.h"

#define kHttpRequestTimeoutSeconds 10

@implementation HTTPRequestService

-(id)initWithUrlString:(NSString *)urlString params:(id)aParam requestMethod:(HTTRequestMethod)method requestType:(HTTPRequestType)aType{
    self = [super init];
    if(self){
        self.requestMethod = method;
        self.requestType = aType;
        self.urlString = urlString;
        self.reqParam = aParam;
    }
    return self;
}

-(void)asiHttpRequestSend{

    if(self.urlString.length == 0){
        return;
    }
    
    NSString *method = @"GET";
    if(self.requestMethod == HTTRequestGET){
        NSString *finalUrlString = [HTTPRequestParamFactory didBuildRequestQueryStringWithUrlString:self.urlString reqParam:self.reqParam];
        method = @"GET";
        if([finalUrlString rangeOfString:@"clientLogin"].location == NSNotFound ) {
    
            finalUrlString = [finalUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        NSURL *url = [NSURL URLWithString:finalUrlString];
        
        asiRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    }else if(self.requestMethod == HTTRequestPOST){
        NSURL *url = [[NSURL alloc] initWithString:self.urlString];
        
//        NSLog(@"%s,%@",__func__,self.urlString);
        
//        NSURL *url = [NSURL URLWithString:self.urlString];
        asiRequest = [[ASIFormDataRequest alloc] initWithURL:url];
            //[self addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"application/json; charset=%@",charset]];
        [HTTPRequestParamFactory didBuildRequestPostParamWith:asiRequest reqParam:self.reqParam];
        method = @"POST";
    }
    NSLog(@"%@", asiRequest.url.absoluteString);
    
    [asiRequest setTimeOutSeconds:kHttpRequestTimeoutSeconds];
    [asiRequest setNumberOfTimesToRetryOnTimeout:1];//重试一次
    asiRequest.requestMethod = method;
    asiRequest.delegate = self;//替换成block
    
    NSString * config = [CMHttpURLManager getCurrentConfig];
    if ([config isEqualToString:ISDEV] || [config isEqualToString:ISSTAGING]) {
        asiRequest.validatesSecureCertificate = NO;
    }
    else if ([config isEqualToString:ISPRODUCTION]){
        //预发布后可应用这段代码
        NSString *tempURL = asiRequest.url.absoluteString;
        if ([tempURL hasPrefix:@"https:"]) {
            [asiRequest setValidatesSecureCertificate:YES];//是否验证服务器端证书，如果此项为yes那么服务器端证书必须为合法的证书机构颁发的，而不能是自己用openssl 或java生成的证书
        }
        else if ([tempURL hasPrefix:@"http:"]) {
            asiRequest.validatesSecureCertificate = NO;
        }
    }

    __block typeof(self)welf = self;
    __block typeof(asiRequest)weakASIRequest = asiRequest;
    if(self.requestType == HTTPRequestSynchronous){
        [asiRequest startSynchronous];
        [self synchronousFinished:asiRequest];
    }else if(self.requestType == HTTPRequestAsynchronous){
        asiRequest.completionBlock = ^() {
            [welf requestFinished:weakASIRequest];
        };
        [asiRequest startAsynchronous];
    }
}
//双向验证
//- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
//    OSStatus securityError = errSecSuccess;
//    NSString *passString = nil;
//    CFStringRef password = (__bridge CFStringRef) passString; //证书密码CFSTR("")
//    const void *keys[] =   { kSecImportExportPassphrase };
//    const void *values[] = { password };
//    
//    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
//    //    CFDictionaryRef optionsDictionary = nil;
//    
//    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//    //securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
//    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,optionsDictionary,&items);
//    
//    if (securityError == 0) {
//        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
//        const void *tempIdentity = NULL;
//        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
//        *outIdentity = (SecIdentityRef)tempIdentity;
//        const void *tempTrust = NULL;
//        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
//        *outTrust = (SecTrustRef)tempTrust;
//    } else {
//        //        NSLog(@"Failed with error code %d",(int)securityError);
//        return NO;
//    }
//    return YES;
//}

-(void)asiHttpUploadSendWithImageData:(NSData *)imageData imageKey:(NSString *)imgKey{
    NSURL *url = [[NSURL alloc] initWithString:self.urlString];
    asiRequest = [[ASIFormDataRequest alloc] initWithURL:url];

    [asiRequest setTimeOutSeconds:kHttpRequestTimeoutSeconds];
    [asiRequest setNumberOfTimesToRetryOnTimeout:0];//不重试
    [HTTPRequestParamFactory didBuildRequestPostParamWith:asiRequest reqParam:self.reqParam];
    
    asiRequest.requestMethod = @"POST";
//    asiRequest.delegate = self;
    __block typeof(self)welf = self;
    __block typeof(asiRequest)weakASIRequest = asiRequest;
    asiRequest.completionBlock = ^() {
        [welf requestFinished:weakASIRequest];
    };
    [asiRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%.0f%@", [[NSDate date] timeIntervalSince1970], @".png"];
    NSLog(@"%@+++", imageName);
    NSString * path = [cachePath stringByAppendingPathComponent:imageName];
    NSLog(@"%@----", path);
    BOOL success = [imageData writeToFile:path atomically:NO];

    if(success){
        [asiRequest setFile:path withFileName:imageName andContentType:@"multipart/form-data" forKey:imgKey];
    }else{
        [asiRequest setData:imageData withFileName:imageName andContentType:@"multipart/form-data" forKey:imgKey];
    }
    [asiRequest startAsynchronous];
}

-(void)uploadFileWithUrlString:(NSString *)urlString params:(id)aParam imageKey:(NSString *)imgKey imageData:(NSData *)imgData successBlock:(void (^)(id))successCallback failureBlock:(void (^)(id))failureCallback{
    
    self.urlString = urlString;
    self.reqParam = aParam;
    self.successCompletionBlock = successCallback;
    self.failureCompletionBlock = failureCallback;
    
    [self asiHttpUploadSendWithImageData:imgData imageKey:imgKey];
}

-(void)didBuildURLRequestWithUrlString:(NSString *)urlString params:(id)aParam requestMethod:(HTTRequestMethod)method requestType:(HTTPRequestType)aType{
    self.requestMethod = method;
    self.requestType = aType;
    self.urlString = urlString;
    self.reqParam = aParam;
}

//-(void)sendRequestWithDelegate:(id)delegate SuccessSEL:(SEL)suSEL failureSEL:(SEL)faSEL{
//    self.delegate = delegate;
//    self.successSelector = suSEL;
//    self.failureSelector = faSEL;
//    [self asiHttpRequestSend];
//}

-(void)sendRequestWithSuccessBlock:(void (^)(id))successCallback failureBlock:(void (^)(id))failureCallback{
    self.successCompletionBlock = successCallback;
    self.failureCompletionBlock = failureCallback;
    
    HTTPRequestService *request = [HTTPRequestManager appendParamForHTTPRequest:self];
    
    [request asiHttpRequestSend];
}

-(void)sendCRHRequestWithSuccessBlock:(void (^)(id))successCallback failureBlock:(void (^)(id))failureCallback{
    self.successCompletionBlock = successCallback;
    self.failureCompletionBlock = failureCallback;
    
    self.crhRequestTag = YES;
    
    [self asiHttpRequestSend];
    
}

/**
 *  同步调用返回
 */
-(void)synchronousFinished:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if(error){
        [self requestFailed:request];
    }else{
        [self requestFinished:request];
    }
} 

/**
 *  异步调用返回
 */
-(void)requestFinished:(ASIHTTPRequest *)request{
//    NSLog(@"-requestFinished-%@",request.url.absoluteString);
    int code = request.responseStatusCode;
    if(code == 404 || code == 500){
        NSDictionary *failureObj = @{@"message":@{@"code":@"404", @"message":@"服务器连接失败, 请重试"}};
        [self didProcessFailureWithMessage:failureObj];
        return;
    }
    
    NSData *responseData = [request responseData];
    NSMutableDictionary* jsonoObj = [[CJSONDeserializer deserializer] deserialize:responseData error:nil];
    if (!jsonoObj) {
        jsonoObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    }
    if (self.crhRequestTag) {
        jsonoObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        jsonoObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    }

//    if([self.delegate respondsToSelector:self.successSelector]){
//        IMP imp = [self.delegate methodForSelector:self.successSelector];
//        void (*functionImp)(id, SEL, id) = (void *)imp;
//        functionImp(self.delegate, self.successSelector, jsonoObj);
//    }
    
    if(self.successCompletionBlock){
        if (!jsonoObj) {
            self.successCompletionBlock(responseData);
        }
        else {
            self.successCompletionBlock(jsonoObj);
        }
    }
    [self clear];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
    NSDictionary *failureObj = @{@"message":@{@"code":@"404", @"message":@"网络连接失败"}};
    [self didProcessFailureWithMessage:failureObj];
    
    [self clear];
}

-(void)didProcessFailureWithMessage:(id)failureObj{
//    if([self.delegate respondsToSelector:self.failureSelector]){
//        IMP imp = [self.delegate methodForSelector:self.failureSelector];
//        void (*functionImp)(id, SEL, id) = (void *)imp;
//        functionImp(self.delegate, self.failureSelector, failureObj);
//    }
    
    if(self.failureCompletionBlock){
        self.failureCompletionBlock(failureObj);
    }
}

-(void)cancelWithoutDelegate {
    [asiRequest clearDelegatesAndCancel];
}

-(void)cancel {
    [asiRequest cancel];
}

-(void)clear{
//    self.delegate = nil;
    self.successSelector = nil;
    self.failureSelector = nil;
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    
//    self.interactorCompletion = nil;
//    asiRequest.delegate = nil;
//    asiRequest = nil;
}

- (void)dealloc{
    [self clear];
}

@end
