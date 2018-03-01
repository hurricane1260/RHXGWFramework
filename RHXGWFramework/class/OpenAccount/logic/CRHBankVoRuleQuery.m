//
//  CRHBankVoRuleQuery.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 2017/9/26.
//

#import "CRHBankVoRuleQuery.h"

@interface CRHBankVoRuleQuery ()

kRhPStrong NSMutableDictionary * fun_flagDic;

kRhPStrong NSMutableDictionary * bank_noDic;

kRhPStrong NSMutableDictionary * econtract_idDic;

@end

static CRHBankVoRuleQuery * instance;

@implementation CRHBankVoRuleQuery

+ (CRHBankVoRuleQuery *)shareInstance{
    
    @synchronized(self) {
        if (instance == nil)
        {
            instance = [[CRHBankVoRuleQuery alloc] init];
        }
    }
    return instance;
}

- (NSMutableDictionary *)fun_flagDic{
    if (!_fun_flagDic) {
        _fun_flagDic = [NSMutableDictionary dictionary];
        [_fun_flagDic setObject:@"11" forKey:@"光大银行"];
        [_fun_flagDic setObject:@"12" forKey:@"建设银行"];
        [_fun_flagDic setObject:@"12" forKey:@"交通银行"];
        [_fun_flagDic setObject:@"11" forKey:@"农业银行"];
        [_fun_flagDic setObject:@"11" forKey:@"浦发银行"];
        [_fun_flagDic setObject:@"11" forKey:@"平安银行"];
        [_fun_flagDic setObject:@"11" forKey:@"兴业银行"];
        [_fun_flagDic setObject:@"11" forKey:@"上海银行"];
        [_fun_flagDic setObject:@"11" forKey:@"招商银行"];
        [_fun_flagDic setObject:@"11" forKey:@"中信银行"];
        [_fun_flagDic setObject:@"12" forKey:@"中国银行"];
        [_fun_flagDic setObject:@"11" forKey:@"民生银行"];
        [_fun_flagDic setObject:@"11" forKey:@"邮政储蓄"];
        [_fun_flagDic setObject:@"12" forKey:@"广发银行"];
        [_fun_flagDic setObject:@"12" forKey:@"工商银行"];
        [_fun_flagDic setObject:@"11" forKey:@"宁波银行"];
    }
    return _fun_flagDic;
}

- (NSMutableDictionary *)bank_noDic{
    if (!_bank_noDic) {
        _bank_noDic = [NSMutableDictionary dictionary];
        [_bank_noDic setObject:@"GDCG" forKey:@"光大银行"];
        [_bank_noDic setObject:@"JHCG" forKey:@"建设银行"];
        [_bank_noDic setObject:@"JTCG" forKey:@"交通银行"];
        [_bank_noDic setObject:@"NHCG" forKey:@"农业银行"];
        [_bank_noDic setObject:@"PFCG" forKey:@"浦发银行"];
        [_bank_noDic setObject:@"SFCG" forKey:@"平安银行"];
        [_bank_noDic setObject:@"XYCG" forKey:@"兴业银行"];
        [_bank_noDic setObject:@"SHCG" forKey:@"上海银行"];
        [_bank_noDic setObject:@"ZSCG" forKey:@"招商银行"];
        [_bank_noDic setObject:@"ZXCG" forKey:@"中信银行"];
        [_bank_noDic setObject:@"ZHCG" forKey:@"中国银行"];
        [_bank_noDic setObject:@"MSCG" forKey:@"民生银行"];
        [_bank_noDic setObject:@"YCCG" forKey:@"邮政储蓄"];
        [_bank_noDic setObject:@"GFCG" forKey:@"广发银行"];
        [_bank_noDic setObject:@"GHCG" forKey:@"工商银行"];
        [_bank_noDic setObject:@"NBCG" forKey:@"宁波银行"];
    }
    return _bank_noDic;
}

- (NSMutableDictionary *)econtract_idDic{
    if (!_econtract_idDic) {
        _econtract_idDic = [NSMutableDictionary dictionary];
        [_econtract_idDic setObject:@"10074" forKey:@"光大银行"];
        [_econtract_idDic setObject:@"10061" forKey:@"建设银行"];
        [_econtract_idDic setObject:@"10072" forKey:@"交通银行"];
        [_econtract_idDic setObject:@"10060" forKey:@"农业银行"];
        [_econtract_idDic setObject:@"10075" forKey:@"浦发银行"];
        [_econtract_idDic setObject:@"10093" forKey:@"平安银行"];
        [_econtract_idDic setObject:@"10059" forKey:@"兴业银行"];
        [_econtract_idDic setObject:@"10094" forKey:@"上海银行"];
        [_econtract_idDic setObject:@"10058" forKey:@"招商银行"];
        [_econtract_idDic setObject:@"10057" forKey:@"中信银行"];
        [_econtract_idDic setObject:@"10062" forKey:@"中国银行"];
        [_econtract_idDic setObject:@"10096" forKey:@"民生银行"];
        [_econtract_idDic setObject:@"10097" forKey:@"邮政储蓄"];
        [_econtract_idDic setObject:@"10121" forKey:@"广发银行"];
        [_econtract_idDic setObject:@"10064" forKey:@"工商银行"];
        [_econtract_idDic setObject:@"10120" forKey:@"宁波银行"];
    }
    return _econtract_idDic;
}

+ (NSString *)queryBankInfoWithKey:(NSString *)key withBankName:(NSString *)bankName{
    CRHBankVoRuleQuery * query = [CRHBankVoRuleQuery shareInstance];
    if ([key isEqualToString:@"fun_flag"]) {
        if ([query.fun_flagDic objectForKey:bankName]) {
            NSString * value = [query.fun_flagDic objectForKey:bankName];
            return value;
        }
    }
    else if ([key isEqualToString:@"bank_no"]){
        if ([query.bank_noDic objectForKey:bankName]) {
            NSString * value = [query.bank_noDic objectForKey:bankName];
            return value;
        }
    }
    else if ([key isEqualToString:@"econtract_id"]){
        if ([query.econtract_idDic objectForKey:bankName]) {
            NSString * value = [query.econtract_idDic objectForKey:bankName];
            return value;
        }
    }
    return nil;
}

+ (BOOL)isSupportBank:(NSString *)bankName{
    NSArray * bankArr = @[@"光大银行",@"建设银行",@"交通银行",@"农业银行",@"浦发银行",@"浦东发展",@"平安银行",@"兴业银行",@"上海银行",@"招商银行",@"中信银行",@"中国银行",@"民生银行",@"邮政储蓄",@"广发银行",@"工商银行",@"宁波银行",@"广东发展"];
    for (NSString * bank in bankArr) {
        if ([bank containsString:bankName] || [bankName containsString:bank] || [bank isEqualToString:bankName]) {
            return YES;
        }
    }
    return NO;
}


@end
