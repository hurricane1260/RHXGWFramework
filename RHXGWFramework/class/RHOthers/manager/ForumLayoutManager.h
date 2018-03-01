//
//  ForumLayoutManager.h
//  stockscontest
//
//  Created by rxhui on 15/5/7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumLayoutManager : NSObject

/**
 *  计算label高度
 *  @param content  要计算高度的字符串
 *  @param maxWidth 最大宽度
 *  @param font     字体
 *  @parma lines    最大行数
 */
+(CGFloat)measureHeightWithString:(NSString *)content andMaxWidth:(CGFloat)maxWidth andFont:(UIFont *)font andLines:(NSInteger)lines;

/**
 *  计算label高度，删去了多余的空行
 *  @param content  要计算高度的字符串
 *  @param maxWidth 最大宽度
 *  @param font     字体
 *  @parma lines    最大行数
 */
+(CGFloat)measureTrimHeightWithString:(NSString *)content andMaxWidth:(CGFloat)maxWidth andFont:(UIFont *)font andLines:(NSInteger)lines;


+(CGFloat)measureHeightWithString:(NSString *)content andMaxWidth:(CGFloat)maxWidth andFont:(UIFont *)font andLines:(NSInteger)lines andSpace:(CGFloat)space;


/**
 根据文本 传入 宽度 和 高度  其中一个是MAXFLOAT 返回相应的自适应的高度或者宽度

 @param height 限制的高度
 @param width 限制的宽度
 @param fontsize 文本的字号
 @param content 文本的内容
 @param space 文本之间的间距
 */
+(CGFloat)autoCalculateWidthOrHeight:(CGFloat)height width:(CGFloat)width fontsize:(CGFloat)fontsize content:(NSString*)content space:(CGFloat)space;



/**
 根据文本 传入 宽度 和 高度  其中一个是MAXFLOAT 返回相应的自适应的高度或者宽度

 @param height 限制的高度
 @param width  限制的宽度
 @param font   文本的字号
 @param content 文本的内容
 @param space 文本之间的间距
 */
+(CGFloat)autoCalculateWidthOrHeight:(CGFloat)height width:(CGFloat)width font:(UIFont *)font content:(NSString*)content space:(CGFloat)space;


/**
 计算文本的size

 @param height 限制的高度
 @param width  限制的宽度
 @param fontsize 文本的字号
 @param content  文本的内容
 @param space  文本之间的间距
 */
+(CGSize)autoSizeWidthOrHeight:(CGFloat)height width:(CGFloat)width fontsize:(CGFloat)fontsize content:(NSString*)content space:(CGFloat)space;

/**
 计算文本的size

 @param height  限制的高度
 @param width   限制的宽度
 @param font    文本的字号UIFont 类型 加粗  加细
 @param content 文本的内容
 @param space   文本之间的间距
 */
+(CGSize)autoSizeWidthOrHeight:(CGFloat)height width:(CGFloat)width font:(UIFont *)font content:(NSString*)content space:(CGFloat)space;

@end
