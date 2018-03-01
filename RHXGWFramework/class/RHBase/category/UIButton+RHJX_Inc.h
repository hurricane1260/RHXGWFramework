//
//  UIButton+RHJX_Inc.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (RHJX_Inc)

//不能改字体，会内存泄漏
+(UIButton *)didBuildButtonWithTitle:(NSString *)aTitle normalTitleColor:(UIColor *)notColor highlightTitleColor:(UIColor *)hltColor disabledTitleColor:(UIColor *)distColor normalBGColor:(UIColor *)noBGColor highlightBGColor:(UIColor *)hlBGColor disabledBGColor:(UIColor *)disBGColor;

+(UIButton *)didBuildButtonWithNormalImage:(UIImage *)nlImage highlightImage:(UIImage *)hlImage;

+(UIButton *)didBuildButtonWithNormalImage:(UIImage *)nlImage highlightImage:(UIImage *)hlImage withTitle:(NSString *)aTitle normalTitleColor:(UIColor *)notColor highlightTitleColor:(UIColor *)hltColor;

+(void)didBuildEdgeInsetsForTopImageBottomTitle:(UIButton *)button;

-(void)didSetImageWithNormalImage:(UIImage *)nImage highlightImage:(UIImage *)hImage;

-(void)didSetTitleWithTitle:(NSString *)aTitle;

+ (UIButton *)didBuildB1WithTitle:(NSString *)aTitle;

+ (UIButton *)didBuildB7_1ButtonWithTitle:(NSString *)aTitle;

+ (UIButton *)didBuildB7_2ButtonWithTitle:(NSString *)aTitle;

+ (UIButton *)didBuildOpenAccNextBtnWithTitle:(NSString *)aTitle;

@end
