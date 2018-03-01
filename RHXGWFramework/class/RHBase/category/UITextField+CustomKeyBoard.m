//
//  UITextField+CustomKeyBoard.m
//  stockscontest
//
//  Created by Zzbei on 16/3/8.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "UITextField+CustomKeyBoard.h"
#import "UITextField+ExtentRange.h"
#import <objc/runtime.h>

@implementation UITextField (CustomKeyBoard)

static char CustomNumberArray;
static char CustomEnglishArray;
static char CustomNumberBoard;
static char CustomEnglishBoard;
static char CustomKeyBoardDelegate;
@dynamic numArr;
@dynamic engArr;
@dynamic numberBoard;
@dynamic englishBoard;
@dynamic keyBoardDelegate;

- (void)setNumArr:(NSArray *)numArr
{
    [self willChangeValueForKey:@"numArr"];
    objc_setAssociatedObject(self, &CustomNumberArray, numArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"numArr"];
}

- (NSArray *)numArr
{
    return objc_getAssociatedObject(self, &CustomNumberArray);
}

- (void)setEngArr:(NSArray *)engArr
{
    [self willChangeValueForKey:@"engArr"];
    objc_setAssociatedObject(self, &CustomEnglishArray, engArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"engArr"];
}

- (NSArray *)engArr
{
    return objc_getAssociatedObject(self, &CustomEnglishArray);
}

- (void)setNumberBoard:(UIView *)numberBoard
{
    [self willChangeValueForKey:@"numberBoard"];
    objc_setAssociatedObject(self, &CustomNumberBoard, numberBoard, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"numberBoard"];
}

- (UIView *)numberBoard
{
    return objc_getAssociatedObject(self, &CustomNumberBoard);
}

- (void)setEnglishBoard:(UIView *)englishBoard
{
    [self willChangeValueForKey:@"englishBoard"];
    objc_setAssociatedObject(self, &CustomEnglishBoard, englishBoard, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"englishBoard"];
}

- (UIView *)englishBoard
{
    return objc_getAssociatedObject(self, &CustomEnglishBoard);
}

- (void)setKeyBoardDelegate:(id<CustomKeyBoardDelegate>)delegate
{
    [self willChangeValueForKey:@"delegate"];
    objc_setAssociatedObject(self, &CustomKeyBoardDelegate, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"delegate"];
}

- (id<CustomKeyBoardDelegate>)keyBoardDelegate
{
    return objc_getAssociatedObject(self, &CustomKeyBoardDelegate);
}

- (void)createCustomKeyBoard
{
    [self makeArrayDate];
    [self createNumberBoard];
    [self createEnglishBoard];
    
    self.inputView = self.numberBoard;
}
#pragma mark 按键数据--------------------------------------------------

- (void)makeArrayDate
{
    self.numArr = @[@"600",@"1",@"2",@"3",@"601",@"4",@"5",@"6",@"603",@"7",@"8",@"9",@"002",@"300",@"0",@"",@"ABC",@""];
    self.engArr = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
}

#pragma mark 创建数字键盘--------------------------------------------------

- (void)createNumberBoard
{
    self.numberBoard = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 720 * 440, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 720 * 440)];
    
    UIColor * color = nil;
    for (int i = 0; i < 18; i++) {
        
        if (i == 0 || i == 4 || i == 8 || i == 12 || i == 13 || i == 15 || i == 16 || i == 17) {
            color = color_bg_gray_f456;
        } else {
            color = [UIColor whiteColor];
        }
        UIButton * button = [self createNumberButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 4 * (i % 4), [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * (i / 4), [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) color:color text:self.numArr[i]];
        button.tag = i;
        
        if (i == 15) {
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cleanButton)];
            [button addGestureRecognizer:longPress];
            [button addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_delete_black"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_delete_white"] forState:UIControlStateHighlighted];
        } else if (i == 16) {
            [button addTarget:self action:@selector(changeKeyBoardToEnglish) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 17) {
            [button addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_keyboard_black"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_keyboard_white"] forState:UIControlStateHighlighted];
        } else {
            [button addTarget:self action:@selector(touchNum:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.numberBoard addSubview:button];
    }
    
    UIButton * button = [self createNumberButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 4 * (18 % 4), [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * (18 / 4), [UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) color:color_bg_gray_f456 text:@"确定"];
    [button addTarget:self action:@selector(certainButton) forControlEvents:UIControlEventTouchUpInside];
    [self.numberBoard addSubview:button];
    
    self.inputView = self.numberBoard;
}

#pragma mark 创建数字按键构造方法--------------------------------------------------

- (UIButton *)createNumberButtonWithFrame:(CGRect)rect
                                    color:(UIColor *)color
                                     text:(NSString *)text
{
    UIButton * button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = color;
    
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = color16_other_xgw.CGColor;
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:color2_text_xgw forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[self createImageWithColor:color2_text_xgw rect:button.bounds] forState:UIControlStateHighlighted];
    
    return button;
}

#pragma mark 切换数字键盘--------------------------------------------------

- (void)changeKeyBoardToNumber
{
    self.inputView = self.numberBoard;
    [self reloadInputViews];
}

#pragma mark 创建英文键盘--------------------------------------------------

- (void)createEnglishBoard
{
    self.englishBoard = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 4, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 4)];
    self.englishBoard.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 26; i++) {
        UIButton * button;
        if (i < 10) {
            button = [self createEnglishButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10 * (i % 10), 0, [UIScreen mainScreen].bounds.size.width / 10, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:self.engArr[i]];
            
        } else if (i < 19) {
            button = [self createEnglishButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10 * (i % 10) + [UIScreen mainScreen].bounds.size.width / 20, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5, [UIScreen mainScreen].bounds.size.width / 10, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:self.engArr[i]];
            
        } else if (i < 26) {
            button = [self createEnglishButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10 * ((i - 19) % 7), [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 2, [UIScreen mainScreen].bounds.size.width / 10, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:self.engArr[i]];
        }
        button.tag = i;
        [button addTarget:self action:@selector(touchEng:) forControlEvents:UIControlEventTouchUpInside];
        [self.englishBoard addSubview:button];
        
    }
    
    UIButton * delBtn = [self createEnglishButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10 * 7, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 2, [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width / 10 * 7, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:nil];
    [delBtn setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_delete_black"] forState:UIControlStateNormal];
    [delBtn setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_delete_white"] forState:UIControlStateHighlighted];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cleanButton)];
    [delBtn addGestureRecognizer:longPress];
    [delBtn addTarget:self action:@selector(deleteButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.englishBoard addSubview:delBtn];
    
    UIButton * numBtn = [self createEnglishButtonWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 3, [UIScreen mainScreen].bounds.size.width / 10 * 3, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:nil];
    [numBtn setTitle:@"123" forState:UIControlStateNormal];
    [numBtn addTarget:self action:@selector(changeKeyBoardToNumber) forControlEvents:(UIControlEventTouchUpInside)];
    [self.englishBoard addSubview:numBtn];
    
    UIButton * hidBtn = [self createEnglishButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10 * 3, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 3, [UIScreen mainScreen].bounds.size.width / 10 * 3, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:nil];
    [hidBtn setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_keyboard_black"] forState:UIControlStateNormal];
    [hidBtn setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_gpcx_keyboard_white"] forState:UIControlStateHighlighted];
    [hidBtn addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:(UIControlEventTouchUpInside)];
    [self.englishBoard addSubview:hidBtn];
    
    UIButton * conBtn = [self createEnglishButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10 * 3 * 2, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5 * 3, [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width / 10 * 3 * 2, [UIScreen mainScreen].bounds.size.width / 720 * 440 / 5) text:nil];
    [conBtn setTitle:@"确定" forState:UIControlStateNormal];
    [conBtn addTarget:self action:@selector(certainButton) forControlEvents:(UIControlEventTouchUpInside)];
    [self.englishBoard addSubview:conBtn];
}

#pragma mark 创建英文按钮构造方法--------------------------------------------------

- (UIButton *)createEnglishButtonWithFrame:(CGRect)rect
                                      text:(NSString *)text
{
    UIButton * button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = color_bg_gray_f456;
    
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = color16_other_xgw.CGColor;
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:color2_text_xgw forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[self createImageWithColor:color2_text_xgw rect:button.bounds] forState:UIControlStateHighlighted];
    return button;
}

#pragma mark 切换英文键盘--------------------------------------------------

- (void)changeKeyBoardToEnglish
{
    if (self.englishBoard == nil) {
        [self createEnglishBoard];
    }
    self.inputView = self.englishBoard;
    [self reloadInputViews];
}

#pragma mark 根据颜色创建图片--------------------------------------------------

- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark 隐藏键盘--------------------------------------------------

- (void)hiddenKeyBoard
{
    [self resignFirstResponder];
}

#pragma mark 确定按钮--------------------------------------------------

- (void)certainButton
{
    self.text = nil;
    
    [self resignFirstResponder];
}

#pragma mark 删除--------------------------------------------------

- (void)deleteButton
{
    int location = (int)self.selectedRange.location;
    
    if (location > 0) {
        NSString * leftStr = [self.text substringToIndex:location - 1];
        NSString * rightStr = [self.text substringFromIndex:location];
        NSString * str = [NSString stringWithFormat:@"%@%@",leftStr,rightStr];
        self.text = str;
    }
    
    [self setSelectedRange:NSMakeRange(location - 1, 0)];
    
    [self.keyBoardDelegate getKeyBoardString:self.text];
}

- (void)cleanButton
{
    self.text = nil;

    [self.keyBoardDelegate getKeyBoardString:self.text];
}

#pragma mark 输入数字--------------------------------------------------

- (void)touchNum:(UIButton *)button
{
    NSString * buttonStr = self.numArr[button.tag];
    
    //记录光标位置
    NSUInteger location = self.selectedRange.location;
    NSMutableString * str = [NSMutableString stringWithString:self.text];
    [str insertString:buttonStr atIndex:location];
    self.text = str;
    
    //重设光标位置
    [self setSelectedRange:NSMakeRange(location + buttonStr.length, 0)];
    
    [self.keyBoardDelegate getKeyBoardString:str];
}

#pragma mark 输入英文--------------------------------------------------

- (void)touchEng:(UIButton *)button
{
    NSString * buttonStr = self.engArr[button.tag];
    
    //记录光标位置
    NSUInteger location = self.selectedRange.location;
    NSMutableString * str = [NSMutableString stringWithString:self.text];
    [str insertString:buttonStr atIndex:location];
    self.text = [str lowercaseString];
    
    //重设光标位置
    [self setSelectedRange:NSMakeRange(location + buttonStr.length, 0)];
    
    [self.keyBoardDelegate getKeyBoardString:str];
}

@end
