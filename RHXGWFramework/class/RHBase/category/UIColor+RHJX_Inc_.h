//
//  UIColor+UIColorExtention.h
//  iphone-bank
//
//  Created by ztian on 13-2-22.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//  UIColor扩展
//

#import <UIKit/UIKit.h>

@interface UIColor (RHJX_Inc_)

// 根据16进制字符串生成UIColor
+(UIColor *)colorWithRXHexString:(NSString *)stringToConvert;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

@end
