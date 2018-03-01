//
//  ForumLayoutManager.m
//  stockscontest
//
//  Created by rxhui on 15/5/7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "ForumLayoutManager.h"
#import "TTTAttributedLabel.h"
#import "NSStringUtilFor@.h"

@implementation ForumLayoutManager

+(CGFloat)measureHeightWithString:(NSString *)content andMaxWidth:(CGFloat)maxWidth andFont:(UIFont *)font andLines:(NSInteger)lines{
//    NSLog(@"--1-%@",content);
    NSString *contentWithoutHref = [NSStringUtilFor_ getSubStringWithoutHref:content];
    NSMutableAttributedString *mutaAttriString = [[NSMutableAttributedString alloc]initWithString:contentWithoutHref];
//    [[GONMarkupParserManager sharedParser] attributedStringFromString:content];
    if ([mutaAttriString.description isEqualToString:@""]) {
        return 0.0f;
    }
//    NSLog(@"--2-%@",mutaAttriString);
//    NSLog(@"---%@",mutaAttriString);
    [mutaAttriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,mutaAttriString.length)];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = 8;
    paraStyle.lineHeightMultiple = 1;
    paraStyle.minimumLineHeight = font.lineHeight;
    paraStyle.maximumLineHeight = font.lineHeight;
    [mutaAttriString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, mutaAttriString.length)];
    
    CGSize tmpSize = [TTTAttributedLabel sizeThatFitsAttributedString:mutaAttriString withConstraints:CGSizeMake(maxWidth, NSIntegerMax) limitedToNumberOfLines:lines];
    return tmpSize.height;
}

+(CGFloat)measureTrimHeightWithString:(NSString *)content andMaxWidth:(CGFloat)maxWidth andFont:(UIFont *)font andLines:(NSInteger)lines{
    NSString *contentWithoutHref = [NSStringUtilFor_ getSubStringWithoutHref:content];
    NSMutableAttributedString *mutaAttriString = [[NSMutableAttributedString alloc]initWithString:contentWithoutHref];
//    NSMutableAttributedString *mutaAttriString = [[GONMarkupParserManager sharedParser] attributedStringFromString:content];
    NSString *trimString = [mutaAttriString.string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [ForumLayoutManager measureHeightWithString:trimString andMaxWidth:maxWidth andFont:font andLines:lines];
}


+(CGFloat)measureHeightWithString:(NSString *)content andMaxWidth:(CGFloat)maxWidth andFont:(UIFont *)font andLines:(NSInteger)lines andSpace:(CGFloat)space{
    NSString *contentWithoutHref = [NSStringUtilFor_ getSubStringWithoutHref:content];
    NSMutableAttributedString *mutaAttriString = [[NSMutableAttributedString alloc]initWithString:contentWithoutHref];
    if ([mutaAttriString.description isEqualToString:@""]) {
        return 0.0f;
    }
  
    [mutaAttriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,mutaAttriString.length)];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
    paraStyle.lineSpacing = space;
    paraStyle.lineHeightMultiple = 1;
    paraStyle.minimumLineHeight = font.lineHeight;
    paraStyle.maximumLineHeight = font.lineHeight;
    [mutaAttriString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, mutaAttriString.length)];
    
    CGSize tmpSize = [TTTAttributedLabel sizeThatFitsAttributedString:mutaAttriString withConstraints:CGSizeMake(maxWidth, NSIntegerMax) limitedToNumberOfLines:lines];
    return tmpSize.height;
}

+(CGFloat)autoCalculateWidthOrHeight:(CGFloat)height width:(CGFloat)width fontsize:(CGFloat)fontsize content:(NSString*)content space:(CGFloat)space
{
    
    //增加文本间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize],NSParagraphStyleAttributeName:style};
    
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil];
    
    //判断计算的是宽还是高
    if (height == MAXFLOAT) {
        return rect.size.height;
    }
    else
        return rect.size.width;
}
+(CGFloat)autoCalculateWidthOrHeight:(CGFloat)height width:(CGFloat)width font:(UIFont *)font content:(NSString*)content space:(CGFloat)space{
    
    //增加文本间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil];
    
    //判断计算的是宽还是高
    if (height == MAXFLOAT) {
        return rect.size.height;
    }
    else
        return rect.size.width;

    
    
    
    
}
+(CGSize)autoSizeWidthOrHeight:(CGFloat)height width:(CGFloat)width font:(UIFont *)font content:(NSString*)content space:(CGFloat)space{
    
    //增加文本间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil];
    return rect.size;
    
}
+(CGSize)autoSizeWidthOrHeight:(CGFloat)height width:(CGFloat)width fontsize:(CGFloat)fontsize content:(NSString*)content space:(CGFloat)space{
    
    //增加文本间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize],NSParagraphStyleAttributeName:style};
    
    //计算出rect
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, height)
                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attribute context:nil];
    return rect.size;
    
}


@end
