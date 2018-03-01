//
//  NSDate+RHJX_Inc.h
//  iphone-pay
//
//  Created by 方海龙 on 13-10-25.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RHJX_Inc)

+(NSString *)formatWithNumber:(NSNumber *)aNumber formatString:(NSString *)formatString;

+(NSString *)formatWithTimeInterval:(NSTimeInterval)interval formatString:(NSString *)formatString;
/// 返回当前毫秒数时间
+(long long)getSystemTime;

/// 返回“yyyyMMdd”格式的整形数字
- (int)yyyyMMddFormat;

/// 返回“yyyy-MM-dd”格式的字符串
- (NSString *)yyyy_MM_ddFormat;

// 返回“yyyyMMdd”格式的字符串
- (NSString *)stringWithyyyyMMddFormat;

//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data;

+ (NSDate *)currentDate;

- (NSDate *)transDateToCurrentDate;
//根据当前时间 返回过去和以后的时间  传入正数是以后的时间 负数相反
+(NSDate *)pastDateAndAfterDateWithCurrentDate:(NSDate *)currentDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end
