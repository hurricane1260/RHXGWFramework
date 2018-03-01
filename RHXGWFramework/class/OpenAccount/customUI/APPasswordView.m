//
//  APPasswordView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import "APPasswordView.h"

#import "APSamePasswordView.h"
#import "APHintView.h"

@interface APPasswordView ()

kRhPStrong UIImageView * markImgView;

kRhPStrong UILabel * titleLabel;

kRhPStrong APSamePasswordView * sameView;

kRhPStrong APHintView * hintView;

kRhPStrong UIButton * secBtn;

@end

@implementation APPasswordView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = color1_text_xgw;
        self.isSame = YES;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    __weak typeof(self) welf = self;
    
    self.markImgView = [[UIImageView alloc] initWithImage:img_open_mark];
    [self addSubview:self.markImgView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"设置密码" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.tradeView = [[APSingleView alloc] initWithTitle:@"交易密码" withPlaceholder:@"请输入6位数字交易密码"];
    self.tradeView.textField.secureTextEntry = YES;
    self.tradeView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.tradeView];
    self.tradeView.editingCallBack = ^{
        [welf checkEnableBtn];
    };
    
    self.reTradeView = [[APSingleView alloc] initWithTitle:@"再次输入" withPlaceholder:@"请再次输入交易密码"];
    self.reTradeView.textField.secureTextEntry = YES;
    self.reTradeView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.reTradeView];
    self.reTradeView.editingCallBack = ^{
        [welf checkEnableBtn];
    };
    
    self.moneyView = [[APSingleView alloc] initWithTitle:@"资金密码" withPlaceholder:@"请输入6位数字资金密码"];
    self.moneyView.textField.secureTextEntry = YES;
    self.moneyView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.moneyView];
    self.moneyView.editingCallBack = ^{
        [welf checkEnableBtn];
    };
    
    self.reMoneyView = [[APSingleView alloc] initWithTitle:@"再次输入" withPlaceholder:@"请再次输入资金密码"];
    self.reMoneyView.textField.secureTextEntry = YES;
    self.reMoneyView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.reMoneyView];
    self.reMoneyView.editingCallBack = ^{
        [welf checkEnableBtn];
    };
    
    self.sameView = [[APSamePasswordView alloc] init];
    self.sameView.selectCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"select"]) {
            welf.isSame = [[param objectForKey:@"select"] boolValue];
            [welf setNeedsLayout];
        }
    };
    [self addSubview:self.sameView];
    
    self.hintView = [[APHintView alloc] init];
    self.hintView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.hintView.height = [[param objectForKey:@"height"] floatValue];
            [welf setNeedsLayout];
        }
    
    };
    [self addSubview:self.hintView];
    
    self.secBtn = [UIButton didBuildButtonWithNormalImage:img_open_noeye highlightImage:img_open_noeye];
    [self.secBtn addTarget: self action:@selector(showPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.secBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetX = 24.0f;
    CGFloat singleHeight = 50.0f;
    
    self.markImgView.frame = CGRectMake(offsetX, 16.0f, self.markImgView.width, self.markImgView.height);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.markImgView.frame) + 5.0f, self.markImgView.y, self.titleLabel.width, self.titleLabel.height);
    
    self.tradeView.frame = CGRectMake(0, CGRectGetMaxY(self.markImgView.frame) + 20.0f, self.width, singleHeight);
    
    self.secBtn.frame = CGRectMake(self.width - self.secBtn.width - 48.0f, self.titleLabel.y, 36.0f, 25.0f);
    self.secBtn.center = CGPointMake(self.secBtn.center.x, self.tradeView.center.y);
    
    self.reTradeView.frame = CGRectMake(0, CGRectGetMaxY(self.tradeView.frame), self.width, singleHeight);

    if (self.isSame) {
        singleHeight = 0;
    }
    self.moneyView.hidden = self.isSame;
    self.reMoneyView.hidden = self.isSame;
    
    self.moneyView.frame = CGRectMake(0, CGRectGetMaxY(self.reTradeView.frame), self.width, singleHeight);
    self.reMoneyView.frame = CGRectMake(0, CGRectGetMaxY(self.moneyView.frame), self.width, singleHeight);

    self.sameView.frame = CGRectMake(0, CGRectGetMaxY(self.reMoneyView.frame), self.width, 43.0f);
    
    self.hintView.frame = CGRectMake(0, CGRectGetMaxY(self.sameView.frame), self.width, self.hintView.height);
    
    if (self.heightCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.hintView.frame)] forKey:@"height"];
        self.heightCallBack(param);
    }
}

- (void)showPassWord{
    if (self.tradeView.textField.secureTextEntry) {
        [self.secBtn setImage:img_open_eye forState:UIControlStateNormal];
    }else{
        [self.secBtn setImage:img_open_noeye forState:UIControlStateNormal];
    }
    self.tradeView.textField.secureTextEntry = !self.tradeView.textField.isSecureTextEntry;
    self.reTradeView.textField.secureTextEntry = !self.reTradeView.textField.isSecureTextEntry;
    self.moneyView.textField.secureTextEntry = !self.moneyView.textField.isSecureTextEntry;
    self.reMoneyView.textField.secureTextEntry = !self.reMoneyView.textField.isSecureTextEntry;

//    [self setNeedsLayout];
}

- (void)checkEnableBtn{
    NSString * trade = self.tradeView.textField.text;
    NSString * reTrade = self.reTradeView.textField.text;
    NSString * money = self.moneyView.textField.text;
    NSString * reMoney = self.reMoneyView.textField.text;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    if (self.isSame) {
        if (trade.length > 1 && reTrade.length > 1) {
            [param setObject:@1 forKey:@"enable"];
            self.enableCallBack(param);
        }
        else{
            [param setObject:@0 forKey:@"enable"];
            self.enableCallBack(param);
        }
        return;
    }
    if (trade.length > 1 && reTrade.length > 1 && money.length > 1 && reMoney.length > 1) {
        [param setObject:@1 forKey:@"enable"];
        self.enableCallBack(param);
    }
    else{
        [param setObject:@0 forKey:@"enable"];
        self.enableCallBack(param);
    }
    
}

- (void)hiddenKeyBoards{
    [self.tradeView.textField resignFirstResponder];
    [self.reTradeView.textField resignFirstResponder];
    [self.moneyView.textField resignFirstResponder];
    [self.reMoneyView.textField resignFirstResponder];

}

@end
