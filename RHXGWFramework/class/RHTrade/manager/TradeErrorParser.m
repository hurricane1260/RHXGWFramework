//
//  TradeErrorParser.m
//  stockscontest
//
//  Created by rxhui on 15/6/24.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeErrorParser.h"
#import "TradeSessionManager.h"

@implementation TradeErrorParser

//error_no:-61, error_info:[120047][客户交易密码错误][p_fund_account=70000085], error_id:, error_svrno:
//@">[^<]+<"
//@"\\$[^\\$]+\\$"
+(NSString *)parseTradeErrorWithData:(id)data {
    NSString *errorString = data;
    NSString *retString = nil;
//    NSString *parten = @"[\u4e00-\u9fa5][\u4e00-\u9fa5]+";
    NSString *parten = @"\\[[^\\]]+\\]";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray* match = [regex matchesInString:errorString options:NSMatchingReportCompletion range:NSMakeRange(0, errorString.length)];
    for (int i = 0; i < match.count; i++) {
        if (i == 1) {
            NSTextCheckingResult *result = [match objectAtIndex:i];
            NSRange subRange = result.range;
            if (subRange.location == NSNotFound) {
                NSLog(@"未发现匹配的错误信息");
                break;
            }
            retString = [errorString substringWithRange:NSMakeRange(subRange.location + 1, subRange.length - 2)];
            if ([retString hasSuffix:@"转发错误"]) {
                retString = [retString substringWithRange:[retString rangeOfString:@"转发错误"]];
            }
            break;
        }
        else {
            continue;
        }
    }
//    for(NSTextCheckingResult *result in match){
//        NSRange subRange = result.range;
//        retString = [errorString substringWithRange:subRange];
//        break;
//    }
    if (!retString) {
        if ([data isEqualToString:@"too many request in a minute"]) {
            data = @"您的请求太过频繁，请稍后再请求";
        }
        return data;
    }
    
    if ([retString rangeOfString:@"重新登陆"].location != NSNotFound || [retString rangeOfString:@"会话超时"].location != NSNotFound ) {
        [TradeSessionManager shareInstance].sessionID = nil;
        [[TradeSessionManager shareInstance] setOnLine:NO];
    }
    
    return retString;
}
@end
