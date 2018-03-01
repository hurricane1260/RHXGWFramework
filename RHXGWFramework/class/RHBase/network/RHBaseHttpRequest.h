//
//  RHBaseHttpRequest.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/13.
//
//

#import <Foundation/Foundation.h>
#import "ListPageInfoVO.h"
#import "CMHttpURLManager.h"
#import "HTTPRequestService.h"

@interface RHBaseHttpRequest : NSObject

kRhPStrong ListPageInfoVO * pageInfo;

kRhPCopy NSString * mark;

kRhPStrong NSMutableArray * orginDataList;

kRhPCopy NSString * page;

/**
 *  发起Get请求
 *
 */
- (void)sendGetRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request;

/**
 *  发起异步Get请求
 *
 */
- (void)sendAsynGetRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request;

/**
 *  发起Post请求
 *
 */
- (void)sendPostRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request;

- (BOOL)hasNextPage;

- (void)getMarkWith:(NSInteger )mark;

- (BOOL)isValidData:(id)resultData;

- (void)pageHandler:(id)resultData;

- (void)cancelAllDelegate;
@end

