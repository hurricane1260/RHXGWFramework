//
//  UIColor+UIColorExtention.m
//  iphone-bank
//
//  Created by ztian on 13-2-22.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import "UIColor+RHJX_Inc_.h"

@implementation UIColor (RHJX_Inc_)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+(UIColor *)colorWithRXHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

@end
