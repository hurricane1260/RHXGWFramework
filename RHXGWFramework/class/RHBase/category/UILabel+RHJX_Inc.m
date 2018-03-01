//
//  UILabel+RHJX_Inc.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "UILabel+RHJX_Inc.h"

@implementation UILabel (RHJX_Inc)

+(UILabel *)didBuildLabelWithText:(NSString *)aTxt fontSize:(CGFloat)aSize textColor:(UIColor *)aColor wordWrap:(BOOL)wordWrapEnable{
    UILabel *label = [[UILabel alloc] init];
    label.text = aTxt;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:aSize];
    label.textColor = aColor;
    if(wordWrapEnable){
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
    }
    return label;
}

+(UILabel *)didBuildLabelWithText:(NSString *)aTxt font:(UIFont *)font textColor:(UIColor *)aColor wordWrap:(BOOL)wordWrapEnable{
    UILabel *label = [[UILabel alloc] init];
    label.text = aTxt;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = aColor;
    if(wordWrapEnable){
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
    }
    return label;
}
+(UILabel *)didBulidLabelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color Spacing:(CGFloat)spacing
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
    
    return label;
}

+ (UILabel *)setSpacingWithText:(NSString *)text spacing:(CGFloat)spacing label:(UILabel *)label{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
    
    return label;
}

+ (UILabel *)didBuildT4Label{
   UILabel * label = [UILabel didBuildLabelWithText:@"" font:font0_common_xgw textColor:color1_text_xgw wordWrap:NO];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = CGSizeMake(15.0f, 14.0f);
    label.layer.cornerRadius = 2.0f;
    label.clipsToBounds = YES;
    return label;
}

@end
