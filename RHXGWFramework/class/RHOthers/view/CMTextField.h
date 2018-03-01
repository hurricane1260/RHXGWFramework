//
//  CMTextField.h
//  iphone-pay
//
//  Created by 方海龙 on 14-8-11.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMTextField : UITextField

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, strong) UIImage *leftImage;

@property (nonatomic, strong) UIImage *rightImage;

@property (nonatomic, assign) CGFloat corRadius;

@end
