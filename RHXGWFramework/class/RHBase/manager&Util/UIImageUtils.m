//
//  UIImageUtils.m
//  stockscontest
//
//  Created by rxhui on 15/3/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "UIImageUtils.h"

@implementation UIImageUtils

+(UIImage *)buildImageWithUIColor:(UIColor *)color andFrame:(CGRect)frame {
    CGSize imageSize =frame.size;
    UIGraphicsBeginImageContext(imageSize);
    [color set];
    UIRectFill(frame);
    UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSLog(@"--%@--",pressedColorImg);
    return pressedColorImg;
}

@end
