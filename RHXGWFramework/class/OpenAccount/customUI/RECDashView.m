//
//  RECDashView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/27.
//
//

#import "RECDashView.h"

@interface RECDashView ()

kRhPStrong UILabel * hintLabel;


@end

@implementation RECDashView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = color_clear;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.hintLabel = [UILabel didBuildLabelWithText:@"请保持头部在红色虚线框里" font:font3_common_xgw textColor:color_rec_red wordWrap:NO];
    [self addSubview:self.hintLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.hintLabel sizeToFit];
    self.hintLabel.frame = CGRectMake((self.width - self.hintLabel.width)/2.0f, 0.0f, self.hintLabel.width, self.hintLabel.height);
}

- (void)drawRect:(CGRect)rect{
//    [self dashLine:40.0f];
    [self dashLine:CGRectGetMaxY(self.hintLabel.frame) + 20.0f];
}

//添加虚线
-(void)dashLine:(CGFloat)y{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(34.0f ,y)];
    [path addLineToPoint:CGPointMake(self.width - 34.0f, y)];
    [path addLineToPoint:CGPointMake(self.width - 34.0f, self.height - 20.0f)];
    [path addLineToPoint:CGPointMake(34.0f, self.height - 20.0f)];
    [path addLineToPoint:CGPointMake(34.0f ,y)];
    CGFloat dash[] = {3.5,3.5};
    [path setLineDash:dash count:2 phase:0];
    [color_rec_red setStroke];
    [path stroke];
}

@end
