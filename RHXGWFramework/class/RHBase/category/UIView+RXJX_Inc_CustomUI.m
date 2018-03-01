//
//  UIView+RXJX_Inc_CustomUI.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/2/9.
//
//

#import "UIView+RXJX_Inc_CustomUI.h"
#import <objc/runtime.h>

@implementation UIView (RXJX_Inc_CustomUI)
static char autoLineView;
@dynamic autoLine;

-(void)setAutoLine:(UIView *)autoLine{
    [self willChangeValueForKey:@"autoLine"];
    objc_setAssociatedObject(self, &autoLineView, autoLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"autoLine"];
}

- (UIView *)autoLine{
    return objc_getAssociatedObject(self, &autoLineView);
}

- (void)addAutoLineWithColor:(UIColor *)color{
    self.autoLine = [[UIView alloc] init];;
    self.autoLine.backgroundColor = color;
    self.autoLine.frame = CGRectMake(0, self.height - 0.5f, self.width, 0.5f);
    [self addSubview:self.autoLine];
}

- (UIView *)addAutoLineViewWithColor:(UIColor *)color{
    [self addAutoLineWithColor:color];
    return self.autoLine;
}

@end
