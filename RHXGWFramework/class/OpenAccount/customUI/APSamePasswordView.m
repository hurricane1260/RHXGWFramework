//
//  APSamePasswordView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/28.
//
//

#import "APSamePasswordView.h"

@interface APSamePasswordView ()

kRhPStrong UIButton * selectBtn;

kRhPStrong UILabel * titleLabel;

kRhPAssign BOOL isSelected;

@end

@implementation APSamePasswordView

- (instancetype)init{
    if (self = [super init]) {
        self.isSelected = YES;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.selectBtn = [UIButton didBuildButtonWithNormalImage:img_open_click highlightImage:img_open_click];
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.selectBtn];
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"资金密码和交易密码相同" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    [self addAutoLineWithColor:color16_other_xgw];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.selectBtn.frame = CGRectMake(24.0f, (self.height - self.selectBtn.imageView.height )/2.0f, self.selectBtn.imageView.width, self.selectBtn.imageView.height);
    self.selectBtn.frame = CGRectMake(24.0f, (self.height - self.selectBtn.height )/2.0f, 20.0f, 20.0f);

    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + 10.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    self.autoLine.frame = CGRectMake(0, self.height - 0.5f, self.width , 0.5);
}

- (void)selectClick:(UIButton *)btn{
    self.isSelected = !self.isSelected;
    
    if (self.isSelected) {
        [self.selectBtn setImage:img_open_click forState:UIControlStateNormal];
    }
    else{
        [self.selectBtn setImage:img_open_deselect forState:UIControlStateNormal];
    }
    
    if (self.selectCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithBool:self.isSelected] forKey:@"select"];
        self.selectCallBack(param);
    }

}

@end
