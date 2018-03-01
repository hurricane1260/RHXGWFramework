//
//  TradeSimulateDataManager.m
//  stockscontest
//
//  Created by rxhui on 16/1/19.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "TradeSimulateDataManager.h"
#import "CMHttpURLManager.h"
//#import "AccountDataManager.h"

#import "ListPageInfoVO.h"
#import "StockListVO.h"
#import "PositionVO.h"
#import "RankViewVO.h"
#import "EntrustListVO.h"
#import "DealHistoryListVO.h"

@interface TradeSimulateDataManager ()

@property (nonatomic,copy) NSString *accountId;

/*! @brief 资金详情*/
@property (nonatomic,strong) HTTPRequestService *requestForFund;

/*! @brief 持仓*/
@property (nonatomic,strong) HTTPRequestService *requestForHoldStock;

/*! @brief 我的组合*/
@property (nonatomic,strong) HTTPRequestService *requestForMyCoupleList;

/*! @brief 最大可买or可卖*/
@property (nonatomic,strong) HTTPRequestService *requestForTradeAmount;

/*! @brief 委托列表*/
@property (nonatomic,strong) HTTPRequestService *requestForEntrustList;

/*! @brief 撤单*/
@property (nonatomic,strong) HTTPRequestService *requestForWithdraw;

/*! @brief 历史交易*/
@property (nonatomic,strong) HTTPRequestService *requestForHistory;

/*! @brief 模拟买卖*/
@property (nonatomic,strong) HTTPRequestService *requestForTrade;

//分页需要
@property (nonatomic, strong) ListPageInfoVO *pageInfo;

@property (nonatomic, strong) NSMutableArray *orginDataList;

@end

@implementation TradeSimulateDataManager

static NSString *kHoldStockListPageSize = @"20";

- (void)cancelAllRequest {
    [self.requestForFund cancelWithoutDelegate];
    [self.requestForHoldStock cancelWithoutDelegate];
    [self.requestForMyCoupleList cancelWithoutDelegate];
    [self.requestForTradeAmount cancelWithoutDelegate];
    [self.requestForEntrustList cancelWithoutDelegate];
    [self.requestForWithdraw cancelWithoutDelegate];
    [self.requestForHistory cancelWithoutDelegate];
    [self.requestForTrade cancelWithoutDelegate];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestForFund = [[HTTPRequestService alloc]init];
        self.requestForFund.delegate = self;
        self.requestForHoldStock = [[HTTPRequestService alloc]init];
        self.requestForHoldStock.delegate = self;
        self.orginDataList = [NSMutableArray array];
        self.pageInfo = [[ListPageInfoVO alloc]init];
        self.requestForMyCoupleList = [[HTTPRequestService alloc]init];
        self.requestForMyCoupleList.delegate = self;
        self.requestForTradeAmount = [[HTTPRequestService alloc]init];
        self.requestForTradeAmount.delegate = self;
        self.requestForEntrustList = [[HTTPRequestService alloc]init];
        self.requestForEntrustList.delegate = self;
        self.requestForWithdraw = [[HTTPRequestService alloc]init];
        self.requestForWithdraw.delegate = self;
        self.requestForHistory = [[HTTPRequestService alloc]init];
        self.requestForHistory.delegate = self;
        self.requestForTrade = [[HTTPRequestService alloc]init];
        self.requestForTrade.delegate = self;
    }
    return self;
}

- (NSString *)accountId {
    if (!_accountId) {
        _accountId = [[NSUserDefaults standardUserDefaults]objectForKey:@"accountId"];
    }
    return _accountId;
}

- (void)requestWithRequest:(HTTPRequestService *)request param:(NSMutableDictionary *)param urlString:(NSString *)urlServID getOrPost:(HTTRequestMethod)requestMethod synOrAsyn:(HTTPRequestType)requestType requestCallBack:(RequestCompletionCallback)callBack {
    request.reqParam = param;
    request.urlString = [CMHttpURLManager urlStringWithServID:urlServID];
    request.requestMethod = requestMethod;
    request.requestType = requestType;
    [request cancelWithoutDelegate];
    [request sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        id messageVO = [data objectForKey:@"message"];
        NSNumber *code = [messageVO objectForKey:@"code"];
        NSString *message = [messageVO objectForKey:@"message"];
        if (code.integerValue == 0) {
            callBack(YES,data);
        }
        else {
            callBack(NO,message);
        }
    } failureBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        id messageVO = [data objectForKey:@"message"];
//        NSNumber *code = [messageVO objectForKey:@"code"];
        NSString *message = [messageVO objectForKey:@"message"];
        callBack(NO,message);
        NSLog(@"%@失败",urlServID);
    }];
}

/**
 *  @brief 查询账户资金详情
 */
- (void)requestDetailFundWithCallBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.accountId forKey:@"accountId"];
    [self requestWithRequest:self.requestForFund param:mutaParam urlString:@"getSimulateFund" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
            [returnDic setValue:[resultData objectForKey:@"funds"] forKey:@"enableBalance"];
            [returnDic setValue:[resultData objectForKey:@"stockValue"] forKey:@"marketValue"];
            [returnDic setValue:[resultData objectForKey:@"totalMarketCapital"] forKey:@"assetBalance"];
            [returnDic setValue:[resultData objectForKey:@"totalProfit"] forKey:@"totalProfit"];
            [returnDic setValue:[resultData objectForKey:@"profitAndLoss"] forKey:@"profitAndLoss"];
            callBack(YES,returnDic);
        }
        else {
            callBack(NO,resultData);
        }
    }];
}

/**
 *  @brief 查询账户持仓列表
 */
-(void)requestHoldPositionListWithCallBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.accountId forKey:@"accountId"];
    [mutaParam setValue:kHoldStockListPageSize forKey:@"pageSize"];
    [mutaParam setValue:@"1" forKey:@"currentPage"];
    [self.orginDataList removeAllObjects];
    __block TradeSimulateDataManager *welf = self;
    [self requestWithRequest:self.requestForHoldStock param:mutaParam urlString:@"getInvestStock" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSNumber *totalPage = [resultData valueForKey:@"totalPage"];
            NSNumber *currentPage = [resultData valueForKey:@"currentPage"];
            welf.pageInfo.totalPage = totalPage.integerValue;
            welf.pageInfo.currentPage = currentPage.integerValue;
            NSArray *dataList = [resultData objectForKey:@"positions"];
            [welf.orginDataList addObjectsFromArray:dataList];
            NSArray *retList = [StockListVO parseSimulateHoldStockFromData:self.orginDataList];
            
            callBack(YES,retList);
        }
        else {
            callBack(NO,resultData);
        }
    }];
}

/**
 *  @brief 查询账户持仓列表下一页
 */
-(void)requestHoldPositionListNextPageWithCallBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.accountId forKey:@"accountId"];
    [mutaParam setValue:kHoldStockListPageSize forKey:@"pageSize"];
    if (self.pageInfo.currentPage + 1 > self.pageInfo.totalPage) {
        callBack(NO,@"已无更多");
        return;
    }
    [mutaParam setValue:[NSNumber numberWithInteger:self.pageInfo.currentPage + 1] forKey:@"currentPage"];
    
    __block TradeSimulateDataManager *welf = self;
    [self requestWithRequest:self.requestForHoldStock param:mutaParam urlString:@"getSimulateHoldStock" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSNumber *totalPage = [resultData valueForKey:@"totalPage"];
            NSNumber *currentPage = [resultData valueForKey:@"currentPage"];
            welf.pageInfo.totalPage = totalPage.integerValue;
            welf.pageInfo.currentPage = currentPage.integerValue;
            NSArray *dataList = [resultData objectForKey:@"positions"];
            [welf.orginDataList addObjectsFromArray:dataList];
            NSArray *retList = [StockListVO parseSimulateHoldStockFromData:self.orginDataList];
            
            callBack(YES,retList);
        }
        else {
            callBack(NO,resultData);
        }
    }];
}

/**
 *  @brief 历史交易
 */
-(void)requestHistoryTradeListWithCallBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.accountId forKey:@"accountId"];
    [mutaParam setValue:kHoldStockListPageSize forKey:@"pageSize"];
    [mutaParam setValue:@"1" forKey:@"currentPage"];
    [self.orginDataList removeAllObjects];
    
    __block TradeSimulateDataManager *welf = self;
    [self requestWithRequest:self.requestForHistory param:mutaParam urlString:@"getSimuHistoryList" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSNumber *totalPage = [resultData valueForKey:@"totalPage"];
            NSNumber *currentPage = [resultData valueForKey:@"currentPage"];
            welf.pageInfo.totalPage = totalPage.integerValue;
            welf.pageInfo.currentPage = currentPage.integerValue;
            NSArray *dataList = [resultData objectForKey:@"tradings"];
            [welf.orginDataList addObjectsFromArray:dataList];
            NSArray *retList = [DealHistoryListVO parseSimulateDealHistoryWithData:welf.orginDataList];
            
            callBack(YES,retList);
        }
        else {
            callBack(NO,resultData);
        }
    }];
}

/**
 *  @brief 历史交易下一页
 */
-(void)requestHistoryTradeListNextPageWithCallBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.accountId forKey:@"accountId"];
    [mutaParam setValue:kHoldStockListPageSize forKey:@"pageSize"];
    if (self.pageInfo.currentPage + 1 > self.pageInfo.totalPage) {
        callBack(NO,@"已无更多");
        return;
    }
    [mutaParam setValue:[NSNumber numberWithInteger:self.pageInfo.currentPage + 1] forKey:@"currentPage"];
    
    __block TradeSimulateDataManager *welf = self;
    [self requestWithRequest:self.requestForHistory param:mutaParam urlString:@"getSimuHistoryList" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSNumber *totalPage = [resultData valueForKey:@"totalPage"];
            NSNumber *currentPage = [resultData valueForKey:@"currentPage"];
            welf.pageInfo.totalPage = totalPage.integerValue;
            welf.pageInfo.currentPage = currentPage.integerValue;
            NSArray *dataList = [resultData objectForKey:@"tradings"];
            [welf.orginDataList addObjectsFromArray:dataList];
            NSArray *retList = [DealHistoryListVO parseSimulateDealHistoryWithData:welf.orginDataList];
            
            callBack(YES,retList);
        }
        else {
            callBack(NO,resultData);
        }
    }];
}

/**
 *  @brief 执行模拟交易买卖
 */
-(void)sendTradeRequestWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack {
    [params setValue:self.accountId forKey:@"accountId"];
    NSTimeInterval timeInter = [[NSDate date]timeIntervalSince1970];
    long long timeLong = timeInter * 1000.0f;
    [params setValue:[NSNumber numberWithLongLong:timeLong] forKey:@"tradeDate"];//交易日期为什么客户端给？
    
    [self requestWithRequest:self.requestForTrade param:params urlString:@"sendSimuTrade" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        callBack(success,resultData);
    }];
}

/**
 *  @brief 查询最大可买/可卖,说明：类型为买入时funds有值，maxSaleVol为空，卖出时反过来
 */
-(void)requestMaxTradeAmountWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack {
    [params setValue:self.accountId forKey:@"accountId"];
    
    [self requestWithRequest:self.requestForTradeAmount param:params urlString:@"getMaxSimuTradeAmount" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
            [returnDic setValue:[resultData objectForKey:@"maxSaleVol"] forKey:@"enableAmount"];
            [returnDic setValue:[resultData objectForKey:@"funds"] forKey:@"funds"];
            callBack(YES,returnDic);
        }
        else {
            callBack(NO, resultData);
        }
    }];
}

/**
 *  @brief 查询委托列表
 */
-(void)requestEntrustListWithCallBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.accountId forKey:@"accountId"];
    
    [self requestWithRequest:self.requestForEntrustList param:mutaParam urlString:@"getSimuEntrustList" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        if (success) {
            NSArray *orginList = [resultData objectForKey:@"entrustList"];
            NSArray *returnList = [EntrustListVO parseSimulateEntrustListWithData:orginList];
            callBack(YES,returnList);
        }
        else {
            callBack(success,resultData);
        }
    }];
}

/**
 *  @brief 撤销委托挂单
 */
-(void)sendWithdrawWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack {
    [self requestWithRequest:self.requestForWithdraw param:params urlString:@"sendSimuWithdraw" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
        callBack(success,resultData);
    }];
}

/**
 *  @brief 查询我的组合列表
 */
//-(void)requestMyInvestCoupleListWithCallBack:(RequestCompletionCallback)callBack {
////    AccountVO *account = [AccountDataManager currentOnlineAccount];
//    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
//    [mutaParam setValue:account.userId forKey:@"userId"];
//    [mutaParam setValue:@"my" forKey:@"type"];
//    
//    [self requestWithRequest:self.requestForMyCoupleList param:mutaParam urlString:@"getMyInvestCPList" getOrPost:HTTRequestGET synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
//        if (success) {
//            NSArray *resultList = [resultData objectForKey:@"rankings"];
//            NSString *type = [resultData objectForKey:@"type"];
//            NSMutableDictionary *retDic = [NSMutableDictionary dictionary];
//            [retDic setValue:type forKey:@"type"];
//            
//            NSMutableArray *returnList = [NSMutableArray array];
//            for (NSInteger i = 0; i < resultList.count; i++) {
//                NSDictionary *itemVO = [resultList firstObject];
//                RankViewVO *rankVO = [RankViewVO parseSimulateCombinationVOWith:itemVO index:i];
////                rankVO.userID = account.userId;
//                [returnList addObject:rankVO];
//            }
//            [retDic setValue:returnList forKey:@"list"];
//            
//            callBack(YES,retDic);
//        }
//        else {
//            callBack(success,resultData);
//        }
//    }];
//}

/**
 *  @brief 提交编辑的资料
 */
//-(void)sendEditedInvestInfoWithParam:(NSMutableDictionary *)params callBack:(RequestCompletionCallback)callBack {
//    [params setValue:self.accountId forKey:@"accountId"];
//    
//    [self requestWithRequest:self.requestForFund param:params urlString:@"editInvestInfo" getOrPost:HTTRequestPOST synOrAsyn:HTTPRequestAsynchronous requestCallBack:^(BOOL success, id resultData) {
//        if (success) {
//            NSNumber *result = [resultData objectForKey:@"result"];
//            callBack(YES,result);
//        }
//        else {
//            callBack(success,resultData);
//        }
//    }];
//}

@end
