//
//  BCBankCardChooseView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/28.
//
//

#import "BCBankCardChooseView.h"
#import "BankInfo.h"

@interface BCBankCardChooseView ()

kRhPStrong UILabel * titleLabel;

kRhPStrong UIButton * clickBtn;

kRhPStrong UILabel * hintLabel;

kRhPStrong UIButton * arrowBtn;

kRhPStrong UIImageView * bankImgView;

kRhPStrong UILabel * bankNameLabel;

kRhPAssign BOOL hasSelectBank;
@end

@implementation BCBankCardChooseView

- (instancetype)init{
    if (self = [super init]) {
        self.hasSelectBank = NO;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"选择银行" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"请选择一家存管银行" font:font3_common_xgw textColor:color5_text_xgw wordWrap:NO];
    [self addSubview:self.hintLabel];
    
    self.arrowBtn = [UIButton didBuildButtonWithNormalImage:img_open_rightArrow highlightImage:img_open_rightArrow];
    [self addSubview:self.arrowBtn];
    
    self.bankImgView = [[UIImageView alloc] initWithImage:img_open_bankjs];
    [self addSubview:self.bankImgView];
    
    self.bankNameLabel = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.bankNameLabel];
    
    self.clickBtn = [[UIButton alloc] init];
    [self.clickBtn addTarget:self action:@selector(bankChoose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clickBtn];

    [self addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetX = 117.0f;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(24.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    [self.hintLabel sizeToFit];
    self.hintLabel.frame = CGRectMake(offsetX, (self.height - self.hintLabel.height)/2.0f, self.hintLabel.width, self.hintLabel.height);
    
    self.arrowBtn.frame = CGRectMake(self.width - 30.0f - 24.0f, 10.0f, 30.0f, 30.0f);
    
    
    UIImage * img = img_open_bankjs;
//    self.bankImgView.frame = CGRectMake(offsetX, (self.height - self.bankImgView.height )/2.0f, self.bankImgView.width, self.bankImgView.height);
    self.bankImgView.frame = CGRectMake(offsetX, (self.height - self.bankImgView.height)/2.0f, img.size.width, img.size.height);
    
    [self.bankNameLabel sizeToFit];
    self.bankNameLabel.frame = CGRectMake(CGRectGetMaxX(self.bankImgView.frame) + 12.0f, (self.height - self.bankNameLabel.height ) /2.0f ,self.bankNameLabel.width, self.bankNameLabel.height);
    
    self.hintLabel.hidden = self.hasSelectBank;
    self.bankImgView.hidden = !self.hasSelectBank;
    self.bankNameLabel.hidden = !self.hasSelectBank;
    
    self.autoLine.frame = CGRectMake(24.0f, self.height - 0.5f, self.width - offsetX, 0.5f);
    
    self.clickBtn.frame = CGRectMake(offsetX, 0, self.width - offsetX, self.height);
}

- (void)setBank:(id )bank{
    if (!bank || (![bank isKindOfClass:[CRHBankListVo class]] && ![bank isKindOfClass:[BankInfo class]])) {
        return;
    }
    NSString * bankName;
    if ([bank isKindOfClass:[CRHBankListVo class]]) {
        CRHBankListVo * vo = bank;
        bankName = vo.bank_name;
        self.bankNameLabel.text = bankName;
        
        if ([bankName isEqualToString:@"平安银行"]) {
            self.hintLabel.text = @"首次转账在银行端进行";
            self.bankImgView.image = img_open_bankpa;
        }
        else if ([bankName isEqualToString:@"招商银行"]) {
            self.hintLabel.text = @"首次转账在银行端进行";
            self.bankImgView.image = img_open_bankzs;
        }
        else if ([bankName isEqualToString:@"工商银行"]) {
            self.hintLabel.text = @"开户后需登录银行端绑定";
            self.bankImgView.image = img_open_bankgs;
        }
        else if ([bankName isEqualToString:@"交通银行"]) {
            self.bankImgView.image = img_open_bankjt;
        }
        else if ([bankName isEqualToString:@"民生银行"]) {
            self.bankImgView.image = img_open_bankms;
        }
        else if ([bankName isEqualToString:@"中国银行"]) {
            self.bankImgView.image = img_open_bankzg;
        }
        else if ([bankName isEqualToString:@"农业银行"]) {
            self.bankImgView.image = img_open_bankny;
        }
        else if ([bankName isEqualToString:@"浦发银行"]) {
            self.bankImgView.image = img_open_bankpf;
        }
        else if ([bankName isEqualToString:@"广发银行"]) {
            self.bankImgView.image = img_open_bankgf;
        }
        else if ([bankName isEqualToString:@"兴业银行"]) {
            self.bankImgView.image = img_open_bankxy;
        }
        else if ([bankName isEqualToString:@"光大银行"]) {
            self.bankImgView.image = img_open_bankgd;
        }
        else if ([bankName isEqualToString:@"上海银行"]) {
            self.bankImgView.image = img_open_banksh;
        }
        else if ([bankName isEqualToString:@"建设银行"]) {
            self.bankImgView.image = img_open_bankjs;
        }
        else if ([bankName isEqualToString:@"宁波银行"]) {
            self.bankImgView.image = img_open_banknb;
        }
        else if ([bankName isEqualToString:@"中信银行"]) {
            self.bankImgView.image = img_open_bankzx;
        }
        else if ([bankName isEqualToString:@"邮政储蓄"] || [bankName containsString:@"邮政储蓄"]) {
            self.bankImgView.image = img_open_bankyz;
        }
        
        self.hasSelectBank = YES;

    }
    else if ([bank isKindOfClass:[BankInfo class]]){
        BankInfo * bankInfo = bank;

        bankName = bankInfo.bankName;
        
        if ([bankName containsString:@"平安银行"]) {
            self.bankNameLabel.text = @"平安银行";

            self.bankImgView.image = img_open_bankpa;
        }
        else if ([bankName containsString:@"招商银行"]) {
            self.bankNameLabel.text = @"招商银行";

            self.bankImgView.image = img_open_bankzs;
        }
        else if ([bankName containsString:@"工商银行"]) {
            self.bankNameLabel.text = @"工商银行";

            self.bankImgView.image = img_open_bankgs;
        }
        else if ([bankName containsString:@"交通银行"]) {
            self.bankNameLabel.text = @"交通银行";

            self.bankImgView.image = img_open_bankjt;
        }
        else if ([bankName containsString:@"民生银行"]) {
            self.bankNameLabel.text = @"民生银行";

            self.bankImgView.image = img_open_bankms;
        }
        else if ([bankName containsString:@"中国银行"]) {
            self.bankNameLabel.text = @"中国银行";

            self.bankImgView.image = img_open_bankzg;
        }
        else if ([bankName containsString:@"农业银行"]) {
            self.bankNameLabel.text = @"农业银行";

            self.bankImgView.image = img_open_bankny;
        }
        else if ([bankName containsString:@"浦发银行"]|| [bankName containsString:@"浦东发展"]) {
            self.bankNameLabel.text = @"浦发银行";

            self.bankImgView.image = img_open_bankpf;
        }
        else if ([bankName containsString:@"广发银行"] || [bankName containsString:@"广东发展"]) {
            self.bankNameLabel.text = @"广发银行";

            self.bankImgView.image = img_open_bankgf;
        }
        else if ([bankName containsString:@"兴业银行"]) {
            self.bankNameLabel.text = @"兴业银行";

            self.bankImgView.image = img_open_bankxy;
        }
        else if ([bankName containsString:@"光大"]) {
            self.bankNameLabel.text = @"光大银行";

            self.bankImgView.image = img_open_bankgd;
        }
        else if ([bankName containsString:@"上海银行"]) {
            self.bankNameLabel.text = @"上海银行";

            self.bankImgView.image = img_open_banksh;
        }
        else if ([bankName containsString:@"建设银行"]) {
            self.bankNameLabel.text = @"建设银行";

            self.bankImgView.image = img_open_bankjs;
        }
        else if ([bankName containsString:@"宁波银行"]) {
            self.bankNameLabel.text = @"宁波银行";

            self.bankImgView.image = img_open_banknb;
        }
        else if ([bankName containsString:@"中信银行"]) {
            self.bankNameLabel.text = @"中信银行";

            self.bankImgView.image = img_open_bankzx;
        }
        else if ([bankName containsString:@"邮政储蓄"]) {
            self.bankNameLabel.text = @"邮政储蓄";

            self.bankImgView.image = img_open_bankyz;
        }
        self.hasSelectBank = YES;

    }
    
        [self setNeedsLayout];
}

- (void)bankChoose{
    if (self.chooseCallBack) {
        self.chooseCallBack();
    }
}

- (NSString *)bankName{
    
    return self.bankNameLabel.text;
    
}
@end
