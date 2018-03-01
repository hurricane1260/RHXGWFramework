//
//  SingleSwichView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/8/17.
//
//

#import "SingleSwichView.h"

@interface SingleSwichView ()

kRhPStrong UILabel * titleLabel;

kRhPStrong UISwitch * swichBtn;

@end

@implementation SingleSwichView

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        [self initSubviewsWithTitle:title];
    }
    return self;
}

- (void)initSubviewsWithTitle:(NSString *)title{
    
    self.titleLabel = [UILabel didBuildLabelWithText:title font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.swichBtn = [[UISwitch alloc] init];
    [self.swichBtn addTarget:self action:@selector(swithBtnClick:) forControlEvents:UIControlEventValueChanged];
    [self.swichBtn setOn:YES];
    [self addSubview:self.swichBtn];
 
    [self addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(24.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    self.swichBtn.frame = CGRectMake(self.width - 24.0f - self.swichBtn.width, (self.height - self.swichBtn.height)/2.0f, self.swichBtn.width, self.swichBtn.height);
    
    self.autoLine.frame = CGRectMake(24.0f, self.height - 0.5f, self.width - 24.0f, 0.5f);
}

- (void)swithBtnClick:(UISwitch *)swich{
    if (!swich.isOn) {
        if (self.swichClickCallBack) {
            self.swichClickCallBack();
        }
        [swich setOn:YES];
        return;
    }
    
}

@end
