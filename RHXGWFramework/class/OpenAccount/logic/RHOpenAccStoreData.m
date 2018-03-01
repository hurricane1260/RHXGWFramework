//
//  RHOpenAccStoreData.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/17.
//
//

#import "RHOpenAccStoreData.h"
#import "RHBaseVO.h"
#import "OARequestManager.h"
#import "CRHUserStatusVo.h"
#import "MNNavigationManager.h"

@interface RHOpenAccStoreData ()

kRhPCopy NSString * cachePath;

kRhPCopy NSString * indexPath;

kRhPStrong OARequestManager * statusManager;
@end

static RHOpenAccStoreData * _instance;

@implementation RHOpenAccStoreData

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[RHOpenAccStoreData alloc] init];
    });
    
    return _instance;
}

+ (void)saveOpenAccountData:(id)data withPath:(NSString *)path{
    if (!data || !path.length) {
        return;
    }
    //    self.indexPath = path;

    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * savePath = [cachPath stringByAppendingPathComponent:path];
    
    [NSKeyedArchiver archiveRootObject:data toFile:savePath];

}

+ (id)loadOpenAccountDataWithPath:(NSString *)path{
//    self.indexPath = path;
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * savePath = [cachPath stringByAppendingPathComponent:path];
    
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:savePath];
    
    return  data;
}

+ (void)storeOpenAccCachUserInfo:(id)value withKey:(NSString *)key{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * storeDic;
    if ([defaults objectForKey:@"openAccount"]) {
        storeDic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"openAccount"]];
        
        if ([key isEqualToString:@"client_id"]) {
            if ([storeDic objectForKey:@"client_id"]) {
                NSString * preClient_id = [storeDic objectForKey:@"client_id"];
                if (![value isEqualToString:preClient_id]) {
                    [storeDic removeAllObjects];
                }
            }
        }
    }
    else{
        storeDic = [NSMutableDictionary dictionary];
    }
    if ([value isKindOfClass:[RHBaseVO class]]) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:value];
        [storeDic setObject:data forKey:key];
    }
    else{
        [storeDic setObject:value forKey:key];
    }
    [defaults setObject:storeDic forKey:@"openAccount"];
    [defaults synchronize];

}

+ (id)getOpenAccCachUserInfoWithKey:(NSString *)key{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * storeDic = [defaults objectForKey:@"openAccount"];
    if (!storeDic.count) {
        return nil;
    }
    if (![storeDic objectForKey:key]) {
        return nil;
    }
    id value = [storeDic objectForKey:key];
    if ([value isKindOfClass:[NSData class]]) {
        RHBaseVO * vo = [NSKeyedUnarchiver unarchiveObjectWithData:value];
        return vo;
    }
    return value;
}

+ (void)clearOpenAccCachUserInfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"openAccount"];
    [defaults synchronize];

}

+ (void)clearOpenAccCachWithKey:(NSString *)key{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
     NSMutableDictionary * storeDic;
    if ([defaults objectForKey:@"openAccount"]) {
        storeDic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"openAccount"]];
        if ([storeDic objectForKey:key]) {
            [storeDic removeObjectForKey:key];
            [defaults setObject:storeDic forKey:@"openAccount"];
            [defaults synchronize];
        }
    }
}

- (OARequestManager *)statusManager{
    if (!_statusManager) {
        _statusManager = [[OARequestManager alloc] init];
    }
    return _statusManager;
}

//通用导航逻辑
+ (void)requestUserStatus:(UIViewController *)currentVC{
    [RHOpenAccStoreData cancelRequestStatus];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString * client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    [param setObject:client_id    forKey:@"client_id"];

    [_instance.statusManager sendCommonRequestWithParam:param withRequestType:kQueryUserStatus withUrlString:@"crhOpenAccStatusQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHUserStatusVo class]]) {
                return;
            }
            
            CRHUserStatusVo * vo = resultData;
            if (vo.risk_serial_no.length) {
                [RHOpenAccStoreData storeOpenAccCachUserInfo:vo.risk_serial_no withKey:kOpenAccountRiskTest];
            }
            
            //open_status状态位：0证件照上传、1基本资料提交、2视频见证完成、3协议已签署、4账户设置、5存管设置、6暂未定义、7风险问卷、8回访设置、9密码设置
            NSString * status = vo.open_status;
            NSString * risk_eval_finished = vo.risk_eval_finished;
            if (status.length != 10) {
                return;
            }
            BOOL shouldContinue = NO;
            NSMutableArray * statusArr = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray * errorArr = [NSMutableArray array];
            for (int i = 0; i < status.length; i++) {
                NSString * str = [status substringWithRange:NSMakeRange(i, 1)];
                [statusArr addObject:str];
                if ([str integerValue] != 0 && [str integerValue] != 1 && i != 2) {
                    //异常
                    [errorArr addObject:[NSNumber numberWithInteger:i]];
                    continue;
                }
                else if([str integerValue] != 0 && [str integerValue] != 1 && [str integerValue] != 2 && i == 2){
                    [errorArr addObject:[NSNumber numberWithInteger:i]];
                    continue;
                }
                
                if ([str integerValue] == 0 && i != 2) {
                    shouldContinue = YES;
                }
                else if([str integerValue] != 2 && i == 2){
                    shouldContinue = YES;
                }
            }
            if (errorArr.count) {
//                //跳审核结果页
//                NSMutableString * reason;
//                if (errorArr.count == 1) {
//                    //只有一个错误原因的时候直接替换即可
//                    reason = [NSMutableString stringWithString:[vo.resultComment stringByReplacingOccurrencesOfString:@"," withString:@""]];
//                }
//                else{
//                    //多个原因的时候需要切割处理
//                    NSArray * arr = [vo.resultComment componentsSeparatedByString:@","];
//                    reason = [NSMutableString string];
//                    for (NSString * str in arr) {
//                        if (str.length > 1) {
//                            if (reason.length < 8) {//复核未通过 :（长度7位）
//                                [reason appendString:str];
//                            }
//                            else{
//                                [reason appendFormat:@"，%@",str];
//                            }
//                        }
//                    }
//                }
//
//                NSMutableDictionary * param = [NSMutableDictionary dictionary];
//                [param setObject:@1 forKey:@"resultType"];
//                [param setObject:errorArr forKey:@"errorArr"];
//                if (reason.length) {
//                    [param setObject:reason forKey:@"errorReason"];
//                }
//                [RHOpenAccStoreData clearOpenAccCachWithKey:kOpenAccountRectify];
//
//                [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHOpenAccResultController" withParam:param];
//                return;
                //open_status状态位：0证件照上传、1基本资料提交、2视频见证完成、3协议已签署、4账户设置、5存管设置、6暂未定义、7风险问卷、8回访设置、9密码设置
                NSString * class = @"";
                if ([errorArr containsObject:@0]) {
                    class = @"RHIDCardController";
                }
                else if ([errorArr containsObject:@1]){
                    class = @"OAPersonalInfoConfirmController";
                }
                else if ([errorArr containsObject:@7]){
                    class = @"RHRiskEvaluationController";
                }
                else if ([errorArr containsObject:@4] || [errorArr containsObject:@9] || [errorArr containsObject:@3]){
                    class = @"RHAccountPasswordController";
                }
                else if ([errorArr containsObject:@5]){
                    class = @"RHBankCardBindController";
                }
                else if ([errorArr containsObject:@2]){
                    class = @"RHReadyToRECController";
                }
                else if ([errorArr containsObject:@8]){
                    class = @"RHQuestionRevisitController";
                }
                
                if (class.length) {
                    [RHOpenAccStoreData storeOpenAccCachUserInfo:errorArr withKey:kOpenAccountRectify];
                    NSMutableDictionary * param = [NSMutableDictionary dictionary];
                    [param setObject:@1 forKey:kOpenAccountRectify];
                    [MNNavigationManager navigationToUniversalVC:currentVC withClassName:class withParam:param];
                    return;
                }
                
            }
            
            if ([risk_eval_finished integerValue] == 0) {
                shouldContinue = YES;
            }
            if (!shouldContinue) {
                //全部流程已进行 申请开户
                [RHOpenAccStoreData clearOpenAccCachWithKey:kOpenAccountRectify];

                [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHOpenAccResultController" withParam:nil];
                return;
            }
            
            [statusArr exchangeObjectAtIndex:2 withObjectAtIndex:7];
            
            BOOL stop = NO;
            for (int i = 0; i < statusArr.count; i++) {
                if (stop) {
                    break;
                }
                NSString * str = statusArr[i];
                if ([str integerValue] == 1 && i != 7) {
                    continue;
                }
                else if ([str integerValue] == 2 && i == 7){
                    continue;
                }
                
                NSMutableDictionary * param = [NSMutableDictionary dictionary];
                [param setObject:@1 forKey:kOpenAccountRectify];
                //open_status状态位：证件照上传0、基本资料提交1、风险问卷2、协议已签署3、账户设置4、存管设置5、暂未定义6、视频见证完成7、回访设置8、密码设置9
                switch (i) {
                    case 0:
                    case 1:{
                        //跳基本资料 还是跳身份证上传
                        [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHIDCardController" withParam:param];
                        stop = YES;
                    }break;
                    case 2:{
                        //风险测评
                        [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHRiskEvaluationController" withParam:param];
                        stop = YES;
                    }break;
                    case 3:
                    case 4:
                    case 9:
                    {
                        if ([risk_eval_finished integerValue] == 0) {
                            //跳风险结果页
                            [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHRiskTestResultController" withParam:param];
                            
                            stop = YES;
                        }else{
                            //跳账户与密码
                            [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHAccountPasswordController" withParam:param];
                            stop = YES;
                        }
                    }break;
                    case 5:{
                        //跳存管设置
                        [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHBankCardBindController" withParam:param];
                        stop = YES;
                    }break;
                    case 7:{
                        // 是否确认风险测评结果 未确认需要先确认
                        if ([risk_eval_finished integerValue] == 0) {
                            //跳风险结果页
                            [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHRiskTestResultController" withParam:param];
                            stop = YES;
                        }else{
                            [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHReadyToRECController" withParam:nil];
                            stop = YES;
                        }
                    }break;
                    case 8:
                    {
                        //回访问卷
                        [MNNavigationManager navigationToUniversalVC:currentVC withClassName:@"RHQuestionRevisitController" withParam:nil];
                        stop = YES;
                    }break;
                    default:
                        break;
                }
            }
        }
        
    }];
    
}

+ (void)cancelRequestStatus{
    _instance = [RHOpenAccStoreData shareManager];
    [_instance.statusManager cancelAllDelegate];
    
}

@end
