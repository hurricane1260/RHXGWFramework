//
//  CMProgress.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  进度组件

#import <Foundation/Foundation.h>

@interface CMProgress : UIView

/**
 *  显示开始进度
 *
 *  @param message  需要显示的文字
 */
+(void)showBeginProgressWithMessage:(NSString *)message superView:(UIView *)sView;


/**
 *  显示结束进度
 *
 *  @param aTitle   标题
 *  @param aMess    提示文字
 *  @param eImage   需要显示的提示图片
 *  @param duration 持续时间
 */
+(void)showEndProgressWithTitle:(NSString *)aTitle message:(NSString *)aMess endImage:(UIImage *)eImage duration:(NSTimeInterval)duration;

+(void)showWarningProgressWithTitle:(NSString *)aTitle message:(NSString *)aMess warningImage:(UIImage *)wImage duration:(NSTimeInterval)duration;

+(void)hiddenWithAnimation:(BOOL)animation;

@end
