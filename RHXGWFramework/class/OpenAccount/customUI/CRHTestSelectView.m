//
//  CRHTestSelectView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/27.
//
//

#import "CRHTestSelectView.h"
#import "CRHSelContentVo.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+RHJX_Inc.h"

@interface  CRHTestSelectView ()

kRhPStrong UIButton * selBtn;

kRhPStrong TTTAttributedLabel * contentLabel;

kRhPAssign BOOL isSelected;
@end

@implementation CRHTestSelectView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.selBtn = [UIButton didBuildButtonWithTitle:@"" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    [self.selBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selBtn];
    
    self.contentLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];

}

- (void)setContent:(id)content{
    if (!content || ![content isKindOfClass:[CRHSelContentVo class]]) {
        return;
    }
    CRHSelContentVo * vo = content;
    if (vo.isSelected) {
        [self.selBtn setTitle:@"选中" forState:UIControlStateNormal];
        self.isSelected = YES;
    }
    else{
        [self.selBtn setTitle:@"未选" forState:UIControlStateNormal];
        self.isSelected = NO;
    }

}

- (void)btnClick:(UIButton *)btn{
    self.isSelected = !self.isSelected;
    if (self.isSelected) {
        [self.selBtn setTitle:@"选中" forState:UIControlStateNormal];
    }
    else{
        [self.selBtn setTitle:@"未选" forState:UIControlStateNormal];
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.selBtn.frame = CGRectMake(0, 10.0f, 20.0f, 15.0f);
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:self.contentLabel.attributedText withConstraints:CGSizeMake(self.width - CGRectGetMaxX(self.selBtn.frame) -18.0f, MAXFLOAT) limitedToNumberOfLines:0];
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.selBtn.frame) + 8.0f, self.selBtn.y, size.width, size.height);
    

}

@end
