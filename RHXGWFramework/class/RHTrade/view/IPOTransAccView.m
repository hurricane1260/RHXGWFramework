
//
//  IPOTransAccView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/16.
//
//

#import "IPOTransAccView.h"

@interface IPOTransAccView ()

kRhPStrong UILabel * usableLabel;

kRhPStrong UIButton * transBtn;

@end


@implementation IPOTransAccView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
        self.backgroundColor = color1_text_xgw;
    }
    return self;
}

- (void)initSubviews{
    _usableLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:_usableLabel];
    
    _transBtn = [UIButton didBuildB7_2ButtonWithTitle:@"银证转账"];
    [_transBtn addTarget:self action:@selector(transClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_transBtn];

}

-(void)setUsableMoney:(NSNumber *)usableMoney{
    _usableLabel.text = [NSString stringWithFormat:@"可用金额：%@元",usableMoney];
    _usableLabel.attributedText = [CPStringHandler getStringWithStr:_usableLabel.text sepByStr:@"：" withPreColor:color2_text_xgw withPreFont:font2_common_xgw withSufColor:color6_text_xgw withSufFont:font4_number_xgw];
//    _usableLabel.attributedText = [CPStringHandler getStringWithStr:_usableLabel.text sepByStr:@":" withPreColor:color2_text_xgw withPreFont:font2_common_xgw withSufColor:color6_text_xgw withSufFont:font4_number_xgw];
    [self setNeedsLayout];
}

- (void)transClick:(UIButton *)btn{
    if (self.transCallBack) {
        self.transCallBack();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_usableLabel sizeToFit];
    
    _usableLabel.frame = CGRectMake(margin_12, (self.height - _usableLabel.height )/2.0f, _usableLabel.width, _usableLabel.height);

    _transBtn.frame = CGRectMake(self.width - _transBtn.width - margin_12, (self.height - _transBtn.height)/2.0f, _transBtn.width, _transBtn.height);
}
@end
