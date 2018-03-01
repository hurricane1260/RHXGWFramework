//
//  UIButton+RHJX_Inc.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "UIButton+RHJX_Inc.h"

@implementation UIButton (RHJX_Inc)

+(UIButton *)didBuildButtonWithTitle:(NSString *)aTitle normalTitleColor:(UIColor *)notColor highlightTitleColor:(UIColor *)hltColor disabledTitleColor:(UIColor *)distColor normalBGColor:(UIColor *)noBGColor highlightBGColor:(UIColor *)hlBGColor disabledBGColor:(UIColor *)disBGColor{

    UIButton *button = [[UIButton alloc] init];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateHighlighted];
    [button setTitleColor:notColor forState:UIControlStateNormal];
    [button setTitleColor:hltColor forState:UIControlStateHighlighted];
    [button setTitleColor:distColor forState:UIControlStateDisabled];
    
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextAddRect(con, CGRectMake(0,0,100,100));
        CGContextSetFillColorWithColor(con, noBGColor.CGColor);
        CGContextFillPath(con);
        UIImage* normalBGImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [button setBackgroundImage:normalBGImage forState:UIControlStateNormal];
    }
    
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextAddRect(con, CGRectMake(0,0,100,100));
        CGContextSetFillColorWithColor(con, hlBGColor.CGColor);
        CGContextFillPath(con);
        UIImage* highlightBGImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [button setBackgroundImage:highlightBGImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:highlightBGImage forState:UIControlStateSelected];
    }
    
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextAddRect(con, CGRectMake(0,0,100,100));
        CGContextSetFillColorWithColor(con, disBGColor.CGColor);
        CGContextFillPath(con);
        UIImage* disabledBGImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [button setBackgroundImage:disabledBGImage forState:UIControlStateDisabled];
    }

    return button;
}

+(UIButton *)didBuildButtonWithNormalImage:(UIImage *)nlImage highlightImage:(UIImage *)hlImage{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:nlImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    [button setImage:hlImage forState:UIControlStateSelected];
    
    return button;
}

+(UIButton *)didBuildButtonWithNormalImage:(UIImage *)nlImage highlightImage:(UIImage *)hlImage withTitle:(NSString *)aTitle normalTitleColor:(UIColor *)notColor highlightTitleColor:(UIColor *)hltColor{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:nlImage forState:UIControlStateNormal];
    [button setImage:hlImage forState:UIControlStateHighlighted];
    [button setImage:hlImage forState:UIControlStateSelected];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateHighlighted];
    [button setTitle:aTitle forState:UIControlStateSelected];
    [button setTitleColor:notColor forState:UIControlStateNormal];
    [button setTitleColor:hltColor forState:UIControlStateHighlighted];
    [button setTitleColor:hltColor forState:UIControlStateSelected];
//    button.titleLabel.font = [UIFont systemFontOfSize:aSzie];

    return button;
}

+(void)didBuildEdgeInsetsForTopImageBottomTitle:(UIButton *)button{
    UILabel *tempLabel = button.titleLabel;
    [tempLabel sizeToFit];
    CGSize titleSize = tempLabel.size;
    CGSize imageSize = button.imageView.image.size;
    CGSize btnSize = button.size;

    CGFloat totalHeight = imageSize.height + titleSize.height;
    CGFloat offestY = (btnSize.height - totalHeight) * 0.5f;

    if(button.imageEdgeInsets.left == 0){
        button.imageEdgeInsets = UIEdgeInsetsMake(offestY, (btnSize.width - imageSize.width) * 0.5f, btnSize.height - offestY - imageSize.height, btnSize.width - (btnSize.width - imageSize.width) * 0.5f - imageSize.width);
    }
    
    if(button.titleEdgeInsets.top == 0){
        CGSize orginSize = button.titleLabel.frame.size;
        CGFloat titleTop = offestY + totalHeight - titleSize.height;
        CGFloat offestX = button.titleLabel.frame.origin.x - (btnSize.width - titleSize.width) * 0.5f;
        button.titleEdgeInsets = UIEdgeInsetsMake(titleTop, offestX * -1 - (titleSize.width - orginSize.width), 0.0f, 0.0f);
    }
}

-(void)didSetImageWithNormalImage:(UIImage *)nImage highlightImage:(UIImage *)hImage{
    [self setImage:nImage forState:UIControlStateNormal];
    [self setImage:hImage forState:UIControlStateHighlighted];
    [self setImage:hImage forState:UIControlStateSelected];
}

-(void)didSetTitleWithTitle:(NSString *)aTitle{
    [self setTitle:aTitle forState:UIControlStateNormal];
    [self setTitle:aTitle forState:UIControlStateHighlighted];
    [self setTitle:aTitle forState:UIControlStateSelected];
}

+ (UIButton *)didBuildB1WithTitle:(NSString *)aTitle{
    UIButton * button = [UIButton didBuildButtonWithTitle:aTitle normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color6_text_xgw highlightBGColor:color10_text_xgw disabledBGColor:color6_2_text_xgw];
    button.titleLabel.font = font1_common_xgw;
    button.size = CGSizeMake(312.0f, 44.0f);
    return button;

}

+ (UIButton *)didBuildB7_1ButtonWithTitle:(NSString *)aTitle{
    UIButton *button = [UIButton didBuildButtonWithTitle:aTitle normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color6_text_xgw highlightBGColor:color10_text_xgw disabledBGColor:color5_text_xgw];
    button.titleLabel.font = font1_common_xgw;
    button.size = CGSizeMake(67.0f, 27.0f);
    button.layer.cornerRadius = 4.0f;
    button.clipsToBounds = YES;
    return button;
}

+ (UIButton *)didBuildB7_2ButtonWithTitle:(NSString *)aTitle{
    UIButton *button = [UIButton didBuildButtonWithTitle:aTitle normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color9_text_xgw normalBGColor:color12_icon_xgw highlightBGColor:color2_text_xgw disabledBGColor:color12_icon_xgw];
    button.titleLabel.font = font1_common_xgw;
    button.size = CGSizeMake(67.0f, 27.0f);
    button.layer.cornerRadius = 4.0f;
    button.clipsToBounds = YES;
    return button;
}

+ (UIButton *)didBuildOpenAccNextBtnWithTitle:(NSString *)aTitle{
    UIButton * button = [UIButton didBuildButtonWithTitle:aTitle normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color6_text_xgw highlightBGColor:color10_text_xgw disabledBGColor:color_open_notselect];
    button.titleLabel.font = font2_common_xgw;
    button.size = CGSizeMake(MAIN_SCREEN_WIDTH - 48.0f, 44.0f);
    button.layer.cornerRadius = 3.0f;
    button.clipsToBounds = YES;
    return button;
    
}

@end
