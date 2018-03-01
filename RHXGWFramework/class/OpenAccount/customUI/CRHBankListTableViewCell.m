//
//  CRHBankListTableViewCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/31.
//
//

#import "CRHBankListTableViewCell.h"
#import "CRHBankListVo.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+RHJX_Inc.h"
#import "RHLabelAttributeTool.h"

@interface CRHBankListTableViewCell ()

kRhPStrong UIImageView * bankImgView;

kRhPStrong UILabel * titleLabel;

kRhPStrong TTTAttributedLabel * hintLabel;

kRhPAssign int i;
@end

@implementation CRHBankListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.i = 0;
        [self initSubviews];
    }
    return self;

}

- (void)initSubviews{
    self.bankImgView = [[UIImageView alloc] initWithImage:img_open_bankjt];
    [self.contentView addSubview:self.bankImgView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.titleLabel];
    
    self.hintLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
    self.hintLabel.numberOfLines = 0;
    [self.contentView addSubview:self.hintLabel];

    [self.contentView addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.bankImgView.frame = CGRectMake(24.0f, (self.height - self.bankImgView.height)/2.0f, self.bankImgView.width, self.bankImgView.height);
    
    [self.titleLabel sizeToFit];
    [self.hintLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.bankImgView.frame) + 10.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    CGFloat width = self.width - CGRectGetMaxX(self.titleLabel.frame) - 51.0f;
    if (self.hintLabel.width > width) {
        RHLabelAttributeTool * tool = [[RHLabelAttributeTool alloc] init];
        NSAttributedString * attStr = [tool getAttribute:self.hintLabel.text withParagraphStyleSpace:@8 withFont:font1_common_xgw];
        CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:attStr withConstraints:CGSizeMake(width, MAXFLOAT) limitedToNumberOfLines:0];
        self.hintLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 27.0f, self.titleLabel.y, size.width, size.height);
    }
    else{
    
        self.hintLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 27.0f, (self.height - self.hintLabel.height)/2.0f, self.hintLabel.width, self.hintLabel.height);

    }
    CGFloat height;
    if (self.hintLabel.width > width) {
        height = CGRectGetMaxY(self.hintLabel.frame) + self.titleLabel.y;

    }
    else{
        height = self.height;
    }

    NSString * text = self.hintLabel.text;
    if (text.length) {
        
        self.contentView.autoLine.frame = CGRectMake(24.0f, height - 0.5f, self.width - 24.0f, 0.5f);
        
    }
    else{
        self.contentView.autoLine.frame = CGRectMake(24.0f, self.height - 0.5f, self.width - 24.0f, 0.5f);

    }
}

- (void)loadDataWithModel:(id)model{
    if (!model || ![model isKindOfClass:[CRHBankListVo class]]) {
        return;
    }
    CRHBankListVo * vo = model;
    self.titleLabel.text = vo.bank_name;
    self.hintLabel.text = @"";
    if ([vo.bank_name isEqualToString:@"平安银行"]) {
        self.hintLabel.text = @"首次转账在银行端进行";
        self.bankImgView.image = img_open_bankpa;
    }
    else if ([vo.bank_name isEqualToString:@"招商银行"]) {
        self.hintLabel.text = @"首次转账在银行端进行";
        self.bankImgView.image = img_open_bankzs;
    }
    else if ([vo.bank_name isEqualToString:@"工商银行"]) {
//        self.hintLabel.text = @"开户后需登录银行端绑定";
        self.bankImgView.image = img_open_bankgs;
    }
    else if ([vo.bank_name isEqualToString:@"交通银行"]) {
        self.bankImgView.image = img_open_bankjt;
    }
    else if ([vo.bank_name isEqualToString:@"民生银行"]) {
        self.bankImgView.image = img_open_bankms;
    }
    else if ([vo.bank_name isEqualToString:@"中国银行"]) {
        self.bankImgView.image = img_open_bankzg;
    }
    else if ([vo.bank_name isEqualToString:@"农业银行"]) {
        self.bankImgView.image = img_open_bankny;
    }
    else if ([vo.bank_name isEqualToString:@"浦发银行"]) {
        self.hintLabel.text = @"首次转账在银行端进行，不支持多券商绑定";
        self.bankImgView.image = img_open_bankpf;
    }
    else if ([vo.bank_name isEqualToString:@"广发银行"]) {
        self.bankImgView.image = img_open_bankgf;
    }
    else if ([vo.bank_name isEqualToString:@"兴业银行"]) {
        self.hintLabel.text = @"不支持多券商绑定";
        self.bankImgView.image = img_open_bankxy;
    }
    else if ([vo.bank_name isEqualToString:@"光大银行"]) {
        self.hintLabel.text = @"不支持多券商绑定";
        self.bankImgView.image = img_open_bankgd;
    }
    else if ([vo.bank_name isEqualToString:@"上海银行"]) {
        self.bankImgView.image = img_open_banksh;
    }
    else if ([vo.bank_name isEqualToString:@"建设银行"]) {
        self.bankImgView.image = img_open_bankjs;
    }
    else if ([vo.bank_name isEqualToString:@"宁波银行"]) {
        self.bankImgView.image = img_open_banknb;
    }
    else if ([vo.bank_name isEqualToString:@"中信银行"]) {
        self.bankImgView.image = img_open_bankzx;
    }
    else if ([vo.bank_name isEqualToString:@"邮政储蓄"] || [vo.bank_name containsString:@"邮政储蓄"]) {
        self.bankImgView.image = img_open_bankyz;
    }
    
    [self layoutSubviews];

    if ([vo.bank_name isEqualToString:@"浦发银行"] && self.heightCallBack && self.i == 0) {
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            CGFloat height = CGRectGetMaxY(self.hintLabel.frame) + self.titleLabel.y;
            if (height > 0) {
                [param setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
                self.heightCallBack(param);
                self.i = 1;
            }
        
    }
}

@end
