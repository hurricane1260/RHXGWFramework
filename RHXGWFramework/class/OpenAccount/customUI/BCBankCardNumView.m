//
//  BCBankCardNumView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/9/18.
//
//

#import "BCBankCardNumView.h"

@interface BCBankCardNumView ()<UITextFieldDelegate>

kRhPStrong UILabel * titleLabel;

kRhPCopy NSString * title;

kRhPCopy NSString * placeholder;

kRhPStrong UIButton * rightBtn;

@end

@implementation BCBankCardNumView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.titleLabel =  [UILabel didBuildLabelWithText:@"银行卡号" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = font2_common_xgw;
    self.textField.textColor = color2_text_xgw;
    self.textField.placeholder = @"请输入银行卡号";
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textField];
    
    self.rightBtn = [UIButton didBuildButtonWithNormalImage:img_open_bcPhoto highlightImage:img_open_bcPhoto];
    [self.rightBtn addTarget: self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBtn];
    
    [self addAutoLineWithColor:color16_other_xgw];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(24.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
//    self.textField.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 12.0f, 0, self.width - CGRectGetMaxX(self.titleLabel.frame) -12.0f - 24.0f - 30.0f, self.height - 0.5f);
    
//    if (self.offsetX == 0) {
//        self.textField.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 12.0f, 0, self.width - CGRectGetMaxX(self.titleLabel.frame) -12.0f - 24.0f, self.height - 0.5f);
//    }
//    else{
        self.textField.frame = CGRectMake(self.offsetX, 0, self.width - self.offsetX - 24.0f - 30.0f - 12.0f, self.height - 0.5f);
        
//    }
    
    self.rightBtn.frame = CGRectMake(self.width - 30.0f - 24.0f, 10.0f, 30.0f, 30.0f);
    
    self.autoLine.frame = CGRectMake(self.titleLabel.x, self.height - 0.5f, self.width - self.titleLabel.x, 0.5f);
}

- (void)photoClick:(UIButton *)btn{
    if (self.photoCallBack) {
        self.photoCallBack();
    }

}

- (void)setBankCode:(NSString *)bankCode{
    if (!bankCode || !bankCode.length) {
        return;
    }
    
    self.textField.text = bankCode;
    [self setNeedsLayout];
    
}

- (void)setPlaceholder:(NSString *)placeholder{
    if (!placeholder || !placeholder.length) {
        return;
    }
    self.textField.placeholder = placeholder;
    [self setNeedsLayout];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.editingCallBack) {
        self.editingCallBack();
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length == 19) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.endEditCallBack) {
        self.endEditCallBack();
    }
    
    if (self.editingCallBack) {
        self.editingCallBack();
    }
    return YES;
}

@end
