//
//  APSingleView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import "APSingleView.h"

//typedef enum : NSInteger {
//    changeType,
//    disChangeType,
//
//}viewType;

@interface APSingleView ()<UITextFieldDelegate>

kRhPStrong UILabel * titleLabel;

kRhPCopy NSString * title;


//kRhPStrong UIButton * showBtn;
@end


@implementation APSingleView


- (instancetype)initWithTitle:(NSString * )title withPlaceholder:(NSString *)placeholder{
    if (self = [super init]) {
        self.title = title;
        self.placeholder = placeholder;
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews{
    self.titleLabel =  [UILabel didBuildLabelWithText:self.title font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = font2_common_xgw;
    self.textField.textColor = color2_text_xgw;
    self.textField.placeholder = self.placeholder;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textField];
    
//    self.showBtn = [[UIButton alloc] init];
//    [self addSubview:self.showBtn];
    
    [self addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(24.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    if (self.offsetX == 0) {
        self.textField.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 12.0f, 0, self.width - CGRectGetMaxX(self.titleLabel.frame) -12.0f - 24.0f, self.height - 0.5f);
    }
    else{
        self.textField.frame = CGRectMake(self.offsetX, 0, self.width - self.offsetX - 24.0f, self.height - 0.5f);
    
    }
    
    self.autoLine.frame = CGRectMake(self.titleLabel.x, self.height - 0.5f, self.width - self.titleLabel.x, 0.5f);

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

- (void)setPlaceholder:(NSString *)placeholder{
    if (!placeholder) {
        return;
    }
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
    [self setNeedsLayout];
}

@end
