//
//  RHOpenAccountController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/8.
//
//

#import "RHOpenAccountController.h"
#import "OARequestManager.h"
//#import "AccountRegisterManager.h"
#import "MNNavigationManager.h"

#import "CRHProtocolListVo.h"
#import "CRHCheckRegiserUserVo.h"
#import "CRHMessageVo.h"
#import "CRHUserStatusVo.h"

#import "MobileVerifyView.h"
#import "IdBankWifiView.h"
#import "MobileVerifyBankView.h"
#import "protocolView.h"
#import "MVSetTopView.h"
#import "RHOpenAccStoreData.h"

@interface RHOpenAccountController ()<UITextFieldDelegate,UIAlertViewDelegate>

kRhPStrong OARequestManager * protocolManager;

kRhPStrong OARequestManager * protocolSignManager;

kRhPStrong OARequestManager * oAManager;

kRhPStrong OARequestManager * statusManager;

//@property (strong, nonatomic) IBOutlet UITextField *phoneNumTextField;
//@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTextField;
//- (IBAction)getVerifyCodeBtn:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *hintTextLabel;
//- (IBAction)nextBtn:(id)sender;

//kRhPStrong AccountRegisterManager *regVerifyManager;
//验证码会话id
kRhPCopy NSString *clientId;
//@property (strong, nonatomic) IBOutlet UITextField *imgVerifyCodeTextField;
//@property (strong, nonatomic) IBOutlet UIButton *imgVerifyCode;
//@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
//- (IBAction)showProtocolBtn:(id)sender;

//- (IBAction)agreeBtn:(id)sender;
//- (IBAction)queryProtocolSign:(id)sender;
//kRhPAssign BOOL isAgreed;
kRhPAssign BOOL editEnabled;

kRhPCopy NSString * protocolNo;

kRhPStrong CRHProtocolListVo * protocolVo;

kRhPStrong NSMutableArray * protocolArr;
//@property (weak, nonatomic) IBOutlet UITextField *queryDicNo;
//- (IBAction)queryDicBtn:(id)sender;

kRhPStrong NSMutableArray * managerArr;
kRhPAssign NSInteger managerNum;

kRhPStrong UIScrollView * bottomScrView;

kRhPStrong MobileVerifyView * verifyView;

kRhPStrong IdBankWifiView * midView;

kRhPStrong UIButton * showBankCardBtn;

kRhPStrong MobileVerifyBankView * bankView;

//kRhPStrong protocolView * proView;

kRhPStrong UIButton * nextStepBtn;

kRhPStrong UIButton * rightBtn;

kRhPStrong MVSetTopView * setView;

kRhPAssign BOOL hasGetVerifyCode;

//渠道号
kRhPStrong NSString * short_url;
//佣金
kRhPStrong NSString * commission;
@end

@implementation RHOpenAccountController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"手机验证";
        self.protocolArr = [NSMutableArray array];
        self.managerArr = [NSMutableArray array];
//        self.isAgreed = YES;
        self.view.backgroundColor = color1_text_xgw;
        self.hasGetVerifyCode = NO;
        [self initSubviews];
        [self.verifyView.userNameTextField becomeFirstResponder];

    }
    return self;
}

//- (AccountRegisterManager *)regVerifyManager{
//    if (!_regVerifyManager) {
//        _regVerifyManager = [[AccountRegisterManager alloc]init];
//        _regVerifyManager.delegate = self;
//    }
//    return _regVerifyManager;
//}

- (OARequestManager *)protocolManager{
    if (!_protocolManager) {
        _protocolManager = [[OARequestManager alloc] init];
    }
    return _protocolManager;
}

- (OARequestManager *)oAManager{
    if (!_oAManager) {
        _oAManager = [[OARequestManager alloc] init];
    }
    return _oAManager;
}

- (OARequestManager *)statusManager{
    if (!_statusManager) {
        _statusManager = [[OARequestManager alloc] init];
    }
    return _statusManager;
}

- (OARequestManager *)protocolSignManager{
    if (!_protocolSignManager) {
        _protocolSignManager = [[OARequestManager alloc] init];
    }
    return _protocolSignManager;
}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam) {
        return;
    }
    if ([universalParam isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = universalParam;
        if ([dic objectForKey:@"short_url"]) {
            self.short_url = [dic objectForKey:@"short_url"];
        }
        if ([dic objectForKey:@"commission"]) {
            self.commission = [dic objectForKey:@"commission"];
        }

        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.hasGetVerifyCode = NO;
//    [self.verifyView.userNameTextField becomeFirstResponder];
//    [self requestProtocol];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideKeyboards];
    self.verifyView.timeNum = 0;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.regVerifyManager cancelAllRequest];
//    for (OARequestManager * manager in self.managerArr) {
//        [manager cancelAllDelegate];
//    }
    [self.oAManager cancelAllDelegate];
    [self.protocolManager cancelAllDelegate];
    [self.statusManager cancelAllDelegate];
    [self.protocolSignManager cancelAllDelegate];
}

- (void)initSubviews{
    __weak typeof(self) welf = self;
    
    self.rightBtn = [UIButton didBuildButtonWithNormalImage:img_open_set highlightImage:img_open_set];
    [self.rightBtn addTarget:self action:@selector(showSetting) forControlEvents:UIControlEventTouchUpInside];
    self.rightButtonView = self.rightBtn;
    
    self.bottomScrView = [[UIScrollView alloc] init];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboards)];
    self.bottomScrView.userInteractionEnabled = YES;
    self.bottomScrView.showsVerticalScrollIndicator = NO;
    [self.bottomScrView addGestureRecognizer:tap];
    [self.view addSubview:self.bottomScrView];
    
    self.verifyView = [[MobileVerifyView alloc] init];
    self.verifyView.verifyCodeCallBack = ^{
        [welf sendSmsVerifyCode];
    };
    self.verifyView.enableCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"enable"]) {
            welf.editEnabled = [[param objectForKey:@"enable"] boolValue];

            [welf checkNextEnabled];
        }
    };
    [self.bottomScrView addSubview:self.verifyView];

    self.midView = [[IdBankWifiView alloc] init];
    [self.bottomScrView addSubview:self.midView];

    self.showBankCardBtn = [UIButton didBuildButtonWithTitle:@"支持的银行借记卡>" normalTitleColor:color8_text_xgw highlightTitleColor:color8_text_xgw disabledTitleColor:color8_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    [self.showBankCardBtn addTarget:self action:@selector(showBankView) forControlEvents:UIControlEventTouchUpInside];
    self.showBankCardBtn.titleLabel.font = font1_common_xgw;
    [self.bottomScrView addSubview:self.showBankCardBtn];
    
    self.bankView = [[MobileVerifyBankView alloc] init];
    self.bankView.hidden = YES;
    [self.bottomScrView addSubview:self.bankView];
    
    
//    self.proView = [[protocolView alloc] init];
//    self.proView.protocolName = @"《华创证券开户协议》";
//    self.proView.selectCallBack = ^(NSDictionary * param){
//        if ([param objectForKey:@"select"]) {
//            welf.isAgreed = [[param objectForKey:@"select"] boolValue];
//        }
//        [welf checkNextEnabled];
//    };
//    self.proView.protocolCallBack = ^{
//        [welf showProtocolBtn];
//    };
//    self.proView.nextCallBack = ^{
//        [welf nextBtn];
//    };
//    
//    [self.view addSubview:self.proView];
    
    self.nextStepBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    [self.nextStepBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    self.nextStepBtn.enabled = NO;
    [self.bottomScrView addSubview:self.nextStepBtn];
    
    self.setView = [[MVSetTopView alloc] init];
    self.setView.hidden = YES;
//    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSetting)];
//    [self.setView addGestureRecognizer:tap1];
    self.setView.clickCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"row"]) {
            NSLog(@"点击了Row");
            [welf showSetting];
            [welf didSelectItemWith:[param objectForKey:@"row"]];
        }
        else{
            [welf showSetting];
        }
    
    };
    [self.view addSubview:self.setView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.rightButtonView.frame = CGRectMake(self.view.width - 44.0f, 20.0f, 44.0f, 44.0f);
    
    self.bottomScrView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
    
    self.verifyView.frame = CGRectMake(0, 24.0f, self.view.width, 100.0f);
    self.midView.frame = CGRectMake(0, CGRectGetMaxY(self.verifyView.frame) + 27.0f, self.view.width, 52.0f);
    
     self.nextStepBtn.frame = CGRectMake((self.view.width - self.nextStepBtn.width)/2.0f, CGRectGetMaxY(self.midView.frame) + 27.0f, self.nextStepBtn.width, self.nextStepBtn.height);
    
    [self.showBankCardBtn.titleLabel sizeToFit];
    self.showBankCardBtn.frame = CGRectMake((self.view.width - self.showBankCardBtn.titleLabel.width ) /2.0f, CGRectGetMaxY(self.nextStepBtn.frame) + 40.0f, self.showBankCardBtn.titleLabel.width, self.showBankCardBtn.titleLabel.height);
    
    self.bankView.frame = CGRectMake(24.0f, CGRectGetMaxY(self.showBankCardBtn.frame) + 20.0f, self.view.width - 24.0f, 170.0f);
    
    if (self.bankView.hidden) {
        self.bankView.height = 0.0f;
    }
    
//    self.proView.frame = CGRectMake(0, self.view.height - 110.0f, self.view.width, 110.0f);
    
    self.setView.frame = self.view.frame;
    
    self.bottomScrView.contentSize = CGSizeMake(self.bottomScrView.width, CGRectGetMaxY(self.bankView.frame) + 10.0f);
}

- (void)sendSmsVerifyCode{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.verifyView.userNameTextField.text forKey:@"mobile_tel"];

    [self.oAManager sendSMSVerifyCodeWithParam:param withRequestType:kSmsVerifyCode withCompletion:^(BOOL success, id resultData) {
        if (success) {
            NSLog(@"发送短信验证码成功");
            self.verifyView.isSelected = !self.verifyView.isSelected;
            self.hasGetVerifyCode = YES;
            [self checkNextEnabled];
        }
        else{
            self.hasGetVerifyCode = NO;
            NSString * error_info = [resultData objectForKey:@"error_info"];
            [CMProgress showWarningProgressWithTitle:nil message:error_info warningImage:nil duration:1];
        }
    }];
}

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
            [CMProgress showEndProgressWithTitle:@"获取协议列表失败" message:nil endImage:nil duration:1];
        }
    }];

}

- (void)checkRegisterUser{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.verifyView.userNameTextField.text  forKey:@"mobile_tel"];
    [param setObject:self.verifyView.verifyTextField.text            forKey:@"mobile_code"];
    [param setObject:@"200"             forKey:@"app_id"];
    [param setObject:@"2"               forKey:@"register_way"];
    [param setObject:@"1"               forKey:@"csdc_open_flag"];
    if (self.short_url && self.short_url.length) {
        [param setObject:self.short_url    forKey:@"short_url"];
    }

//    [param setObject:@"192.168.200.17"  forKey:@"op_station"];

    __weak typeof(self) welf = self;
    [self.oAManager sendCheckRegisterUserWithParam:param withRequestType:kSmsVCCheck withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHCheckRegiserUserVo class]]) {
                [CMProgress showEndProgressWithTitle:@"用户注册信息返回错误" message:nil endImage:nil duration:2.0f];
                return;
            }
            CRHCheckRegiserUserVo * vo = resultData;
            
            [RHOpenAccStoreData storeOpenAccCachUserInfo:vo.client_id withKey:kOpenAccClientId];
            [RHOpenAccStoreData storeOpenAccCachUserInfo:welf.verifyView.userNameTextField.text withKey:kOpenAccMobile];
            if (welf.short_url.length) {
                [RHOpenAccStoreData storeOpenAccCachUserInfo:welf.short_url withKey:@"short_url"];
            }
            if (welf.commission.length) {
                [RHOpenAccStoreData storeOpenAccCachUserInfo:welf.commission withKey:@"commission"];
            }
            if ([vo.is_first_reg boolValue]) {
                
//                [welf queryProtocolSign:nil];
                [MNNavigationManager navigationToUniversalVC:welf withClassName:@"RHIDCardController" withParam:nil];
            }
            else{
//                //请求当前进入的阶段状态 跳转相应的页面
                [welf requestUserStatus:vo.client_id];
//                [MNNavigationManager navigationToUniversalVC:welf withClassName:@"RHRiskEvaluationController" withParam:nil];

            }
        }
        else{
            if ([resultData isKindOfClass:[NSDictionary class]]) {
                if ([resultData objectForKey:@"error_info"]) {
                    NSString * error_info = [resultData objectForKey:@"error_info"];
                    [CMProgress showWarningProgressWithTitle:nil  message:error_info warningImage:nil duration:2.0f];
                }
            }
            else{
                [CMProgress showWarningProgressWithTitle:nil  message:@"校验验证码失败" warningImage:nil duration:2.0f];
                
            }
        }
    }];

}

- (void)requestUserStatus:(NSString * )client_id{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
//    [param setObject:self.phoneNumTextField.text     forKey:@"mobile_tel"];
    [param setObject:client_id    forKey:@"client_id"];
    __weak typeof(self) welf = self;
    [self.statusManager sendCommonRequestWithParam:param withRequestType:kQueryUserStatus withUrlString:@"crhOpenAccStatusQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            //检查开户状态 恢复到相应的场景跳转
//            open_status状态位：证件照上传、基本资料提交、视频见证完成、协议已签署、账户设置、存管设置、暂未定义、风险问卷、回访设置、密码设置
//            标识位：常规：0：未处理，1：已处理
//            标识位：第3位视频见证完成：0：未见证、1：未定义、2：视频见证完成、3：见证失败
//            1101011111    1120011111
            
//            三方存管信息  0001100111     重新设置后0001111111
//            基本资料 1001111111
//            风险评测信息 0001111011 答题后进入结果页 1101011111
//            账户选择信息 0000011111
//            证件照采集 0001111111
//            其他 0001111111
//            公安验证 0001111111
//            用户中断 1101111111
            
//            视频驳回 2017.7.27
//            三方存管  0001100111
//            风险测评 1121111111
        
            if (!resultData || ![resultData isKindOfClass:[CRHUserStatusVo class]]) {
                return;
            }
            
            CRHUserStatusVo * vo = resultData;
            if (vo.risk_serial_no.length) {
                [RHOpenAccStoreData storeOpenAccCachUserInfo:vo.risk_serial_no withKey:kOpenAccountRiskTest];
            }
//            [CMProgress showWarningProgressWithTitle:nil message:vo.open_status warningImage:nil duration:5];

            NSString * status = vo.open_status;
            NSString * risk_eval_finished = vo.risk_eval_finished;
            if (status.length != 10) {
                return;
            }
            BOOL shouldContinue = NO;
            NSMutableArray * statusArr = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray * errorArr = [NSMutableArray array];
            for (int i = 0; i < status.length; i++) {
                NSString * str = [status substringWithRange:NSMakeRange(i, 1)];
                [statusArr addObject:str];
                if ([str integerValue] != 0 && [str integerValue] != 1 && i != 2) {
                    //异常
                    [errorArr addObject:[NSNumber numberWithInteger:i]];
                    continue;
                }
                else if([str integerValue] != 0 && [str integerValue] != 1 && [str integerValue] != 2 && i == 2){
                    [errorArr addObject:[NSNumber numberWithInteger:i]];
                    continue;
                }
                
                if ([str integerValue] == 0 && i != 2) {
                    shouldContinue = YES;
                }
                else if([str integerValue] != 2 && i == 2){
                    shouldContinue = YES;
                }
            }
            if (errorArr.count) {
                //跳审核结果页
                NSMutableString * reason;
                if (errorArr.count == 1) {
                    //只有一个错误原因的时候直接替换即可
                    reason = [NSMutableString stringWithString:[vo.resultComment stringByReplacingOccurrencesOfString:@"," withString:@""]];
                }
                else{
                    //多个原因的时候需要切割处理
                    NSArray * arr = [vo.resultComment componentsSeparatedByString:@","];
                    reason = [NSMutableString string];
                    for (NSString * str in arr) {
                        if (str.length > 1) {
                            if (reason.length < 8) {//复核未通过 :（长度7位）
                                [reason appendString:str];
                            }
                            else{
                                [reason appendFormat:@"，%@",str];
                            }
                        }
                    }
                }

                NSMutableDictionary * param = [NSMutableDictionary dictionary];
                [param setObject:@1 forKey:@"resultType"];
                [param setObject:errorArr forKey:@"errorArr"];
                if (reason.length) {
                    [param setObject:reason forKey:@"errorReason"];
                }
                [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHOpenAccResultController" withParam:param];
                return;
            }
            
            if ([risk_eval_finished integerValue] == 0) {
                shouldContinue = YES;
            }
            if (!shouldContinue) {
                //全部流程已进行 申请开户
                
                [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHOpenAccResultController" withParam:nil];
                return;
            }
            
            [statusArr exchangeObjectAtIndex:2 withObjectAtIndex:7];
            
            BOOL stop = NO;
            for (int i = 0; i < statusArr.count; i++) {
                if (stop) {
                    break;
                }
                NSString * str = statusArr[i];
                if ([str integerValue] == 1 && i != 7) {
                    continue;
                }
                else if ([str integerValue] == 2 && i == 7){
                    continue;
                }
//                open_status状态位：证件照上传、基本资料提交、风险问卷、协议已签署、账户设置、存管设置、暂未定义、视频见证完成、回访设置、密码设置

                switch (i) {
                    case 0:
//                    {
//                        if ([statusArr[3] integerValue] == 1) {
//                            //跳证件照上传
//                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHIDCardController" withParam:nil];
//                        }
//                        else if ([statusArr[3] integerValue] == 0){
                            //签署协议 跳转证件照
//                            [welf queryProtocolSign:nil];
//                        }
//                        stop = YES;
//                    }break;
                    case 1:{
//                        if ([statusArr[0] integerValue] == 1) {
                            //跳基本资料？还是跳身份证上传
                             [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHIDCardController" withParam:nil];
//                        }
                        stop = YES;
                    }break;
                    case 2:{
                        //风险测评
                        [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskEvaluationController" withParam:nil];
                        stop = YES;
                    }break;
                    case 3:
                    case 4:
                    case 9:
                    {
                        if ([risk_eval_finished integerValue] == 0) {
                            //跳风险结果页
                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskTestResultController" withParam:nil];

                            stop = YES;
                        }else{
                        //跳账户与密码
                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHAccountPasswordController" withParam:nil];
                            stop = YES;
                        }
                    }break;
                    case 5:{
                        //跳存管设置
                        [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHBankCardBindController" withParam:nil];
                        stop = YES;
                    }break;
//                        open_status状态位：证件照上传0、基本资料提交1、风险问卷2、协议已签署3、账户设置4、存管设置5、暂未定义6、视频见证完成7、回访设置8、密码设置9
                    case 7:{
                        if ([risk_eval_finished integerValue] == 0) {
                            //跳风险结果页
                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskTestResultController" withParam:nil];
                            
                            stop = YES;
                        
                        }else{
                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHReadyToRECController" withParam:nil];
                            stop = YES;
                        }
                    }break;
                    case 8:
                    {
                        //回访问卷
                        [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHQuestionRevisitController" withParam:nil];
                        stop = YES;
                    }break;
//                    case 9:{
                  
//                        if ([risk_eval_finished integerValue] == 0) {
//                            //风险结果页
//                            
//                            stop = YES;
//                        }
//                        else{
//                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHReadyToRECController" withParam:nil];
//                        stop = YES;
//                        }
//                    }
                    default:
                        break;
                }
            }
        }
    }];
}

- (void)checkNextEnabled{
    if (self.editEnabled && self.hasGetVerifyCode) {//self.editEnabled && self.isAgreed && self.hasGetVerifyCode
        self.nextStepBtn.enabled = YES;
//        self.proView.enable = YES;
        return;
    }
    self.nextStepBtn.enabled = NO;
//    self.proView.enable = NO;
}

#pragma mark ------交互
-(void)hideKeyboards {
    [self.verifyView.userNameTextField resignFirstResponder];
    [self.verifyView.verifyTextField resignFirstResponder];

}

#pragma mark ------显示支持的银行
- (void)showBankView{
    self.bankView.hidden = !self.bankView.hidden;
    [self.view setNeedsLayout];
}

- (void)showSetting{
    self.setView.hidden = !self.setView.hidden;
    
}

- (void)didSelectItemWith:(NSNumber *)index{
    NSLog(@"点击了跳转开户");
    switch ([index integerValue]) {
        case 0:
            //清理缓存
            [RHOpenAccStoreData clearOpenAccCachUserInfo];
            [CMProgress showWarningProgressWithTitle:nil message:@"清理干净啦" warningImage:nil duration:2];
            break;
        case 1:{
            //拨打客服
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"400-088-5558" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
//            [alertView show];
            NSString *number = @"4000885558";
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号

        }break;
            
        case 2:
            //跳开户问题
            [MNNavigationManager navigationToUniversalVC:self withClassName:@"MVOpenQuestionController" withParam:nil];
            break;
        default:
            break;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *number = @"4000885558";//
        //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number];
        //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
        //        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }
}


#pragma mark -------下一步
- (void)nextBtn{
    if (self.verifyView.userNameTextField.text.length != 11) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入正确的手机号" warningImage:img_progress_warning duration:kPopupWindowDurationInterval];

        return;
    }
    if (self.verifyView.verifyTextField.text.length != 4) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入正确的手机验证码" warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
        return;
    }
//    if (!self.isAgreed) {
//        [CMProgress showWarningProgressWithTitle:nil message:@"请同意《华创证券开户协议》" warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
//        return;
//    }
    
    [self checkRegisterUser];
    
}

//- (void)showProtocolBtn{
//    
//    [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAProtocolListController" withParam:self.protocolArr];
//    
//}


//- (void)queryProtocolSign:(id)sender {
//    
//    if (!self.protocolArr.count) {
//        return;
//    }
//
//    self.managerNum = 0;
//    [self.managerArr removeAllObjects];
//    for (int i = 0; i < self.protocolArr.count; i++) {
//        CRHProtocolListVo * vo = self.protocolArr[i];
//        OARequestManager * manager = [[OARequestManager alloc] init];
//        
//        __weak typeof (self) welf = self;
//        [manager requestProtocolSignWithCRHProtocolListVo:vo withCACertSn:@"NOSN" withRequestType:kProtocolSign withBusinessType:@"1"  withCompletion:^(BOOL success, id resultData) {
//            welf.managerNum++;
//            if (success) {
//                
//            }
//            else{
//                NSString * error = [NSString stringWithFormat:@"签署《%@》失败",vo.econtract_name];
//                [CMProgress showEndProgressWithTitle:nil message:error endImage:nil duration:2.0f];
//            }
//            if ([welf checkIfProtocolSignComplete]) {
//                [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHIDCardController" withParam:nil];
//            }
//            
//        }];
//        [welf.managerArr addObject:manager];
//    }
//    
//}
//
//- (BOOL)checkIfProtocolSignComplete{
//    if (self.managerNum == self.managerArr.count) {
//        return YES;
//    }
//    return NO;
//}

- (void)queryDicWithId:(NSString *)entry{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:entry forKey:@"dict_entry"];
    
    [self.oAManager sendCommonRequestWithParam:param withRequestType:kQueryDic withUrlString:@"crhQueryDataDic" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
        }
    }];
}

- (IBAction)queryDicBtn:(id)sender {
//    if (!self.queryDicNo.text.length) {
//        return;
//    }
//    [self queryDicWithId:self.queryDicNo.text];
//    
}
@end
