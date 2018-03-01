//
//  UIFactory.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  组件工厂
//

#import <Foundation/Foundation.h>
#import "CMTextField.h"

@interface UIFactory : NSObject

+(CMTextField *)didBuildTextFieldWithLeftImage:(UIImage *)lImg rightImage:(UIImage *)rImg backgroundColor:(UIColor *)bgColor placeholder:(NSString *)pholder borderCornerRadius:(CGFloat)corRadius borderColor:(UIColor *)bColor keyboardType:(UIKeyboardType)kType;

@end
