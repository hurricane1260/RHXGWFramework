//
//  OARequestManager.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/5.
//
//

#import "OARequestManager.h"

#import "RHOpenAccStoreData.h"
#import "NSString+MD5.h"

#import "CRHMessageVo.h"
#import "CRHProtocolListVo.h"
#import "CRHCheckRegiserUserVo.h"
#import "CRHBranchVo.h"

#import "CRHRiskTestVo.h"
#import "CRHRiskResultVo.h"
#import "CRHRiskQueryVo.h"
#import "CRHBankListVo.h"
#import "CRHCACertVo.h"

#import "CRHClientInfoVo.h"

#import "CRHVideoServiceVo.h"
#import "CRHSigleVedioTaskVo.h"
#import "CRHUserVideoStausInfoVo.h"

#import "CRHOpenAccResultVo.h"

#import "CRHUserStatusVo.h"

#import "CRHMatchCheckVo.h"

@interface OARequestManager ()

kRhPStrong HTTPRequestService * smsVCRequest;

kRhPStrong HTTPRequestService * checkVCRquest;

kRhPStrong HTTPRequestService * protocolListRequest;

kRhPStrong HTTPRequestService * protocolContenRequest;

kRhPStrong HTTPRequestService * protocolSignRequest;

kRhPCopy  RequestCompletionCallback  sendSmsVCCallBack;

kRhPCopy RequestCompletionCallback protocolListCallBack;

kRhPCopy RequestCompletionCallback protocolContentCallBack;

kRhPCopy RequestCompletionCallback protocolSignCallBack;

kRhPCopy RequestCompletionCallback checkSmsVCCallBack;

kRhPStrong HTTPRequestService * commonRequest;

kRhPCopy RequestCompletionCallback commonCallBack;

kRhPCopy RequestCompletionCallback clientInfoCallBack;

kRhPAssign CRHRequestType requestType;

kRhPStrong NSMutableArray * resultArr;

@end

@implementation OARequestManager


- (instancetype)init{
    if (self = [super init]) {
        self.resultArr = [NSMutableArray array];
    }
    return self;
}

- (void)cancelAllDelegate{
    [self.smsVCRequest cancelWithoutDelegate];
    [self.checkVCRquest cancelWithoutDelegate];
    [self.protocolListRequest cancelWithoutDelegate];
    [self.protocolContenRequest cancelWithoutDelegate];
    [self.commonRequest cancelWithoutDelegate];
    [self.protocolSignRequest cancelWithoutDelegate];
}

- (void)dealloc{
    [self.smsVCRequest cancelWithoutDelegate];
    [self.checkVCRquest cancelWithoutDelegate];
    [self.protocolListRequest cancelWithoutDelegate];
    [self.protocolContenRequest cancelWithoutDelegate];
    [self.commonRequest cancelWithoutDelegate];
    [self.protocolSignRequest cancelWithoutDelegate];

    self.sendSmsVCCallBack = NULL;
    self.commonCallBack = NULL;
    self.checkSmsVCCallBack = NULL;
    self.protocolListCallBack = NULL;
    self.protocolSignCallBack = NULL;
    self.protocolContentCallBack = NULL;
}

- (HTTPRequestService *)commonRequest{
    if (!_commonRequest) {
        _commonRequest = [[HTTPRequestService alloc] init];
    }
    return _commonRequest;
}

- (HTTPRequestService *)smsVCRequest{
    if (!_smsVCRequest) {
        _smsVCRequest = [[HTTPRequestService alloc] init];
    }
    return _smsVCRequest;
}

- (HTTPRequestService *)checkVCRquest{
    if (!_checkVCRquest) {
        _checkVCRquest = [[HTTPRequestService alloc] init];
    }
    return _checkVCRquest;
}

- (HTTPRequestService *)protocolListRequest{
    if (!_protocolListRequest) {
        _protocolListRequest = [[HTTPRequestService alloc] init];
    }
    return _protocolListRequest;
}

- (HTTPRequestService *)protocolContenRequest{
    if (!_protocolContenRequest) {
        _protocolContenRequest = [[HTTPRequestService alloc] init];
    }
    return _protocolContenRequest;
}

- (HTTPRequestService *)protocolSignRequest{
    if (!_protocolSignRequest) {
        _protocolSignRequest = [[HTTPRequestService alloc] init];
    }
    return _protocolSignRequest;
}

#pragma mark--------对外请求
- (void)sendCommonRequestWithParam:(id)param withRequestType:(CRHRequestType)type withUrlString:(NSString *)url withCompletion:(RequestCompletionCallback)callBack{
    if (!param || !url.length) {
        return;
    }
    self.commonCallBack = callBack;
    self.requestType = type;
    [self sendPostRequestWithParam:param WithUrl:url withRequest:self.commonRequest];
}

- (void)sendJinHuiRequestWithParam:(id)param withRequestType:(CRHRequestType)type withUrlString:(NSString *)url withCompletion:(RequestCompletionCallback)callBack{
    if (!param || !url.length) {
        return;
    }
    self.commonCallBack = callBack;
    self.requestType = type;
    
    [self sendJinHuiPostRequestWithParam:param WithUrl:url withRequest:self.commonRequest];
}

- (void)queryDicWithId:(NSString *)entry withCompletion:(RequestCompletionCallback)callBack{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:entry forKey:@"dict_entry"];
    
    [self sendCommonRequestWithParam:param withRequestType:kQueryDic withUrlString:@"crhQueryDataDic" withCompletion:^(BOOL success, id resultData) {
//        if (success) {
//            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
//                callBack(success,resultData);
//                return;
//            }
            callBack(success,resultData);
//        }
    }];
    
    
}

#pragma mark -------------手机验证
- (void)sendSMSVerifyCodeWithParam:(NSDictionary *)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    
    self.sendSmsVCCallBack = callBack;
    NSString * url = @"crhSmsVerifyCode";
    self.requestType = type;
    [self sendPostRequestWithParam:param WithUrl:url withRequest:self.smsVCRequest];
//    [self sendGetRequestWithParam:param WithUrl:url withRequest:self.smsVCRequest];

}

- (void)sendCheckSMSVerifyCodeWithParam:(NSDictionary *)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    
    self.sendSmsVCCallBack = callBack;
    NSString * url = @"checkVerifyCodeService";
    self.requestType = type;
    [self sendGetRequestWithParam:param WithUrl:url withRequest:self.checkVCRquest];
    
}

- (void)sendCheckRegisterUserWithParam:(NSDictionary *)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    self.checkSmsVCCallBack = callBack;
    NSString * url = @"crhCheckRegisterUser";
    self.requestType = type;
    [self sendPostRequestWithParam:param WithUrl:url withRequest:self.checkVCRquest];
//    [self sendGetRequestWithParam:param WithUrl:url withRequest:self.checkVCRquest];
}


- (void)requestProtocolListWithParam:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    
    NSMutableDictionary * aParam = [NSMutableDictionary dictionaryWithDictionary:param];
    //统一添加站点地址
//    [aParam setObject:@"192.168.200.17" forKey:@"op_station"];
    
    self.protocolListCallBack = callBack;
    NSString * url = @"crhProtocolList";
    self.requestType = type;
    [self sendPostRequestWithParam:aParam WithUrl:url withRequest:self.protocolListRequest];

}

- (void)requestProtocolContentWithParam:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    
    NSMutableDictionary * aParam = [NSMutableDictionary dictionaryWithDictionary:param];
//    [aParam setObject:@"192.168.200.17" forKey:@"op_station"];

    self.protocolContentCallBack = callBack;
    NSString * url = @"crhProtocolContent";
    self.requestType = type;
    [self sendPostRequestWithParam:aParam WithUrl:url withRequest:self.protocolContenRequest];
    
}

- (void)requestProtocolSignWithCRHProtocolListVo:(CRHProtocolListVo *)vo withCACertSn:(NSString *)caCertSn withRequestType:(CRHRequestType)type withBusinessType:(NSString *)bizType withCompletion:(RequestCompletionCallback)callBack{
    if (!vo || !caCertSn.length) {
        return;
    }
    
    NSString * client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    if (!client_id.length) {
        return;
    }
    
    NSMutableDictionary * aParam = [NSMutableDictionary dictionary];
    [aParam setObject:client_id forKey:@"client_id"];
    
    [aParam setObject:bizType forKey:@"biz_id"];
    [aParam setObject:@100 forKey:@"app_id"];
    
    [aParam setObject:vo.econtract_id forKey:@"econtract_id"];
    [aParam setObject:vo.econtract_name forKey:@"econtract_name"];
    [aParam setObject:vo.econtract_md5 forKey:@"econtract_md5"];
    [aParam setObject:vo.econtract_md5 forKey:@"cert_sign"];
    [aParam setObject:vo.econtract_md5 forKey:@"plain_text"];
    
    [aParam setObject:caCertSn forKey:@"cert_sn"];
    
    self.protocolSignCallBack = callBack;
    self.requestType = type;
    NSString * url = @"crhProtocolSign";
    [self sendPostRequestWithParam:aParam WithUrl:url withRequest:self.protocolSignRequest];
    
}

- (void)checkUserCanOpenAccountWithParam:(id)param withRequestType:(CRHRequestType) type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    self.commonCallBack = callBack;
    self.requestType = type;
//    NSString * url = 

}

#pragma mark ----------上传个人信息
- (void)requestUploadPersonIdImgToSever:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    self.commonCallBack = callBack;
    self.requestType = type;
    NSString * url = @"crhUploadPersonIdImg";
    [self sendPostRequestWithParam:param WithUrl:url withRequest:self.commonRequest];
}


- (void)requestUploadPersonMsgToSever:(id)param withRequestType:(CRHRequestType)type withCompletion:(RequestCompletionCallback)callBack{
    if (!param) {
        return;
    }
    self.commonCallBack = callBack;
    self.requestType = type;
    NSString * url = @"crhUploadPersonMsg";
    [self sendPostRequestWithParam:param WithUrl:url withRequest:self.commonRequest];
}

#pragma mark -----------客户信息查询
- (void)requestQueryClientInfoWithComoletion:(RequestCompletionCallback)callBack{
    NSString * clientId = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    if (!clientId.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:clientId forKey:@"client_id"];
    
    self.clientInfoCallBack = callBack;
    self.requestType = kQueryClientInfo;
    NSString * url = @"crhQueryClientInfo";
    [self sendPostRequestWithParam:param WithUrl:url withRequest:self.commonRequest];
    
}

#pragma mark--------------- 内部请求 get post
//发起Get请求
- (void)sendGetRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request{
    [request cancelWithoutDelegate];
    
    request.urlString = [CMHttpURLManager urlStringWithServID:urlString];
    request.reqParam = aParam;
    request.requestMethod = HTTRequestGET;
    request.requestType = HTTPRequestAsynchronous;
    __block typeof(self) welf = self;
    [request sendCRHRequestWithSuccessBlock:^(id data) {
        if ([self isCRHValidData:data]) {
            [welf didProcessRequestCompleteResultData:data withSuccess:YES];
        }
        else{
            [welf didProcessRequestCompleteResultData:data withSuccess:NO];
        }

    } failureBlock:^(id data) {
        
        [welf didProcessRequestCompleteResultData:data withSuccess:NO];
    }];
    
}


//发起Post请求
- (void)sendPostRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request{
    [request cancelWithoutDelegate];
    
    request.urlString = [CMHttpURLManager urlStringWithServID:urlString];
    
    NSString * nonceStr = [self randomString];
    NSMutableDictionary * param = [NSMutableDictionary dictionaryWithDictionary:aParam];
    [param setObject:@"868faf13f3b4385cc3af4fd00baa5c8a" forKey:@"appId"];
    [param setObject:nonceStr forKey:@"nonceStr"];
    NSString * signStr = [self signParam:param];
    [param setObject:signStr forKey:@"sign"];
    request.reqParam = param;
    
//    request.reqParam = aParam;
    request.requestMethod = HTTRequestPOST;
    request.requestType = HTTPRequestAsynchronous;
    __weak typeof(self) welf = self;
    
//    NSLog(@"%s,%@",__func__,request.urlString);
    
    [request sendCRHRequestWithSuccessBlock:^(id data) {
        
        if ([self isCRHValidData:data]) {
            [welf didProcessRequestCompleteResultData:data withSuccess:YES];
        }
        else{
            [welf didProcessRequestCompleteResultData:data withSuccess:NO];
        }
        
    } failureBlock:^(id data) {
        
        [welf didProcessRequestCompleteResultData:data withSuccess:NO];
    }];
}

//发起Post请求
- (void)sendJinHuiPostRequestWithParam:(NSDictionary *)aParam WithUrl:(NSString *)urlString withRequest:(HTTPRequestService *)request{
    [request cancelWithoutDelegate];
    
    request.urlString = [CMHttpURLManager urlStringWithServID:urlString];
    request.reqParam = aParam;
    request.requestMethod = HTTRequestPOST;
    request.requestType = HTTPRequestAsynchronous;
    request.crhRequestTag = YES;
    __block typeof(self) welf = self;
    [request sendRequestWithSuccessBlock:^(id data) {
        
        if ([self isValidData:data]) {
            [welf didProcessRequestCompleteResultData:data withSuccess:YES];
        }
        else{
            [welf didProcessRequestCompleteResultData:data withSuccess:NO];
        }
        
    } failureBlock:^(id data) {
        
        [welf didProcessRequestCompleteResultData:data withSuccess:NO];
    }];
}
#pragma mark ----------内部数据回调处理
- (void)didProcessRequestCompleteResultData:(id)resultData withSuccess:(BOOL)isSuc{
    if (!isSuc) {
        switch (self.requestType) {
            case kProtocolList:
                self.protocolListCallBack(NO,resultData);
                break;
            case kProtocolContent:
                self.protocolContentCallBack(NO,resultData);
                break;
            case kSmsVerifyCode:
                self.sendSmsVCCallBack(NO,resultData);
                break;
            case kSmsVCCheck:
                self.checkSmsVCCallBack(NO,resultData);
                break;
            case kQueryUserStatus:
                self.commonCallBack(NO,resultData);
                break;
                
            case kUploadPersonIdImg:
                self.commonCallBack(NO,resultData);
                break;
            case kCheckCanOpenAcc:
                self.commonCallBack(NO,resultData);
                break;
                
            case kUploadPersonMsg:
                self.commonCallBack(NO,resultData);
                break;
            case kQueryDic:
                self.commonCallBack(NO,resultData);
                break;
                
            case kQueryBranchCommission:
                self.commonCallBack(NO,resultData);
                break;
            case kOpenStockAcc:
                self.commonCallBack(NO,resultData);
                break;
            case kOpenFundAcc:
                self.commonCallBack(NO,resultData);
                break;
            case kSetTradePassWord:
                self.commonCallBack(NO,resultData);
                break;
                
            case kRiskTestPaper :
                self.commonCallBack(NO,resultData);
                break;
            case kReturnVisitPaper:
                self.commonCallBack(NO,resultData);
                break;
            case kRiskTestCommit:
                self.commonCallBack(NO,resultData);
                break;
            case kRiskTestQuery :
                self.commonCallBack(NO,resultData);
                break;
            case kReturnVisitCommit:
                self.commonCallBack(NO,resultData);
                break;
            case kRiskResultConfirm:
                self.commonCallBack(NO,resultData);
                break;
            case kRiskSpecialResultSave:
                self.commonCallBack(NO,resultData);
                break;
            case kRiskMatchCheck:
                self.commonCallBack(NO,resultData);
                break;

                
                
            case kGetBankList:
                self.commonCallBack(NO,resultData);
                break;
            case kVerifyBankCodeWithBankType:
                self.commonCallBack(NO,resultData);
                break;
            case kBindingBankCard:
                self.commonCallBack(NO,resultData);
                break;
                
            case kProtocolQuery:
                self.commonCallBack(NO,resultData);
                break;
            case kProtocolSign:
                self.protocolSignCallBack(NO,resultData);
                break;
            case kCACertQuery:
                self.commonCallBack(NO,resultData);
                break;
                
            case kBeginVideoRequest:
            case kUserVedioStatusInfoQuery:
            case kSingleTrackVideoTask:
            case kRemoveUser:
            case kVideoServiceQuery:
                self.commonCallBack(NO,resultData);
                break;
                
            case kOpenAccApply:
            case kOpenResultQuery:
            case kSetEntrustType:
                self.commonCallBack(NO,resultData);
                break;
            
            case kQueryClientInfo:
                self.clientInfoCallBack(NO,resultData);
                break;
            default:
                break;
        }
        return;
    }
    switch (self.requestType) {
        case kSmsVerifyCode:
            self.sendSmsVCCallBack(YES,nil);
//            [self didParasSmsVerifyCodeResultWith:resultData];
            break;
        case kProtocolList:
            [self didParaseProtocolListResultWith:resultData];
            break;
        case kProtocolContent:
            [self didParaseProtocolContentResultWith:resultData];
            break;
        case kSmsVCCheck:
            [self didParasCheckRegisterUserResultWith:resultData];
            break;
        case kQueryUserStatus:
            [self didParasUserStatusResultWith:resultData];
            break;
            
        case kUploadPersonIdImg:
            self.commonCallBack(YES,resultData);
            break;
        case kCheckCanOpenAcc:
            self.commonCallBack(YES,resultData);
            break;
            
        case kUploadPersonMsg:
//            [self didParaseUploadPersonMsgResultWith:resultData];
            self.commonCallBack(YES,nil);
            break;
        case kQueryDic:
            [self didParaseQueryDicResultWith:resultData];
//            self.commonCallBack(YES,resultData);
            break;
        case kQueryBranchCommission:
            [self didParaseBranchCommissionResultWith:resultData];
            break;
        case kOpenStockAcc:
            self.commonCallBack(YES,resultData);
            break;
        case kOpenFundAcc:
            self.commonCallBack(YES,resultData);
            break;
        case kSetTradePassWord:
            self.commonCallBack(YES,resultData);
            break;
        case kRiskTestPaper :
            [self didParaseRiskTestPaperResultWith:resultData];
            break;
        case kReturnVisitPaper:
            [self didParaseReturnVisitPaperResultWith:resultData];
            break;
        case kRiskTestCommit:
            [self didParaseRiskTestCommitResultWith:resultData];
            break;
        case kRiskTestQuery :
            [self didParaseRiskTestQueryResultWith:resultData];
            break;
        case kReturnVisitCommit:
            self.commonCallBack(YES,resultData);
            break;
        case kRiskResultConfirm:
//            [self didParaseRiskResultConfirmWith:resultData];
            self.commonCallBack(YES,resultData);

            break;
        case kRiskSpecialResultSave:
            [self didParaseRiskSpecialResultSaveWith:resultData];
            break;
        case kRiskMatchCheck:
            [self didParaseRiskMatchCheckWith:resultData];
            break;
            
            
        case kGetBankList:
            [self didParaseBankListResultWith:resultData];
            break;
        case kVerifyBankCodeWithBankType:
            self.commonCallBack(YES,resultData);
            break;
        case kBindingBankCard:
            self.commonCallBack(YES,resultData);
            break;

            
        case kProtocolQuery:
            [self didParaseProtocolQueryResultWith:resultData];
            break;
        case kProtocolSign:
            self.protocolSignCallBack(YES,resultData);
            break;
        case kCACertQuery:
            [self didParaseCACertQueryResultWith:resultData];
            break;

        case kBeginVideoRequest:
            self.commonCallBack(YES,resultData);
            break;
        case kUserVedioStatusInfoQuery:
            [self didParaseUserVedioStatusInfoResultWith:resultData];
            break;
        case kSingleTrackVideoTask:
            [self didParaseSingleTrackVideoTaskResultWith:resultData];
            break;
        case kRemoveUser:
            self.commonCallBack(YES,resultData);
            break;
        case kVideoServiceQuery:
            [self didParaseVideoServiceResultWith:resultData];
            break;

        case kOpenAccApply:
            self.commonCallBack(YES,resultData);
            break;
        case kOpenResultQuery:
            [self didParaseOpenResultQueryResultWith:resultData];
            break;
        case kSetEntrustType:
            self.commonCallBack(YES,resultData);
            break;
        
        case kQueryClientInfo:
            [self didParaseQueryClientInfoResultWith:resultData];
            break;

        default:
            break;
    }

    
}


#pragma mark ----------财人汇数据返回 判断是否请求成功
- (BOOL)isCRHValidData:(id)resultData{
    if (resultData == nil || ![resultData isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    CRHMessageVo * msgVo = [CRHMessageVo generateWithDict:resultData];
    BOOL isSuccess = [msgVo.error_no boolValue] == 0?YES:NO;
    if (!isSuccess) {
        return NO;
    }
    return YES;
}

#pragma mark -------------财人汇数据处理

- (void)didParasSmsVerifyCodeResultWith:(id)resultData{
    

}

- (void)didParasCheckRegisterUserResultWith:(id)resultData{
    CRHCheckRegiserUserVo * vo = [CRHCheckRegiserUserVo generateWithDict:resultData];
    if (vo) {
        self.checkSmsVCCallBack(YES,vo);
    }

}

- (void)didParasUserStatusResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHUserStatusVo * vo = [CRHUserStatusVo generateWithDict:dic];
//    NSString * open_status = [dic objectForKey:@"open_status"];
//    NSString * risk_eval_finished = [dic objectForKey:@"risk_eval_finished"];
    if (vo) {
        self.commonCallBack(YES,vo);
        return;
    }
    self.commonCallBack(YES,nil);
}

- (void)didParaseProtocolListResultWith:(id)resultData{
    
    NSDictionary * dic = resultData;
    NSArray * resultList = [dic objectForKey:@"resultList"];
    if (!resultList.count) {
        self.protocolListCallBack(YES,nil);
        return;
    }
    
    self.protocolListCallBack(YES,resultList);
    return;
    
    //这里不做详细数据处理，因为此接口用到的地方非常多，处理不同，所以均返回原有数据，到相应的类进行所需处理
//    for (NSDictionary * resultDic in resultList) {
//        CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:resultDic];
//        
//        if ([vo.econtract_name isEqualToString:@"华创证券有限责任公司网上开户协议"]) {
//            self.protocolListCallBack(YES,vo);
//            return;
//        }
//    }
//    self.protocolListCallBack(YES,nil);
}

- (void)didParaseProtocolContentResultWith:(id)resultData{
    
    NSDictionary * dic = resultData;
    CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:dic];
    if (vo) {
        self.protocolContentCallBack(YES,vo);
    }
    else{
        self.protocolContentCallBack(YES,nil);
    }
    

}

- (void)didParaseUploadPersonMsgResultWith:(id)resultData{
    

}

- (void)didParaseQueryDicResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    NSArray * resultArr = [dic objectForKey:@"resultList"];
    if (resultArr.count) {
        self.commonCallBack(YES,resultArr);
        return;
    }
    self.commonCallBack(YES,nil);

}

- (void)didParaseBranchCommissionResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHBranchVo * vo = [CRHBranchVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }

}

- (void)didParaseBankListResultWith:(id)resultData{
    [self.resultArr removeAllObjects];
    NSDictionary * dic = resultData;
    NSArray * arr = [dic objectForKey:@"resultList"];
    for (NSDictionary * bankDic in arr) {
        CRHBankListVo * vo = [CRHBankListVo generateWithDict:bankDic];
        if ([vo.fun_flag isEqualToString:@"11"] || [vo.fun_flag isEqualToString:@"12"]) {// || [vo.bank_no isEqualToString:@"GHCG"]
            [self.resultArr addObject:vo];
        }
    }

    if (self.resultArr.count) {
        self.commonCallBack(YES,self.resultArr);
    }
    else{
        self.commonCallBack(YES,nil);
    }
}

- (void)didParaseRiskTestPaperResultWith:(id)resultData{
    [self.resultArr removeAllObjects];
    NSDictionary * dic = resultData;
    NSArray * arr = [dic objectForKey:@"resultList"];
    
    NSString * local_paper_id = [dic objectForKey:@"local_paper_id"];
    for (NSDictionary * resultDic in arr) {
        CRHRiskTestVo * vo = [CRHRiskTestVo generateWithDict:resultDic];
        vo.local_paper_id = local_paper_id;
        [self.resultArr addObject:vo];
    }
    if (self.resultArr.count) {
        self.commonCallBack(YES,self.resultArr);
    }
    else{
        self.commonCallBack(YES,nil);
    }

}

- (void)didParaseReturnVisitPaperResultWith:(id)resultData{
    [self.resultArr removeAllObjects];
    NSDictionary * dic = resultData;
    NSArray * arr =  [dic objectForKey:@"resultList"];
    for (NSDictionary * resultDic in arr) {
        CRHRiskTestVo * vo = [CRHRiskTestVo generateWithDict:resultDic];
        [self.resultArr addObject:vo];
    }
    if (self.resultArr.count) {
        self.commonCallBack(YES,self.resultArr);
    }
    else{
        self.commonCallBack(YES,nil);
    }
}

- (void)didParaseRiskTestCommitResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHRiskResultVo * vo = [CRHRiskResultVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }

}

- (void)didParaseRiskTestQueryResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHRiskResultVo * vo = [CRHRiskResultVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }
}

- (void)didParaseRiskResultConfirmWith:(id)resultData{
    NSDictionary * dic = resultData;


}

- (void)didParaseRiskSpecialResultSaveWith:(id)resultData{
    NSDictionary * dic = resultData;

    
}

- (void)didParaseRiskMatchCheckWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHMatchCheckVo * vo = [CRHMatchCheckVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }
}

- (void)didParaseProtocolQueryResultWith:(id)resultData{
    

}


//- (void)didParaseProtocolSignResultWith:(id)resultData{
////    self.protocolSignCallBack
//}

- (void)didParaseCACertQueryResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHCACertVo * vo = [CRHCACertVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }
}

- (void)didParaseUserVedioStatusInfoResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHUserVideoStausInfoVo * vo = [CRHUserVideoStausInfoVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }

}

- (void)didParaseSingleTrackVideoTaskResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHSigleVedioTaskVo * vo = [CRHSigleVedioTaskVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }

}

- (void)didParaseVideoServiceResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    CRHVideoServiceVo * vo = [CRHVideoServiceVo generateWithDict:dic];
    if (vo) {
        self.commonCallBack(YES,vo);
    }
    else{
        self.commonCallBack(YES,nil);
    }

}

- (void)didParaseOpenResultQueryResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    NSDictionary * fund_account = [dic objectForKey:@"fund_account"];
    CRHAccVo * fund = [CRHAccVo generateWithDict:fund_account];
    NSArray * bank_account = [dic objectForKey:@"bank_account"];
    NSMutableArray * bankArr = [NSMutableArray array];
    for (NSDictionary * bDic in bank_account) {
        CRHAccVo * bank = [CRHAccVo generateWithDict:bDic];
        [bankArr addObject:bank];
    }
    NSArray * stock_account = [dic objectForKey:@"stock_account"];
    NSMutableArray * stockArr = [NSMutableArray array];
    for (NSDictionary * sDic in stock_account) {
        CRHAccVo * stock = [CRHAccVo generateWithDict:sDic];
        if ([stock.exchange_kind isEqualToString:@"1"]) {
            [stockArr insertObject:stock atIndex:0];
            continue;
        }
        [stockArr addObject:stock];
    }
    CRHOpenAccResultVo * vo = [[CRHOpenAccResultVo alloc] init];
    vo.fund_account = fund;
    vo.bank_account = bankArr;
    vo.stock_account = stockArr;
    if (fund_account.count) {
        self.commonCallBack(YES,vo);
        return;
    }
    self.commonCallBack(YES,nil);

}

- (void)didParaseQueryClientInfoResultWith:(id)resultData{
    NSDictionary * dic = resultData;
    
    CRHClientInfoVo * vo = [CRHClientInfoVo generateWithDict:dic];
    if (vo) {
        self.clientInfoCallBack(YES,vo);
        return;
    }
    self.clientInfoCallBack(YES,nil);

}

//随机字符串
- (NSString * )randomString{
    NSInteger len = 10;
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}

//签名
- (NSString *)signParam:(NSDictionary *)param{

    NSArray * kArrSort = [param allKeys];
    //按字母排序参数,拼接字符串keyvalue
    NSArray * sortArr = [kArrSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSArray * resultArr = [[sortArr reverseObjectEnumerator] allObjects];
    NSMutableString * sortString = [NSMutableString string];
    for (NSString * key in resultArr) {
        [sortString appendFormat:@"%@%@",key,[param objectForKey:key]];
    }
    
    //拼接appSecret
    [sortString appendString:@"ddc99abb98d03300963dd7ea5d67e1f4"];

    //转换大写
    NSString * upperStr = [sortString uppercaseString];
    
    //md5加密两次
    NSString * sign = [[upperStr MD5] MD5];
    return sign;
}

@end
