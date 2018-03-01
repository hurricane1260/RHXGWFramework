//
//  CMKeyboardScrollView.m
//  iphone-pay
//
//  Created by 方海龙 on 13-10-15.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import "CMKeyboardScrollView.h"

@implementation CMKeyboardScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)hiddenKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging){
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    
    [self hiddenKeyboard];
    
    [super touchesEnded:touches withEvent:event];
}

@end
