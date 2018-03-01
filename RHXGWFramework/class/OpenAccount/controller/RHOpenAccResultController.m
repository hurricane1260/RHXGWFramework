
//
//  RHOpenAccResultController.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/7.
//
//

#import "RHOpenAccResultController.h"
#import "OARequestManager.h"
#import "CRHOpenAccResultVo.h"
#import "CRHClientInfoVo.h"

#import "ApplyFinishView.h"
#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

@interface RHOpenAccResultController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

kRhPStrong OARequestManager * requestManager;

kRhPStrong OARequestManager * queryManager;

kRhPStrong OARequestManager * setManager;

kRhPStrong UIScrollView * bottomScrollow;

kRhPStrong ApplyFinishView * applyStateView;

kRhPStrong UIButton * stepBtn;

kRhPAssign TagType resultType;

kRhPStrong NSArray * errorArr;

kRhPCopy NSString * errorReason;

kRhPCopy NSString * client_id;

kRhPStrong NSArray * dataArr;

kRhPCopy NSString * userName;
@end

@implementation RHOpenAccResultController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"新开户";
        self.view.backgroundColor = color1_text_xgw;
        self.backButtonHidden = YES;
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    //重复提交审核 防止没有提交审核的情况
    [self requestClientInfo];
    [self applyOpenAcc];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam || ![universalParam isKindOfClass:[NSDictionary class]]) {
        return;
    }

    NSDictionary * param = universalParam;
    if ([param objectForKey:@"resultType"]) {
        self.resultType = [[param objectForKey:@"resultType"] integerValue];
    }
    if ([param objectForKey:@"errorArr"]) {
        self.errorArr = [param objectForKey:@"errorArr"];
    }
    if ([param objectForKey:@"errorReason"]) {
        self.errorReason = [param objectForKey:@"errorReason"];
    }
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (void)initSubviews{
    __weak typeof(self) welf = self;
    
    self.bottomScrollow = [[UIScrollView alloc] init];
    [self.view addSubview:self.bottomScrollow];
    
    switch (self.resultType) {
        case applyingType:
            self.applyStateView = [[ApplyFinishView alloc] initWithType:self.resultType withData:nil];

            break;
        case failType:
            self.applyStateView = [[ApplyFinishView alloc] initWithType:self.resultType withData:self.errorArr];
            self.applyStateView.errorReason = self.errorReason;
            break;
            
        case successType:
            self.applyStateView = [[ApplyFinishView alloc] initWithType:self.resultType withData:self.dataArr];
            break;
        default:
            break;
    }
    self.applyStateView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.applyStateView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    
    [self.bottomScrollow addSubview:self.applyStateView];
    
    self.stepBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@""];
    [self.stepBtn addTarget:self action:@selector(stepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stepBtn];
    
    switch (self.resultType) {
        case applyingType:
            [self.stepBtn setTitle:@"退出" forState:UIControlStateNormal];
            break;
        case failType:
            [self.stepBtn setTitle:@"继续开户" forState:UIControlStateNormal];
            break;
        case successType:
            [self.stepBtn setTitle:@"去交易" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    [self.view addAutoLineWithColor:color16_other_xgw];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bottomScrollow.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY - self.stepBtn.height - 48.0f);
    
    self.applyStateView.frame = CGRectMake(0, 0, self.view.width, self.applyStateView.height);
    
    self.stepBtn.frame = CGRectMake((self.view.width - self.stepBtn.width)/2.0f, self.view.height - 14.0f - self.stepBtn.height, self.stepBtn.width, self.stepBtn.height);
    
    self.view.autoLine.frame = CGRectMake(0, self.stepBtn.y - 14.0f, self.view.width, 0.5f);
    
    self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, CGRectGetMaxY(self.applyStateView.frame));
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self.requestManager cancelAllDelegate];
    [self.queryManager cancelAllDelegate];
}

- (OARequestManager *)requestManager{
    if (!_requestManager) {
        _requestManager = [[OARequestManager alloc] init];
    }
    return _requestManager;
}

- (OARequestManager *)queryManager{
    if (!_queryManager) {
        _queryManager = [[OARequestManager alloc] init];
    }
    return _queryManager;
}

-(OARequestManager *)setManager{
    if (!_setManager) {
        _setManager = [[OARequestManager alloc] init];
    }
    return _setManager;
}

- (void)requestClientInfo{
    __weak typeof(self) welf = self;

    [self.setManager requestQueryClientInfoWithComoletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHClientInfoVo class]]) {
                return;
            }
            CRHClientInfoVo * vo = resultData;
            welf.userName = vo.client_name;
        }
    }];
    
}

- (void)applyOpenAcc{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    __weak typeof(self) welf = self;

    [self.requestManager sendCommonRequestWithParam:param withRequestType:kOpenAccApply withUrlString:@"crhOpenAccApply" withCompletion:^(BOOL success, id resultData) {
        if (success) {

        }
        else{

        }
        
        if (welf.resultType != failType) {
            [welf queryOpenAccResult];
            
        }
        else{
            [welf initSubviews];
            [welf.view setNeedsLayout];
        }
    }];
}


- (void)queryOpenAccResult{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    __weak typeof(self) welf = self;

    [self.queryManager sendCommonRequestWithParam:param withRequestType:kOpenResultQuery withUrlString:@"crhOpenAccResultQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHOpenAccResultVo class]]) {
                //默认
                return;
            }
            CRHOpenAccResultVo * vo = resultData;
            CRHAccVo * fund = vo.fund_account;
            CRHAccVo * bank = vo.bank_account[0];
            CRHAccVo * stockShang = vo.stock_account[0];
            CRHAccVo * stockShen = vo.stock_account[1];
            NSInteger fundStatus = [fund.open_status integerValue];
            NSInteger bankStatus = [bank.open_status integerValue];
            NSInteger stockShangStatus = [stockShang.open_status integerValue];
            NSInteger stockShenStatus = [stockShen.open_status integerValue];
            if (fundStatus == 0 || bankStatus == 0 || stockShangStatus == 0 || stockShenStatus == 0) {
//                //正在审核
                welf.resultType = applyingType;
            }
            else if (fundStatus == 1 && fund.fund_account.length && bankStatus == 1 && stockShangStatus == 1 && stockShang.stock_account.length && stockShenStatus == 1 && stockShen.stock_account.length){
                //开户成功
                welf.resultType = successType;
                NSMutableArray * arr = [NSMutableArray array];
                CRHAccVo * vo = [[CRHAccVo alloc] init];
                vo.title = @"客户姓名";
                vo.subTitle = welf.userName;
                fund.title = @"资金账号";
                fund.subTitle = fund.fund_account;
                bank.title = @"三方存管";
                bank.subTitle = bank.bank_name;
                stockShang.title = stockShang.account_name;
                stockShang.subTitle = stockShang.stock_account;
                stockShen.title = stockShen.account_name;
                stockShen.subTitle = stockShen.stock_account;
                [arr addObject:vo];
                [arr addObject:fund];
                [arr addObject:stockShang];
                [arr addObject:stockShen];
                [arr addObject:bank];
                welf.dataArr = arr;
            
            }
            else if (fundStatus == 2 || fundStatus == 3){
                welf.resultType = failType;
                
            }
            [welf initSubviews];
            [welf.view setNeedsLayout];
        }
        else{
            NSLog(@"");
        }
    }];
}

- (void)stepBtnClick:(id)sender {
    self.stepBtn.enabled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.stepBtn.enabled = NO;
    });
    
    switch (self.resultType) {
        case successType:
            [self.navigationController popToRootViewControllerAnimated:NO];
            
            break;
        case failType:{
            //跳转相应问题页面
            if (self.errorArr && self.errorArr.count) {
//                open_status状态位：证件照上传、基本资料提交、视频见证完成、协议已签署、账户设置、存管设置、暂未定义、风险问卷、回访设置、密码设置
                NSString * class = @"";
                if ([self.errorArr containsObject:@0 ]) {
                    class = @"RHIDCardController";
                }
                else if ([self.errorArr containsObject:@1]){
                    class = @"OAPersonalInfoConfirmController";
                }
                else if ([self.errorArr containsObject:@7]){
                    class = @"RHRiskEvaluationController";
                }
                else if ([self.errorArr containsObject:@4] || [self.errorArr containsObject:@9]){
                    class = @"RHAccountPasswordController";
                }
                else if ([self.errorArr containsObject:@5]){
                    class = @"RHBankCardBindController";
                }
                else if ([self.errorArr containsObject:@2]){
                    class = @"RHReadyToRECController";
                }
                else if ([self.errorArr containsObject:@8]){
                    class = @"RHQuestionRevisitController";
                }
                
                if (class.length) {
                    [RHOpenAccStoreData storeOpenAccCachUserInfo:self.errorArr withKey:kOpenAccountRectify];
                    NSMutableDictionary * param = [NSMutableDictionary dictionary];
                    [param setObject:@1 forKey:kOpenAccountRectify];
                    [MNNavigationManager navigationToUniversalVC:self withClassName:class withParam:param];
                    return;
                }
            }
        }break;
            
        case applyingType:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

@end
