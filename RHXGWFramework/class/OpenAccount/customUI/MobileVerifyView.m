//
//  MobileVerifyView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/19.
//
//

#import "MobileVerifyView.h"
#import "UIFactory.h"

@interface MobileVerifyView ()<UITextFieldDelegate>

kRhPStrong UIView * wrapViewPhoneNum;

kRhPStrong UIView * wrapViewVerifyCode;



kRhPStrong NSTimer * timer;

@end

@implementation MobileVerifyView


- (instancetype)init{
    if (self = [super init]) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUp:) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timeNum = 60;
        self.isSelected = NO;

        [self initSubviews];
        
    }
    return self;

}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;

}

- (void)initSubviews{

    //手机号
    _wrapViewPhoneNum = [[UIView alloc] init];
    [self addSubview:_wrapViewPhoneNum];
    self.userNameTextField = [UIFactory didBuildTextFieldWithLeftImage:img_login_tel rightImage:img_clear_form backgroundColor:color1_text_xgw placeholder:kCHSLoginUserNameTextFieldPlaceholder borderCornerRadius:0.0f borderColor:[UIColor clearColor] keyboardType:UIKeyboardTypeDefault];
    self.userNameTextField.delegate = self;
    self.userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userNameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.userNameTextField.textFont = font2_number_xgw;
    [self.wrapViewPhoneNum addSubview:self.userNameTextField];

    [self.wrapViewPhoneNum addAutoLineWithColor:color16_other_xgw];
    
    //验证码
    self.wrapViewVerifyCode = [[UIView alloc] init];
    [self addSubview:self.wrapViewVerifyCode];
    self.verifyTextField = [UIFactory didBuildTextFieldWithLeftImage:img_login_telcode rightImage:img_clear_form backgroundColor:color1_text_xgw placeholder:kCHSPhoneVerifyCodeTextFieldPlaceholder borderCornerRadius:0.0f borderColor:[UIColor clearColor] keyboardType:UIKeyboardTypeDefault];
    self.verifyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.verifyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.verifyTextField.textFont = font2_common_xgw;
    self.verifyTextField.delegate = self;
    self.verifyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.wrapViewVerifyCode addSubview:self.verifyTextField];
    [self.wrapViewVerifyCode addAutoLineWithColor:color16_other_xgw];

    self.smsVerifyLabel = [UILabel didBuildLabelWithText:@"获取验证码" font:font1_common_xgw textColor:color1_text_xgw wordWrap:NO];
    self.smsVerifyLabel.backgroundColor = color6_text_xgw;
    self.smsVerifyLabel.layer.cornerRadius = 3.0f;
    self.smsVerifyLabel.clipsToBounds = YES;
    self.smsVerifyLabel.textAlignment = NSTextAlignmentCenter;
    self.smsVerifyLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVerifyCode)];
    [self.smsVerifyLabel addGestureRecognizer:tap2];
    [self.wrapViewPhoneNum addSubview:self.smsVerifyLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetX = 24.0f;
    CGFloat height = 50.0f;
    self.wrapViewPhoneNum.frame = CGRectMake(offsetX, 0.0f, self.width - 2 * offsetX, height);
    
    self.userNameTextField.frame = CGRectMake(0, 0, self.wrapViewPhoneNum.width - 80.0f, self.wrapViewPhoneNum.height);
    self.smsVerifyLabel.frame = CGRectMake(CGRectGetMaxX(self.userNameTextField.frame), (self.wrapViewPhoneNum.height - self.smsVerifyLabel.height ) /2.0f, 80.0f, 27.0f);
    
    self.wrapViewPhoneNum.autoLine.frame = CGRectMake(0, self.wrapViewPhoneNum.height - 1.0f, self.wrapViewPhoneNum.width, 0.5f);
    
    self.wrapViewVerifyCode.frame = CGRectMake(self.wrapViewPhoneNum.x, CGRectGetMaxY(self.wrapViewPhoneNum.frame), self.wrapViewPhoneNum.width, self.wrapViewPhoneNum.height);
    self.verifyTextField.frame = CGRectMake(0, 0, self.wrapViewVerifyCode.width, self.wrapViewVerifyCode.height);
    self.wrapViewVerifyCode.autoLine.frame = CGRectMake(0, self.wrapViewVerifyCode.height - 1.0f, self.wrapViewVerifyCode.width, 0.5f);
    
}

//验证码
- (void)getVerifyCode{
    if (self.userNameTextField.text.length != 11) {
        //输入您要获取短信的手机号码
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入正确的手机号码"  warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
        return;
    }
//    self.isSelected = !self.isSelected;
    
    if (self.verifyCodeCallBack) {
        self.verifyCodeCallBack();
    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.smsVerifyLabel.backgroundColor = color_open_notselect;
        self.timeNum = 60;
        [self.timer setFireDate:[NSDate distantPast]];
    }
    else{
        self.smsVerifyLabel.backgroundColor = color6_text_xgw;
        self.smsVerifyLabel.text = @"重新发送";
    }
    self.smsVerifyLabel.userInteractionEnabled = !_isSelected;
    [self setNeedsLayout];
}

- (void)timerUp:(NSTimer *)timer{
    if (self.timeNum == 0) {
        self.isSelected = NO;
        [self.timer setFireDate:[NSDate distantFuture]];
        return;
    }
    
    self.smsVerifyLabel.text = [NSString stringWithFormat:@"%lds后重试",self.timeNum];
    
    self.timeNum--;
    
    [self setNeedsLayout];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self checkUserNameAndPassword];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length > 10) {
        return NO;
    }
    [self checkUserNameAndPassword];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self hideKeyboards];
    return YES;
}

-(void)hideKeyboards{
    [self.userNameTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboards];
    return YES;
}

- (void)checkUserNameAndPassword{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    if (self.userNameTextField.text.length >= 10 && self.verifyTextField.text.length >= 3) {
        [param setObject:@1 forKey:@"enable"];
    }
    else{
        [param setObject:@0 forKey:@"enable"];
    }
    self.enableCallBack(param);

}
@end
