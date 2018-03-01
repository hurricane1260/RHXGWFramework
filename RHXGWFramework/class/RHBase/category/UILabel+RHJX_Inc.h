//
//  UILabel+RHJX_Inc.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RHJX_Inc)

+(UILabel *)didBuildLabelWithText:(NSString *)aTxt fontSize:(CGFloat)aSize textColor:(UIColor *)aColor wordWrap:(BOOL)wordWrapEnable;

+(UILabel *)didBuildLabelWithText:(NSString *)aTxt font:(UIFont *)font textColor:(UIColor *)aColor wordWrap:(BOOL)wordWrapEnable;

+(UILabel *)didBulidLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color Spacing:(CGFloat)spacing;

+ (UILabel *)setSpacingWithText:(NSString *)text spacing:(CGFloat)spacing label:(UILabel *)label;


+ (UILabel *)didBuildT4Label;

@end
