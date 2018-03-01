//
//  TimeUtils.h
//  stockscontest
//
//  Created by rxhui on 15-1-30.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtils : NSObject
/**
 *毫秒数->特定格式
 *10s内->@"刚刚"
 *59min内->@"59分钟前"
 *超过1小时->@"hh:mm"
 *超过1天->@"MM-dd"
 *超过一年->@"yyyy-MM-dd"
 */
+(NSString *)getTimeStringWithLongLongNum:(NSNumber *)timeNum;

/**
 *  把毫秒数转成特定格式的字符串
 *
 *  @param timeNum 毫秒数
 *  @param formatterString 时间格式字符串，如@"yyyy/MM/dd HH:mm"
 *
 *  @return 时间日期字符串
 */
+(NSString *)getTimeStringWithNumber:(NSNumber *)timeNum formatString:(NSString *)formatterString;

+(NSString *)getTimeOfMonthStringWithLongLongNum:(NSNumber *)timeNum;

//获取多少天前的时间戳
+(NSString *)getHalfYearAgoDateString:(NSInteger)timeNUmber;

//根据NSString转换成时间戳
+ (NSNumber *)getTimeWithString:(NSString *)timeStr formatString:(NSString *)formatterString;

+(int)getTimeDifference:(NSString *)beforeTime with:(NSString *)afterTime;

+(NSString *)getAfterDay:(NSString *)time with:(NSInteger)daysNumber;
@end
