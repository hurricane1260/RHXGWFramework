//
//  RHBaseHttpRequest.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/13.
//
//

#import "RHBaseHttpRequest.h"
#import "ResultMessageVO.h"


@interface RHBaseHttpRequest ()



@end

@implementation RHBaseHttpRequest

- (instancetype)init{
    if (self = [super init]) {
        self.orginDataList = [NSMutableArray array];
        
    }
    return self;
}

- (void)cancelAllDelegate{

}

- (void)getMarkWith:(NSInteger )mark{
    self.mark = [NSString stringWithFormat:@"%ld",(long)mark];
}

- (BOOL)hasNextPage{
    return self.pageInfo.hasNextPage;
}

#pragma mark------内部请求方法------
//发起Get请求
- (void)sendGetRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request{
    [request cancelWithoutDelegate];
    
    request.urlString = [CMHttpURLManager urlStringWithServID:urlString];
    request.reqParam = aParam;
    request.requestMethod = HTTRequestGET;
    request.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [request sendRequestWithSuccessBlock:^(id data) {
        
        [welf didProcessRequestCompleteResultData:data withSuccess:YES];
        
    } failureBlock:^(id data) {
        
        [welf didProcessRequestCompleteResultData:data withSuccess:NO];

    }];
    
}

//发起异步Get请求
- (void)sendAsynGetRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request{
    [request cancelWithoutDelegate];
    
    request.urlString = [CMHttpURLManager urlStringWithServID:urlString];
    request.reqParam = aParam;
    request.requestMethod = HTTRequestGET;
    request.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [request sendRequestWithSuccessBlock:^(id data) {
        
        [welf didProcessAsynRequestCompleteResultData:data withSuccess:YES];
        
    } failureBlock:^(id data) {
        
        [welf didProcessAsynRequestCompleteResultData:data withSuccess:NO];
        
    }];
    
}

//发起Post请求
- (void)sendPostRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request{
    [request cancelWithoutDelegate];
    
    request.urlString = [CMHttpURLManager urlStringWithServID:urlString];
    request.reqParam = aParam;
    request.requestMethod = HTTRequestPOST;
    request.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [request sendRequestWithSuccessBlock:^(id data) {
        
        if ([self isValidData:data]) {
            [welf didProcessRequestCompleteResultData:data withSuccess:YES];
            
        } else {
            [welf didProcessRequestCompleteResultData:data withSuccess:NO];
            
        }
        
    } failureBlock:^(id data) {
        
        [welf didProcessRequestCompleteResultData:data withSuccess:NO];
    }];
    
}


#pragma mark------数据处理------
#pragma mark======请求返回数据统一处理======
- (void)didProcessRequestCompleteResultData:(id)resultData withSuccess:(BOOL)isSuc{
    //子类重写
}

- (void)didProcessAsynRequestCompleteResultData:(id)resultData withSuccess:(BOOL)isSuc{
    //子类重写
}

#pragma mark 通用方法 判断是否请求成功
- (BOOL)isValidData:(id)resultData{
    if (resultData == nil || ![resultData isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    ResultMessageVO * messVO = [ResultMessageVO parseData:resultData];
    BOOL isSuccess = messVO.code == 0?YES:NO;
    if (!isSuccess) {
        return NO;
    }
    return YES;
}

- (void)pageHandler:(id)resultData{
    NSNumber *totalPage = [resultData objectForKey:@"totalPage"];
    NSNumber *currentPage = [resultData objectForKey:@"currentPage"];
    self.pageInfo.totalPage = totalPage.integerValue;
    self.pageInfo.currentPage = currentPage.integerValue;
    self.pageInfo.hasNextPage = [[resultData objectForKey:@"hasNextPage"] boolValue];
}
@end
