//
//  UITextField+ExtentRange.m
//  KeyBoard
//
//  Created by Zzbei on 15/8/11.
//  Copyright (c) 2015年 zbwang. All rights reserved.
//

#import "UITextField+ExtentRange.h"

@implementation UITextField (ExtentRange)

- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

////取消长按弹出按钮
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if ([UIMenuController sharedMenuController]) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return NO;
//}

@end
