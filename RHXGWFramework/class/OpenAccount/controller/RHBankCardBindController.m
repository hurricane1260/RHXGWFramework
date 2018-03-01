//
//  RHBankCardBindController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/15.
//
//

#import "RHBankCardBindController.h"
#import "OARequestManager.h"
#import "CRHBankListVo.h"
#import "CRHProtocolListVo.h"
#import "CRHCACertVo.h"
#import "ResultMessageVO.h"

#import "APSingleView.h"
#import "BCBankCardChooseView.h"
#import "protocolView.h"
#import "BCBankCardNumView.h"

#import "ESCameraViewController.h"
#import "ESResultViewController.h"
#import "KCPhoto.h"
#import "KCResultViewController.h"

#import "CRHBankVoRuleQuery.h"

#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

@interface RHBankCardBindController ()<ESCameraDelegate,ESEditDelegate,KCPhotoDelegate>
//- (IBAction)naviToBankList:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
//- (IBAction)agreeBtnClick:(id)sender;
//- (IBAction)showOtherDepositProtocol:(id)sender;
//- (IBAction)bindingDeposit:(id)sender;
//@property (weak, nonatomic) IBOutlet UITextField *bankAccCode;
//@property (weak, nonatomic) IBOutlet UITextField *bankAccPassword;
//- (IBAction)checkAccAndBank:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *protocolName;
//
//@property (weak, nonatomic) IBOutlet UILabel *selectedBankName;

kRhPStrong OARequestManager * oAManager;

kRhPStrong OARequestManager * protocolSignManager;

kRhPStrong OARequestManager * checkManager;

kRhPStrong NSArray * bankList;

kRhPStrong CRHBankListVo * selectedBank;

kRhPCopy NSString * caCertSn;

kRhPCopy NSString * protocolNo;

kRhPStrong CRHProtocolListVo * protocolVo;

kRhPStrong UIScrollView * bottomScrollow;

kRhPStrong UILabel * hintLable;

kRhPStrong BCBankCardChooseView * bankView;

//kRhPStrong APSingleView * bankNoView;

kRhPStrong APSingleView * bankPwView;

kRhPStrong protocolView * nextView;

kRhPStrong UIView * sepView;

kRhPAssign BOOL isAgree;

kRhPCopy NSString * client_id;

kRhPStrong CRHBankListVo * storeBank;

kRhPCopy NSString * storeAccCode;

kRhPAssign BOOL isSupport;

kRhPAssign BOOL needRectify;

kRhPStrong BankInfo * bankInfo;

kRhPStrong KCPhoto * bankCardPhoto;

//kRhPStrong IDPhoto * idPhoto;

kRhPStrong BCBankCardNumView * bankNoView;
@end

@implementation RHBankCardBindController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"银行卡绑定";
        self.isAgree = YES;
        self.isSupport = YES;
        self.needRectify = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankIsSelected:) name:@"kBankSelectNoti" object:nil];

        [self initSubviews];
        [self loadStoreData];

    }
    return self;
}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam) {
        return;
    }
    if ([universalParam isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = universalParam;
        if ([dic objectForKey:@"hiddenBack"]) {
            self.backButtonHidden = [[dic objectForKey:@"hiddenBack"] boolValue];
        }
        if ([dic objectForKey:kOpenAccountRectify]) {
            self.needRectify = [[dic objectForKey:kOpenAccountRectify] boolValue];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self requestToBankList];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.oAManager cancelAllDelegate];
    [self.protocolSignManager cancelAllDelegate];
    
    if (self.needRectify) {
        [RHOpenAccStoreData cancelRequestStatus];
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kBankSelectNoti" object:nil];

}

- (void)initSubviews{
    __weak typeof(self) welf = self;
    
    self.bottomScrollow = [[UIScrollView alloc] init];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboards)];
    self.bottomScrollow.userInteractionEnabled = YES;
    [self.bottomScrollow addGestureRecognizer:tap];
    [self.view addSubview:self.bottomScrollow];
    
    self.hintLable = [UILabel didBuildLabelWithText:@"注：银行卡必须为您本人的借记卡（非信用卡）" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
    [self.bottomScrollow addSubview:self.hintLable];
    
    self.sepView = [self.bottomScrollow addAutoLineViewWithColor:color16_other_xgw];
    
    self.bankView = [[BCBankCardChooseView alloc] init];
    self.bankView.chooseCallBack = ^{
        [welf naviToBankListPage:welf.bankList];
    };
    [self.bottomScrollow addSubview:self.bankView];

//    self.bankNoView = [[APSingleView alloc] initWithTitle:@"银行卡卡号" withPlaceholder:@"请输入银行卡号"];
    
    self.bankNoView = [[BCBankCardNumView alloc] init];
    self.bankNoView.endEditCallBack = ^{
        [welf checkAccAndBank];
    };
    self.bankNoView.editingCallBack = ^{
        [welf checkEnableBtn];
    };
    self.bankNoView.textField.font = font3_common_xgw;
    self.bankNoView.offsetX = 117.0f;
    self.bankNoView.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.bankNoView.photoCallBack = ^{
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:welf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:welf.view];
    };
    [self.bottomScrollow addSubview:self.bankNoView];
    
    self.bankPwView = [[APSingleView alloc] initWithTitle:@"密码" withPlaceholder:@"请输入6位银行卡密码"];
    self.bankPwView.editingCallBack = ^{
        [welf checkEnableBtn];
    };
    self.bankPwView.textField.secureTextEntry = YES;
    self.bankPwView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.bankPwView.textField.font = font3_common_xgw;
    self.bankPwView.offsetX = 117.0f;
    [self.bottomScrollow addSubview:self.bankPwView];
    
    [self.bottomScrollow addAutoLineWithColor:color16_other_xgw];
    
    self.nextView = [[protocolView alloc] init];
    self.nextView.isSelected = YES;
    self.nextView.bottomProtocol = YES;
    self.nextView.protocolName = @"《客户交易结算资金第三方存管业务协议》";
    self.nextView.selectCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"select"]) {
            welf.isAgree = [[param objectForKey:@"select"] boolValue];
            [welf checkEnableBtn];

        }
    };
    
    self.nextView.protocolCallBack = ^{
        [welf naviToProtocalPageWith:welf.protocolVo];
    };
    
    self.nextView.nextCallBack = ^{
        [welf bindingDeposit];
    };
    [self.view addSubview:self.nextView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bottomScrollow.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY - 118.0f);
    
    CGFloat avgHeight = 50.0f;
    
    [self.hintLable sizeToFit];
    self.hintLable.frame = CGRectMake(24.0f, (avgHeight - self.hintLable.height)/2.0f, self.hintLable.width, self.hintLable.height);
    self.sepView.frame = CGRectMake(0, 50.0 - 0.5f, self.bottomScrollow.width, 0.5f);
    
    self.bankView.frame = CGRectMake(0, CGRectGetMaxY(self.sepView.frame), self.bottomScrollow.width, avgHeight);
    
    self.bankNoView.frame = CGRectMake(0, CGRectGetMaxY(self.bankView.frame), self.bottomScrollow.width, avgHeight);
    
    self.bankPwView.frame = CGRectMake(0, CGRectGetMaxY(self.bankNoView.frame), self.bottomScrollow.width, avgHeight);

    self.bottomScrollow.autoLine.frame = CGRectMake(0, CGRectGetMaxY(self.bankPwView.frame) - 0.5f, self.bottomScrollow.width, 0.5f);
    
    self.nextView.frame = CGRectMake(0, self.view.height - 118.0f, self.view.width, 118.0f);
}

- (void)loadStoreData{
    if ([RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccBindBank]) {
        CRHBankListVo * bank = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccBindBank];
        NSNotification * noti = [NSNotification notificationWithName:@"kBankSelectNoti" object:bank];
        [self bankIsSelected:noti];
    }
    
    if ([RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccBankCode]) {
        NSString * bankAccCode = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccBankCode];
        self.bankNoView.textField.text = bankAccCode;
    }
    [self checkAccAndBank];
    [self checkEnableBtn];

    //[self.view setNeedsLayout];
}

-(void)backButtonTouchHandler:(id)sender{
    
    if (self.selectedBank) {
        [RHOpenAccStoreData storeOpenAccCachUserInfo:self.selectedBank withKey:kOpenAccBindBank];
    }
    if (self.bankNoView.textField.text.length) {
        [RHOpenAccStoreData storeOpenAccCachUserInfo:self.bankNoView.textField.text withKey:kOpenAccBankCode];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bankIsSelected:(NSNotification *)noti{
    CRHBankListVo * vo = noti.object;
    self.bankView.bank = vo;
    self.selectedBank = vo;
    
    if ([vo.bank_name containsString:@"民生"]) {
        self.bankPwView.placeholder = @"请输入查询密码";
    }
    else{
        self.bankPwView.placeholder = @"请输入6位银行卡密码";
        
    }
    
    if ([vo.bank_name containsString:@"广发"]||[vo.bank_name isEqualToString:@"中国银行"]||[vo.bank_name containsString:@"建设"]||[vo.bank_name containsString:@"交通"]) {
        
        self.bankPwView.hidden = YES;
        self.bottomScrollow.autoLine.hidden = YES;
        
    }else{
        
        self.bankPwView.hidden = NO;
        self.bottomScrollow.autoLine.hidden = NO;
        
        
    }
    
    [self requestBankProtocol];
    [self checkAccAndBank];
    [self.view setNeedsLayout];
}

- (OARequestManager *)oAManager{
    if (!_oAManager) {
        _oAManager = [[OARequestManager alloc] init];
    }
    return _oAManager;
}

- (OARequestManager *)protocolSignManager{
    if (!_protocolSignManager) {
        _protocolSignManager = [[OARequestManager alloc] init];
    }
    return _protocolSignManager;
}

- (OARequestManager *)checkManager{
    if (!_checkManager) {
        _checkManager = [[OARequestManager alloc] init];
    }
    return _checkManager;
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

-(void)hideKeyboards {
    [self.bankPwView.textField resignFirstResponder];
    [self.bankNoView.textField resignFirstResponder];
}


- (void)requestToBankList{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    __weak typeof (self) welf = self;
    [self.oAManager sendCommonRequestWithParam:param withRequestType:kGetBankList withUrlString:@"crhDepositBankQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                NSLog(@"银行列表获取失败");
                return;
            }
            NSArray * arr = resultData;
            if (arr.count) {
                welf.bankList = resultData;
//                [welf naviToBankListPage:self.bankList];
            }
        }
        else{
//            [welf naviToBankListPage:nil];

        }
    }];
    
    
}

- (void)naviToBankListPage:(NSArray *)arr{
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHBankListController" withParam:arr];
    
}

- (void)requestBankProtocol{
    [self requestBankProtocolList];

}

- (void)requestBankProtocolList{
    self.protocolVo = nil;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@0 forKey:@"econtract_type"];
//    [param setObject:@6 forKey:@"biz_id"];
    
    __weak typeof(self) welf = self;
    [self.protocolSignManager requestProtocolListWithParam:param withRequestType:kProtocolList withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                return;
            }
            for (NSDictionary * resultDic in resultData) {
                CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:resultDic];
                
                if ([vo.econtract_id isEqualToString:welf.selectedBank.econtract_id]) {

                    welf.nextView.protocolName = [NSString stringWithFormat:@"《%@》",vo.econtract_name];;
                    
                    welf.protocolVo = vo;
//                    NSString * protocolName = [NSString stringWithFormat:@"《%@》",vo.econtract_name];
//                    [welf.protocolName setTitle:protocolName forState:UIControlStateNormal];
                    
//                    [welf requestCACertQuery];
                    [welf.view setNeedsLayout];
                }
            }
        }
        else{
            [CMProgress showWarningProgressWithTitle:@"获取协议列表失败" message:nil warningImage:nil duration:2];
        }
    }];


}

- (void)requestProtocolContent{
    
    if (!self.protocolNo.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    //电子合同id
    [param setObject:self.protocolVo.econtract_id forKey:@"econtract_id"];
    
    [self.oAManager requestProtocolContentWithParam:param withRequestType:kProtocolContent withCompletion:^(BOOL success, id resultData) {
        if (success) {
//            if (!resultData || ![resultData isKindOfClass:[CRHProtocolListVo class]]) {
//                return;
//            }
            //vo.econtract_content即协议内容
//            CRHProtocolListVo * vo = resultData;
            
        }
    }];
    
}

- (void)requestCACertQuery{
    self.caCertSn = nil;
    
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    __weak typeof(self) welf = self;
    [self.oAManager sendCommonRequestWithParam:param withRequestType:kCACertQuery withUrlString:@"crhCACertQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHCACertVo class]]) {
                welf.caCertSn = nil;
                return;
            }
            CRHCACertVo * vo = resultData;
            welf.caCertSn = vo.csdc_cert_sn;
        }
    }];

}

- (void)naviToProtocalPageWith:(id)data{
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAProtocolController" withParam:data];
    
}

- (void)protocolSign{
    if (!self.protocolVo) {
        return;
    }
//    if (!self.caCertSn.length) {
//        return;
//    }
    __weak typeof(self) welf = self;
    [self.protocolSignManager requestProtocolSignWithCRHProtocolListVo:self.protocolVo withCACertSn:@"NOSN" withRequestType:kProtocolSign withBusinessType:@"6" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (self.needRectify) {
                
                [RHOpenAccStoreData requestUserStatus:self];
                return ;
                
                NSArray * arr = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRectify];
                if (arr.count) {
                    NSString * class = @"";
                    if ([arr containsObject:@2]){
                        class = @"RHReadyToRECController";
                    }
                    else if ([arr containsObject:@8]){
                        class = @"RHQuestionRevisitController";
                    }
                    else{
                        [RHOpenAccStoreData clearOpenAccCachWithKey:kOpenAccountRectify];
                        class = @"RHOpenAccResultController";
                    }
                    if (class.length) {
                        NSMutableDictionary * param = [NSMutableDictionary dictionary];
                        [param setObject:@1 forKey:kOpenAccountRectify];
                        [MNNavigationManager navigationToUniversalVC:self withClassName:class withParam:param];
                        return;
                    }
                }
            }
        
            [MNNavigationManager navigationToUniversalVC:welf withClassName:@"RHReadyToRECController" withParam:nil];
            
        }
    }];

}


- (void)bindingDeposit{
    if (!self.client_id.length || !self.selectedBank) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    //银行代码
    [param setObject:self.selectedBank.bank_no forKey:@"bank_no"];
    //类型 11：一步式需要密码，12：一步式无需密码，21：两步式需要卡号，22：两步式无需卡号
    [param setObject:self.selectedBank.fun_flag forKey:@"type"];
    
    NSString * bankAccCode = self.bankNoView.textField.text;
    NSString * bankAccPassword = self.bankPwView.textField.text;
    
    if (bankAccCode.length < 15 || bankAccCode.length > 19) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入正确的银行卡号" warningImage:nil duration:2];
        return;
    }
    
    //11：一步式需要密码，12：一步式无需密码，21：两步式需要卡号，22：两步式无需卡号
    switch ([self.selectedBank.fun_flag integerValue]) {
        case 11:{
            if (!bankAccCode.length) {
                [CMProgress showWarningProgressWithTitle:nil message:@"请输入卡号" warningImage:nil duration:1];
                return;
            }
            [param setObject:bankAccCode forKey:@"bank_account"];
            
            if (!bankAccPassword.length) {
                 [CMProgress showWarningProgressWithTitle:nil message:@"请输入密码" warningImage:nil duration:1];
                return;
            }
            [param setObject:bankAccPassword forKey:@"bk_password"];
        
        }
            break;
            
        case 12:{
            if (!bankAccCode.length) {
                [CMProgress showWarningProgressWithTitle:nil message:@"请输入卡号" warningImage:nil duration:1];
                return;
            }
            [param setObject:bankAccCode forKey:@"bank_account"];

        }break;
            
        case 21:{
            if (!bankAccCode.length) {
                [CMProgress showWarningProgressWithTitle:nil message:@"请输入卡号" warningImage:nil duration:1];
                return;
            }
            [param setObject:bankAccCode forKey:@"bank_account"];
        }break;
            
        case 22:{
            //无需卡号
        }break;
        default:
            break;
    }
    
    __weak typeof(self) welf = self;

    [self.oAManager sendCommonRequestWithParam:param withRequestType:kBindingBankCard withUrlString:@"crhDepositOpenAcc" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            [RHOpenAccStoreData storeOpenAccCachUserInfo:bankAccCode withKey:kOpenAccBankCode];
            [RHOpenAccStoreData storeOpenAccCachUserInfo:self.selectedBank withKey:kOpenAccBindBank];
            
            [welf protocolSign];
        }
    }];
    
}

- (void)checkEnableBtn{
    
    if ([self.selectedBank.bank_name containsString:@"广发"]||[self.selectedBank.bank_name isEqualToString:@"中国银行"]||[self.selectedBank.bank_name containsString:@"建设"]||[self.selectedBank.bank_name containsString:@"交通"]) {
        
        
        if (self.selectedBank && self.bankNoView.textField.text.length && self.isAgree && self.isSupport) {
            self.nextView.enable = YES;
        }
        else{
            self.nextView.enable = NO;
        }
        
        
    }else{
        
        if (self.selectedBank && self.bankNoView.textField.text.length && self.bankPwView.textField.text.length && self.isAgree && self.isSupport) {
            self.nextView.enable = YES;
        }
        else{
            self.nextView.enable = NO;
        }
        
    }
    
}

- (void)checkAccAndBank{
    NSString * bankAccCode = self.bankNoView.textField.text;
    
    if (!bankAccCode.length || !self.selectedBank) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@"recharge" forKey:@"type"];
//    [param setObject:@"6214830102207031" forKey:@"cardId"];
    [param setObject:bankAccCode forKey:@"cardId"];

    __weak typeof(self) welf = self;

    [self.checkManager sendJinHuiRequestWithParam:param withRequestType:kVerifyBankCodeWithBankType withUrlString:@"jinhuiBankAccCheck" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            NSDictionary * dic = resultData;
            NSDictionary * data = [dic objectForKey:@"data"];
            NSString * queryString = [data objectForKey:@"simpleName"];
            NSString * hintStr;
            if ([welf.selectedBank.bank_name isEqualToString:queryString]) {
                hintStr = @"识别银行卡号成功";
                self.isSupport = YES;
            }
            else if ([welf.selectedBank.bank_name isEqualToString:@"邮政储蓄银行"] && [queryString isEqualToString:@"邮政储蓄"]){
                hintStr = @"识别银行卡号成功";
                self.isSupport = YES;
            }
            else{
                hintStr = @"您输入的银行卡号与选择的银行不一致";
                self.isSupport = NO;
                [CMProgress showWarningProgressWithTitle:nil message:hintStr warningImage:nil duration:2];

            }
            [self checkEnableBtn];
//            [CMProgress showWarningProgressWithTitle:nil message:hintStr warningImage:nil duration:2];
        }
        else{
             ResultMessageVO * messVO = [ResultMessageVO parseData:resultData];
            self.isSupport = NO;
            [self checkEnableBtn];
            if (messVO.code == 2) {
                [CMProgress showWarningProgressWithTitle:nil  message:@"请使用借记卡绑定" warningImage:nil duration:2];

            }else{
            
                [CMProgress showWarningProgressWithTitle:nil  message:messVO.message warningImage:nil duration:2];
            }
        }
    }];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self photoFromCamera];
    }
    else if (buttonIndex == 1){
        [self photoFromAlbums];
    }
}

- (void)photoFromCamera{
    ESCameraViewController * esVc = [[ESCameraViewController alloc] init];
    esVc.delegate = self;
    [self.navigationController pushViewController:esVc animated:YES];
}

- (void)photoFromAlbums{
    self.bankCardPhoto = [[KCPhoto alloc] init];
    self.bankCardPhoto.target = self;
    self.bankCardPhoto.delegate = self;
    [self.bankCardPhoto photoReco];
}

-(void)didEndRecBANKWithResult:(BankInfo *)bankInfo from:(id)sender
{
    UIViewController * vc = (UIViewController*)sender;
    [vc.navigationController popViewControllerAnimated:YES];
    if(bankInfo != nil) {
        
        if (![CRHBankVoRuleQuery isSupportBank:bankInfo.bankName]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"暂不支持您选择的银行" warningImage:nil duration:2];
            return;
        }
        if (![bankInfo.cardType isEqualToString:@"借记卡"]) {
            //如果不是借记卡 有可能为其他种类支持的卡种 因此需要判断
            NSString * num = [bankInfo.cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];

            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            [param setObject:@"recharge" forKey:@"type"];
            if (!num.length) {
                [CMProgress showWarningProgressWithTitle:nil message:@"未识别出您的银行卡信息" warningImage:nil duration:2];
                return;
            }
            [param setObject:num forKey:@"cardId"];

            __weak typeof (self)welf = self;
            [self.checkManager sendJinHuiRequestWithParam:param withRequestType:kVerifyBankCodeWithBankType withUrlString:@"jinhuiBankAccCheck" withCompletion:^(BOOL success, id resultData) {
                if (success) {
                    [welf dealBankInfoWith:bankInfo];
                    
                }else{
                    [CMProgress showWarningProgressWithTitle:nil message:@"银行卡必须为本人的借记卡" warningImage:nil duration:2];
                }
            }];
        }
        else{
            [self dealBankInfoWith:bankInfo];
        }
    }
    else{
        [CMProgress showWarningProgressWithTitle:nil message:@"未识别出您的银行卡信息" warningImage:nil duration:2];
        
    }
}

- (void)dealBankInfoWith:(BankInfo *)bankInfo{
    self.bankInfo = bankInfo;
    NSString * num = [self.bankInfo.cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.bankNoView.textField.text = num;
    
    self.bankView.bank = self.bankInfo;
    //需要转换BankInfo为CRHBankListVo 统一类型 便于使用
    self.selectedBank = [[CRHBankListVo alloc] init];
    self.selectedBank.bank_name = self.bankView.bankName;
    self.selectedBank.fun_flag = [CRHBankVoRuleQuery queryBankInfoWithKey:@"fun_flag" withBankName:self.selectedBank.bank_name];
    self.selectedBank.bank_no = [CRHBankVoRuleQuery queryBankInfoWithKey:@"bank_no" withBankName:self.selectedBank.bank_name];
    self.selectedBank.econtract_id = [CRHBankVoRuleQuery queryBankInfoWithKey:@"econtract_id" withBankName:self.selectedBank.bank_name];
    
    if ([self.bankInfo.bankName containsString:@"民生"]) {
        self.bankPwView.placeholder = @"请输入查询密码";
    }
    else{
        self.bankPwView.placeholder = @"请输入6位银行卡密码";
    }
    
    if ([self.bankView.bankNameLabel.text isEqualToString:@"广发银行"]||[self.bankView.bankNameLabel.text isEqualToString:@"中国银行"]||[self.bankView.bankNameLabel.text isEqualToString:@"建设银行"]||[self.bankView.bankNameLabel.text isEqualToString:@"交通银行"]) {
        
        self.bankPwView.hidden = YES;
        self.bottomScrollow.autoLine.hidden = YES;
        
    }else{
        
        self.bankPwView.hidden = NO;
        self.bottomScrollow.autoLine.hidden = NO;
        
        
    }
    
    self.isSupport = YES;
    [self requestBankProtocol];
    [self checkEnableBtn];
    [self.view setNeedsLayout];
    
}

-(void)didEndEdit:(NSString*)str from:(id)sender{
    
}

-(void)didEndPhotoRecBANKWithResult:(BankInfo *)bankInfo Image:(UIImage *)image from:(id)sender{

    if (bankInfo != nil) {
        [self dealBankInfoWith:bankInfo];

    }
    else{
        [CMProgress showWarningProgressWithTitle:nil message:@"未识别出您的银行卡信息" warningImage:nil duration:2];

    }
}

-(void)didFinishPhotoRec{
    
}

@end
