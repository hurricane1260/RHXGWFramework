//
//  APTopView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import "APTopView.h"

@interface APTopView ()

kRhPStrong UILabel * saleLabel;

kRhPStrong UILabel * commissionLabel;

@end

@implementation APTopView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = color1_text_xgw;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.saleLabel = [UILabel didBuildLabelWithText:@"开户营业部：北京万寿路" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.saleLabel];
    
    self.commissionLabel = [UILabel didBuildLabelWithText:@"佣金：0.025%" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.commissionLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.saleLabel sizeToFit];
    [self.commissionLabel sizeToFit];
    
    self.saleLabel.frame = CGRectMake(24.0f, (self.height - self.saleLabel.height )/2.0f, self.saleLabel.width, self.saleLabel.height);
    
    self.commissionLabel.frame = CGRectMake(self.width - 24.0f - self.commissionLabel.width, self.saleLabel.y, self.saleLabel.width, self.saleLabel.height);
    
}

-(void)setCommission:(NSString *)commission{
    _commission = commission;
    self.commissionLabel.text = _commission;
    [self setNeedsLayout];

}

@end
