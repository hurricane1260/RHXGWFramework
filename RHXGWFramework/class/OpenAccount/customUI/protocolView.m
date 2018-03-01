//
//  protocolView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/20.
//
//

#import "protocolView.h"
#import "TTTAttributedLabel.h"

@interface protocolView ()

kRhPStrong UIButton * selectBtn;

kRhPStrong TTTAttributedLabel * btn;

kRhPStrong UIButton * contentBtn;

kRhPStrong UIButton * nextBtn;


@end

@implementation protocolView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.selectBtn = [UIButton didBuildButtonWithNormalImage:img_open_click highlightImage:img_open_click];
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    self.isSelected = NO;
    [self addSubview:self.selectBtn];
    
    self.agreeLabel = [UILabel didBuildLabelWithText:@"我已阅读并同意：" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.agreeLabel];
    
    self.contentBtn = [UIButton didBuildButtonWithTitle:@"" normalTitleColor:color8_text_xgw highlightTitleColor:color8_text_xgw disabledTitleColor:color8_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    self.contentBtn.titleLabel.font = font1_common_xgw;
    self.contentBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentBtn addTarget:self action:@selector(prorocolClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contentBtn];
    
    //self.btn = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    
    self.nextBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextBtn];
    self.nextBtn.enabled = NO;
    [self addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.autoLine.frame = CGRectMake(0, 0, self.width, 0.5f);
    
    self.selectBtn.frame = CGRectMake(24.0f, 20.0f, 17.0f, 17.0f);
    
    [self.agreeLabel sizeToFit];
    self.agreeLabel.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + 12.0f, self.selectBtn.y, self.agreeLabel.width, self.agreeLabel.height);
    
    [self.contentBtn.titleLabel sizeToFit];
    self.contentBtn.frame = CGRectMake(CGRectGetMaxX(self.agreeLabel.frame), self.selectBtn.y, self.contentBtn.titleLabel.width, self.contentBtn.titleLabel.height);
    self.agreeLabel.center = CGPointMake(self.agreeLabel.center.x, self.selectBtn.center.y);
    self.contentBtn.center = CGPointMake(self.contentBtn.center.x, self.selectBtn.center.y);
    
    if (self.bottomProtocol) {
        self.selectBtn.y = 10.0f;
        self.agreeLabel.y = self.selectBtn.y;
        self.contentBtn.x = self.agreeLabel.x;
        self.contentBtn.y = CGRectGetMaxY(self.selectBtn.frame) + 5.0f;
        if (self.contentBtn.width > self.width - self.contentBtn.x) {
//            self.contentBtn.x = self.width - self.contentBtn.width;
            self.contentBtn.width = self.width - self.contentBtn.x - 24.0f;
        }
        else if (self.width - self.contentBtn.width < 0.0f){
            self.contentBtn.x = 0.0f;
        }
    }
    
//    self.nextBtn.layer.cornerRadius = 3.0f;
//    self.nextBtn.clipsToBounds = YES;
//    self.nextBtn.width = self.width - 48.0f;
    self.nextBtn.frame = CGRectMake((self.width - self.nextBtn.width ) /2.0f, self.height - self.nextBtn.height - 14.0f, self.nextBtn.width, self.nextBtn.height);
}

- (void)setProtocolName:(NSString *)protocolName{
    _protocolName = protocolName;
//    NSString * p = [NSString stringWithFormat:@"《%@》",_protocolName];
    [self.contentBtn setTitle:_protocolName forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        [self.selectBtn setImage:img_open_click forState:UIControlStateNormal];
    }
    else{
        [self.selectBtn setImage:img_open_deselect forState:UIControlStateNormal];

    }
    [self setNeedsLayout];
}

- (void)selectClick:(UIButton *)btn{
    self.isSelected = !self.isSelected;
    if (self.selectCallBack) {
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithBool:self.isSelected] forKey:@"select"];
        self.selectCallBack(param);
    }

}

- (void)prorocolClick:(UIButton *)btn{
    if (self.protocolCallBack) {
        self.protocolCallBack();
    }
    
}

- (void)nextClick:(UIButton *)btn{
    self.nextBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nextBtn.enabled = YES;
    });
    if (self.nextCallBack) {
        self.nextCallBack();
    }
}

- (void)setEnable:(BOOL)enable{
    self.nextBtn.enabled = enable;
    [self setNeedsLayout];
}
@end
