//
//  UIFactory.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+(CMTextField *)didBuildTextFieldWithLeftImage:(UIImage *)lImg rightImage:(UIImage *)rImg backgroundColor:(UIColor *)bgColor placeholder:(NSString *)pholder borderCornerRadius:(CGFloat)corRadius borderColor:(UIColor *)bColor keyboardType:(UIKeyboardType)kType{
    CMTextField *textField = [[CMTextField alloc] init];

    textField.backgroundColor = bgColor;
    textField.placeholder = pholder;
    textField.leftImage = lImg;
    textField.rightImage = rImg;
    textField.keyboardType = kType;
    textField.layer.borderColor = bColor.CGColor;
    textField.layer.cornerRadius = corRadius;
    
    return textField;
}

@end
