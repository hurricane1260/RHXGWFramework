//
//  NSStringUtilFor@.m
//  stockscontest
//
//  Created by rxhui on 15-1-22.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "NSStringUtilFor@.h"

@implementation NSStringUtilFor_

#pragma  mark -------------------------公开方法-----------------------------

//加链接
+(NSString *)addHrefForAtWithString:(NSString *)string andUserId:(NSString *)userId{
    NSMutableString *mutaString = [string mutableCopy];
    NSRange rangeOfAt = [string rangeOfString:@"@"];
    //回复<a href='/profile.do?uid=152659' target='_blank'>@可乐</a>:OK
    NSString *subString = [NSString stringWithFormat:@"<a href='/profile.do?uid=%@' target='_blank'>",userId];
    [mutaString insertString:subString atIndex:rangeOfAt.location];
    
    NSRange rangeOfColon = [mutaString rangeOfString:@":"];
    [mutaString insertString:@"</a>" atIndex:rangeOfColon.location];
//    NSLog(@"%@",mutaString);
    return mutaString.copy;
}

//去回复@xx：
+(NSString *)getSubStringWithoutRecomment:(NSString *)string{
    NSRange range = [string rangeOfString:@":"];
    if (range.location == NSNotFound || range.length == NSNotFound) {
        return string;
    }
    return [string substringFromIndex:range.location + range.length];
}

//根据字典的key返回@xx的checkResults
+(NSMutableArray *)getCheckingResultsWithString:(NSString *)string andNamesAndUserIdsDic:(NSMutableDictionary *)dictionary{
//    NSLog(@"string%@",string);
    if (!string) {
        return nil;
    }
    NSMutableArray *matches = [NSMutableArray array];
    for (id key in dictionary) {
        NSString *partenName = [NSString stringWithFormat:@"%@",key];
        if ([partenName hasPrefix:@"$"]) {
            continue;
        }
//        NSLog(@"1-parten-%@",parten);
        NSError* error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:partenName options:NSRegularExpressionCaseInsensitive  error:&error];
        NSArray* match = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
//        NSLog(@"2---%@",match);
        [matches addObjectsFromArray:match];
    }
    return matches;
}

//根据字典的key返回需要加蓝的range
+(NSMutableArray *)getRangesOfTouchableWithString:(NSString *)string andNamesAndUserIdsDic:(NSMutableDictionary *)dictionary{
//    NSLog(@"2%@",dictionary);
    
    NSMutableArray *ranges = [NSMutableArray array];//所有需要显示为蓝色的range
    NSMutableArray *match = [NSStringUtilFor_ getCheckingResultsWithString:string andNamesAndUserIdsDic:dictionary];//@xx的range
//    NSLog(@"2%@",match);
    for(NSTextCheckingResult *result in match){
//        NSLog(@"3%@",[NSValue valueWithRange:result.range]);
        [ranges addObject:[NSValue valueWithRange:result.range]];
    }
    NSMutableArray *poundRanges = [NSStringUtilFor_ getRangesOfBlueAreaWithString:string];
    [ranges addObjectsFromArray:poundRanges];
//    NSLog(@"4%@",ranges);
    return ranges;
}

//在原来的基础上，加上##$$的匹配range
+(NSMutableArray *)getRangesOfBlueAreaWithString:(NSString *)string {
    NSMutableArray *ranges = [NSMutableArray array];
    
    if (!string) {
        return nil;
    }
    
    NSString *parten = @"#[^#]+#";
    NSError* error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray* match = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    for(NSTextCheckingResult *result in match){
        NSRange subRange = result.range;
        [ranges addObject:[NSValue valueWithRange:subRange]];
    }
    
    parten = @"\\$[^\\$]+\\$";
    regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    match = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    for(NSTextCheckingResult *result in match){
        NSRange subRange = result.range;
        [ranges addObject:[NSValue valueWithRange:subRange]];
    }
    
//    NSLog(@"--%@-%@",ranges,string);
    
    return ranges;
}

//返回用户id的字典
+(NSMutableDictionary *)getNickNamesAndUserIdsFromString:(NSString *)string {
//    NSLog(@"%@",string);
    NSMutableArray *nickNames = [NSMutableArray array];
    NSMutableArray *userIDs = [NSMutableArray array];
    NSArray *tempArr = [string componentsSeparatedByString:@">"];
    
    for (NSString *str in tempArr) {
        if ([str hasPrefix:@"@"]) {//带@的部分，取nickName
            NSArray *temp1 = [str componentsSeparatedByString:@"@"];
            if (temp1.count < 2) {
                continue;
            }
            NSArray *temp2 = [[temp1 objectAtIndex:1] componentsSeparatedByString:@"<"];
            if (temp2.count < 1) {
                continue;
            }
            [nickNames addObject:[NSString stringWithFormat:@"@%@",[temp2 objectAtIndex:0]]];
        }
        else {//带uid的部分，取uid
            NSArray *temp1 = [str componentsSeparatedByString:@"uid="];//第二部分开头
            
            if (temp1.count >= 2) {
                NSArray *temp2 = [temp1[1] componentsSeparatedByString:@"'"];
                if (temp2.count < 1) {
                    continue;
                }
                [userIDs addObject:[temp2 objectAtIndex:0]];
            }
        }
    }

    if (userIDs.count == 0 || nickNames.count == 0) {
        return nil;
    }
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    for (int i = 0 ; i < nickNames.count; i++) {
        [returnDic setValue:[userIDs objectAtIndex:i] forKey:[nickNames objectAtIndex:i]];
    }
//    NSLog(@"%@",returnDic);

    return returnDic;
}



/**
 *传入字符串，返回@ ## $$ href的键值对
 */
+(NSMutableDictionary *)getInfoDictionaryFromString:(NSString *)string{
    //1.保存用户id
    NSMutableDictionary *userDic = [NSStringUtilFor_ getNickNamesAndUserIdsFromString:string];
    NSMutableDictionary *retDic = nil;
    if (userDic) {
        retDic = [NSMutableDictionary dictionaryWithDictionary:userDic];
    }
    else {
        retDic = [NSMutableDictionary dictionary];
    }
//    NSLog(@"1%@",retDic);
    //#秀实盘# <a href='/weibo/share.do?user_id=891&keywords=601700' target='_blank'>$风范股份(601700)$</a>
    //2.保存股票代码
    NSMutableDictionary *stockDic = [NSStringUtilFor_ getStockCodeAndStockNameFromString:string];
    if (stockDic) {
        [retDic addEntriesFromDictionary:stockDic];
    }
//    NSLog(@"2%@",retDic);
    //3.保存普通超链接
    NSMutableDictionary *hrefDic = [NSStringUtilFor_ getNormalHrefLinkFromString:string];
    if (hrefDic) {
        [retDic addEntriesFromDictionary:hrefDic];
    }
    
//    NSLog(@"3%@%@",retDic,string);
    return retDic;
}

//返回去超链接的string
+(NSString *)getSubStringWithoutHref:(NSString *)string {
//    NSLog(@"%@", string);
    NSString *originalString = [NSString stringWithFormat:@"%@",string];
    NSMutableArray *retStrings = [NSMutableArray array];
    
    if(!originalString){
        return nil;
    }
    
    //取头
    NSRange firstRange = [originalString rangeOfString:@"<"];
    if (firstRange.location > originalString.length) {//没找到，说明不是html的tag，直接返回
        return originalString;
    }
    NSString *firstString = [originalString substringWithRange:NSMakeRange(0 , firstRange.location)];
    [retStrings addObject:firstString];
    
    //中间
    NSString *parten = @">[^<]+<";
    NSError* error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray* math = [regex matchesInString:originalString options:NSMatchingReportCompletion range:NSMakeRange(0, originalString.length)];
    for(NSTextCheckingResult *result in math){
        NSRange subRange = result.range;
        if (subRange.location > originalString.length) {
            return originalString;
        }
        NSRange factRange = NSMakeRange(subRange.location + 1, subRange.length - 2);
        NSString *tempString = [originalString substringWithRange:factRange];
//        NSLog(@"%@++++", tempString);
        [retStrings addObject:tempString];
    }
    
    //取尾
    NSRange secondRange = [originalString rangeOfString:@">" options:NSBackwardsSearch];
    if (secondRange.location > originalString.length) {
        return originalString;
    }
    NSString *secondString = [originalString substringWithRange:NSMakeRange(secondRange.location + secondRange.length, originalString.length - (secondRange.location + secondRange.length))];
    [retStrings addObject:secondString];
    
    //拼接
    originalString = [retStrings componentsJoinedByString:@"\n\n"];
//    NSLog(@"------retstring%@",string);
    return originalString;
}




#pragma  mark -------------------------私有方法-----------------------------

+(NSMutableDictionary *)getStockCodeAndStockNameFromString:(NSString *)string {
    if (!string) {
        return nil;
    }
    //    NSLog(@"%@",string);
    NSString *stockCode = @"";
    NSString *stockName = @"";
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    NSString *parten = @"\\$[^\\$]+\\$";
    NSError* error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray *match = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if (match.count == 1) {
        NSTextCheckingResult *result = [match objectAtIndex:0];
        stockName = [string substringWithRange:result.range];
        
        NSRange leftRange = [stockName rangeOfString:@"("];
        NSRange rightRange = [stockName rangeOfString:@")"];
        if (leftRange.location != NSNotFound && rightRange.location != NSNotFound) {
            stockCode = [stockName substringWithRange:NSMakeRange(leftRange.location + 1, rightRange.location - leftRange.location - 1)];
            [returnDic setValue:stockCode forKey:stockName];
        }
        
    }
    
    //    NSLog(@"%@",returnDic);
    return returnDic;
}

+(NSMutableDictionary *)getNormalHrefLinkFromString:(NSString *)string {
    if (!string) {
        return nil;
    }
    //    NSLog(@"%@",string);
    NSString *hrefName = @"";
    NSString *hrefLink = @"";
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    NSRange httpRange = [string rangeOfString:@"://"];
    if (httpRange.location == NSNotFound) {//保证是正常的超链接字符串
        return nil;
    }
    
    NSString *parten = @">[^<]+<";
    NSError* error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray *match = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if (match.count == 1) {
        NSTextCheckingResult *result = [match objectAtIndex:0];
        hrefName = [string substringWithRange:result.range];
    }
    
    parten = @"'[^']+'";
    regex = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive  error:&error];
    match = [regex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if (match.count != 0) {
        NSTextCheckingResult *result = [match objectAtIndex:0];
        hrefLink = [string substringWithRange:result.range];
    }
    
    if (![hrefLink isEqualToString:@""] && ![hrefName isEqualToString:@""]) {
        [returnDic setValue:hrefLink forKey:hrefName];
    }
    
    //    NSLog(@"%@",returnDic);
    return returnDic;
}








#pragma  mark -------------------------test-----------------------------

-(void)testString{
    NSString *aString = @"<a href='1'>@fanghailong</a>sdfa<a href='1'>@songxiansuo</a>sdfew<a href='1'>@wuziyue</a>eeee<a href='1'>@tianzheng</a>sfsdf";
    
    NSString *startParten = @"<a[^>]+>@";
    NSString *endpartern = @"</a>";
    
    NSError* error = NULL;
    NSRegularExpression *startRegex = [NSRegularExpression regularExpressionWithPattern:startParten options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray* startMatch = [startRegex matchesInString:aString options:NSMatchingReportCompletion range:NSMakeRange(0, aString.length)];
    
    NSRegularExpression *endRegex = [NSRegularExpression regularExpressionWithPattern:endpartern options:NSRegularExpressionCaseInsensitive  error:&error];
    NSArray* endMatch = [endRegex matchesInString:aString options:NSMatchingReportCompletion range:NSMakeRange(0, aString.length)];
    
    for(NSTextCheckingResult *result in startMatch){
        NSLog(@"%@", NSStringFromRange(result.range));
    }
    
    for(NSTextCheckingResult *result in endMatch){
        NSLog(@"%@", NSStringFromRange(result.range));
    }
}

+(NSString *)testForHrefWithString:(NSString *)string {
    NSLog(@"%@", string);
    
    if(!string){
        return nil;
    }else if (![string containsString:@"<a"] && ![string containsString:@"a>"]) {
        return string;
    }
    

    NSString *startParten = @"<a[^>]+>";
    NSString *endpartern = @"</a>";
    
    NSError* error = NULL;
    
    NSRegularExpression *startRegex = [NSRegularExpression regularExpressionWithPattern:startParten options:NSRegularExpressionCaseInsensitive  error:&error];
    
    while ([string containsString:@"<a"]) {
        NSTextCheckingResult *startResult = [startRegex firstMatchInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
        string = [string stringByReplacingCharactersInRange:startResult.range withString:@""];
    }
    NSLog(@"----start:%@",string);
    
    NSRegularExpression *endRegex = [NSRegularExpression regularExpressionWithPattern:endpartern options:NSRegularExpressionCaseInsensitive  error:&error];
    
    while ([string containsString:@"a>"]) {
        NSTextCheckingResult *endResult = [endRegex firstMatchInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
        string = [string stringByReplacingCharactersInRange:endResult.range withString:@""];
    }
    
    NSLog(@"+++end:%@", string);
    return string;
}
@end
