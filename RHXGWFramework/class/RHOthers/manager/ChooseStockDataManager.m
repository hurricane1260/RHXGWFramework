//
//  ChooseStockDataManager.m
//  JinHuiXuanGuWang
//
//  Created by Zzbei on 2016/10/24.
//
//

#import "ChooseStockDataManager.h"
#import "CMHttpURLManager.h"
#import "HTTPRequestService.h"
//#import "AccountDataManager.h"
//#import "AccountVO.h"
#import "PrefecturePictureVO.h"
//#import "ChooseStockListVO.h"
//#import "CurrentChooseStockVO.h"
//#import "RecommendStockVO.h"

@interface ChooseStockDataManager ()

@property (nonatomic,strong) HTTPRequestService * requestForBanner;
//@property (nonatomic,strong) HTTPRequestService * requestForList;
//@property (nonatomic,strong) HTTPRequestService * requestForCurrent;
//@property (nonatomic,strong) HTTPRequestService * requestForRecommend;
//@property (nonatomic,strong) HTTPRequestService * requestForTagStock;
//@property (nonatomic,strong) HTTPRequestService * requestForFeedBack;

@end

@implementation ChooseStockDataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initAllRequest];
    }
    return self;
}

- (void)initAllRequest
{
    self.requestForBanner = [[HTTPRequestService alloc] init];
    self.requestForBanner.delegate = self;
//    self.requestForList = [[HTTPRequestService alloc] init];
//    self.requestForList.delegate = self;
//    self.requestForCurrent = [[HTTPRequestService alloc] init];
//    self.requestForCurrent.delegate = self;
//    self.requestForRecommend = [[HTTPRequestService alloc] init];
//    self.requestForRecommend.delegate = self;
//    self.requestForTagStock = [[HTTPRequestService alloc] init];
//    self.requestForTagStock.delegate = self;
//    self.requestForFeedBack = [[HTTPRequestService alloc] init];
//    self.requestForFeedBack.delegate = self;
}

- (void)cancelAllRequest {
    [self.requestForBanner cancelWithoutDelegate];
//    [self.requestForList cancelWithoutDelegate];
//    [self.requestForCurrent cancelWithoutDelegate];
//    [self.requestForRecommend cancelWithoutDelegate];
//    [self.requestForTagStock cancelWithoutDelegate];
//    [self.requestForFeedBack cancelWithoutDelegate];
}

#pragma mark 请求选股banner-----------------------------------

- (void)requestChooseStockBannerWithLocation:(NSString *)location
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:location forKey:@"location"];
    [param setValue:@"CP140813001" forKey:@"appcode"];
    if ([UIScreen mainScreen].bounds.size.width <= 360) {
        [param setValue:@"720" forKey:@"spec"];
    }
    else if ([UIScreen mainScreen].bounds.size.width <= 540 && [UIScreen mainScreen].bounds.size.width > 360) {
        [param setValue:@"1080" forKey:@"spec"];
    }
    else if ([UIScreen mainScreen].bounds.size.width <= 622 && [UIScreen mainScreen].bounds.size.width > 540) {
        [param setValue:@"1242" forKey:@"spec"];
    }
    else {
        [param setValue:@"1242" forKey:@"spec"];
    }
    
    self.requestForBanner.reqParam = param;
    self.requestForBanner.urlString = [CMHttpURLManager urlStringWithServID:@"prefecturePicture"];
    self.requestForBanner.requestMethod = HTTRequestGET;
    self.requestForBanner.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [self.requestForBanner sendRequestWithSuccessBlock:^(id data) {
        [welf getChooseStockBannerHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"请求banner失败");
//        [welf getChooseStockBannerHandler:data];

    }];
}

- (void)getChooseStockBannerHandler:(id)resultData {
    NSDictionary * messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestChooseStockBannerResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSMutableArray * mutArray = [NSMutableArray array];
            for (NSDictionary * dic in resultData[@"bannerList"]) {
                PrefecturePictureVO * vo = [PrefecturePictureVO pictureWithDict:dic];
                [mutArray addObject:vo];
            }
            [self.delegate requestChooseStockBannerResultHandler:mutArray andSuccess:YES];
            
        } else {
            [self.delegate requestChooseStockBannerResultHandler:message andSuccess:NO];
        }
    }
}
/*
#pragma mark 请求选股列表-----------------------------------

- (void)requestChooseStockList
{
    self.requestForList.urlString = [CMHttpURLManager urlStringWithServID:@"chooseStockHomePage"];
    self.requestForList.requestMethod = HTTRequestGET;
    self.requestForList.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [self.requestForList sendRequestWithSuccessBlock:^(id data) {
        [welf getChooseStockListHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"请求选股列表失败");
        [welf getChooseStockListHandler:data];
        
    }];
}

- (void)getChooseStockListHandler:(id)resultData {
    NSDictionary * messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestChooseStockListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSMutableArray * mutArray = [NSMutableArray array];
            for (NSDictionary * dic in resultData[@"strategyInfos"]) {
                ChooseStockListVO * vo = [ChooseStockListVO listWithDict:dic];
                [mutArray addObject:vo];
            }
            [self.delegate requestChooseStockListResultHandler:mutArray andSuccess:YES];
            
        } else {
            [self.delegate requestChooseStockListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark 请求实时选股-----------------------------------

- (void)requestCurrentChooseStockWithSortFlag:(NSString *)sortFlag andPageSize:(NSString *)pageSize andCurrentPage:(NSString *)currentPage
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:sortFlag forKey:@"sortFlag"];
    [param setValue:pageSize forKey:@"ps"];
    [param setValue:currentPage forKey:@"cp"];
    
    self.requestForCurrent.reqParam = param;
    self.requestForCurrent.urlString = [CMHttpURLManager urlStringWithServID:@"currentChooseStock"];
    self.requestForCurrent.requestMethod = HTTRequestGET;
    self.requestForCurrent.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [self.requestForCurrent cancelWithoutDelegate];
    [self.requestForCurrent sendRequestWithSuccessBlock:^(id data) {
        [welf getCurrentChooseStockHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"请求实时选股失败");
        [welf getCurrentChooseStockHandler:data];
        
    }];
}

- (void)getCurrentChooseStockHandler:(id)resultData {
    NSDictionary * messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestCurrenChooseStockResultHandler:andPageCount:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSMutableArray * mutArray = [NSMutableArray array];
            for (NSDictionary * dic in resultData[@"indicesStockPools"]) {
                CurrentChooseStockVO * vo = [CurrentChooseStockVO currentWithDict:dic];
                [mutArray addObject:vo];
            }
            
            [self.delegate requestCurrenChooseStockResultHandler:mutArray andPageCount:resultData[@"totalPage"] andSuccess:YES];
            
        } else {
            [self.delegate requestCurrenChooseStockResultHandler:message andPageCount:nil andSuccess:NO];
        }
    }
}

#pragma mark 请求荐股-----------------------------------

- (void)requestRecommendStockWithPageSize:(NSString *)pageSize andCurrentPage:(NSString *)currentPage andType:(NSString *)type
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:pageSize forKey:@"ps"];
    [param setValue:currentPage forKey:@"cp"];
    [param setValue:type forKey:@"skipType"];
    
    self.requestForRecommend.reqParam = param;
    self.requestForRecommend.urlString = [CMHttpURLManager urlStringWithServID:@"top10"];
    self.requestForRecommend.requestMethod = HTTRequestGET;
    self.requestForRecommend.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [self.requestForRecommend cancelWithoutDelegate];
    [self.requestForRecommend sendRequestWithSuccessBlock:^(id data) {
        [welf getRecommendStockHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"请求荐股失败");
        [welf getRecommendStockHandler:data];
        
    }];
}

- (void)getRecommendStockHandler:(id)resultData {
    NSDictionary * messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestRecommendStockResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            
            NSMutableArray * mutArray = [NSMutableArray array];
            for (NSDictionary * dic in resultData[@"indicesStockPools"]) {
                RecommendStockVO * vo = [RecommendStockVO recommendWithDict:dic];
                [mutArray addObject:vo];
            }
            [self.delegate requestRecommendStockResultHandler:mutArray andSuccess:YES];
            
        } else {
            [self.delegate requestRecommendStockResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark 请求标签股-----------------------------------

- (void)requestTagStockWithTagType:(NSString *)tagType andPageSize:(NSString *)pageSize andCurrentPage:(NSString *)currentPage
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:tagType forKey:@"tagType"];
    [param setValue:pageSize forKey:@"ps"];
    [param setValue:currentPage forKey:@"cp"];
    
    self.requestForTagStock.reqParam = param;
    self.requestForTagStock.urlString = [CMHttpURLManager urlStringWithServID:@"tagStock"];
    self.requestForTagStock.requestMethod = HTTRequestGET;
    self.requestForTagStock.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [self.requestForTagStock cancelWithoutDelegate];
    [self.requestForTagStock sendRequestWithSuccessBlock:^(id data) {
        [welf getTagStockHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"请求标签股失败");
        [welf getTagStockHandler:data];
        
    }];
}

- (void)getTagStockHandler:(id)resultData {
    NSDictionary * messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTagStockResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            
            NSMutableArray * mutArray = [NSMutableArray array];
            for (NSDictionary * dic in resultData[@"stockCodes"]) {
                CurrentChooseStockVO * vo = [CurrentChooseStockVO currentWithDict:dic];
                [mutArray addObject:vo];
            }
            [self.delegate requestTagStockResultHandler:mutArray andSuccess:YES];
            
        } else {
            [self.delegate requestTagStockResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark 意见反馈-----------------------------------

- (void)requestFeedBackWithUserId:(NSString *)userId andContent:(NSString *)content
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:userId forKey:@"userId"];
    [param setValue:content forKey:@"content"];
    [param setValue:@"9" forKey:@"projectType"];
    [param setValue:@"2" forKey:@"activityType"];
    
    self.requestForFeedBack.reqParam = param;
    self.requestForFeedBack.urlString = [CMHttpURLManager urlStringWithServID:@"feedBack"];
    self.requestForFeedBack.requestMethod = HTTRequestGET;
    self.requestForFeedBack.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [self.requestForFeedBack cancelWithoutDelegate];
    [self.requestForFeedBack sendRequestWithSuccessBlock:^(id data) {
        [welf getFeedBackHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"请求意见反馈失败");
        [welf getFeedBackHandler:data];
        
    }];
}

- (void)getFeedBackHandler:(id)resultData {
    NSDictionary * messageVO = resultData;
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFeedBackkResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            
            [self.delegate requestFeedBackkResultHandler:message andSuccess:YES];
            
        } else {
            [self.delegate requestFeedBackkResultHandler:message andSuccess:NO];
        }
    }
}
*/
@end
