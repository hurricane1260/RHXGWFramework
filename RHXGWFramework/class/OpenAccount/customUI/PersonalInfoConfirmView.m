//
//  PersonalInfoConfirmView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/11.
//
//

#import "PersonalInfoConfirmView.h"
#import "PersonInfoVo.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+RHJX_Inc.h"
#import "RHLabelAttributeTool.h"

@interface PersonalInfoConfirmView ()

kRhPStrong UIView * backView;

kRhPStrong UILabel * titleLabel;

kRhPStrong UILabel * nameLabel;

kRhPStrong UILabel * cardIdLabel;

kRhPStrong UILabel * addressLabel;

kRhPStrong TTTAttributedLabel * name;

kRhPStrong UILabel * cardId;

kRhPStrong TTTAttributedLabel * address;

kRhPStrong UIButton * modifyBtn;

kRhPStrong UIButton * sureBtn;

kRhPStrong UIView * line;

kRhPStrong RHLabelAttributeTool * tool;
@end

@implementation PersonalInfoConfirmView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (RHLabelAttributeTool *)tool{
    if (!_tool) {
        _tool = [[RHLabelAttributeTool alloc] init];
    }
    return _tool;
}


- (void)initSubviews{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];

    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = color1_text_xgw;
//    self.backView.layer.cornerRadius
    [self addSubview:self.backView];

    self.titleLabel = [UILabel didBuildLabelWithText:@"身份证信息确认" font:font4_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.backView addSubview:self.titleLabel];
    
    self.nameLabel = [UILabel didBuildLabelWithText:@"姓名" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.backView addSubview:self.nameLabel];
    
    self.cardIdLabel = [UILabel didBuildLabelWithText:@"身份证号" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.backView addSubview:self.cardIdLabel];
    
    self.addressLabel = [UILabel didBuildLabelWithText:@"证件地址" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.backView addSubview:self.addressLabel];

//    self.name = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
    self.name = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:YES];
    [self.backView addSubview:self.name];

    self.cardId = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.backView addSubview:self.cardId];

    
    self.address = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.address.numberOfLines = 0;
    [self.backView addSubview:self.address];

    self.modifyBtn = [UIButton didBuildButtonWithTitle:@"修改" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    self.modifyBtn.titleLabel.font = font2_common_xgw;
    [self.modifyBtn addTarget:self action:@selector(modifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.modifyBtn];
    
    self.sureBtn = [UIButton didBuildButtonWithTitle:@"确认" normalTitleColor:color6_text_xgw highlightTitleColor:color6_text_xgw disabledTitleColor:color6_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    self.sureBtn.titleLabel.font = font2_common_xgw;
    [self.sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.sureBtn];
    
    self.line = [self.backView addAutoLineViewWithColor:color16_other_xgw];
    [self.backView addAutoLineWithColor:color16_other_xgw];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetY = 20.0f;
    
    self.backView.frame = CGRectMake((self.width - self.backView.width ) /2.0f, (self.height - self.backView.height )/2.0f, self.width - 60.0f, 100.0f);
    self.backView.layer.cornerRadius = 6.0f;
    self.backView.clipsToBounds = YES;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.backView.width - self.titleLabel.width)/2.0f, offsetY, self.titleLabel.width, self.titleLabel.height);
    
    [self.nameLabel sizeToFit];
    [self.cardIdLabel sizeToFit];
    [self.addressLabel sizeToFit];
    
//    [self.name sizeToFit];
    [self.cardId sizeToFit];
    [self.address sizeToFit];
    
    CGFloat gap = 20.0f;
    CGFloat offsetX = 95.0f;
    
    self.nameLabel.frame = CGRectMake(gap, CGRectGetMaxY(self.titleLabel.frame) + 27.0f, self.nameLabel.width ,  self.nameLabel.height);
    
    self.name.attributedText = [self.tool getAttribute:self.name.text withParagraphStyleSpace:@6 withFont:font3_common_xgw];
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:self.name.attributedText
                                                   withConstraints:CGSizeMake(self.backView.width - gap - offsetX, MAXFLOAT)
                                            limitedToNumberOfLines:0];
    self.name.frame = CGRectMake(offsetX, self.nameLabel.y, size.width, size.height);
    
    self.cardIdLabel.frame = CGRectMake(gap, CGRectGetMaxY(self.name.frame) + offsetY, self.cardIdLabel.width, self.cardIdLabel.height);
    
    self.cardId.frame = CGRectMake(self.name.x, self.cardIdLabel.y, self.cardId.width, self.cardId.height);
    
    self.addressLabel.frame = CGRectMake(gap, CGRectGetMaxY(self.cardIdLabel.frame) + offsetY, self.addressLabel.width, self.addressLabel.height);
    
    self.address.attributedText = [self.tool getAttribute:self.address.text withParagraphStyleSpace:@6 withFont:font3_common_xgw];
    CGSize size1 = [TTTAttributedLabel sizeThatFitsAttributedString:self.address.attributedText
                                             withConstraints:CGSizeMake(self.backView.width - gap - offsetX, MAXFLOAT)
                                      limitedToNumberOfLines:0];
    self.address.frame = CGRectMake(self.name.x, self.addressLabel.y, size1.width, size1.height);
    
    self.backView.autoLine.frame = CGRectMake(0, CGRectGetMaxY(self.address.frame) + offsetY, self.backView.width, 1.0f);
    
    self.line.frame = CGRectMake(self.backView.width / 2.0f, self.backView.autoLine.y, 1.0f, 43.0f);
    
    self.backView.height = CGRectGetMaxY(self.line.frame);
    self.backView.center = self.center;
    
    self.modifyBtn.frame = CGRectMake(0, CGRectGetMaxY(self.backView.autoLine.frame), (self.backView.width - self.line.width)/2.0f, self.line.height);
    
     self.sureBtn.frame = CGRectMake(CGRectGetMaxX(self.line.frame) , self.modifyBtn.y, (self.backView.width - self.line.width)/2.0f, self.line.height);
}

- (void)setDetailData:(id)detailData{
    if (!detailData || ![detailData isKindOfClass:[PersonInfoVo class]]) {
        return;
    }
    PersonInfoVo * infoVo = detailData;
    self.name.text = infoVo.name;
    self.cardId.text = infoVo.cardId;
    self.address.text = infoVo.address;
    [self setNeedsLayout];
}

- (void)modifyInfo:(UIButton *)btn{
    if (self.modifyCallBack) {
        self.modifyCallBack();
    }

}

- (void)sureClick:(UIButton *)btn{
    if (self.sureCallBack) {
        self.sureCallBack();
    }
}

@end
