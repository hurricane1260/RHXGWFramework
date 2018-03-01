//
//  RHAccountPasswordController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/15.
//
//

#import "RHAccountPasswordController.h"
#import "OARequestManager.h"

#import "CRHBranchVo.h"
#import "CRHClientInfoVo.h"
#import "CRHMatchCheckVo.h"
#import "CRHProtocolListVo.h"

#import "APTopView.h"
#import "APOpenTypeView.h"
#import "APPasswordView.h"
#import "protocolView.h"

#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

@interface RHAccountPasswordController ()
//@property (strong, nonatomic) IBOutlet UILabel *CommissionLabel;
//- (IBAction)HuShenBtn:(id)sender;
//- (IBAction)JiJinBtn:(id)sender;
//- (IBAction)ChuangYeBanBtn:(id)sender;
//@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
//@property (strong, nonatomic) IBOutlet UITextField *reInputTextField;
//- (IBAction)SamePasswordBtn:(id)sender;
//- (IBAction)nextStepBtn:(id)sender;
//
//@property (strong, nonatomic) IBOutlet UIButton *HuShenBtn;
//@property (strong, nonatomic) IBOutlet UIButton *JiJinBtn;
//@property (strong, nonatomic) IBOutlet UIButton *CYBBtn;
//@property (strong, nonatomic) IBOutlet UIButton *SamePwBtn;
//
//- (IBAction)openStockAcc:(id)sender;
//- (IBAction)openFundAcc:(id)sender;
//- (IBAction)transCYBAcc:(id)sender;
//
//- (IBAction)setTradePassword:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UIView *fundView;
//@property (weak, nonatomic) IBOutlet UITextField *fundTextField;
//@property (weak, nonatomic) IBOutlet UITextField *reFundTextField;

kRhPStrong UIScrollView * bottomScrollow;

kRhPStrong APTopView * topView;

kRhPStrong APOpenTypeView * openTypeView;

kRhPStrong APPasswordView * passwordView;

kRhPStrong protocolView * nextBtn;

kRhPAssign BOOL isHuShenSelected;
//
//kRhPAssign BOOL isJiJinSelected;
//
//kRhPAssign BOOL isChuangYeBanSelected;
//
//kRhPAssign BOOL isSamePasswordSelected;

kRhPAssign BOOL isAgreed;

kRhPAssign BOOL isEdited;

kRhPStrong OARequestManager * requestManager;

kRhPStrong OARequestManager * setManager;

kRhPStrong OARequestManager * matchManager;

kRhPStrong OARequestManager * matchIdManager;

kRhPStrong OARequestManager * protocolManager;

kRhPCopy NSString * tel;

kRhPCopy NSString * cardId;

kRhPStrong UIView * sepView;

kRhPAssign BOOL isMatch;

kRhPCopy NSString * matchNo;

kRhPStrong CRHProtocolListVo * protocolVo;

kRhPCopy NSString * client_id;

kRhPAssign BOOL needRectify;

kRhPStrong NSMutableArray * protocolArr;

kRhPAssign NSInteger managerNum;

kRhPStrong NSMutableArray * managerArr;
@end

@implementation RHAccountPasswordController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"账户与密码";
        self.view.backgroundColor = color1_text_xgw;
        self.needRectify = NO;
        self.isHuShenSelected = YES;
        self.isAgreed = YES;
        self.isMatch = YES;

        self.protocolArr = [NSMutableArray array];
        self.managerArr = [NSMutableArray array];
        [self initSubviews];
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
        
    }}

- (OARequestManager *)requestManager{
    if (!_requestManager) {
        _requestManager = [[OARequestManager alloc] init];
    }
    return _requestManager;
}

- (OARequestManager *)setManager{
    if (!_setManager) {
        _setManager = [[OARequestManager alloc] init];
    }
    return _setManager;
}

- (OARequestManager *)matchManager{
    if (!_matchManager) {
        _matchManager = [[OARequestManager alloc] init];
    }
    return _matchManager;
}

- (OARequestManager *)matchIdManager{
    if (!_matchIdManager) {
        _matchIdManager = [[OARequestManager alloc] init];
    }
    return _matchIdManager;
}

- (OARequestManager *)protocolManager{
    if (!_protocolManager) {
        _protocolManager = [[OARequestManager alloc] init];
    }
    return _protocolManager;
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestCommission];
    [self requestClientInfo];
    [self requestMatchCheck];
    
    [self requestProtocol];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.requestManager cancelAllDelegate];
    [self.setManager cancelAllDelegate];
    [self.matchManager cancelAllDelegate];
    [self.protocolManager cancelAllDelegate];
    for (OARequestManager * manager in self.managerArr) {
        [manager cancelAllDelegate];
    }
    
    if (self.needRectify) {
        [RHOpenAccStoreData cancelRequestStatus];
    }
}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;
    self.bottomScrollow = [[UIScrollView alloc] init];
    self.bottomScrollow.backgroundColor = color1_text_xgw;
    self.bottomScrollow.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboards)];
    self.bottomScrollow.userInteractionEnabled = YES;
    [self.bottomScrollow addGestureRecognizer:tap];
    [self.view addSubview:self.bottomScrollow];
    
    self.topView = [[APTopView alloc] init];
    [self.bottomScrollow addSubview:self.topView];

    self.sepView = [self.bottomScrollow addAutoLineViewWithColor:color18_other_xgw];
    
    self.openTypeView = [[APOpenTypeView alloc] init];
    self.openTypeView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.openTypeView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    self.openTypeView.selectCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"select"]) {
            welf.isHuShenSelected = [[param objectForKey:@"select"] boolValue];
            [welf checkEnableBtn];
        }
    };
    [self.bottomScrollow addSubview:self.openTypeView];
    
    [self.bottomScrollow addAutoLineViewWithColor:color18_other_xgw];
    
    self.passwordView = [[APPasswordView alloc] init];
    self.passwordView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.passwordView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    self.passwordView.enableCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"enable"]) {
            welf.isEdited = [[param objectForKey:@"enable"] boolValue];
            [welf checkEnableBtn];
        }
    };
    
    [self.bottomScrollow addSubview:self.passwordView];
    
//    self.nextBtn  = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
//    [self.nextBtn addTarget:self action:@selector(nextStepBtn) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = [[protocolView alloc] init];
//    self.nextBtn.bottomProtocol = YES;
    self.nextBtn.protocolName = @"《华创证券开户协议》";
    self.nextBtn.selectCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"select"]) {
            welf.isAgreed = [[param objectForKey:@"select"] boolValue];
            [welf checkEnableBtn];

        }
    };
    self.nextBtn.protocolCallBack = ^{
        [welf naviToProtocolPage];
    };
    self.nextBtn.nextCallBack = ^{
        [welf nextStepBtn];
    };
    self.nextBtn.enable = NO;
    [self.view addSubview:self.nextBtn];
    
//    [self.view addAutoLineWithColor:color16_other_xgw];
}

- (void)checkEnableBtn{
    if (self.isEdited && self.isAgreed && self.isHuShenSelected) {
        self.nextBtn.enable = YES;
    }
    else{
        self.nextBtn.enable = NO;
    }
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGFloat gap = 6.0f;
    
    self.bottomScrollow.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY - 110.0f);
    
    self.topView.frame = CGRectMake(0, 0, self.bottomScrollow.width, 50.0f);
    
    self.sepView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.bottomScrollow.width, gap);
    
    self.openTypeView.frame = CGRectMake(0, CGRectGetMaxY(self.sepView.frame), self.bottomScrollow.width, self.openTypeView.height);
    
    self.bottomScrollow.autoLine.frame = CGRectMake(0, CGRectGetMaxY(self.openTypeView.frame), self.bottomScrollow.width, gap);
    
    self.passwordView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomScrollow.autoLine.frame), self.bottomScrollow.width, self.passwordView.height);
    
//    self.nextBtn.frame = CGRectMake((self.view.width - self.nextBtn.width ) /2.0f, self.view.height - 14.0f - self.nextBtn.height, self.nextBtn.width, self.nextBtn.height);
    
    self.nextBtn.frame = CGRectMake(0, self.view.height - 110.0f, self.view.width, 110.0f);

//    self.view.autoLine.frame = CGRectMake(0, self.view.height - self.nextBtn.height - 28.0f , self.view.width, 0.5f);
    
    self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width,CGRectGetMaxY(self.passwordView.frame));
}

- (void)requestCommission{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@"33" forKey:@"branch_no"];

    __weak typeof(self) welf = self;
    [self.requestManager sendCommonRequestWithParam:param withRequestType:kQueryBranchCommission withUrlString:@"crhQueryBranchCommission" withCompletion:^(BOOL success, id resultData) {
        if (success) {
//            if (!resultData) {
//                welf.topView.commission = @"佣金：0.025%";
//            }
//            else if([resultData isKindOfClass:[CRHBranchVo class]]){
//                CRHBranchVo * vo = resultData;
//                if (vo.commission.length) {
//                    welf.topView.commission = [NSString stringWithFormat:@"佣金：%@",vo.commission];
//                }
//                else{
//                    welf.topView.commission = @"佣金：0.025%";
//                }
//            }
            NSString * short_url = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:@"short_url"];
            if ([short_url isEqualToString:@"xgw"]) {
                welf.topView.commission = @"佣金：0.025%";
            }
            else if ([short_url isEqualToString:@"xycf"]){
                welf.topView.commission = @"佣金：0.08%";
            }
            else{
                welf.topView.commission = @"佣金：0.025%";
            }
            
        }
        else{
            welf.topView.commission = @"佣金：0.025%";
        }
        [welf.view setNeedsLayout];
    }];


}

#pragma mark 适当性匹配检查
- (void)requestMatchCheck{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@"100017" forKey:@"prod_code"];
    [param setObject:self.client_id forKey:@"client_id"];
    
    __weak typeof(self) welf = self;

    [self.matchManager sendCommonRequestWithParam:param withRequestType:kRiskMatchCheck withUrlString:@"crhRiskMatchCheck" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (![resultData isKindOfClass:[CRHMatchCheckVo class]]) {
                welf.isMatch = YES;
                [welf requestToGetMatchProtocolId];
                return;
            }
            CRHMatchCheckVo * vo = resultData;
            if ([vo.suit_flag isEqualToString:@"0"]) {
                welf.isMatch = YES;
//                welf.nextBtn.protocolName = @"《适当性匹配意见及投资者确认书》";
            }
            else if ([vo.suit_flag isEqualToString:@"1"]){
                welf.isMatch = NO;
//                welf.nextBtn.protocolName = @"《产品或服务风险警示及投资者确认书》";
            }
            else if([vo.suit_flag isEqualToString:@"2"]){
              
                [CMProgress showWarningProgressWithTitle:nil message:@"您所选择账户的最高风险等级为中，与您评测的风险等级不匹配（禁止）" warningImage:nil duration:3];
            }
            [welf requestToGetMatchProtocolId];
        }
        else{
            NSString * error_info = [resultData objectForKey:@"error_info"];
            [CMProgress showWarningProgressWithTitle:nil message:error_info warningImage:nil duration:3];
        }
        [welf.view setNeedsLayout];
    }];
}

#pragma mark 获取匹配不匹配确认书id
- (void)requestToGetMatchProtocolId{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    if (self.isMatch) {
        self.matchNo = @"10085";
        //匹配确认书
    }
    else{
        self.matchNo = @"10086";
        //不匹配确认书
    }
    [param setObject:self.matchNo forKey:@"biz_id"];

    
    __weak typeof(self) welf = self;
    [self.matchIdManager requestProtocolListWithParam:param withRequestType:kProtocolList withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                return;
            }
            for (NSDictionary * resultDic in resultData) {
                CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:resultDic];
                welf.protocolVo = vo;
                [welf.protocolArr addObject:welf.protocolVo];
            }
        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"获取匹配或不匹配确认书失败" warningImage:nil duration:1];

        }
    }];
}

#pragma mark 签署匹配或不匹配确认书
- (void)requestToSignMatchProtocol{
    [self.protocolManager requestProtocolSignWithCRHProtocolListVo:self.protocolVo withCACertSn:@"NOSN" withRequestType:kProtocolSign withBusinessType:self.matchNo  withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (self.needRectify) {
                
                [RHOpenAccStoreData requestUserStatus:self];
                return ;
                
                NSArray * arr = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRectify];
                if (arr.count) {
                    NSString * class = @"";
                    if ([arr containsObject:@5]){
                        class = @"RHBankCardBindController";
                    }
                    else if ([arr containsObject:@2]){
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
            
            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHBankCardBindController" withParam:nil];

        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"签署匹配或不匹配确认书失败" warningImage:nil duration:2];

        }
    }];
}

#pragma mark 签署开户协议

- (void)requestProtocol{
    [self.protocolArr removeAllObjects];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@1 forKey:@"biz_id"];
    [param setObject:@1 forKey:@"econtract_type"];
    
    __weak typeof(self) welf = self;
    [self.protocolManager requestProtocolListWithParam:param withRequestType:kProtocolList withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                return;
            }
            for (NSDictionary * resultDic in resultData) {
                CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:resultDic];
                
//                if ([vo.econtract_name isEqualToString:@"华创证券有限责任公司网上开户协议"]) {
//                    welf.protocolNo = vo.econtract_id;
//                    welf.protocolVo = vo;
//                }
                [welf.protocolArr addObject:vo];
            }
            
        }
        else{
            [CMProgress showWarningProgressWithTitle:@"获取协议列表失败" message:nil warningImage:nil duration:1];
        }
    }];
    
}

- (void)queryProtocolSign{
    
    if (!self.protocolArr.count) {
        return;
    }
    
    self.managerNum = 0;
    [self.managerArr removeAllObjects];
    for (int i = 0; i < self.protocolArr.count; i++) {
        CRHProtocolListVo * vo = self.protocolArr[i];
        OARequestManager * manager = [[OARequestManager alloc] init];
        
        __weak typeof (self) welf = self;
        [manager requestProtocolSignWithCRHProtocolListVo:vo withCACertSn:@"NOSN" withRequestType:kProtocolSign withBusinessType:@"1"  withCompletion:^(BOOL success, id resultData) {
            welf.managerNum++;
            if (success) {
                
            }
            else{
                NSString * error = [NSString stringWithFormat:@"签署《%@》失败",vo.econtract_name];
                [CMProgress showWarningProgressWithTitle:nil message:error warningImage:nil duration:2];
 
            }
            if ([welf checkIfProtocolSignComplete]) {

                [welf requestToSignMatchProtocol];
            }
            
        }];
        [welf.managerArr addObject:manager];
    }
    
}

- (BOOL)checkIfProtocolSignComplete{
    if (self.managerNum == self.managerArr.count) {
        return YES;
    }
    return NO;
}

- (void)requestClientInfo{
    [self.setManager requestQueryClientInfoWithComoletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHClientInfoVo class]]) {
                return;
            }
            CRHClientInfoVo * vo = resultData;
            self.tel = vo.mobile_tel;
            self.cardId = vo.id_no;
        }
    }];

}

- (void)requestSetTradePassword{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@"000000" forKey:@"capital_password"];
    [param setObject:@"000000" forKey:@"transaction_password"];
    
    if (self.passwordView.tradeView.textField.text.length == 6) {
        [param setObject:self.passwordView.tradeView.textField.text forKey:@"capital_password"];
    }
    
    if (self.passwordView.isSame) {
        [param setObject:self.passwordView.tradeView.textField.text forKey:@"transaction_password"];
    }
    else{
        [param setObject:self.passwordView.moneyView.textField.text forKey:@"transaction_password"];
    }
    
    [param setObject:self.client_id forKey:@"client_id"];
    __weak typeof(self) welf = self;

    [self.setManager sendCommonRequestWithParam:param withRequestType:kSetTradePassWord withUrlString:@"crhSetTradePassword" withCompletion:^(BOOL success, id resultData) {
        if (success) {
//            [CMProgress showWarningProgressWithTitle:nil message:@"设置交易、资金密码成功" warningImage:nil duration:2];

            [welf queryProtocolSign];
        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"设置交易、资金密码失败" warningImage:nil duration:2];

        }
    }];
}


- (void)requestStockOpenAcc{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    NSString * kind = @"1,2";
    NSString * opType = @"1,1";
    [param setObject:kind forKey:@"exchange_kind"];
    [param setObject:opType forKey:@"bizOpType_list"];
    
    __weak typeof(self) welf = self;

    [self.requestManager sendCommonRequestWithParam:param withRequestType:kOpenStockAcc withUrlString:@"crhOpenStockAcc" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            [welf requestSetTradePassword];
//            [CMProgress showWarningProgressWithTitle:nil message:@"申请开通证券账号成功" warningImage:nil duration:2];
        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"申请开通证券账号失败" warningImage:nil duration:2];

        }
    }];
}


- (void)requestFundOpenAcc{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    NSArray * arr = @[@1,@2];
    [param setObject:arr forKey:@"fund_company"];
    
    [self.requestManager sendCommonRequestWithParam:param withRequestType:kOpenStockAcc withUrlString:@"crhOpenFundAcc" withCompletion:^(BOOL success, id resultData) {
        if (success) {
//            [CMProgress showWarningProgressWithTitle:@"基申请开通金账号成功" message:nil warningImage:nil duration:2];

        }
    }];

}

- (void)requestTransCYBAcc{
    [self checkIfCanTransCYB];

}

- (void)checkIfCanTransCYB{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"user_id"];
    
    __weak typeof(self) welf = self;
    [self.requestManager sendCommonRequestWithParam:param withRequestType:kCheckCanTransCYB withUrlString:@"crhCYBCheck" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            [welf modifySecondConnectInfo];
        }
    }];

}

- (void)modifySecondConnectInfo{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"user_id"];
    [param setObject:@"啦啦" forKey:@"sec_relation_name"];
    [param setObject:@"158100001111" forKey:@"sec_relation_phone"];
    [param setObject:@1 forKey:@"isconnifs"];
    [param setObject:@"朋友" forKey:@"socialral_type"];
    
    __weak typeof(self) welf = self;
    [self.requestManager sendCommonRequestWithParam:param withRequestType:kSecondConnectModify withUrlString:@"crhCYBConnectModify" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            [welf transCYBCheckIn];
        }
    }];


}


- (void)transCYBCheckIn{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"user_id"];
    [param setObject:@1 forKey:@"gem_train_flag"];
    [param setObject:@"00000000000" forKey:@"stock_account"];
       
    __weak typeof(self) welf = self;
    [self.requestManager sendCommonRequestWithParam:param withRequestType:kTransCYBAcc withUrlString:@"crhCYBCheckIn" withCompletion:^(BOOL success, id resultData) {
        if (success) {

        }
    }];

}

- (void)naviToProtocolPage{
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObject:self.protocolVo forKey:@"match"];
//    [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAProtocolController" withParam:param];

    [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAProtocolListController" withParam:self.protocolArr];

}

- (void)hideKeyboards{
    [self.passwordView hiddenKeyBoards];
}

- (void)nextStepBtn{
    if (![self checkIfCanOpenAcc]) {
        return;
    }
    
    [self requestStockOpenAcc];
    
}

- (BOOL)checkIfCanOpenAcc{
    
    NSString * tradePw = self.passwordView.tradeView.textField.text;
    NSString * reTradePw = self.passwordView.reTradeView.textField.text;
    NSString * moneyPw = self.passwordView.moneyView.textField.text;
    NSString * reMoneyPw = self.passwordView.reMoneyView.textField.text;
    
    if (!self.isHuShenSelected) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请选择要开户的类型" warningImage:nil duration:1];
        return NO;
    }
    if (tradePw.length != 6 || reTradePw.length != 6) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入6位交易密码" warningImage:nil duration:1];
        return NO;
    }
    if (![tradePw isEqualToString:reTradePw]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"交易密码两次输入不一致，请检查后重新输入" warningImage:nil duration:1];
        return NO;
    }
    if ([self.tel containsString: tradePw] || [self.cardId containsString:tradePw]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"密码不能为身份证、手机号一部分" warningImage:nil duration:1];
        return NO;
    }

    if (![self checkPWLegal:tradePw]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"密码不合格" warningImage:nil duration:1];
        return NO;
    }
    
    if (!self.passwordView.isSame) {
        if ((!moneyPw.length || !reMoneyPw.length)) {
            [CMProgress showWarningProgressWithTitle:nil message:@"资金密码不能为空" warningImage:nil duration:1];
            return NO;
        }
        
        if (![moneyPw isEqualToString:reMoneyPw]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"资金密码两次输入不一致，请检查后重新输入" warningImage:nil duration:1];
            return NO;
        }
        if (![self checkPWLegal:moneyPw]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"资金密码不合格" warningImage:nil duration:1];
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkPWLegal:(NSString *)string{
    if (string.length != 6) {
        return NO;
    }
    for (int i = 0; i < string.length - 2; i++) {
        NSMutableString * str = [NSMutableString stringWithString:[string substringWithRange:NSMakeRange(i, 3)]];

        NSString * str0 = [NSString stringWithFormat:@"%c",[str characterAtIndex:0]];
        NSString * str1 = [NSString stringWithFormat:@"%c",[str characterAtIndex:1]];
        NSString * str2 = [NSString stringWithFormat:@"%c",[str characterAtIndex:2]];
        
        if ([str0 isEqualToString:str1] && [str1 isEqualToString:str2]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"密码中同一数字不能连续出现三次" warningImage:nil duration:1];
            return NO;
        }
        if ([str0 integerValue] + 1 == [str1 integerValue] && [str1 integerValue] + 1 == [str2 integerValue]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"密码中不能出现连续三个数字" warningImage:nil duration:1];
            return NO;
        }
        if ([str0 integerValue] - 1 == [str1 integerValue] && [str1 integerValue] - 1 == [str2 integerValue]) {
            [CMProgress showWarningProgressWithTitle:nil message:@"密码中不能出现连续三个数字" warningImage:nil duration:1];
            return NO;
        }
    }
    NSString * str1 = [string substringToIndex:3];
    NSString * str2 = [string substringFromIndex:3];
    NSMutableString * reverseString = [NSMutableString string];
    for(int i = 0 ; i < str2.length; i++){
        unichar c = [str2 characterAtIndex:str2.length- i -1];
        [reverseString appendFormat:@"%c",c];
    }
    if ([str1 isEqualToString:reverseString]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"密码中不能出现回文数字" warningImage:nil duration:1];
        return NO;
    }
    return YES;
}

@end
