//
//  HTTPRequestService.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  封装ASIHttpRequest网络服务
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

//typedef void (^InteractorLayerRequestCompletion)(id resultData);

typedef NS_ENUM(NSUInteger, HTTRequestMethod){
    HTTRequestGET = 1,
    HTTRequestPOST = 2
};

typedef NS_ENUM(NSUInteger, HTTPRequestType){
    HTTPRequestSynchronous = 1,
    HTTPRequestAsynchronous = 2
};

typedef void(^SuccessCompletion)(id);

typedef void(^FailureCompletion)(id);

@interface HTTPRequestService : NSObject{
    ASIFormDataRequest *asiRequest;
}

//@property (nonatomic, copy) InteractorLayerRequestCompletion interactorCompletion;

@property (nonatomic, assign) HTTRequestMethod requestMethod;

@property (nonatomic, assign) HTTPRequestType requestType;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) id reqParam;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) SEL successSelector;

@property (nonatomic, assign) SEL failureSelector;

@property (nonatomic, strong) SuccessCompletion successCompletionBlock;

@property (nonatomic, strong) FailureCompletion failureCompletionBlock;

kRhPAssign BOOL  crhRequestTag;

-(id)initWithUrlString:(NSString *)urlString params:(id)aParam requestMethod:(HTTRequestMethod)method requestType:(HTTPRequestType)aType;

-(void)didBuildURLRequestWithUrlString:(NSString *)urlString params:(id)aParam requestMethod:(HTTRequestMethod)method requestType:(HTTPRequestType)aType;

-(void)sendRequestWithSuccessBlock:(void (^)(id data))successCallback failureBlock:(void (^)(id data))failureCallback;

//-(void)sendRequestWithDelegate:(id)delegate SuccessSEL:(SEL)suSEL failureSEL:(SEL)faSEL;


-(void)uploadFileWithUrlString:(NSString *)urlString params:(id)aParam imageKey:(NSString *)imgKey imageData:(NSData *)imgData successBlock:(void (^)(id data))successCallback failureBlock:(void (^)(id data))failureCallback;

-(void)cancel;

-(void)cancelWithoutDelegate;

-(void)sendCRHRequestWithSuccessBlock:(void (^)(id))successCallback failureBlock:(void (^)(id))failureCallback;

@end
