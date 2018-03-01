//
//  UITextField+ExtentRange.h
//  KeyBoard
//
//  Created by Zzbei on 15/8/11.
//  Copyright (c) 2015年 zbwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

//返回光标位置
- (NSRange) selectedRange;
//设置光标位置
- (void) setSelectedRange:(NSRange) range;

@end
