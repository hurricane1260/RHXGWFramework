//
//  CPStringHandler.h
//  stockscontest
//
//  Created by liyan on 16/3/17.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPStringHandler : NSObject

/**
 *  数值拼接字符串后按规定颜色样式输出 例：仓位占比：99.75%
 */
+ (NSAttributedString *)getAttributeStrWithNSNumber:(NSNumber *)num withAppendStr:(NSString *)str withPreStr:(NSString *)preStr;

/**
 *  将两个字符串按照规定颜色样式拼接返回格式字符串 例：字符串1（灰色）字符串2（黑色）
 */
+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withColor:(UIColor *)preColor andAppendString:(NSString *)sufStr withColor:(UIColor *)sufColor;

+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withColor:(UIColor *)preColor withSize:(CGFloat)preSize andAppendString:(NSString *)sufStr withColor:(UIColor *)sufColor withSize:(CGFloat)sufSize;

/**
 *  获取数值百分比的格式字符串 例99.75%
 */
+ (NSAttributedString *)getStringWithNum:(NSNumber *)num;

+ (NSAttributedString *)getAttributedStringWithString:(NSString *)str;


+ (NSString *)dealNumberWithFormat:(NSNumber *)num;

+ (NSString *)dealNumberWithFormatPercent:(NSNumber *)num;

/**
 *  将两个字符串按照规定颜色、字体样式拼接返回格式字符串 例：字符串1（灰色、系统字体）字符串2（黑色、数字字体）
 */
+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withColor:(UIColor *)preColor withFont:(UIFont *)preFont andAppendString:(NSString *)sufStr withColor:(UIColor *)sufColor withFont:(UIFont *)sufFont;

+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withFont:(UIFont *)preFont andMidString:(NSString *)midStr withFont:(UIFont *)midFont AppendString:(NSString *)sufStr  withFont:(UIFont *)sufFont;

+ (NSAttributedString *)getStringWithStr:(NSString *)str sepByStr:(NSString *)sepStr withPreColor:(UIColor *)preColor withPreFont:(UIFont *)preFont  withSufColor:(UIColor *)sufColor withSufFont:(UIFont *)sufFont;

+ (NSAttributedString *)getStringWithStr:(NSString *)preStr withFont:(UIFont *)preFont withColor:(UIColor *)preColor andMidString:(NSString *)midStr withFont:(UIFont *)midFont withColor:(UIColor *)midColor AppendString:(NSString *)sufStr  withFont:(UIFont *)sufFont withColor:(UIColor *)sufColor;

@end
