//
//  CPStringHandler.m
//  stockscontest
//
//  Created by liyan on 16/3/17.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "CPStringHandler.h"

@implementation CPStringHandler

#pragma mark--------对外接口----------
//  数值拼接字符串后按规定颜色样式输出 例：仓位占比：99.75%
+ (NSAttributedString *)getAttributeStrWithNSNumber:(NSNumber *)num withAppendStr:(NSString *)str withPreStr:(NSString *)preStr{
    CPStringHandler * handler = [[CPStringHandler alloc] init];
    return [handler getAttributeStrWithNSNumber:num withAppendStr:str withPreStr:preStr];
}

// 将两个字符串按照规定颜色样式拼接返回格式字符串 例：字符串1（灰色）字符串2（黑色）
+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withColor:(UIColor *)preColor andAppendString:(NSString *)sufStr withColor:(UIColor *)sufColor{
    if (!preStr && !sufStr) {
        return nil;
    }
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",preStr,sufStr]];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:preColor range:NSMakeRange(0,preStr.length)];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:sufColor range:NSMakeRange(preStr.length , mutaStr.length - preStr.length)];
    return mutaStr.copy;
    
}

// 将两个字符串按照规定颜色样式拼接返回格式字符串 例：字符串1（灰色）字符串2（黑色）
+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withColor:(UIColor *)preColor withSize:(CGFloat)preSize andAppendString:(NSString *)sufStr withColor:(UIColor *)sufColor withSize:(CGFloat)sufSize{
    if (!preStr && !sufStr) {
        return nil;
    }
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",preStr,sufStr]];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:preColor range:NSMakeRange(0,preStr.length)];
    [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:preSize] range:NSMakeRange(0,preStr.length)];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:sufColor range:NSMakeRange(preStr.length + 1, mutaStr.length - preStr.length - 1)];
    [mutaStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sufSize] range:NSMakeRange(preStr.length + 1, mutaStr.length - preStr.length - 1)];
    return mutaStr.copy;
    
}


//  生成规定的百分比样式 （百分比符号%字体为规定大小） 99.15%（%字体小）
+ (NSAttributedString *)getStringWithNum:(NSNumber *)num{
    NSString * profitText = [NSString stringWithFormat:@"%@%%",num];
    NSMutableAttributedString * attProfit = [[NSMutableAttributedString alloc] initWithString:profitText];
    [attProfit addAttribute:NSFontAttributeName value:font1_common_xgw range:NSMakeRange(attProfit.length - 1, 1)];
    return attProfit;
}

+ (NSAttributedString *)getAttributedStringWithString:(NSString *)str{
    NSMutableAttributedString * attProfit = [[NSMutableAttributedString alloc] initWithString:str];
    [attProfit addAttribute:NSFontAttributeName value:font1_common_xgw range:NSMakeRange(str.length - 1, 1)];
    return attProfit;
}

// 将数值转换为百分比，保留两位小数的字符串
+ (NSString *)dealNumberWithFormatPercent:(NSNumber *)num{
    NSNumber *profitNum = [NSNumber numberWithDouble:num.doubleValue * 100];
    NSString *formatString = [NSString formatDecimalStyleWith:profitNum withSuffix:@"%" maximumFractionDigits:2];
    return formatString;
}

+ (NSString *)dealNumberWithFormat:(NSNumber *)num{
    NSNumber *profitNum = [NSNumber numberWithDouble:num.doubleValue];
    NSString *formatString = [NSString formatDecimalStyleWith:profitNum withSuffix:@"%" maximumFractionDigits:2];
    return formatString;
}

//  数值拼接字符串后按规定颜色样式输出 例：仓位占比：99.75%
- (NSAttributedString *)getAttributeStrWithNSNumber:(NSNumber *)num withAppendStr:(NSString *)str withPreStr:(NSString *)preStr{
    if (!num) {
        num = @0;
    }
    NSString * dealStr;
    if ([str isEqualToString:@"%"]) {
        dealStr = [CPStringHandler dealNumberWithFormatPercent:num];
    }
    else{
        dealStr = [CPStringHandler dealNumberWithFormat:num];
    }
    
    NSAttributedString * attributeStr = [CPStringHandler getStringWithStr:preStr withColor:color14_icon_xgw andAppendString:dealStr withColor:color3_text_xgw];
    return attributeStr;
}

////按照规定的颜色样式返回拼接的字符串 例：仓位占比：（灰色）99.95%（黑色）                   暂未用
//- (NSAttributedString *)getStringWithNumber:(NSNumber *)focusAmount andAppendString:(NSString *)append{
//    if (!focusAmount) {
//        focusAmount = @0;
//    }
//    NSString *numberString = [NSString stringWithFormat:@"%@",focusAmount];
//    
//    NSAttributedString * attributeStr =  [self getStringWithStr:numberString withColor:color2_text_xgw andAppendString:append withColor:color14_icon_xgw];
//    return attributeStr.copy;
//}

// 将两个字符串按照规定颜色样式拼接返回格式字符串 例：字符串1（灰色）字符串2（黑色）
+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withColor:(UIColor *)preColor withFont:(UIFont *)preFont andAppendString:(NSString *)sufStr withColor:(UIColor *)sufColor withFont:(UIFont *)sufFont{
    if (!preStr && !sufStr) {
        return nil;
    }
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",preStr,sufStr]];
    NSRange preRange = NSMakeRange(0,preStr.length);
    NSRange sufRange = NSMakeRange(preStr.length, mutaStr.length - preStr.length);
    [mutaStr addAttribute:NSForegroundColorAttributeName value:preColor range:preRange];
    [mutaStr addAttribute:NSFontAttributeName value:preFont range:preRange];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:sufColor range:sufRange];
    [mutaStr addAttribute:NSFontAttributeName value:sufFont range:sufRange];
    return mutaStr.copy;
    
}

+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withFont:(UIFont *)preFont andMidString:(NSString *)midStr withFont:(UIFont *)midFont AppendString:(NSString *)sufStr  withFont:(UIFont *)sufFont{
    if (!preStr && !sufStr && !midStr) {
        return nil;
    }
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    if (!midStr) {
        midStr = @"";
    }
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",preStr,midStr,sufStr]];
    NSRange preRange = NSMakeRange(0,preStr.length);
    NSRange midRange = NSMakeRange(preStr.length, midStr.length);
    NSRange sufRange = NSMakeRange(midRange.location + midRange.length, mutaStr.length - preStr.length - midStr.length);
    [mutaStr addAttribute:NSFontAttributeName value:preFont range:preRange];
    [mutaStr addAttribute:NSFontAttributeName value:midFont range:midRange];
    [mutaStr addAttribute:NSFontAttributeName value:sufFont range:sufRange];
    return mutaStr.copy;
    
}

+ (NSAttributedString *)getStringWithStr:(NSString *)str sepByStr:(NSString *)sepStr withPreColor:(UIColor *)preColor withPreFont:(UIFont *)preFont  withSufColor:(UIColor *)sufColor withSufFont:(UIFont *)sufFont{
    if (!str) {
        return nil;
    }
    if ([str rangeOfString:sepStr].location == NSNotFound) {
        return nil;
    }
    NSRange range = [str rangeOfString:sepStr];
    NSString * preStr = [str substringToIndex:range.location];
    NSString * sufStr = [str substringFromIndex:range.location + 1];
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange preRange = NSMakeRange(0,preStr.length);
    NSRange sufRange = NSMakeRange(preStr.length + 1, mutaStr.length - preStr.length - 1);
    [mutaStr addAttribute:NSForegroundColorAttributeName value:preColor range:preRange];
    [mutaStr addAttribute:NSFontAttributeName value:preFont range:preRange];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:sufColor range:sufRange];
    [mutaStr addAttribute:NSFontAttributeName value:sufFont range:sufRange];
    return mutaStr.copy;
    
}

+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withFont:(UIFont *)preFont withColor:(UIColor *)preColor andMidString:(NSString *)midStr withFont:(UIFont *)midFont withColor:(UIColor *)midColor AppendString:(NSString *)sufStr  withFont:(UIFont *)sufFont withColor:(UIColor *)sufColor{
    if (!preStr && !sufStr && !midStr) {
        return nil;
    }
    if (!preStr) {
        preStr = @"";
    }
    if (!sufStr) {
        sufStr = @"";
    }
    if (!midStr) {
        midStr = @"";
    }
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",preStr,midStr,sufStr]];
    NSRange preRange = NSMakeRange(0,preStr.length);
    NSRange midRange = NSMakeRange(preStr.length, midStr.length);
    NSRange sufRange = NSMakeRange(midRange.location + midRange.length, mutaStr.length - preStr.length - midStr.length);
    [mutaStr addAttribute:NSFontAttributeName value:preFont range:preRange];
    [mutaStr addAttribute:NSFontAttributeName value:midFont range:midRange];
    [mutaStr addAttribute:NSFontAttributeName value:sufFont range:sufRange];
    
    [mutaStr addAttribute:NSForegroundColorAttributeName value:preColor range:preRange];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:midColor range:midRange];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:sufColor range:sufRange];
    
    return mutaStr.copy;
    
}

@end
