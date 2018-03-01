//
//  TradeDataManager.m
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeDataManager.h"
#import "HTTPRequestService.h"
#import "CMHttpURLManager.h"

#import "TradeStockPriceVO.h"
#import "StockVO.h"
#import "StockListVO.h"
#import "EntrustListVO.h"
#import "DealListVO.h"
#import "DealHistoryListVO.h"
#import "TransferFlowListVO.h"
#import "TransferHistoryListVO.h"

@interface TradeDataManager ()

/*! @brief 登录－login*/
@property (nonatomic,strong) HTTPRequestService *requestForLogin;

/*! @brief 登录－验证码*/
@property (nonatomic,strong) HTTPRequestService *requestForMagicCode;

/*! @brief 持仓－详细资金，转账银行*/
@property (nonatomic,strong) HTTPRequestService *requestForFund;

/*! @brief 持仓－列表，买卖－键盘精灵，自选股－股票列表*/
@property (nonatomic,strong) HTTPRequestService *requestForStockList;

/*! @brief 买卖－确认上下限价格，交易确认－执行买卖，银证转账－3根据流水取余额*/
@property (nonatomic,strong) HTTPRequestService *requestForEntrust;

/*! @brief 买卖－确认可购买数量*/
@property (nonatomic,strong) HTTPRequestService *requestForStockCount;

/*! @brief 买卖－行情，交易确认－股东账户*/
@property (nonatomic,strong) HTTPRequestService *requestForMarket;

/*! @brief 委托－列表*/
@property (nonatomic,strong) HTTPRequestService *requestForEntrustList;

/*! @brief 委托－撤单*/
@property (nonatomic,strong) HTTPRequestService *requestForWithdraw;

/*! @brief 成交－当日列表 银证转账5当日流水*/
@property (nonatomic,strong) HTTPRequestService *requestForDealList;

/*! @brief 成交－历史列表 银证转账6历史流水*/
@property (nonatomic,strong) HTTPRequestService *requestForDealHistoryList;

/*! @brief 成交－历史列表下一页*/
//@property (nonatomic,strong) HTTPRequestService *requestForDealHistoryListNextPage;

/*! @brief 成交－历史列表下一页备用*/
//@property (nonatomic,strong) HTTPRequestService *requestForDealHistoryListNextPageBack;

/*! @brief 买卖－stockCode->exchangeType*/
@property (nonatomic,strong) HTTPRequestService *requestForExchangeType;

/*! @brief 转账－银行，查询余额1银行账户，2获取余额流水号，4转账*/
@property (nonatomic,strong) HTTPRequestService *requestForTransfer;



/*! @brief 委托列表的定位串*/
@property (nonatomic,copy) NSString *positionStrForEntrustList;

/*! @brief 当日成交列表的定位串*/
@property (nonatomic ,copy) NSString *positionStrForDealList;

/*! @brief 历史成交列表的定位串*/
//@property (nonatomic ,copy) NSString *positionStrForDealHistoryList;

/*! @brief 持仓列表的定位串*/
@property (nonatomic, copy) NSString *positionStrForStockList;

/*! @brief 维护委托列表*/
@property (nonatomic,strong) NSMutableArray *entrustList;

/*! @brief 维护当日交易列表*/
//@property (nonatomic, strong) NSMutableArray *dealList;

/*! @brief 维护历史交易列表*/
@property (nonatomic, strong) NSMutableArray *dealHistoryList;

/*! @brief 维护持仓列表*/
@property (nonatomic, strong) NSMutableArray *holdStockList;

/*! @brief 维护历史转账列表*/
@property (nonatomic, strong) NSMutableArray *transferHistoryList;

/*! @brief 记录历史成交上一次请求的起点时间*/
@property (nonatomic, strong) NSDate *lastStartDate;

/*! @brief 历史成交的起点时间限制*/
@property (nonatomic, strong) NSDate *limitStartDate;

/*! @brief 维护转账流水列表*/
@property (nonatomic, strong) NSMutableArray *transferFlowList;
@end

@implementation TradeDataManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestForLogin = [[HTTPRequestService alloc]init];
        self.requestForLogin.delegate = self;
        
        self.requestForMagicCode = [[HTTPRequestService alloc]init];
        self.requestForMagicCode.delegate = self;
        
        self.requestForEntrust = [[HTTPRequestService alloc]init];
        self.requestForEntrust.delegate = self;
        
        self.requestForStockList = [[HTTPRequestService alloc]init];
        self.requestForStockList.delegate = self;
        
        self.requestForStockCount = [[HTTPRequestService alloc]init];
        self.requestForStockCount.delegate = self;
        
        self.requestForMarket = [[HTTPRequestService alloc]init];
        self.requestForMarket.delegate = self;
        
        self.requestForFund = [[HTTPRequestService alloc]init];
        self.requestForFund.delegate = self;
        
        self.requestForEntrustList = [[HTTPRequestService alloc]init];
        self.requestForEntrustList.delegate = self;
        
        self.requestForWithdraw = [[HTTPRequestService alloc]init];
        self.requestForWithdraw.delegate = self;
        
        self.requestForDealList = [[HTTPRequestService alloc]init];
        self.requestForDealList.delegate = self;
        
        self.requestForExchangeType = [[HTTPRequestService alloc]init];
        self.requestForExchangeType.delegate = self;
        
        self.requestForDealHistoryList = [[HTTPRequestService alloc]init];
        self.requestForDealHistoryList.delegate = self;
        
//        self.requestForDealHistoryListNextPage = [[HTTPRequestService alloc]init];
//        self.requestForDealHistoryListNextPage.delegate = self;
        
//        self.requestForDealHistoryListNextPageBack = [[HTTPRequestService alloc]init];
//        self.requestForDealHistoryListNextPageBack.delegate = self;
        
        self.requestForTransfer = [[HTTPRequestService alloc]init];
        self.requestForTransfer.delegate = self;
    }
    return self;
}

-(void)cancelAllRequest {
    [self.requestForLogin cancelWithoutDelegate];
    [self.requestForMagicCode cancelWithoutDelegate];
    [self.requestForEntrust cancelWithoutDelegate];
    [self.requestForStockList cancelWithoutDelegate];
    [self.requestForStockCount cancelWithoutDelegate];
    [self.requestForMarket cancelWithoutDelegate];
    [self.requestForFund cancelWithoutDelegate];
    [self.requestForEntrustList cancelWithoutDelegate];
    [self.requestForWithdraw cancelWithoutDelegate];
    [self.requestForDealList cancelWithoutDelegate];
    [self.requestForExchangeType cancelWithoutDelegate];
    [self.requestForDealHistoryList cancelWithoutDelegate];
//    [self.requestForDealHistoryListNextPage cancelWithoutDelegate];
//    [self.requestForDealHistoryListNextPageBack cancelWithoutDelegate];
    [self.requestForTransfer cancelWithoutDelegate];
}

#pragma mark -----------------------------------------------登录1:login----------------------------------------------------

-(void)sendLoginRequestWithParam:(id)param {
    NSMutableDictionary *mutaParam = param;
    [mutaParam setValue:@"0" forKey:@"opBranchNo"];
//    [mutaParam setValue:@"5" forKey:@"opEntrustWay"];
    [mutaParam setValue:@"0" forKey:@"opEntrustWay"];
    [mutaParam setValue:@"IP:127.0.0.1;MAC;HD;" forKey:@"opStation"];
    [mutaParam setValue:@"1" forKey:@"inputContent"];
    [mutaParam setValue:@"0" forKey:@"contentType"];
    
    self.requestForLogin.reqParam = mutaParam;
    self.requestForLogin.urlString = [CMHttpURLManager urlStringWithServID:@"sessionLogin"];
    self.requestForLogin.requestMethod = HTTRequestGET;
    self.requestForLogin.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForLogin cancelWithoutDelegate];
    [self.requestForLogin sendRequestWithSuccessBlock:^(id data) {
        [welf sendLoginSuccessHandler:data];
    } failureBlock:^(id data) {
        [welf sendLoginSuccessHandler:data];
        NSLog(@"session登录失败");
    }];
}

-(void)sendLoginSuccessHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSDictionary *account = [results firstObject];
            [self.delegate loginResultHandler:account andSuccess:YES];
        }
        else {
            [self.delegate loginResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------登录2:验证码----------------------------------------------------

-(void)requestMagicCode {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    
    self.requestForMagicCode.reqParam = mutaParam;
    self.requestForMagicCode.urlString = [CMHttpURLManager urlStringWithServID:@"getMagicCode"];
    self.requestForMagicCode.requestMethod = HTTRequestGET;
    self.requestForMagicCode.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForMagicCode cancelWithoutDelegate];
    [self.requestForMagicCode sendRequestWithSuccessBlock:^(id data) {
        [welf getMagicCodeSuccessHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"获取验证码失败－1");
        [welf getMagicCodeSuccessHandler:data];
    }];
}

-(void)getMagicCodeSuccessHandler:(id)resultData {
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(getMagicCodeResultHandler:andSuccess:)]) {
        return;
    }
    if ([resultData isKindOfClass:[NSDictionary class]]) {//获取验证码失败？
        id messageVO = [resultData objectForKey:@"message"];
        NSString *message = [messageVO objectForKey:@"message"];
        [self.delegate getMagicCodeResultHandler:message andSuccess:NO];
    }
    else {
        UIImage *image = [UIImage imageWithData:resultData];
        [self.delegate getMagicCodeResultHandler:image andSuccess:YES];
    }
}

#pragma mark -----------------------------------------------买卖1:查询股票列表----------------------------------------------------

//-(void)requestStockListWithPatam:(id)param {
//    NSMutableDictionary *mutaParam = param;
//    [mutaParam setValue:@"stock" forKey:@"queryType"];
//    [mutaParam setValue:@"stock" forKey:@"searchFrom"];
//    [mutaParam setValue:@"20" forKey:@"count"];
//    
//    self.requestForStockList.reqParam = mutaParam;
//    self.requestForStockList.urlString = [CMHttpURLManager urlStringWithServID:@"getStockList"];
//    self.requestForStockList.requestMethod = HTTRequestGET;
//    self.requestForStockList.requestType = HTTPRequestAsynchronous;
//    __block __typeof(self) welf = self;
//    
//    [self.requestForStockList cancelWithoutDelegate];
//    [self.requestForStockList sendRequestWithSuccessBlock:^(id data) {
//        [welf requestStockListResultHandler:data];
//    } failureBlock:^(id data) {
//        NSLog(@"查询股票列表失败");
//        [welf requestStockListResultHandler:data];
//    }];
//}

//-(void)requestStockListResultHandler:(id)resultData {
//    if (![resultData isKindOfClass:[NSDictionary class]]) {
//        return;
//    }
//    id messageVO = [resultData objectForKey:@"message"];
//    NSNumber *code = [messageVO objectForKey:@"code"];
//    NSString *message = [messageVO objectForKey:@"message"];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockListResultHandler:andSuccess:)]) {
//        if (code.integerValue == 1) {
//            id listData = [resultData objectForKey:@"list"];
//            NSArray *listArray = [NSObject parseJsonToModelList:listData listItemClass:[StockVO class]];
//            [self.delegate getStockListResultHandler:listArray andSuccess:YES];
//        }
//        else {
//            [self.delegate getStockListResultHandler:message andSuccess:YES];
//        }
//    }
//}

//-(void)cancelStockListRequest {
//    [self.requestForStockList cancelWithoutDelegate];
//}

#pragma mark -----------------------------------------------买卖2:委托请求----------------------------------------------------

-(void)sendTradeRequestWithPatam:(id)param {
    self.requestForEntrust.reqParam = param;
    self.requestForEntrust.urlString = [CMHttpURLManager urlStringWithServID:@"sessionEntrust"];
    self.requestForEntrust.requestMethod = HTTRequestGET;
    self.requestForEntrust.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForEntrust cancelWithoutDelegate];
    [self.requestForEntrust sendRequestWithSuccessBlock:^(id data) {
        [welf sendTradeResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"委托买卖失败");
        [welf sendTradeResultHandler:data];
    }];
}

-(void)sendTradeResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSLog(@"---%@",resultData);
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tradeResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            id results = [resultData objectForKey:@"results"];
            [self.delegate tradeResultHandler:results andSuccess:YES];
        }
        else {
            [self.delegate tradeResultHandler:message andSuccess:NO];
        }
    }
}

/*
#pragma mark -----------------------------------------------买卖3:股票价格确认----------------------------------------------------

-(void)requestStockPriceWithPatam:(id)param {
    self.requestForEntrust.reqParam = param;
    self.requestForEntrust.urlString = [CMHttpURLManager urlStringWithServID:@"sessionCodeEnsure"];
    self.requestForEntrust.requestMethod = HTTRequestGET;
    self.requestForEntrust.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForEntrust sendRequestWithSuccessBlock:^(id data) {
        [welf requestStockPriceResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"股票价格确认失败");
    }];
}

-(void)requestStockPriceResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockPriceResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            //需返回：upPrice，downPrice，lastPrice，highAmount，lowAmount
            NSArray *results = [resultData objectForKey:@"results"];
            TradeStockPriceVO *resultVO = [NSObject parseJsonToModel:[results firstObject] targetClass:[TradeStockPriceVO class]];
            [self.delegate getStockPriceResultHandler:resultVO andSuccess:YES];
        }
        else {
            [self.delegate getStockPriceResultHandler:message andSuccess:NO];
        }
    }
}
 */

#pragma mark -----------------------------------------------买卖4:可购买数量确认----------------------------------------------------

-(void)requestStockCountWithPatam:(id)param {
//    NSMutableDictionary *mutaParam = param;
//    NSString *stockCode = [param objectForKey:@"stockCode"];
//    NSString *exchangeType = [self getExchangeTypeWithStockCode:stockCode];
//    [mutaParam setValue:exchangeType forKey:@"exchangeType"];
//    [mutaParam setValue:@"0" forKey:@"entrustProp"];
    
    self.requestForStockCount.reqParam = param;
    self.requestForStockCount.urlString = [CMHttpURLManager urlStringWithServID:@"sessionBuyCount"];
    self.requestForStockCount.requestMethod = HTTRequestGET;
    self.requestForStockCount.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForStockCount cancelWithoutDelegate];
    [self.requestForStockCount sendRequestWithSuccessBlock:^(id data) {
        [welf requestStockCountResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"可购买数量确认失败");
        [welf requestStockCountResultHandler:data];
    }];
}

-(void)requestStockCountResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockCountResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            id results = [resultData objectForKey:@"results"];
            if (![results isKindOfClass:[NSDictionary class]]) {
                return;
            }
//            NSLog(@"---%@",results);
            //{"enableAmount":4589700,"storeUnit":0,"enableBuyAmount":0,"highAmount":0}
            NSNumber *maxCount = [results objectForKey:@"enableAmount"];
            [self.delegate getStockCountResultHandler:maxCount andSuccess:YES];
        }
        else {
            [self.delegate getStockCountResultHandler:message andSuccess:NO];
        }
    }
}

/*
#pragma mark -----------------------------------------------买卖5:行情查询----------------------------------------------------

-(void)requestMarketPriceWithPatam:(id)param {
    NSMutableDictionary *mutaParam = param;
    NSString *stockCode = [param objectForKey:@"stockCode"];
    NSString *exchangeType = [self getExchangeTypeWithStockCode:stockCode];
    [mutaParam setValue:exchangeType forKey:@"exchangeType"];
    
    self.requestForStockCount.reqParam = mutaParam;
    self.requestForStockCount.urlString = [CMHttpURLManager urlStringWithServID:@"sessionPriceRequest"];
    self.requestForStockCount.requestMethod = HTTRequestGET;
    self.requestForStockCount.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForStockCount sendRequestWithSuccessBlock:^(id data) {
        [welf requestMarketPriceResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"行情查询失败");
    }];
}

-(void)requestMarketPriceResultHandler:(id)resultData {
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockMarketPriceResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
//需返回：五档行情,涨幅
            id results = [resultData objectForKey:@"results"];
            TradeStockPriceVO *resultVO = [NSObject parseJsonToModel:results targetClass:[TradeStockPriceVO class]];
//            TradeStockPriceVO *resultVO = [TradeStockPriceVO parseStockPriceVOWithData:results];
            [self.delegate getStockMarketPriceResultHandler:resultVO andSuccess:YES];
        }
        else {
            [self.delegate getStockMarketPriceResultHandler:message andSuccess:NO];
        }
    }
}
*/

#pragma mark -----------------------------------------------买卖6:exchangeType----------------------------------------------------

-(void)requestStockExchangeTypeWithPatam:(id)param {
    self.requestForExchangeType.reqParam = param;
    self.requestForExchangeType.urlString = [CMHttpURLManager urlStringWithServID:@"getStockExchangeType"];
    self.requestForExchangeType.requestMethod = HTTRequestGET;
    self.requestForExchangeType.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForExchangeType cancelWithoutDelegate];
    [self.requestForExchangeType sendRequestWithSuccessBlock:^(id data) {
        [welf requestStockExchangeTypeResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"查询exchangeType失败");
        [welf requestStockExchangeTypeResultHandler:data];
    }];
}

-(void)requestStockExchangeTypeResultHandler:(id)resultData {
//    NSLog(@"-requestStockExchangeTypeResultHandler--%@",resultData);
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getStockExchangeTypeResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            if (![results isKindOfClass:[NSArray class]]) {
                return;
            }
//            NSLog(@"---%@",results);[{"internalCode":"601318","exchangeType":"1",
            NSDictionary *item = [results firstObject];
            [self.delegate getStockExchangeTypeResultHandler:item andSuccess:YES];
        }
        else {
            [self.delegate getStockExchangeTypeResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------持仓1:详细资金查询----------------------------------------------------

-(void)requestDetailFund {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
//    [mutaParam setValue:@" " forKey:@"moneyType"];//只传sessionID
    
    self.requestForFund.reqParam = mutaParam;
    self.requestForFund.urlString = [CMHttpURLManager urlStringWithServID:@"sessionFundRequest"];
    self.requestForFund.requestMethod = HTTRequestGET;
    self.requestForFund.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForFund cancelWithoutDelegate];
    [self.requestForFund sendRequestWithSuccessBlock:^(id data) {
        [welf requestDetailFundResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"详细资金查询失败");
        [welf requestDetailFundResultHandler:data];
    }];
}

-(void)requestDetailFundResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getDetailFundResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
//需返回：enableBalance可用资金，marketValue股票市值，assetBalance总资产
            NSArray *results = [resultData objectForKey:@"results"];
//            NSLog(@"---%@",results);
            NSDictionary *resultDic = [results firstObject];
            NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
            [returnDic setValue:[resultDic objectForKey:@"enableBalance"] forKey:@"enableBalance"];
            [returnDic setValue:[resultDic objectForKey:@"marketValue"] forKey:@"marketValue"];
            [returnDic setValue:[resultDic objectForKey:@"assetBalance"] forKey:@"assetBalance"];
            [returnDic setValue:[resultDic objectForKey:@"fetchBalance"] forKey:@"fetchBalance"];
            [self.delegate getDetailFundResultHandler:returnDic andSuccess:YES];
        }
        else {
            [self.delegate getDetailFundResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------持仓2：列表查询----------------------------------------------------

-(void)requestHoldPositionList {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
//    [mutaParam setValue:@" " forKey:@"moneyType"];//只传sessionID
//    [mutaParam setValue:@"0" forKey:@"entrustProp"];
    [mutaParam setValue:@" " forKey:@"positionStr"];
//    [mutaParam setValue:@"20" forKey:@"requestNum"];

    self.requestForStockList.reqParam = mutaParam;
    self.requestForStockList.urlString = [CMHttpURLManager urlStringWithServID:@"sessionStockRequest"];
    self.requestForStockList.requestMethod = HTTRequestGET;
    self.requestForStockList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
//    [self.requestForStockList cancelWithoutDelegate];
    [self.requestForStockList sendRequestWithSuccessBlock:^(id data) {
        [welf requestHoldPositionListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"持仓列表查询失败");
        [welf requestHoldPositionListResultHandler:data];
    }];
}

-(void)requestHoldPositionListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getHoldPositionListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            self.holdStockList = [NSMutableArray arrayWithArray:results];
//            NSLog(@"---%@",results);
            NSMutableArray *returnArray = [NSMutableArray array];
            for (id item in results) {
                StockListVO *itemVO = [StockListVO parseVOFromData:item];
                self.positionStrForStockList = itemVO.positionStr;
                [returnArray addObject:itemVO];
            }
//            NSLog(@"--%@--",returnArray);
            [self.delegate getHoldPositionListResultHandler:returnArray andSuccess:YES];
        }
        else {
            [self.delegate getHoldPositionListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------持仓3:下一页查询----------------------------------------------------

-(void)requestHoldListNextPage {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@" " forKey:@"moneyType"];
    [mutaParam setValue:@"0" forKey:@"entrustProp"];
    [mutaParam setValue:self.positionStrForStockList forKey:@"positionStr"];
    [mutaParam setValue:@"20" forKey:@"requestNum"];
    
    self.requestForStockList.reqParam = mutaParam;
    self.requestForStockList.urlString = [CMHttpURLManager urlStringWithServID:@"sessionStockRequest"];
    self.requestForStockList.requestMethod = HTTRequestGET;
    self.requestForStockList.requestType = HTTPRequestAsynchronous;
    
    __block __typeof(self) welf = self;
    [self.requestForStockList cancelWithoutDelegate];
    [self.requestForStockList sendRequestWithSuccessBlock:^(id data) {
        [welf requestHoldListNextPageHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"--持仓下一页查询失败");
        [welf requestHoldListNextPageHandler:data];
    }];
}

-(void)requestHoldListNextPageHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getHoldPositionListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            
            [self.holdStockList addObjectsFromArray:results];
//            NSLog(@"---%@",results);
            NSMutableArray *returnArray = [NSMutableArray array];
            for (id item in self.holdStockList) {
                StockListVO *itemVO = [StockListVO parseVOFromData:item];
                self.positionStrForStockList = itemVO.positionStr;
                [returnArray addObject:itemVO];
            }
            [self.delegate getHoldPositionListResultHandler:returnArray andSuccess:YES];
        }
        else {
            [self.delegate getHoldPositionListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------委托1:列表查询----------------------------------------------------

-(void)requestEntrustWithdrawList {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@" " forKey:@"positionStr"];
    [mutaParam setValue:@"10000" forKey:@"requestNum"];
    [mutaParam setValue:@"1" forKey:@"sortDirection"];
    
    self.requestForEntrustList.reqParam = mutaParam;
    self.requestForEntrustList.urlString = [CMHttpURLManager urlStringWithServID:@"sessionEntrustRequest"];
    self.requestForEntrustList.requestMethod = HTTRequestGET;
    self.requestForEntrustList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForEntrustList cancelWithoutDelegate];
    [self.requestForEntrustList sendRequestWithSuccessBlock:^(id data) {
        [welf requestEntrustWithdrawListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"委托列表查询失败");
        [welf requestEntrustWithdrawListResultHandler:data];
    }];
}

-(void)requestEntrustWithdrawListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getEntrustWithdrawListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            //需返回：委托列表
            NSArray *results = [resultData objectForKey:@"results"];
            self.entrustList = [NSMutableArray arrayWithArray:results];
//            NSLog(@"---%@",results);
            NSMutableArray *returnArray = [NSMutableArray array];
            for (id item in results) {
                EntrustListVO *itemVO = [NSObject parseJsonToModel:item targetClass:[EntrustListVO class]];
                self.positionStrForEntrustList = itemVO.positionStr;
                if (![itemVO.entrustProp isEqualToString:@"0"] && ![itemVO.entrustProp isEqualToString:@"3"] && ![itemVO.entrustProp isEqualToString:@"4"]) {
                    itemVO.entrustPrice = [NSNumber numberWithInteger:0];//如果不是限价委托也不是申购，价格为0,显示“市价”
                }
                [EntrustListVO changeStatusStringWithItem:itemVO];
                [returnArray addObject:itemVO];
            }
            //按时间顺序排序
            [returnArray sortUsingSelector:@selector(compare:)];
            [self.delegate getEntrustWithdrawListResultHandler:returnArray andSuccess:YES];
        }
        else {
            [self.delegate getEntrustWithdrawListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------委托2:列表下一页----------------------------------------------------

-(void)requestNextPageEntrustWithdrawList {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:self.positionStrForEntrustList forKey:@"positionStr"];
    [mutaParam setValue:@"20" forKey:@"requestNum"];
    [mutaParam setValue:@"1" forKey:@"sortDirection"];//'0'-正常 '1'-倒序
    
    self.requestForEntrustList.reqParam = mutaParam;
    self.requestForEntrustList.urlString = [CMHttpURLManager urlStringWithServID:@"sessionEntrustRequest"];
    self.requestForEntrustList.requestMethod = HTTRequestGET;
    self.requestForEntrustList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForEntrustList cancelWithoutDelegate];
    [self.requestForEntrustList sendRequestWithSuccessBlock:^(id data) {
        [welf requestNextPageEntrustWithdrawListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"委托列表下一页失败");
        [welf requestNextPageEntrustWithdrawListResultHandler:data];
    }];
}

-(void)requestNextPageEntrustWithdrawListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getEntrustWithdrawListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            //需返回：委托列表
            NSArray *results = [resultData objectForKey:@"results"];
            
            [self.entrustList addObjectsFromArray:results];
            
//            NSLog(@"---%@",results);
            NSMutableArray *returnArray = [NSMutableArray array];
            for (id item in self.entrustList) {
                EntrustListVO *itemVO = [NSObject parseJsonToModel:item targetClass:[EntrustListVO class]];
                self.positionStrForEntrustList = itemVO.positionStr;
                if (![itemVO.entrustProp isEqualToString:@"0"] && ![itemVO.entrustProp isEqualToString:@"3"] && ![itemVO.entrustProp isEqualToString:@"4"]) {
                    itemVO.entrustPrice = [NSNumber numberWithInteger:0];//如果不是限价委托也不是申购，价格为0,显示“市价”
                }
                [EntrustListVO changeStatusStringWithItem:itemVO];
                [returnArray addObject:itemVO];
            }
            //按时间顺序排序
            [returnArray sortUsingSelector:@selector(compare:)];
            [self.delegate getEntrustWithdrawListResultHandler:returnArray andSuccess:YES];
        }
        else {
            [self.delegate getEntrustWithdrawListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------委托3：撤单请求----------------------------------------------------

-(void)sendWithdrawRequestWith:(id)param {
    NSMutableDictionary *mutaParam = param;
    [mutaParam setValue:@"0" forKey:@"batchFlag"];
    
    self.requestForWithdraw.reqParam = mutaParam;
    self.requestForWithdraw.urlString = [CMHttpURLManager urlStringWithServID:@"sessionEntrustWithdraw"];
    self.requestForWithdraw.requestMethod = HTTRequestGET;
    self.requestForWithdraw.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForWithdraw cancelWithoutDelegate];
    [self.requestForWithdraw sendRequestWithSuccessBlock:^(id data) {
        [welf requestWithdrawResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"撤单请求失败");
        [welf requestWithdrawResultHandler:data];
    }];
}

-(void)requestWithdrawResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendWithdrawRequestResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            //需返回：enableBalance可用资金，marketValue股票市值，assetBalance总资产
            id results = [resultData objectForKey:@"results"];
//            NSLog(@"---%@",results);
            
            [self.delegate sendWithdrawRequestResultHandler:results andSuccess:YES];
        }
        else {
            [self.delegate sendWithdrawRequestResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------成交1:列表查询----------------------------------------------------

-(void)requestDealList {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@"0" forKey:@"queryType"];
    [mutaParam setValue:@"200" forKey:@"requestNum"];
    [mutaParam setValue:@" " forKey:@"exchangeType"];
//    [mutaParam setValue:@"0" forKey:@"queryDirection"];//（'1'-正序　'0'-逆序）是否生效由系统配置决定
    
    self.requestForDealList.reqParam = mutaParam;
    self.requestForDealList.urlString = [CMHttpURLManager urlStringWithServID:@"sessionDealRequest"];
    self.requestForDealList.requestMethod = HTTRequestGET;
    self.requestForDealList.requestType = HTTPRequestAsynchronous;
    
    __block __typeof(self) welf = self;
    [self.requestForDealList cancelWithoutDelegate];
    [self.requestForDealList sendRequestWithSuccessBlock:^(id data) {
        [welf requestDealListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"成交列表失败");
        [welf requestDealListResultHandler:data];
    }];
}

-(void)requestDealListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDealListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            //需返回：委托列表
            NSArray *results = [resultData objectForKey:@"results"];
            NSMutableArray *returnArray = [NSMutableArray array];
            NSArray *originalArray = [NSObject parseJsonToModelList:results listItemClass:[DealListVO class]];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
//            self.dealList = [NSMutableArray arrayWithArray:returnArray];
            [self.delegate requestDealListResultHandler:returnArray andSuccess:YES];
        }
        else {
            [self.delegate requestDealListResultHandler:message andSuccess:NO];
        }
    }
}

/*
#pragma mark -----------------------------------------------成交2:下一页查询----------------------------------------------------

-(void)requestDealListForNextPage {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@"0" forKey:@"queryType"];
    [mutaParam setValue:@"20" forKey:@"requestNum"];
    [mutaParam setValue:@" " forKey:@"exchangeType"];
    [mutaParam setValue:@"0" forKey:@"queryDirection"];
    [mutaParam setValue:self.positionStrForDealList forKey:@"positionStr"];

    self.requestForDealList.reqParam = mutaParam;
    self.requestForDealList.urlString = [CMHttpURLManager urlStringWithServID:@"sessionDealRequest"];
    self.requestForDealList.requestMethod = HTTRequestGET;
    self.requestForDealList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForDealList sendRequestWithSuccessBlock:^(id data) {
        [welf requestDealListResultNextPageHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"成交列表下一页失败");
    }];
}

-(void)requestDealListResultNextPageHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDealListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            //需返回：委托列表
            NSArray *results = [resultData objectForKey:@"results"];
            
            [self.dealList addObjectsFromArray:results];
            
            //            NSLog(@"---%@",results);
            NSMutableArray *returnArray = [NSMutableArray array];
            for (id item in self.dealList) {
                DealListVO *itemVO = [NSObject parseJsonToModel:item targetClass:[DealListVO class]];
                self.positionStrForDealList = itemVO.positionStr;
                [returnArray addObject:itemVO];
            }
            [self.delegate requestDealListResultHandler:returnArray andSuccess:YES];
        }
        else {
            [self.delegate requestDealListResultHandler:message andSuccess:NO];
        }
    }
}
*/

#pragma mark -----------------------------------------------成交3:历史列表查询----------------------------------------------------

-(void)requestDealHistoryListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@" " forKey:@"positionStr"];
    [mutaParam setValue:@"10000" forKey:@"requestNum"];
    
//    self.lastStartDate = [NSDate date];
//    self.limitStartDate = [NSDate dateWithTimeInterval:0 - 3600 * 24 * 60 sinceDate:self.lastStartDate];
    [mutaParam setValue:[self transFormDateToStringWithDate:startDate] forKey:@"startDate"];
    [mutaParam setValue:[self transFormDateToStringWithDate:endDate] forKey:@"endDate"];
    
    self.requestForDealHistoryList.reqParam = mutaParam;
    self.requestForDealHistoryList.urlString = [CMHttpURLManager urlStringWithServID:@"getDealHistoryList"];
    self.requestForDealHistoryList.requestMethod = HTTRequestGET;
    self.requestForDealHistoryList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForDealHistoryList cancelWithoutDelegate];
    [self.requestForDealHistoryList sendRequestWithSuccessBlock:^(id data) {
        [welf requestDealHistoryListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"成交历史列表失败");
        [welf requestDealHistoryListResultHandler:data];
    }];
}

-(void)requestDealHistoryListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDealHistoryListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            
//            if (results.count == 0) {
//                [self requestDealHistoryListForNextPage];
//            }
            
            NSMutableArray *returnArray = [NSMutableArray array];
            NSArray *originalArray = [DealHistoryListVO parseDealHistoryVOWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            
            self.dealHistoryList = [NSMutableArray arrayWithArray:returnArray];
            [self.delegate requestDealHistoryListResultHandler:self.dealHistoryList andSuccess:YES];
        }
        else {
            [self.delegate requestDealHistoryListResultHandler:message andSuccess:NO];
        }
    }
}

/*
#pragma mark -----------------------------------------------成交4:历史列表下一页查询----------------------------------------------------

-(void)requestDealHistoryListForNextPage {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@"10000" forKey:@"requestNum"];
//    if ([self.limitStartDateString isEqualToString:[self getOtherYearMonthDayStringWithTimeInterval:0 - 3600 * 24 * 7]]) {
//        return;
//    }
    [mutaParam setValue:[self transFormDateToStringWithDate:self.lastStartDate] forKey:@"endDate"];
    [mutaParam setValue:[self getOtherYearMonthDayStringWithTimeInterval:0 - 3600 * 24 * 10] forKey:@"startDate"];
    [mutaParam setValue:@" " forKey:@"positionStr"];
    
    self.requestForDealHistoryListNextPage.reqParam = mutaParam;
    self.requestForDealHistoryListNextPage.urlString = [CMHttpURLManager urlStringWithServID:@"getDealHistoryList"];
    self.requestForDealHistoryListNextPage.requestMethod = HTTRequestGET;
    self.requestForDealHistoryListNextPage.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForDealHistoryListNextPage cancelWithoutDelegate];
    [self.requestForDealHistoryListNextPage sendRequestWithSuccessBlock:^(id data) {
        [welf requestDealHistoryListResultNextPageHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"历史成交列表下一页失败");
        [welf requestDealHistoryListResultNextPageHandler:data];
    }];
}

-(void)requestDealHistoryListResultNextPageHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDealHistoryListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            
            if (results.count == 0) {
                [self requestForDealHistoryListNextPageBack];
            }
            
            NSMutableArray *returnArray = [self.dealHistoryList mutableCopy];
            NSArray *originalArray = [DealHistoryListVO parseDealHistoryVOWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            self.dealHistoryList = returnArray.copy;
            [self.delegate requestDealHistoryListResultHandler:self.dealHistoryList andSuccess:YES];
        }
        else {
            [self.delegate requestDealHistoryListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------成交4:历史列表下一页查询----------------------------------------------------

-(void)requestDealHistoryListForNextPageBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@"10000" forKey:@"requestNum"];
    //    if ([self.limitStartDateString isEqualToString:[self getOtherYearMonthDayStringWithTimeInterval:0 - 3600 * 24 * 7]]) {
    //        return;
    //    }
    [mutaParam setValue:[self transFormDateToStringWithDate:self.lastStartDate] forKey:@"endDate"];
    [mutaParam setValue:[self getOtherYearMonthDayStringWithTimeInterval:0 - 3600 * 24 * 10] forKey:@"startDate"];
    [mutaParam setValue:@"" forKey:@"positionStr"];
    
    self.requestForDealHistoryListNextPageBack.reqParam = mutaParam;
    self.requestForDealHistoryListNextPageBack.urlString = [CMHttpURLManager urlStringWithServID:@"getDealHistoryList"];
    self.requestForDealHistoryListNextPageBack.requestMethod = HTTRequestGET;
    self.requestForDealHistoryListNextPageBack.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForDealHistoryListNextPageBack cancelWithoutDelegate];
    [self.requestForDealHistoryListNextPageBack sendRequestWithSuccessBlock:^(id data) {
        [welf requestDealHistoryListResultNextPageHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"历史成交列表下一页失败");
        [welf requestDealHistoryListResultNextPageHandler:data];
    }];
}

-(void)requestDealHistoryListResultNextPageBackHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDealHistoryListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            
            if (results.count == 0) {
                [self requestForDealHistoryListNextPage];
            }
            
            NSMutableArray *returnArray = [self.dealHistoryList mutableCopy];
            NSArray *originalArray = [DealHistoryListVO parseDealHistoryVOWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            self.dealHistoryList = returnArray.copy;
            [self.delegate requestDealHistoryListResultHandler:self.dealHistoryList andSuccess:YES];
        }
        else {
            [self.delegate requestDealHistoryListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -------------------------------------------成交5:查询某时间段的历史成交列表------------------------------------------------

-(void)requestDealHistoryListStart:(NSString *)startDate end:(NSString *)endDate callBack:(RequestCompletionCallback)callBack {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@"10000" forKey:@"requestNum"];
    [mutaParam setValue:@" " forKey:@"positionStr"];
    [mutaParam setValue:endDate forKey:@"endDate"];
    [mutaParam setValue:startDate forKey:@"startDate"];
    
    self.requestForDealHistoryList.reqParam = mutaParam;
    self.requestForDealHistoryList.urlString = [CMHttpURLManager urlStringWithServID:@"getDealHistoryList"];
    self.requestForDealHistoryList.requestMethod = HTTRequestGET;
    self.requestForDealHistoryList.requestType = HTTPRequestAsynchronous;
    
    [self.requestForDealHistoryList cancelWithoutDelegate];
    [self.requestForDealHistoryList sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            callBack(NO,@"请求错误");
        }
        id messageVO = [data objectForKey:@"message"];
        NSNumber *code = [messageVO objectForKey:@"code"];
        NSString *message = [messageVO objectForKey:@"message"];
        if (code.integerValue == 0) {
            NSArray *results = [data objectForKey:@"results"];
            
            NSMutableArray *returnArray = [NSMutableArray array];
            NSArray *originalArray = [DealHistoryListVO parseDealHistoryVOWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            callBack(YES,returnArray);
        }
        else {
            callBack(NO,message);
        }
    } failureBlock:^(id data) {
        NSLog(@"成交历史列表失败");
        id messageVO = [data objectForKey:@"message"];
        NSString *message = [messageVO objectForKey:@"message"];
        callBack(NO,message);
    }];
}
*/

#pragma mark -----------------------------------------------交易确认1:股东代码----------------------------------------------------

-(void)requestShareHolderAccountNumber {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    
    self.requestForMarket.reqParam = mutaParam;
    self.requestForMarket.urlString = [CMHttpURLManager urlStringWithServID:@"getShareHolderAccount"];
    self.requestForMarket.requestMethod = HTTRequestGET;
    self.requestForMarket.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    
    [self.requestForMarket cancelWithoutDelegate];
    [self.requestForMarket sendRequestWithSuccessBlock:^(id data) {
        [welf requestShareHolderAccountNumberHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"查询股东失败");
        [welf requestShareHolderAccountNumberHandler:data];
    }];
}

-(void)requestShareHolderAccountNumberHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestShareHolderAccountNumberResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSDictionary *item = [results firstObject];
            NSString *stockAccount = [item objectForKey:@"stockAccount"];
            NSLog(@"股东账号%@",stockAccount);
            [self.delegate requestShareHolderAccountNumberResultHandler:stockAccount andSuccess:YES];
        }
        else {
            [self.delegate requestShareHolderAccountNumberResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账1:银行账户----------------------------------------------------

-(void)requestBankAccount {
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionary];
    [mutaParam setValue:@" " forKey:@"moneyType"];
    [mutaParam setValue:@" " forKey:@"bankNo"];
    
    self.requestForTransfer.reqParam = mutaParam;
    self.requestForTransfer.urlString = [CMHttpURLManager urlStringWithServID:@"getBankAccount"];
    self.requestForTransfer.requestMethod = HTTRequestGET;
    self.requestForTransfer.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForTransfer cancelWithoutDelegate];
    [self.requestForTransfer sendRequestWithSuccessBlock:^(id data) {
        [welf requestBankAccountResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"银行账户查询失败");
    }];
}

-(void)requestBankAccountResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBankAccountResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSDictionary *resultDic = [results firstObject];
            NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
            [returnDic setValue:[resultDic objectForKey:@"bankName"] forKey:@"bankName"];
            [returnDic setValue:[resultDic objectForKey:@"moneyType"] forKey:@"moneyType"];
            [returnDic setValue:[resultDic objectForKey:@"bankNo"] forKey:@"bankNo"];
            [self.delegate getBankAccountResultHandler:returnDic andSuccess:YES];
        }
        else {
            [self.delegate getBankAccountResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账2:银行余额的流水号----------------------------------------------------

-(void)requestBankMoneyWithParam:(NSMutableDictionary *)param {
    
    self.requestForTransfer.reqParam = param;
    self.requestForTransfer.urlString = [CMHttpURLManager urlStringWithServID:@"getBankMoney"];
    self.requestForTransfer.requestMethod = HTTRequestGET;
    self.requestForTransfer.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForTransfer cancelWithoutDelegate];
    [self.requestForTransfer sendRequestWithSuccessBlock:^(id data) {
        [welf requestBankMoneyResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"银行余额查询失败");
    }];
}

-(void)requestBankMoneyResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBankMoneyResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSDictionary *resultDic = [resultData objectForKey:@"results"];
            NSString *returnString = [resultDic objectForKey:@"serialNo"];
            [self.delegate getBankMoneyResultHandler:returnString andSuccess:YES];
        }
        else {
            [self.delegate getBankMoneyResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账3:根据流水号取余额----------------------------------------------------

-(void)requestBankSerialMoneyWithParam:(NSMutableDictionary *)param {
    [param setValue:@"0" forKey:@"actionIn"];
    [param setValue:@" " forKey:@"positionStr"];
    [param setValue:@"50" forKey:@"requestNum"];
    
    self.requestForEntrust.reqParam = param;
    self.requestForEntrust.urlString = [CMHttpURLManager urlStringWithServID:@"getBankSerialMoney"];
    self.requestForEntrust.requestMethod = HTTRequestGET;
    self.requestForEntrust.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForEntrust cancelWithoutDelegate];
    [self.requestForEntrust sendRequestWithSuccessBlock:^(id data) {
        [welf requestBankSerialMoneyResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"根据流水号取余额查询失败");
    }];
}

-(void)requestBankSerialMoneyResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBankMoneySerialResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSDictionary *resultDic = [results lastObject];
            NSString *returnString = [resultDic objectForKey:@"occurBalance"];
            [self.delegate getBankMoneySerialResultHandler:returnString andSuccess:YES];
        }
        else {
            [self.delegate getBankMoneySerialResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账4:转账----------------------------------------------------

-(void)sendTransferRequestWithParam:(NSMutableDictionary *)param {
    
//    [param setValue:@"123456" forKey:@"bankPassword"];
    
    self.requestForTransfer.reqParam = param;
    self.requestForTransfer.urlString = [CMHttpURLManager urlStringWithServID:@"requestTransfer"];
    self.requestForTransfer.requestMethod = HTTRequestGET;
    self.requestForTransfer.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForTransfer cancelWithoutDelegate];
    [self.requestForTransfer sendRequestWithSuccessBlock:^(id data) {
        [welf sendTransferRequestResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"银行余额查询失败");
    }];
}

-(void)sendTransferRequestResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendTransferRequestResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSDictionary *resultDic = [resultData objectForKey:@"results"];
            NSString *returnString = [resultDic objectForKey:@"entrustNo"];
            [self.delegate sendTransferRequestResultHandler:returnString andSuccess:YES];
        }
        else {
            [self.delegate sendTransferRequestResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账5:当日流水----------------------------------------------------

-(void)requestTransferFlowListWithParam:(NSMutableDictionary *)param {
    [param setValue:@"0" forKey:@"entrustNo"];
    [param setValue:@"10000" forKey:@"requestNum"];
    [param setValue:@"0" forKey:@"actionIn"];
    [param setValue:@" " forKey:@"positionStr"];
    
    self.requestForDealList.reqParam = param;
    self.requestForDealList.urlString = [CMHttpURLManager urlStringWithServID:@"getTransferFlowList"];
    self.requestForDealList.requestMethod = HTTRequestGET;
    self.requestForDealList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForDealList cancelWithoutDelegate];
    [self.requestForDealList sendRequestWithSuccessBlock:^(id data) {
        [welf requestTransferFlowListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"转账历史列表失败");
    }];
}

-(void)requestTransferFlowListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTransferFlowListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSMutableArray *returnArray = [NSMutableArray array];
            NSArray *originalArray = [TransferFlowListVO parseTransferFlowListWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
//                TransferFlowListVO *item = [originalArray objectAtIndex:originalArray.count - 1 - i];
//                NSLog(@"--%@",item.entrustStatus);
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            self.transferFlowList = [NSMutableArray arrayWithArray:returnArray];
            [self.delegate requestTransferFlowListResultHandler:self.transferFlowList andSuccess:YES];
        }
        else {
            [self.delegate requestTransferFlowListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账6:查询历史流水----------------------------------------------------

-(void)requestTransferHistoryListWithParam:(NSMutableDictionary *)param {
    [param setValue:@"10000" forKey:@"requestNum"];
    [param setValue:@"" forKey:@"positionStr"];
    [param setValue:@"0" forKey:@"actionIn"];
    
    self.lastStartDate = [NSDate date];
    self.limitStartDate = [NSDate dateWithTimeInterval:0 - 3600 * 24 * 60 sinceDate:self.lastStartDate];
    [param setValue:[self getOtherYearMonthDayStringWithTimeInterval:0 - 3600 * 24 * 10] forKey:@"startDate"];
    [param setValue:[self transFormDateToStringWithDate:[NSDate date]] forKey:@"endDate"];
    
    self.requestForDealHistoryList.reqParam = param;
    self.requestForDealHistoryList.urlString = [CMHttpURLManager urlStringWithServID:@"getTransferHistoryList"];
    self.requestForDealHistoryList.requestMethod = HTTRequestGET;
    self.requestForDealHistoryList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForDealHistoryList cancelWithoutDelegate];
    [self.requestForDealHistoryList sendRequestWithSuccessBlock:^(id data) {
        [welf requestTransferHistoryListResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"历史成交列表失败");
    }];
}

-(void)requestTransferHistoryListResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTransferHistoryListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSMutableArray *returnArray = [self.transferFlowList mutableCopy];
            NSArray *originalArray = [TransferHistoryListVO parseTransferHistoryListWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            self.transferHistoryList = returnArray.copy;
            [self.delegate requestTransferHistoryListResultHandler:self.transferHistoryList andSuccess:YES];
        }
        else {
            [self.delegate requestTransferHistoryListResultHandler:message andSuccess:NO];
        }
    }
}

#pragma mark -----------------------------------------------银证转账6:查询历史流水下一页----------------------------------------------------

-(void)requestTransferHistoryListNextPageWithParam:(NSMutableDictionary *)param {
    [param setValue:@"10000" forKey:@"requestNum"];
    [param setValue:[self transFormDateToStringWithDate:self.lastStartDate] forKey:@"endDate"];
    [param setValue:[self getOtherYearMonthDayStringWithTimeInterval:0 - 3600 * 24 * 10] forKey:@"startDate"];
    [param setValue:@"" forKey:@"positionStr"];
    
    self.requestForDealHistoryList.reqParam = param;
    self.requestForDealHistoryList.urlString = [CMHttpURLManager urlStringWithServID:@"getTransferFlowList"];
    self.requestForDealHistoryList.requestMethod = HTTRequestGET;
    self.requestForDealHistoryList.requestType = HTTPRequestAsynchronous;
    __block __typeof(self) welf = self;
    [self.requestForDealHistoryList cancelWithoutDelegate];
    [self.requestForDealHistoryList sendRequestWithSuccessBlock:^(id data) {
        [welf requestTransferHistoryListNextPageResultHandler:data];
    } failureBlock:^(id data) {
        NSLog(@"历史成交列表下一页失败");
    }];
}

-(void)requestTransferHistoryListNextPageResultHandler:(id)resultData {
    if (![resultData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    id messageVO = [resultData objectForKey:@"message"];
    NSNumber *code = [messageVO objectForKey:@"code"];
    NSString *message = [messageVO objectForKey:@"message"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestTransferHistoryListResultHandler:andSuccess:)]) {
        if (code.integerValue == 0) {
            NSArray *results = [resultData objectForKey:@"results"];
            NSMutableArray *returnArray = [self.dealHistoryList mutableCopy];
            NSArray *originalArray = [DealHistoryListVO parseDealHistoryVOWithData:results];
            for (int i = 0; i < originalArray.count; i++) {
                [returnArray addObject:[originalArray objectAtIndex:originalArray.count - 1 - i]];
            }
            self.transferHistoryList = returnArray.copy;
            [self.delegate requestTransferHistoryListResultHandler:self.transferHistoryList andSuccess:YES];
        }
        else {
            [self.delegate requestTransferHistoryListResultHandler:message andSuccess:NO];
        }
    }
}


#pragma mark -----------------------------------------------工具----------------------------------------------------

-(NSString *)getTodayYearMonthDayString {
    return [self transFormDateToStringWithDate:[NSDate date]];
}

-(NSString *)getOtherYearMonthDayStringWithTimeInterval:(NSTimeInterval)timeInterval {
//    NSTimeInterval timeInterval = 0 - 3600 * 24 * 60;
    NSDate *twoMonthAgo = [NSDate dateWithTimeInterval:timeInterval sinceDate:self.lastStartDate];
    self.lastStartDate = twoMonthAgo;
    return [self transFormDateToStringWithDate:twoMonthAgo];
}

-(NSString *)transFormDateToStringWithDate:(NSDate *)date {
    NSString *description = date.description;
    NSArray *tempArray = [description componentsSeparatedByString:@" "];
    if (tempArray.count == 0) {
        return nil;
    }
    NSString *dateString = [tempArray firstObject];
    tempArray = [dateString componentsSeparatedByString:@"-"];
    dateString = [tempArray componentsJoinedByString:@""];
//    NSLog(@"--%@",dateString);
    return dateString;
}

@end
