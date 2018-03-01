//
//  XgwSevenManager.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/26.
//
//

#import "XgwSevenManager.h"
#import "HTTPRequestService.h"
#import "CMHttpURLManager.h"
#import "ResultMessageVO.h"
#import "RHSignTool.h"
#import "CleanStockVO.h"
#import "CleanStocksTreadVO.h"
#import "HistoryRecordVO.h"
#import "HistoryTreadVO.h"
#import "TradeSessionManager.h"

@interface XgwSevenManager ()
@property (nonatomic,strong)HTTPRequestService * requestCleanStocksList;
@property (nonatomic,strong)HTTPRequestService * requestCleanTradeList;
@property (nonatomic,strong)HTTPRequestService * requestHistoryRecordList;
@property (nonatomic,strong)HTTPRequestService * requestHistoryTreadList;
@property (nonatomic,strong)HTTPRequestService * singRiskCaution;


@property (nonatomic,copy)ReuqestCompletion cleanStocksListBack;
@property (nonatomic,copy)ReuqestCompletion cleanTradeListBack;
@property (nonatomic,copy)ReuqestCompletion historyRecordListBack;
@property (nonatomic,copy)ReuqestCompletion historyTreadListBack;
@property (nonatomic,copy)ReuqestCompletion singRiskCautionBack;

@end


@implementation XgwSevenManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestCleanStocksList = [[HTTPRequestService alloc]init];
        self.requestCleanTradeList = [[HTTPRequestService alloc]init];
        self.requestHistoryRecordList = [[HTTPRequestService alloc]init];
        self.requestHistoryTreadList = [[HTTPRequestService alloc]init];
        self.singRiskCaution = [[HTTPRequestService alloc]init];
        
    }
    return self;
}
- (void)cancelAllDelegate{
    
    [self.requestCleanStocksList cancelWithoutDelegate];
    [self.requestCleanTradeList cancelWithoutDelegate];
    [self.requestHistoryRecordList cancelWithoutDelegate];
    [self.requestHistoryTreadList cancelWithoutDelegate];
    [self.singRiskCaution cancelWithoutDelegate];
 
}
-(void)dealloc{
   
    self.requestCleanStocksList = nil;
    self.cleanStocksListBack = nil;
    self.requestCleanTradeList = nil;
    self.cleanTradeListBack = nil;
    self.requestHistoryRecordList = nil;
    self.historyRecordListBack = nil;
    self.requestHistoryTreadList = nil;
    self.historyTreadListBack = nil;
    self.singRiskCaution = nil;
    self.singRiskCautionBack = nil;
   
}
#pragma mark--签署风险揭示书
- (void)signRiskCautionWithParam:(NSDictionary *)param completion:(ReuqestCompletion)callBack{
    _singRiskCautionBack = callBack;
    
    NSString *urlString = [CMHttpURLManager urlStringWithServID:@"RiskCautionSign"];
    self.singRiskCaution.urlString = urlString;
    self.singRiskCaution.requestMethod = HTTRequestGET;
    self.singRiskCaution.reqParam = param;
    self.singRiskCaution.requestType = HTTPRequestAsynchronous;
    __weak __typeof(self) welf = self;
    
    [self.singRiskCaution sendRequestWithSuccessBlock:^(id data) {
        [welf didprocessSignRiskCautionResult:data];
    } failureBlock:^(id data) {
        [welf didprocessSignRiskCautionResult:data];
    }];
    
}
-(void)didprocessSignRiskCautionResult:(id)resultData{


    if (!_singRiskCautionBack) {
        return;
    }
    ResultMessageVO *messVO = [ResultMessageVO parseData:resultData];
    BOOL isSuccess = messVO.code == 0 ? YES : NO;
    
    if (isSuccess) {
       
        self.singRiskCautionBack(isSuccess,nil);
    }else{
        
        self.singRiskCautionBack(isSuccess,messVO.message);
        
    }
    self.singRiskCautionBack = NULL;

}

#pragma mark--历史成交对账单
-(void)requestHistoryTreadListParam: (NSDictionary *)param completion:(ReuqestCompletion)callBack{
    
    _historyTreadListBack = callBack;
    /**加签名*/
    NSString * sing = [RHSignTool signStrWithParam:param andAccountId:[TradeSessionManager shareInstance].onLineAccount];
    
    NSString *urlString = [CMHttpURLManager urlStringWithServID:@"HistoryTradeList"];
    NSMutableDictionary *aParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [aParam setObject:sing forKey:@"sign"];
    
    self.requestHistoryTreadList.urlString = urlString;
    self.requestHistoryTreadList.requestMethod = HTTRequestGET;
    self.requestHistoryTreadList.reqParam = aParam;
    self.requestHistoryTreadList.requestType = HTTPRequestAsynchronous;
    
    __weak __typeof(self) welf = self;
    [self.requestHistoryTreadList sendRequestWithSuccessBlock:^(id data) {
        [welf didprocessHistoryTreadListResult:data];
    } failureBlock:^(id data) {
        [welf didprocessHistoryTreadListResult:data];
    }];

    
}
-(void)didprocessHistoryTreadListResult:(id)resultData{
    if (!_historyTreadListBack) {
        return;
    }
    ResultMessageVO *messVO = [ResultMessageVO parseData:resultData];
    BOOL isSuccess = messVO.code == 0 ? YES : NO;
    NSDictionary * resuitDic = (NSDictionary *)resultData;
    if (isSuccess) {
        NSMutableArray * array = [NSMutableArray array];
        HistoryTreadVO * listVO = [HistoryTreadVO generateWithDict:resuitDic];
        for (NSDictionary * dataDic in listVO.data) {
            HistoryTreadListVO * VO = [HistoryTreadListVO generateWithDict:dataDic];
            [array addObject:VO];
        }
        
        listVO.data = array;
        
        self.historyTreadListBack(isSuccess,listVO);
    }else{
        
        self.historyTreadListBack(isSuccess,messVO.message);
        
    }
    self.historyTreadListBack = NULL;

    
    
    
    
    
}
#pragma mark--历史转账记录
-(void)requestHistoryRecordWithParam: (NSDictionary *)param completion:(ReuqestCompletion)callBack{
    
    _historyRecordListBack = callBack;
    /**加签名*/
    NSString * sing = [RHSignTool signStrWithParam:param andAccountId:[TradeSessionManager shareInstance].onLineAccount];
    
    NSString *urlString = [CMHttpURLManager urlStringWithServID:@"HistoryRecordList"];
    NSMutableDictionary *aParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [aParam setObject:sing forKey:@"sign"];
    
    self.requestHistoryRecordList.urlString = urlString;
    self.requestHistoryRecordList.requestMethod = HTTRequestGET;
    self.requestHistoryRecordList.reqParam = aParam;
    self.requestHistoryRecordList.requestType = HTTPRequestAsynchronous;
    
    __weak __typeof(self) welf = self;
    [self.requestHistoryRecordList sendRequestWithSuccessBlock:^(id data) {
        [welf didprocessHistoryRecordListResult:data];
    } failureBlock:^(id data) {
        [welf didprocessHistoryRecordListResult:data];
    }];
    
    
}
-(void)didprocessHistoryRecordListResult:(id)resultData{
    
    if (!_historyRecordListBack) {
        return;
    }
    ResultMessageVO *messVO = [ResultMessageVO parseData:resultData];
    BOOL isSuccess = messVO.code == 0 ? YES : NO;
    NSDictionary * resuitDic = (NSDictionary *)resultData;
    if (isSuccess) {
        NSMutableArray * array = [NSMutableArray array];
        HistoryRecordVO * listVO = [HistoryRecordVO generateWithDict:resuitDic];
        for (NSDictionary * dataDic in listVO.data) {
            HistoryRecordListVO * VO = [HistoryRecordListVO generateWithDict:dataDic];
            [array addObject:VO];
        }
        
        listVO.data = array;
        
        self.historyRecordListBack(isSuccess,listVO);
    }else{
        
        self.historyRecordListBack(isSuccess,messVO.message);
        
    }
    self.historyRecordListBack = NULL;

    
    
}
#pragma mark--请求清仓股票列表
-(void)requestCleanStocksListWithParam:(NSDictionary *)param completion:(ReuqestCompletion)callBack{
    
    _cleanStocksListBack = callBack;
    
    NSString * sing = [RHSignTool signStrWithParam:param andAccountId:[TradeSessionManager shareInstance].onLineAccount];
    
    NSString *urlString = [CMHttpURLManager urlStringWithServID:@"clearanceStocksList"];
    NSMutableDictionary *aParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [aParam setObject:sing forKey:@"sign"];
    
    self.requestCleanStocksList.urlString = urlString;
    self.requestCleanStocksList.requestMethod = HTTRequestGET;
    self.requestCleanStocksList.reqParam = aParam;
    self.requestCleanStocksList.requestType = HTTPRequestAsynchronous;
    
    __weak __typeof(self) welf = self;
    [self.requestCleanStocksList sendRequestWithSuccessBlock:^(id data) {
        [welf didprocessCleanStocksListResult:data];
    } failureBlock:^(id data) {
        [welf didprocessCleanStocksListResult:data];
    }];
    
    
    
}
-(void)didprocessCleanStocksListResult:(id)resultData{
    
    if (!_cleanStocksListBack) {
        return;
    }
    ResultMessageVO *messVO = [ResultMessageVO parseData:resultData];
    BOOL isSuccess = messVO.code == 0 ? YES : NO;
    NSDictionary * resuitDic = (NSDictionary *)resultData;
    if (isSuccess) {
        NSMutableArray * array = [NSMutableArray array];
        CleanStocksListVO * listVO = [CleanStocksListVO generateWithDict:resuitDic];
        for (NSDictionary * dataDic in listVO.data) {
            CleanStockVO * VO = [CleanStockVO generateWithDict:dataDic];
            [array addObject:VO];
        }
        
        listVO.data = array;
        
        self.cleanStocksListBack(isSuccess,listVO);
    }else{
        
        self.cleanStocksListBack(isSuccess,messVO.message);

    }
    self.cleanStocksListBack = NULL;

}
#pragma mark--请求清仓交易列表  清仓股票列表的下一级
-(void)requestCleanStocksTradeWithParam: (NSDictionary *)param  completion:(ReuqestCompletion)callBack{
    
    
    _cleanTradeListBack = callBack;
    
    NSString * sing = [RHSignTool signStrWithParam:param andAccountId:[TradeSessionManager shareInstance].onLineAccount];
    
    NSString *urlString = [CMHttpURLManager urlStringWithServID:@"clearanceStocksTradeList"];
    NSMutableDictionary *aParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [aParam setObject:sing forKey:@"sign"];
    
    self.requestCleanTradeList.urlString = urlString;
    self.requestCleanTradeList.requestMethod = HTTRequestGET;
    self.requestCleanTradeList.reqParam = aParam;
    self.requestCleanTradeList.requestType = HTTPRequestAsynchronous;
    
    __weak __typeof(self) welf = self;
    [self.requestCleanTradeList sendRequestWithSuccessBlock:^(id data) {
        [welf didprocessCleanTradeStocksListResult:data];
    } failureBlock:^(id data) {
        [welf didprocessCleanTradeStocksListResult:data];
    }];
 }
-(void)didprocessCleanTradeStocksListResult:(id)resultData{
    
    
    if (!_cleanTradeListBack) {
        return;
    }
    ResultMessageVO *messVO = [ResultMessageVO parseData:resultData];
    BOOL isSuccess = messVO.code == 0 ? YES : NO;
    NSDictionary * resuitDic = (NSDictionary *)resultData;
    if (isSuccess) {
        NSMutableArray * array = [NSMutableArray array];
        CleanStocksTreadVO * tradeVO = [CleanStocksTreadVO generateWithDict:resuitDic];
        for (NSDictionary * dataDic in tradeVO.data) {
            CleanStocksTreadListVO * VO = [CleanStocksTreadListVO generateWithDict:dataDic];
            [array addObject:VO];
        }
        
        tradeVO.data = array;
        
        self.cleanTradeListBack(isSuccess,tradeVO);
    }else{
        
        self.cleanTradeListBack(isSuccess,messVO.message);
        
    }
    self.cleanTradeListBack = NULL;
}

@end
