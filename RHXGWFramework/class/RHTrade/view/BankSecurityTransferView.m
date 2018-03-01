//
//  BankSecurityTransferView.m
//  stockscontest
//
//  Created by rxhui on 15/7/14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BankSecurityTransferView.h"
#import "TradeDirectionPickerView.h"

typedef enum : NSUInteger {
    TransferViewTypeBankToSecurity,
    TransferViewTypeSecurityToBank
} TransferViewType;

@interface BankSecurityTransferView ()<UITextFieldDelegate,TradeDirectionPickerDelegate>

@property (nonatomic, assign) TransferViewType viewType;

@property (nonatomic, strong) UIView *wrapperItem1;

/*! @brief 转账方向 title */
@property (nonatomic, strong) UILabel *directionTitleLabel;

/*! @brief 转账方向选择器 */
@property (nonatomic, strong) TradeDirectionPickerView *directionPicker;

@property (nonatomic, strong) UIView *wrapperItem2;

/*! @brief 转账银行 title */
@property (nonatomic, strong) UILabel *bankTitleLabel;

/*! @brief 转账银行 值 */
@property (nonatomic, strong) UILabel *bankValueLabel;

@property (nonatomic, strong) UIView *wrapperItem3;

/*! @brief 币种 title */
@property (nonatomic, strong) UILabel *currencyTypeTitleLabel;

/*! @brief 币种 值 */
@property (nonatomic, strong) UILabel *currencyTypeValueLabel;

@property (nonatomic, strong) UIView *wrapperItem4;

/*! @brief 金额 title */
@property (nonatomic, strong) UILabel *transferSumTitleLabel;

/*! @brief 金额 输入框 */
@property (nonatomic, strong) UITextField *transferSumTextField;

@property (nonatomic, strong) UIView *wrapperItem5;

/*! @brief 资金密码 title */
@property (nonatomic, strong) UILabel *fundPasswordTitleLabel;

/*! @brief 资金密码 输入框 */
@property (nonatomic, strong) UITextField *fundPasswordTextField;

@property (nonatomic, strong) UIView *wrapperItem6;

@property (nonatomic, strong) UIView *wrapperItem7;

/*! @brief 银行资金 title */
//@property (nonatomic, strong) UILabel *bankFundTitleLabel;

/*! @brief 银行资金 值 */
//@property (nonatomic, strong) UILabel *bankFundValueLabel;

/*! @brief 银行资金 按钮 */
//@property (nonatomic, strong) UIButton *bankFundButton;

/*! @brief 可转账金额 title */
@property (nonatomic, strong) UILabel *canTransferTitleLabel;

/*! @brief 可转账金额 值 */
@property (nonatomic, strong) UILabel *canTransferValueLabel;

/*! @brief 确认转账 按钮 */
@property (nonatomic, strong) UIButton *comitTransferButton;


kRhPStrong UILabel * transferTimeLabel;
@end

@implementation BankSecurityTransferView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)setViewType:(TransferViewType )aType {
    _viewType = aType;
    if (_viewType == TransferViewTypeBankToSecurity) {
//        self.bankFundTitleLabel.hidden = NO;
//        self.bankFundValueLabel.hidden = NO;
//        self.bankFundButton.hidden = NO;
//        self.wrapperItem6.hidden = YES;
        self.fundPasswordTitleLabel.text = @"银行密码";
        self.canTransferTitleLabel.hidden = YES;
        self.canTransferValueLabel.hidden = YES;
    }
    else {
//        self.bankFundTitleLabel.hidden = YES;
//        self.bankFundValueLabel.hidden = YES;
//        self.bankFundButton.hidden = YES;
//        self.wrapperItem6.hidden = NO;
        self.fundPasswordTitleLabel.text = @"资金密码";
        self.canTransferTitleLabel.hidden = NO;
        self.canTransferValueLabel.hidden = NO;
    }
    [self setNeedsLayout];
}

-(void)setBankName:(NSString *)aName {
    if (_bankName) {
        _bankName = nil;
    }
    _bankName = aName;
    self.bankValueLabel.text = _bankName;
    if (self.viewType == TransferViewTypeBankToSecurity) {
        if ([_bankName isEqualToString:@"中行存管"]) {
            self.fundPasswordTitleLabel.text = @"电话银行密码";
        } else if ([_bankName isEqualToString:@"民生存管"]) {
            self.fundPasswordTitleLabel.text = @"银行查询密码";
        } else {
            self.fundPasswordTitleLabel.text = @"银行密码";
        }
    } else if (self.viewType == TransferViewTypeSecurityToBank) {
        self.fundPasswordTitleLabel.text = @"资金密码";
    }
    
    if ([_bankName isEqualToString:@"工行存管"] || [_bankName isEqualToString:@"平安存管"] || [_bankName isEqualToString:@"浦发存管"] || [_bankName isEqualToString:@"招商存管"]) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"popRemindBankInfo"] isEqual:@1]) {
            [self.transDelegate popRemindBankInfo];
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"popRemindBankInfo"];
        }
    }

}

-(void)setCanTransferMoney:(NSNumber *)aMoney {
    if (_canTransferMoney) {
        _canTransferMoney = nil;
    }
    _canTransferMoney = aMoney;
    self.canTransferValueLabel.text = [NSString stringWithFormat:@"%@",_canTransferMoney];
}

//-(void)setBankMoney:(NSNumber *)aMoney {
//    if (_bankMoney) {
//        _bankMoney = nil;
//    }
//    _bankMoney = aMoney;
//    self.bankFundValueLabel.text = [NSString stringWithFormat:@"%@",_bankMoney];
//}


-(void)initSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.wrapperItem1 = [[UIView alloc]init];
    self.wrapperItem1.backgroundColor = color17_other_xgw;
//    [self addSubview:self.wrapperItem1];
    
    self.directionTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.directionTitleLabel];
    self.directionTitleLabel.text = @"转账方向";
    self.directionTitleLabel.font = font3_common_xgw;
    self.directionTitleLabel.textColor = color4_text_xgw;
    self.directionTitleLabel.backgroundColor = [UIColor clearColor];
    
    self.directionPicker = [[TradeDirectionPickerView alloc]initWithTitleList:@[@"银行转证券",@"证券转银行"]];
    self.directionPicker.delegate = self;
    
    self.wrapperItem2 = [[UIView alloc]init];
    [self addSubview:self.wrapperItem2];
    self.wrapperItem2.backgroundColor = color18_other_xgw;
    
    self.bankTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.bankTitleLabel];
    self.bankTitleLabel.text = @"转账银行";
    self.bankTitleLabel.font = font3_common_xgw;
    self.bankTitleLabel.textColor = color4_text_xgw;
    self.bankTitleLabel.backgroundColor = [UIColor clearColor];
    
    self.bankValueLabel = [[UILabel alloc]init];
    [self addSubview:self.bankValueLabel];
    self.bankValueLabel.font = font3_common_xgw;
    self.bankValueLabel.textColor = color2_text_xgw;
    self.bankValueLabel.backgroundColor = [UIColor clearColor];
    self.bankValueLabel.textAlignment = NSTextAlignmentRight;
    
    self.wrapperItem3 = [[UIView alloc]init];
    [self addSubview:self.wrapperItem3];
    self.wrapperItem3.backgroundColor = color18_other_xgw;
    
    self.currencyTypeTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.currencyTypeTitleLabel];
    self.currencyTypeTitleLabel.text = @"转账币种";
    self.currencyTypeTitleLabel.font = font3_common_xgw;
    self.currencyTypeTitleLabel.textColor = color4_text_xgw;
    self.currencyTypeTitleLabel.backgroundColor = [UIColor clearColor];
    
    self.currencyTypeValueLabel = [[UILabel alloc]init];
    [self addSubview:self.currencyTypeValueLabel];
    self.currencyTypeValueLabel.text = @"人民币";
    self.currencyTypeValueLabel.font = font3_common_xgw;
    self.currencyTypeValueLabel.textColor = color2_text_xgw;
    self.currencyTypeValueLabel.backgroundColor = [UIColor clearColor];
    self.currencyTypeValueLabel.textAlignment = NSTextAlignmentRight;
    
    self.wrapperItem4 = [[UIView alloc]init];
    [self addSubview:self.wrapperItem4];
    self.wrapperItem4.backgroundColor = color18_other_xgw;
    
    self.transferSumTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.transferSumTitleLabel];
    self.transferSumTitleLabel.text = @"转账金额";
    self.transferSumTitleLabel.font = font3_common_xgw;
    self.transferSumTitleLabel.textColor = color4_text_xgw;
    self.transferSumTitleLabel.backgroundColor = [UIColor clearColor];
    
    self.transferSumTextField = [[UITextField alloc]init];
    [self addSubview:self.transferSumTextField];
    self.transferSumTextField.delegate = self;
    self.transferSumTextField.placeholder = @"请输入";
    self.transferSumTextField.font = font3_number_xgw;
    self.transferSumTextField.textColor = color2_text_xgw;
    self.transferSumTextField.backgroundColor = [UIColor clearColor];
    self.transferSumTextField.textAlignment = NSTextAlignmentRight;
    self.transferSumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.wrapperItem5 = [[UIView alloc]init];
    [self addSubview:self.wrapperItem5];
    self.wrapperItem5.backgroundColor = color18_other_xgw;
    
    self.fundPasswordTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.fundPasswordTitleLabel];
    self.fundPasswordTitleLabel.text = @"银行密码";
    self.fundPasswordTitleLabel.font = font3_common_xgw;
    self.fundPasswordTitleLabel.textColor = color4_text_xgw;
    self.fundPasswordTitleLabel.backgroundColor = [UIColor clearColor];
    
    self.fundPasswordTextField = [[UITextField alloc]init];
    [self addSubview:self.fundPasswordTextField];
    self.fundPasswordTextField.delegate = self;
    self.fundPasswordTextField.placeholder = @"请输入";
    self.fundPasswordTextField.font = font3_number_xgw;
    self.fundPasswordTextField.textColor = color2_text_xgw;
    self.fundPasswordTextField.backgroundColor = [UIColor clearColor];
    self.fundPasswordTextField.textAlignment = NSTextAlignmentRight;
    self.fundPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.fundPasswordTextField.secureTextEntry = YES;
    
    self.wrapperItem6 = [[UIView alloc]init];
    [self addSubview:self.wrapperItem6];
    self.wrapperItem6.backgroundColor = color18_other_xgw;
    
//    self.bankFundTitleLabel = [[UILabel alloc]init];
//    [self addSubview:self.bankFundTitleLabel];
//    self.bankFundTitleLabel.text = @"银行资金";
//    self.bankFundTitleLabel.font = font3_common_xgw;
//    self.bankFundTitleLabel.textColor = color4_text_xgw;
//    self.bankFundTitleLabel.backgroundColor = [UIColor clearColor];
    
    
//    self.bankFundValueLabel = [[UILabel alloc]init];
//    [self addSubview:self.bankFundValueLabel];
//    self.bankFundValueLabel.font = font3_number_xgw;
//    self.bankFundValueLabel.textColor = color2_text_xgw;
//    self.bankFundValueLabel.backgroundColor = [UIColor clearColor];
//    self.bankFundValueLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.bankFundButton = [[UIButton alloc]init];
//    [self addSubview:self.bankFundButton];
//    self.bankFundButton.titleLabel.font = font3_common_xgw;
//    [self.bankFundButton setTitle:@"查询资金" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//    [self.bankFundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//    self.bankFundButton.backgroundColor = color_font_orange;
//    self.bankFundButton.size = CGSizeMake(100, 32);
//    [self.bankFundButton addTarget:self action:@selector(bankFundButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.wrapperItem7 = [[UIView alloc]init];
    [self addSubview:self.wrapperItem7];
    self.wrapperItem7.backgroundColor = color18_other_xgw;

    self.canTransferTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.canTransferTitleLabel];
    self.canTransferTitleLabel.text = @"可转账金额";
    self.canTransferTitleLabel.font = font3_common_xgw;
    self.canTransferTitleLabel.textColor = color4_text_xgw;
    self.canTransferTitleLabel.backgroundColor = [UIColor clearColor];
    self.canTransferTitleLabel.hidden = YES;
    
    self.canTransferValueLabel = [[UILabel alloc]init];
    [self addSubview:self.canTransferValueLabel];
//    self.canTransferValueLabel.text = @"人民币";
    self.canTransferValueLabel.font = font3_number_xgw;
    self.canTransferValueLabel.textColor = color6_text_xgw;
    self.canTransferValueLabel.backgroundColor = [UIColor clearColor];
    self.canTransferValueLabel.textAlignment = NSTextAlignmentRight;
    self.canTransferValueLabel.hidden = YES;
     
    self.comitTransferButton = [[UIButton alloc]init];
    [self addSubview:self.comitTransferButton];
    [self.comitTransferButton addTarget:self action:@selector(comitButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.comitTransferButton setTitle:@"转账" forState:UIControlStateNormal];
    [self.comitTransferButton setTitle:@"转账" forState:UIControlStateHighlighted];
    [self.comitTransferButton setTitle:@"转账" forState:UIControlStateSelected];
    [self.comitTransferButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    self.comitTransferButton.backgroundColor = color2_text_xgw;
    self.comitTransferButton.titleLabel.font = font5_common_xgw;
    
    [self addSubview:self.directionPicker];
    
    self.transferTimeLabel = [UILabel didBuildLabelWithText:@"转账时间：交易日09:00-16:00" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.transferTimeLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 15.0f;
    CGFloat layoutY = 0.0f;
    CGFloat formHeight = 51.5f;
    CGFloat halfWidth = self.width * 0.5f;
    
    self.wrapperItem1.width = self.width;
    self.wrapperItem1.height = 0.5f;
    
    self.directionTitleLabel.x = margin;
    self.directionTitleLabel.width = halfWidth  - margin;
    self.directionTitleLabel.height = formHeight;
    
    self.directionPicker.size = CGSizeMake(self.width, formHeight);
//    self.directionPicker.x = self.directionTitleLabel.x + self.directionTitleLabel.width;
    
    layoutY = formHeight + 0.5f;
    
    self.wrapperItem2.width = self.width;
    self.wrapperItem2.height = 0.5f;
    self.wrapperItem2.y = layoutY;
    
    self.bankTitleLabel.y = layoutY;
    self.bankTitleLabel.x = margin;
    self.bankTitleLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    self.bankValueLabel.y = layoutY;
    self.bankValueLabel.x = self.bankTitleLabel.x + self.bankTitleLabel.width;
    self.bankValueLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    layoutY = ( formHeight + 0.5f ) * 2;
    
    self.wrapperItem3.size = CGSizeMake(self.width, 0.5f);
    self.wrapperItem3.y = layoutY;
    
    self.currencyTypeTitleLabel.y = layoutY;
    self.currencyTypeTitleLabel.x = margin;
    self.currencyTypeTitleLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    
    self.currencyTypeValueLabel.y = layoutY;
    self.currencyTypeValueLabel.x = self.currencyTypeTitleLabel.x + self.currencyTypeTitleLabel.width;
    self.currencyTypeValueLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    layoutY = ( formHeight + 0.5f ) * 3;
    
    self.wrapperItem4.size = CGSizeMake(self.width, 0.5f);
    self.wrapperItem4.y = layoutY;
    
    self.transferSumTitleLabel.y = layoutY;
    self.transferSumTitleLabel.x = margin;
    self.transferSumTitleLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    self.transferSumTextField.y = layoutY;
    self.transferSumTextField.x = self.transferSumTitleLabel.x + self.transferSumTitleLabel.width;
    self.transferSumTextField.size = CGSizeMake(halfWidth - margin, formHeight);
    
    if (self.viewType == TransferViewTypeBankToSecurity) {
        layoutY = ( formHeight + 0.5f ) * 4;
    }
    else {
        layoutY = ( formHeight + 0.5f ) * 5;
    }
    
    self.wrapperItem5.size = CGSizeMake(self.width, 0.5f);
    self.wrapperItem5.y = layoutY;
    
    self.fundPasswordTitleLabel.y = layoutY;
    self.fundPasswordTitleLabel.x = margin;
    self.fundPasswordTitleLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    self.fundPasswordTextField.y = layoutY;
    self.fundPasswordTextField.x = self.fundPasswordTitleLabel.x + self.fundPasswordTitleLabel.width;
    self.fundPasswordTextField.size = CGSizeMake(halfWidth - margin, formHeight);
    
    if (self.viewType == TransferViewTypeBankToSecurity) {
        layoutY = ( formHeight + 0.5f ) * 5;
    }
    else {
        layoutY = ( formHeight + 0.5f ) * 4;
    }
    
    self.wrapperItem6.size = CGSizeMake(self.width, 0.5f);
    self.wrapperItem6.y = layoutY;
    
//    self.bankFundTitleLabel.y = layoutY;
//    self.bankFundTitleLabel.x = margin;
//    self.bankFundTitleLabel.size = CGSizeMake(self.width * 0.33f - margin, formHeight);
//    
//    self.bankFundValueLabel.y = layoutY;
//    self.bankFundValueLabel.x = self.bankFundTitleLabel.x + self.bankFundTitleLabel.width;
//    self.bankFundValueLabel.size = CGSizeMake(self.width * 0.33f, formHeight);
//    
//    self.bankFundButton.x = self.width - self.bankFundButton.width - margin;
//    self.bankFundButton.y = (formHeight- self.bankFundButton.height) / 2.0f + layoutY;
    
    self.canTransferTitleLabel.y = layoutY;
    self.canTransferTitleLabel.x = margin;
    self.canTransferTitleLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    self.canTransferValueLabel.y = layoutY;
    self.canTransferValueLabel.x = self.canTransferTitleLabel.x + self.canTransferTitleLabel.width;
    self.canTransferValueLabel.size = CGSizeMake(halfWidth - margin, formHeight);
    
    layoutY = ( formHeight + 0.5f ) * 6;
    
    if (self.viewType == TransferViewTypeBankToSecurity) {
        layoutY -= self.canTransferTitleLabel.height;
    }

    self.wrapperItem7.size = CGSizeMake(self.width, self.height - layoutY);
    self.wrapperItem7.y = layoutY;
    
    self.comitTransferButton.width = self.width - 20.0f;
    self.comitTransferButton.height = 44.0f;
    self.comitTransferButton.x = (self.width - self.comitTransferButton.width) / 2.0f;
    self.comitTransferButton.y = layoutY + 20.0f;
    
    self.directionPicker.height = self.comitTransferButton.y + self.comitTransferButton.height;
    self.contentSize = CGSizeMake(self.width, self.directionPicker.height);
    
    [self.transferTimeLabel sizeToFit];
    self.transferTimeLabel.frame = CGRectMake((self.width - self.transferTimeLabel.width)/2.0f, CGRectGetMaxY(self.comitTransferButton.frame) + 20.0f, self.transferTimeLabel.width, self.transferTimeLabel.height);
}

#pragma mark ---------------------------------------------------交互-----------------------------------------------------------

//-(void)bankFundButtonTouchHandler {
//    [self hideKeyboard];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入银行密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    textField.placeholder = @"输入银行密码";
//    textField.keyboardType = UIKeyboardTypeNumberPad;
//    [alertView show];
//}

-(void)comitButtonTouchHandler {
    [self hideKeyboard];
    
    if (![self.transDelegate respondsToSelector:@selector(comitTransferWithParam:)]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.viewType == TransferViewTypeBankToSecurity) {
        [param setValue:@"1" forKey:@"transferDirection"];//银行转证券
        //银行密码
        self.bankPassword = self.fundPasswordTextField.text;
        if (self.bankPassword.length == 0 || [self.bankPassword isEqualToString:@""]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"请输入银行密码" warningImage:nil duration:1.5f];
            return;
        }
        else {
            [param setValue:self.bankPassword forKey:@"bankPassword"];
        }
    }
    else {
        [param setValue:@"2" forKey:@"transferDirection"];//证券转银行
        self.fundPassword = self.fundPasswordTextField.text;
        //资金密码
        if (self.fundPassword.length == 0 || [self.bankPassword isEqualToString:@""]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"请输入资金密码" warningImage:nil duration:3.0f];
            return;
        }
        else {
            [param setValue:self.fundPassword forKey:@"fundPassword"];
        }
    }
    
    //转账资金
    if (self.transferSumTextField.text.length == 0 || [self.transferSumTextField.text isEqualToString:@""]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入转账资金" warningImage:nil duration:3.0f];
        return;
    }
    else {
        [param setValue:self.transferSumTextField.text forKey:@"occurBalance"];
    }
    
    [self.transDelegate comitTransferWithParam:param.copy];
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入银行密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    textField.placeholder = @"输入银行密码";
//    textField.keyboardType = UIKeyboardTypeNumberPad;
//    [alertView show];
}

#pragma mark ---------------------------------------------------delegate-----------------------------------------------------------

//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        return;
//    }
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    

    
//    if (self.fundPassword.length == 0 || [self.bankPassword isEqualToString:@""]) {
//        [CMProgress showWarningProgressWithTitle:nil message:@"请输入资金密码" warningImage:nil duration:3.0f];
//        return;
//    }
//    if ([self.transDelegate respondsToSelector:@selector(requestBankMoneyWithParam:)]) {
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        [param setValue:_bankPassword forKey:@"bankPassword"];
//        [param setValue:_fundPassword forKey:@"fundPassword"];
//        [self.transDelegate requestBankMoneyWithParam:param];
//        
//    }
//}

-(void)didSelectItemWithTitle:(NSString *)titleString {
    if ([titleString isEqualToString:@"银行转证券"]) {
        self.viewType = TransferViewTypeBankToSecurity;
    }
    else if ([titleString isEqualToString:@"证券转银行"]) {
        self.viewType = TransferViewTypeSecurityToBank;
    }
}

-(void)hideKeyboard {
    [self.transferSumTextField resignFirstResponder];
    [self.fundPasswordTextField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.fundPasswordTextField) {
        self.fundPassword = self.fundPasswordTextField.text;
    }
}

//-(void)dealloc {
//    self.directionTitleLabel = nil;
//    self.directionPicker = nil;
//    self.wrapperItem1 = nil;
//    self.bankTitleLabel = nil;
//    self.bankValueLabel = nil;
//    self.wrapperItem2 = nil;
//    self.currencyTypeTitleLabel = nil;
//    self.currencyTypeValueLabel = nil;
//    self.wrapperItem3 = nil;
//    self.transferSumTitleLabel = nil;
//    self.transferSumTextField = nil;
//    self.wrapperItem4 = nil;
//    self.fundPasswordTitleLabel = nil;
//    self.fundPasswordTextField = nil;
//    self.wrapperItem5 = nil;
//    self.bankFundTitleLabel = nil;
//    self.bankFundValueLabel = nil;
//    self.wrapperItem6 = nil;
//    self.canTransferTitleLabel = nil;
//    self.canTransferValueLabel = nil;
//    self.wrapperItem7 = nil;
//    self.comitTransferButton = nil;
//}
@end
