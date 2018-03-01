//
//  TradeIPOManager.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/12.
//
//

#import "TradeIPOManager.h"
#import "TradeIPOTodayVO.h"
#import "TradeIPOWeekVO.h"
#import "ASIHttpTool.h"

@interface TradeIPOManager ()

kRhPStrong HTTPRequestService * IPOTodayRequest;

kRhPStrong HTTPRequestService * IPOLimitRequest;

kRhPStrong HTTPRequestService * IPOWeekRequest;

kRhPStrong HTTPRequestService * IPOMatchRequest;

kRhPStrong HTTPRequestService * IPOLuckyRequest;

kRhPCopy RequestCompletionCallback todayCallBack;

kRhPCopy RequestCompletionCallback limitCallBack;

kRhPCopy RequestCompletionCallback weekCallBack;

kRhPCopy RequestCompletionCallback matchCallBack;

kRhPCopy RequestCompletionCallback luckyCallBack;

@end

@implementation TradeIPOManager

- (instancetype)init{
    if (self = [super init]) {
        _IPOTodayRequest = [[HTTPRequestService alloc] init];
        _IPOLimitRequest = [[HTTPRequestService alloc] init];
        _IPOWeekRequest = [[HTTPRequestService alloc] init];
        _IPOMatchRequest = [[HTTPRequestService alloc] init];
        _IPOLuckyRequest = [[HTTPRequestService alloc] init];
    }
    return self;
}

- (void)cancelAllDelegate{
    [_IPOWeekRequest cancelWithoutDelegate];
    [_IPOTodayRequest cancelWithoutDelegate];
    [_IPOMatchRequest cancelWithoutDelegate];
    [_IPOLuckyRequest cancelWithoutDelegate];
    
}

#pragma mark ----------对外请求
//今日新股申购查询
- (void)requestForIPOToday:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack{
    if (!aParam || !aParam.count) {
        return;
    }
    self.todayCallBack = callBack;
    [self getMarkWith:modeId];
    NSString * urlString = @"IPOToday";
    [self sendGetRequestWithParam:aParam WithUrl:urlString withRequest:self.IPOTodayRequest];
    
}

////新股申购额度查询
//- (void)requestForIPOMatchInfo:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack{
//    if (!aParam || !aParam.count) {
//        return;
//    }
//    self.limitCallBack = callBack;
//    [self getMarkWith:modeId];
//    NSString * urlString = @"IPOLimit";
//    [self sendRequestWithParam:aParam WithUrl:urlString withRequest:self.IPOLimitRequest];
//}

//本周新股申购查询
- (void)requestForIPOWeekWithModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack{
    self.weekCallBack = callBack;
    //    [self getMarkWith:modeId];
    NSString * urlString = @"IPOWeek";
    //    [self sendAsynRequestWithParam:nil WithUrl:urlString withRequest:self.IPOWeekRequest];
    
    [ASIHttpTool getWithURL:urlString params:nil success:^(id json) {
        [self parseIPOWeekMsgFromResultData:json];
    } failure:^(NSError *error) {
        callBack(NO,nil);
    }];
}

//新股申购历史中签查询
- (void)requestForIPOHisLucky:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack{
    if (!aParam || !aParam.count) {
        return;
    }
    self.luckyCallBack = callBack;
    [self getMarkWith:modeId];
    NSString * urlString = @"IPOHisLucky";//IPOHisLucky
    [self sendGetRequestWithParam:aParam WithUrl:urlString withRequest:self.IPOLuckyRequest];
}

//新股申购历史配号查询
- (void)requestForIPOMatchInfo:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack{
    if (!aParam || !aParam.count) {
        return;
    }
    self.matchCallBack = callBack;
    [self getMarkWith:modeId];
    NSString * urlString = @"IPOHisMatch";
    [self sendGetRequestWithParam:aParam WithUrl:urlString withRequest:self.IPOMatchRequest];
}

#pragma mark -----------回调数据处理
- (void)didProcessRequestCompleteResultData:(id)resultData withSuccess:(BOOL)isSuc{
    if (!isSuc) {
        switch ([self.mark integerValue]) {
            case kIPOTodayDetail:
                //今日
                self.todayCallBack(NO,resultData);
                break;
            case kIPOWeekDetail:
                //本周
                self.weekCallBack(NO,resultData);
                break;
            case kIPOMatch:
                //配号
                self.matchCallBack(NO,resultData);
                break;
                
            case kIPOLucky:
                //中签
                self.luckyCallBack(NO,resultData);
                break;
                
            default:
                break;
        }
        return;
    }
    switch ([self.mark integerValue]) {
        case kIPOWeekDetail:
            [self parseIPOWeekMsgFromResultData:resultData];
            break;
        case kIPOTodayDetail:
            [self parseIPOTodayMsgFromResultData:resultData];
            break;
        case kIPOLucky:
            [self parseIPOLuckyMsgFromResultData:resultData];
            break;
        case kIPOMatch:
            [self parseIPOMatchMsgFromResultData:resultData];
            break;
        default:
            break;
    }
}

- (void)didProcessAsynRequestCompleteResultData:(id)resultData withSuccess:(BOOL)isSuc{
    if (!isSuc) {
        switch ([self.mark integerValue]) {
            case kIPOTodayDetail:
                //今日
                break;
                
            case kIPOWeekDetail:
                //本周
                self.weekCallBack(NO,resultData);
                break;
                
            case kIPOMatch:
                //配号
                self.matchCallBack(NO,resultData);
                break;
                
            case kIPOLucky:
                //中签
                self.luckyCallBack(NO,resultData);
                break;
            default:
                break;
        }
        return;
    }
    switch ([self.mark integerValue]) {
        case kIPOWeekDetail:
            [self parseIPOWeekMsgFromResultData:resultData];
            break;
        case kIPOTodayDetail:
            [self parseIPOTodayMsgFromResultData:resultData];
            break;
        case kIPOLucky:
            [self parseIPOLuckyMsgFromResultData:resultData];
            break;
        case kIPOMatch:
            [self parseIPOMatchMsgFromResultData:resultData];
            break;
        default:
            break;
    }
}

#pragma mark ---------------数据处理
#pragma mark ---一周新股
- (void)parseIPOWeekMsgFromResultData:(NSDictionary *)resultData{
    if (![self isValidData:resultData]) {
        if (self.weekCallBack) {
            self.weekCallBack(YES,nil);
        }
        return;
    }
    NSMutableArray * newsArr = [NSMutableArray array];
    NSMutableArray * todayArr = [NSMutableArray array];
    
    NSArray * newStocks = [resultData objectForKey:@"newStocks"];
    NSArray * todayNewStocks = [resultData objectForKey:@"todayNewStocks"];
    NSString * tag;
    NSMutableArray * listArr = [NSMutableArray array];
    NSMutableArray * headerArr = [NSMutableArray array];
    for (NSDictionary * newsDic in newStocks) {
        TradeIPOWeekVO * IPOVO = [TradeIPOWeekVO generateWithDict:newsDic];
        
        if (!tag.length) {
            tag = IPOVO.applyDate;
            [listArr addObject:IPOVO];
            if ([newsDic isEqual:[newStocks lastObject]]) {
                //                [newsArr addObject:[listArr copy]];
                [newsArr addObject:[NSArray arrayWithArray:listArr]];
                id tradeHeadVO = listArr[0];
                [headerArr addObject:tradeHeadVO];
            }
        }
        else{
            if ([IPOVO.applyDate isEqualToString:tag]) {
                [listArr addObject:IPOVO];
                if ([newsDic isEqual:[newStocks lastObject]]) {
                    //                    [newsArr addObject:[listArr copy]];
                    [newsArr addObject:[NSArray arrayWithArray:listArr]];
                    //                    [headerArr addObject:[listArr[0] copy]];
                    id tradeHeadVO = listArr[0];
                    [headerArr addObject:tradeHeadVO];
                }
            }
            else{
                //                [newsArr addObject:[listArr copy]];
                [newsArr addObject:[NSArray arrayWithArray:listArr]];
                //                [headerArr addObject:[listArr[0] copy]];
                id tradeHeadVO = listArr[0];
                [headerArr addObject:tradeHeadVO];
                
                [listArr removeAllObjects];
                tag = IPOVO.applyDate;
                [listArr addObject:IPOVO];
                if ([newsDic isEqual:[newStocks lastObject]]) {
                    //                    [newsArr addObject:[listArr copy]];
                    [newsArr addObject:[NSArray arrayWithArray:listArr]];
                    //                    [headerArr addObject:[listArr[0] copy]];
                    id tradeHeadVO = listArr[0];
                    [headerArr addObject:tradeHeadVO];
                    
                }
            }
        }
        
        //        [newsArr addObject:IPOVO];
    }
    for (NSDictionary * todayDic in todayNewStocks) {
        TradeIPOTodayVO * today = [TradeIPOTodayVO generateWithDict:todayDic];
        [todayArr addObject:today];
    }
    NSMutableDictionary * resultDic = [NSMutableDictionary dictionary];
    if (newsArr.count) {
        [resultDic setObject:newsArr forKey:@"newsArr"];
    }
    if (todayArr.count) {
        [resultDic setObject:todayArr forKey:@"todayArr"];
    }
    if (headerArr.count) {
        [resultDic setObject:headerArr forKey:@"headerArr"];
    }
    if (!resultDic.count) {
        self.weekCallBack(YES,nil);
        return;
    }
    self.weekCallBack(YES,resultDic);
    
}

#pragma mark ---今日新股
- (void)parseIPOTodayMsgFromResultData:(NSDictionary *)resultData{
    if (![self isValidData:resultData]) {
        if (self.todayCallBack) {
            self.todayCallBack(YES,nil);
        }
        return;
    }
    NSMutableArray * newsArr = [NSMutableArray array];
    
    NSArray * resultsArr = [resultData objectForKey:@"results"];
    NSNumber * serverTime = [resultData objectForKey:@"serverTime"];
    for (NSDictionary * newsDic in resultsArr) {
        TradeIPOTodayVO * IPOVO = [TradeIPOTodayVO generateWithDict:newsDic];
        IPOVO.applyAmount = IPOVO.enableAmount;
        [newsArr addObject:IPOVO];
    }
    if (!newsArr.count) {
        TradeIPOTodayVO * IPOVO = [[TradeIPOTodayVO alloc] init];
        IPOVO.serverTime = serverTime;
    //与headView赋值时统一格式为@“yyyyMMdd”的NSNumber类型
        IPOVO.businessDate = [NSNumber numberWithInteger:[[TimeUtils getTimeStringWithNumber:serverTime formatString:@"yyyyMMdd"] integerValue]];
        self.todayCallBack(YES,IPOVO);
        return;
    }
    self.todayCallBack(YES,newsArr);
    
}

#pragma mark ---中签
- (void)parseIPOLuckyMsgFromResultData:(NSDictionary *)resultData{
    if (![self isValidData:resultData]) {
        if (self.luckyCallBack) {
            self.luckyCallBack(YES,nil);
        }
        return;
    }
    NSMutableArray * newsArr = [NSMutableArray array];
    
    NSArray * resultsArr = [resultData objectForKey:@"results"];
    for (NSDictionary * newsDic in resultsArr) {
        TradeIPOTodayVO * IPOVO = [TradeIPOTodayVO generateWithDict:newsDic];
        IPOVO.type = kLucky;
        [newsArr addObject:IPOVO];
    }
    
    NSSortDescriptor * descr = [NSSortDescriptor sortDescriptorWithKey:@"businessDate" ascending:NO];
    NSMutableArray * temArr = [NSMutableArray arrayWithArray:newsArr];
    NSArray * sortArr = [temArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:descr]];
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temArr.count)];
    [newsArr replaceObjectsAtIndexes:indexSet withObjects:sortArr];
    
    if (!newsArr.count) {
        self.luckyCallBack(YES,nil);
        return;
    }
    self.luckyCallBack(YES,newsArr);
    
}

#pragma mark --- 配号
- (void)parseIPOMatchMsgFromResultData:(NSDictionary *)resultData{
    if (![self isValidData:resultData]) {
        if (self.matchCallBack) {
            self.matchCallBack(YES,nil);
        }
        return;
    }
    NSMutableArray * newsArr = [NSMutableArray array];
    
    NSArray * resultsArr = [resultData objectForKey:@"results"];
    for (NSDictionary * newsDic in resultsArr) {
        TradeIPOTodayVO * IPOVO = [TradeIPOTodayVO generateWithDict:newsDic];
        IPOVO.type = kMatch;
        [newsArr addObject:IPOVO];
    }
    
    NSSortDescriptor * descr = [NSSortDescriptor sortDescriptorWithKey:@"businessDate" ascending:NO];
    NSMutableArray * temArr = [NSMutableArray arrayWithArray:newsArr];
    NSArray * sortArr = [temArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:descr]];
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temArr.count)];
    [newsArr replaceObjectsAtIndexes:indexSet withObjects:sortArr];
    
    if (!newsArr.count) {
        self.matchCallBack(YES,nil);
        return;
    }
    self.matchCallBack(YES,newsArr);
    
}


@end
