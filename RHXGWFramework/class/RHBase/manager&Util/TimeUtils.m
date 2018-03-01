//
//  TimeUtils.m
//  stockscontest
//
//  Created by rxhui on 15-1-30.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TimeUtils.h"

@implementation TimeUtils
+(NSString *)getTimeStringWithLongLongNum:(NSNumber *)timeNum {
    /*时间内容
     *10s内->@"刚刚"
     *59min内->@"59分钟前"
     *超过1小时->@"hh:mm"
     *超过1天->@"MM-dd"
     *超过一年->@"yyyy-MM-dd"
     */
    long long time = timeNum.longLongValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    long long timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
//    NSLog(@"timeInterval = %ld",(long)timeInterval);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *timeString = @"";
    if (timeInterval <= 10) {
        timeString = @"刚刚";
    }
    else if (timeInterval > 10 && timeInterval <= 60) {
        
        timeString = [NSString stringWithFormat:@"1分钟前"];
    }
    else if (timeInterval > 60 && timeInterval < 3600) {
        
        timeString = [NSString stringWithFormat:@"%lld分钟前",timeInterval / 60];
    }
    else if (timeInterval >= 3600 && timeInterval < 3600 * 24) {
        [formatter setDateFormat:@"HH:mm"];
        timeString = [formatter stringFromDate:date];
    }
    else if (timeInterval >= 3600 * 24 && timeInterval < 3600 * 24 * 365) {//暂不考虑闰年
        [formatter setDateFormat:@"MM-dd"];
        timeString = [formatter stringFromDate:date];
    }
    else if (timeInterval >= 3600 * 24 * 365) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
        timeString = [formatter stringFromDate:date];
    }
    
    return timeString;
}

+ (NSString *)getTimeStringWithNumber:(NSNumber *)timeNum formatString:(NSString *)formatterString {
    long long time = timeNum.longLongValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterString];
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}

+(NSString *)getTimeOfMonthStringWithLongLongNum:(NSNumber *)timeNum {
    /*时间内容
     *不足1个月->@"不足1"
     *大于1个月->显示月
     */
    long long time = timeNum.longLongValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    long long timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSString *timeString = @"";
    if (timeInterval < 10 ) {
        timeString = @"0";
    }
    else if (timeInterval <= 30 * 60 * 60 * 24 && timeInterval > 10) {
        timeString = @"不足1";
    }
    else{
        NSInteger time = (NSInteger)timeInterval/(30* 60 * 60 * 24);
        timeString = [NSString stringWithFormat:@"%ld",(long)time];
    }
    
    return timeString;
}
+(NSString *)getHalfYearAgoDateString:(NSInteger)timeNUmber{

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date = [[NSDate alloc] init];
    date = [date dateByAddingTimeInterval:-timeNUmber*3600*24];
        
    NSString *dateString = [formatter stringFromDate:date];
    
    NSLog(@"时间 === %@",dateString);
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    NSLog(@"时间戳 === %@",timeSp);
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSp integerValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"时间 === %@",confromTimespStr);

    
    return timeSp;
    
}

/*
+(NSString *)getTimeAndDateStringWithNumber:(NSNumber *)timeNum  {
    long long time = timeNum.longLongValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}

+(NSString *)getDateStringWithNumber:(NSNumber *)timeNum  {
    long long time = timeNum.longLongValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *timeString = [formatter stringFromDate:date];;
    
    return timeString;
}

+(NSString *)getYearDateStringWithNumber:(NSNumber *)timeNum  {
    long long time = timeNum.longLongValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeString = [formatter stringFromDate:date];;
    
    return timeString;
}
 */

//根据NSString转换成时间戳
+ (NSNumber *)getTimeWithString:(NSString *)timeStr formatString:(NSString *)formatterString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSDate * date = [formatter dateFromString:timeStr];
    NSTimeInterval timNum = [date timeIntervalSince1970] *1000;
    return [NSNumber numberWithInteger:timNum];
    
}

//获取两个时间段相差的天数
+(int)getTimeDifference:(NSString *)beforeTime with:(NSString *)afterTime{
    
    beforeTime = [NSString stringWithFormat:@"%@",beforeTime];
    afterTime = [NSString stringWithFormat:@"%@",afterTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *beforeTimeDate;
    NSDate *afterTimeDate;
    NSString *beforeStr;
    NSString *afterStr;
    
    //如果传进来的是时间戳
    if ([beforeTime rangeOfString:@"-"].location == NSNotFound) {
        
        if (beforeTime.length == 13  && afterTime.length == 13) {
            
            afterTime = [afterTime substringToIndex:10];
            beforeTime = [beforeTime substringToIndex:10];
        }
        
        //时间戳转换成标准时间
        beforeTimeDate = [NSDate dateWithTimeIntervalSince1970:[beforeTime integerValue]];
        afterTimeDate = [NSDate dateWithTimeIntervalSince1970:[afterTime integerValue]];
        
        beforeStr = [formatter stringFromDate:beforeTimeDate];
        afterStr = [formatter stringFromDate:afterTimeDate];
        
        beforeTime = beforeStr;
        afterTime = afterStr;
    }
    
    NSDate *date1 = [formatter dateFromString:beforeTime];
    NSDate *date2 = [formatter dateFromString:afterTime];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    int hour = (int)(aTimer/3600);
    //    int minute = (int)(aTimer-hour*3600)/60;
    int day = (int)(hour/24);
    return day;
}

//一个日期之后多少天的日期
+(NSString *)getAfterDay:(NSString *)time with:(NSInteger)daysNumber{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *nowDate = [formatter dateFromString:time];
    
    NSTimeInterval  oneDay = 24*60*60*1;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    
    NSInteger number = [timeSp integerValue] + oneDay*daysNumber;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:number];
    
    NSString *afterTime = [formatter stringFromDate:confromTimesp];
    
//    NSLog(@"%@  %ld天之后的时间是 %@",time,(long)daysNumber,afterTime);
    
    return afterTime;
}
@end
