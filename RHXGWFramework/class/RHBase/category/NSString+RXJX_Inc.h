//
//  NSString+RXJX_Inc.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RXJX_Inc)

+(NSString *)didBuildImageNameWithUrlString:(NSString *)urlString;

+(NSString *)formatDecimalStyleWith:(NSNumber *)num withSuffix:(NSString *)suffix maximumFractionDigits:(int)mumFractionDigits;

- (NSInteger) indexOf:(NSString *)text;
//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string;
+(NSString *)ifStringisNull:(NSString *)string;
//去除空格
+(NSString *)trim:(NSString *)source;
//交易提示语替换
+(NSString *)tradeRemindString:(NSString *)string;
//换算成万 123456 = 12.34万   1234 = 1234 小于万的则不换算
+(NSString *)moneyTenThousandConvertWithString:(NSString *)string;

@end
