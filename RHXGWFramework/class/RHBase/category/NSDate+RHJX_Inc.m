//
//  NSDate+RHJX_Inc.m
//  iphone-pay
//
//  Created by 方海龙 on 13-10-25.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import "NSDate+RHJX_Inc.h"

@implementation NSDate (RHJX_Inc)

+(NSString *)formatWithNumber:(NSNumber *)aNumber formatString:(NSString *)formatString{
    NSTimeInterval interval = [aNumber doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    NSString *resultString = [formatter stringFromDate:date];
    return resultString;
}

+(NSString *)formatWithTimeInterval:(NSTimeInterval)interval formatString:(NSString *)formatString{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    NSString *resultString = [formatter stringFromDate:date];
    return resultString;
}

+(long long)getSystemTime
{
    double time = [[NSDate date] timeIntervalSince1970];
    return time * 1000;
}

- (int)yyyyMMddFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *strValue = [formatter stringFromDate:self];
    return strValue.intValue;
}

- (NSString *)stringWithyyyyMMddFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *strValue = [formatter stringFromDate:self];
    return strValue;
}

- (NSString *)yyyy_MM_ddFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *strValue = [formatter stringFromDate:self];
    return strValue;
}

//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data/1000];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

//存在时区差 获取当前时区时间
+ (NSDate *)currentDate{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date  dateByAddingTimeInterval:interval];
    return localDate;
}

- (NSDate *)transDateToCurrentDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *localDate = [self  dateByAddingTimeInterval:interval];
    return localDate;

}
+(NSDate *)pastDateAndAfterDateWithCurrentDate:(NSDate *)currentDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitHour|NSCalendarUnitDay fromDate:currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
    return newdate;
    
}

@end
