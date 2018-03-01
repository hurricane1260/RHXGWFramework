//
//  CustomNumberView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/4.
//
//

#import "CustomNumberView.h"
@interface CustomNumberView ()
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)UIButton * openBtn;
@property (nonatomic,strong)UILabel * textLb;


@end
@implementation CustomNumberView

-(instancetype)init{
    
    if (self = [super init ]) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    self.bgView = [[UIView alloc]init];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = color14_icon_xgw.CGColor;
    [self addSubview:self.bgView];
    
    self.openBtn = [[UIButton alloc]init];
    [self addSubview:self.openBtn];
    self.openBtn.backgroundColor = color10_text_xgw;
    [self.openBtn setTitle:@"复制并打开" forState:UIControlStateNormal];
    [self.openBtn setTitleColor:color1_text_xgw forState:UIControlStateNormal];
    self.openBtn.titleLabel.font = font2_common_xgw;
    [self.openBtn addTarget:self action:@selector(openBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.textLb = [[UILabel alloc]init];
    self.textLb.textColor =color3_text_xgw;
    self.textLb.font = font3_common_xgw;
    [self.bgView addSubview:self.textLb];
    
   
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.openBtn.frame = CGRectMake(self.frame.size.width-100, 0, 100, self.frame.size.height);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.openBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.openBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.openBtn.layer.mask = maskLayer;
    
    
    [self.textLb sizeToFit];
    self.textLb.center = CGPointMake(12+self.textLb.frame.size.width/2, self.bgView.center.y);
}
-(void)setNumberText:(NSString *)numberText{
    
    self.textLb.text = numberText;
    [self setNeedsLayout];
}
-(void)openBtnClick{
    /**复制文字到剪切板*/
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.textLb.text];
    
    if (self.openBlock) {
        self.openBlock(self.textLb.text);
    }
}
@end
