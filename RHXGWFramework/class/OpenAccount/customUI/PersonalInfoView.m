//
//  PersonalInfoView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/11.
//
//

#import "PersonalInfoView.h"

@interface PersonalInfoView ()<UITextViewDelegate>


kRhPStrong UIButton * expandBtn;

kRhPAssign BOOL isExpand;
@end


@implementation PersonalInfoView

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        self.isExpand = NO;
        self.title = title;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:self.title font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.backView addSubview:self.titleLabel];
    
    self.textView = [[UITextView alloc] init];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.textView.delegate = self;
    
    [self.textView setFont:font3_common_xgw];
    [self.textView setTextColor:color2_text_xgw];
    [self.backView addSubview:self.textView];
    
    [self.backView addAutoLineWithColor:color16_other_xgw];
    
    self.expandBtn = [UIButton didBuildButtonWithNormalImage:img_open_down highlightImage:img_open_down];
//    self.expandBtn = [[UIButton alloc] init];
    self.expandBtn.hidden = YES;
    [self.expandBtn addTarget:self action:@selector(expandSelectItems) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.expandBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.height == 0) {
        self.height = 50.0f;
    }
    if (self.width == 0) {
        self.width = MAIN_SCREEN_WIDTH;
    }
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(24.0f, (self.backView.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
     CGSize size = [self.textView sizeThatFits:CGSizeMake(self.width - 122.0f - 10.0f, MAXFLOAT)];
    self.textView.frame = CGRectMake(112.0f, (self.backView.height - self.textView.height)/2.0f, size.width, size.height);
    
    self.expandBtn.frame = CGRectMake(self.width - 24.0f, (self.backView.height - 24.0f)/2.0f, 24.0f, 24.f);
    
    if (MAIN_SCREEN_HEIGHT < 570) {
        CGSize size = [self.textView sizeThatFits:CGSizeMake(self.width - 80.0f - 10.0f, MAXFLOAT)];
        self.textView.frame = CGRectMake(80.0f, (self.backView.height - self.textView.height)/2.0f,self.width - 80.0f - 10.0f , size.height);

    }
    else{
        self.textView.x = 112.0f;
        self.textView.width = self.width - 112.0f - 10.0f;
    }
    
    if (self.needHeightCal) {
        CGSize size = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.frame), MAXFLOAT)];
        CGRect frame = self.textView.frame;
        frame.size.height = size.height;
        
        self.backView.height = frame.size.height + 28.0f;

        self.textView.frame = CGRectMake(frame.origin.x, (self.backView.height - frame.size.height)/2.0f, frame.size.width, frame.size.height);
    
        self.titleLabel.y = (self.backView.height - self.titleLabel.height)/2.0f;
        
    }
    self.expandBtn.frame = self.textView.frame;
    
    self.backView.autoLine.frame = CGRectMake(24.0f, self.backView.height - 0.5f, self.width - 24.0f, 0.5f);
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (!text.length) {
        return YES;
    }
    if (self.needLimit && textView.text.length > 17) {
        return NO;
    }
    if (textView.text.length > 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.needHeightCal) {
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        CGRect frame = textView.frame;
        frame.size.height = size.height;
        textView.frame = frame;
        
        [self layoutSubviews];
            
        if (self.heightCallBack) {
            NSMutableDictionary  * param = [NSMutableDictionary dictionary];
            [param setObject:[NSNumber numberWithFloat:self.backView.height] forKey:@"height"];
            self.heightCallBack(param);
        }
    }
    if (self.endEditCallBack) {
        self.endEditCallBack();
    }
}

//- (void)textViewDidEndEditing:(UITextView *)textView{
//    [self.textView resignFirstResponder];
//}


- (void)setShowExpendView:(BOOL)showExpendView{
    _showExpendView = showExpendView;
    self.expandBtn.hidden = !_showExpendView;
    
}

- (void)setDetailData:(id)detailData{
    if (!detailData) {
        return;
    }
    
    

}

- (void)setDetail:(NSString *)detail{
    self.textView.text = detail;
    [self setNeedsLayout];
    
    //触发第一次赋值时更新height
    if (self.needHeightCal && self.heightCallBack) {
        [self textViewDidChange:self.textView];
    }
}

- (NSString *)detail{
    return self.textView.text;
}

- (void)expandSelectItems{
//    self.isExpand = !self.isExpand;
    
    if (self.isExpand) {
        [UIView animateWithDuration:0.3 animations:^{
            self.expandBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else{
    
        [UIView animateWithDuration:0.3 animations:^{
            self.expandBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    
    if (self.expendClickCallBack) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        [dic setObject:[NSNumber numberWithBool:self.isExpand] forKey:@"expand"];
        [dic setObject:@1 forKey:@"expand"];
        self.expendClickCallBack(dic);
    }

}



@end
