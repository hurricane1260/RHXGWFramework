//
//  NSString+RXJX_Inc.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "NSString+RXJX_Inc.h"

@implementation NSString (RXJX_Inc)

+(NSString *)didBuildImageNameWithUrlString:(NSString *)urlString{
    if(urlString.length == 0){
        return nil;
    }
    NSRange range = [urlString rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.location != NSNotFound){
        NSRange nameRange = NSMakeRange(range.location + 1, urlString.length - range.location - 1);
        NSString *aImgName = [urlString substringWithRange:nameRange];
        return aImgName;
    }
    return nil;
}

+(NSString *)formatDecimalStyleWith:(NSNumber *)num withSuffix:(NSString *)suffix maximumFractionDigits:(int)mumFractionDigits{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = mumFractionDigits;
    formatter.minimumFractionDigits = mumFractionDigits;
    NSString *string = [formatter stringFromNumber:num];
    string = [string stringByAppendingFormat:@"%@", suffix];
    return string;
}

- (NSInteger)indexOf:(NSString *)text
{
    NSRange range = [self rangeOfString:text];
    if (range.length > 0) {
        return range.location;
    } else {
        return -1;
    }
}
//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL||[string isEqualToString:@"(null)"]||[string isEqualToString:@"null"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//如果字符串为空返回空的字符串
+(NSString *)ifStringisNull:(NSString *)string{
    if ([NSString isBlankString:string]) {
        return @"";
    }
    return string;
}
//字符串中去除空格
+(NSString *)trim:(NSString *)source{
    if(source.length <= 0){
        
        return source;
    }
    NSString *retString = [source  stringByReplacingOccurrencesOfString:@" " withString:@""];
    return retString;
}
+(NSString *)tradeRemindString:(NSString *)string
{
    NSString * result;
    if ([string rangeOfString:@"当前时间不允许委托"].location != NSNotFound) {
        result = @"请在交易日09:15-15:00进行该操作";
    } else if ([string rangeOfString:@"存管预指定客户不允许证券转银行"].location != NSNotFound) {
        result = @"请先登入您开户时所绑定银行的网银，进行第一笔银证转账。或详询客服 400-088-5558";
    } else if ([string rangeOfString:@"指定标志不对或者在委托托管股票类别不是X"].location != NSNotFound) {
        result = @"当日开户，下个交易日才能买入股票";
    } else if ([string rangeOfString:@"必须有j权限才能做创业板交易"].location != NSNotFound) {
        result = @"无创业板交易权限，办理该业务请详询 400-088-5558";
    } else if ([string rangeOfString:@"证券帐户表记录不存在"].location != NSNotFound) {
        result = @"您没有开通深圳股东账户，无法交易深市个股，办理该业务请详询 400-088-5558";
    } else if ([string rangeOfString:@"上海的未指定户或者在委托托管股票类别不是X"].location != NSNotFound) {
        result = @"上海指定交易失败，请联系客服帮您处理，客服电话 400-088-5558";
    } else if ([string rangeOfString:@"有股东限制"].location != NSNotFound) {
        result = @"当日开户，下个交易日才能买入股票";
    } else if ([string rangeOfString:@"禁止在当前系统使用"].location != NSNotFound) {
        result = @"请在交易日09:00-16:00进行银证转账";
    } else if ([string rangeOfString:@"非工作时间"].location != NSNotFound) {
        result = @"请在交易日09:00-16:00进行该操作";
    } else if ([string rangeOfString:@"客户风险级别不允许开通风险警示业务"].location != NSNotFound){
        result = @"您的风险级别不允许开通风险警示业务，请点击右上角“掌厅”重新测评。";
    }
    else {
        result = string;
    }
    return result;
}
//换算成万
+(NSString *)moneyTenThousandConvertWithString:(NSString *)string{
    CGFloat money = 0.0;
    NSInteger number = [string integerValue];
    NSString * numStr = [NSString stringWithFormat:@"%ld",(long)number];
    
    if (numStr.length>=5) {
        money = [string floatValue]/10000;
        return [NSString stringWithFormat:@"%.2f万",money];
        
    }else{
        return [NSString stringWithFormat:@"%.2f",[string floatValue]] ;
        
    }
}

@end
