//
//  RHRiskTestResultController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/12.
//
//

#import "RHRiskTestResultController.h"
#import "OARequestManager.h"
#import "CRHRiskResultVo.h"
#import "CRHProtocolListVo.h"
#import "RiskLetterView.h"
#import "CRHClientInfoVo.h"
#import "InstrumentView.h"
#import "CRHRiskTestVo.h"
#import "RHRiskEvaluationController.h"
#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

@interface RHRiskTestResultController ()<UIScrollViewDelegate>
kRhPStrong UIScrollView * bgScrollView;
kRhPStrong RiskLetterView * riskLetterView;
kRhPStrong InstrumentView * instrumentView;
kRhPStrong UIButton * nextBtn;
kRhPStrong UIButton * againTestBtn;
kRhPStrong OARequestManager * riskTestManager;
kRhPStrong OARequestManager * riskNoticeManager;
kRhPStrong OARequestManager * setManager;
kRhPStrong CRHProtocolListVo * protocolVo;
kRhPStrong CRHClientInfoVo * clientInfoVo;
//试卷编号
kRhPCopy   NSString * local_paper_id;
//用户风险级别
kRhPCopy   NSString * riskLevel;

kRhPCopy NSString * client_id;

kRhPAssign BOOL needRectify;

@end

@implementation RHRiskTestResultController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"风险测评结果";
        [self initSubviews];
        
    }
    return self;
}
- (OARequestManager *)riskTestManager{
    if (!_riskTestManager) {
        _riskTestManager = [[OARequestManager alloc] init];
    }
    return _riskTestManager;
}

- (OARequestManager *)riskNoticeManager{
    if (!_riskNoticeManager) {
        _riskNoticeManager = [[OARequestManager alloc] init];
    }
    return _riskNoticeManager;
}
- (OARequestManager *)setManager{
    if (!_setManager) {
        _setManager = [[OARequestManager alloc] init];
    }
    return _setManager;
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

@synthesize universalParam = _universalParam;
- (void)setUniversalParam:(id)universalParam{
    if (!universalParam) {
        return;
    }
    _universalParam = universalParam;
    if ([universalParam isKindOfClass:[NSString class]]) {
        self.local_paper_id = _universalParam;
    }
    else if ([universalParam isKindOfClass:[NSDictionary class]]){
        NSDictionary * dic = _universalParam;
        if ([dic objectForKey:@"local_paper_id"]) {
            self.local_paper_id = [dic objectForKey:@"local_paper_id"];
        }
        if ([dic objectForKey:kOpenAccountRectify]) {
            self.needRectify = [[dic objectForKey:kOpenAccountRectify] boolValue];
        }
    
    }
}

-(void)initSubviews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.backgroundColor = color1_text_xgw;
    self.bgScrollView.delegate = self;
    [self.view addSubview:self.bgScrollView];
    
    self.instrumentView = [[InstrumentView alloc]init];
    self.instrumentView.frame = CGRectMake(0, 40, kDeviceWidth, 230);

    [self.bgScrollView addSubview:self.instrumentView];
    [self initInstrumentView];
    
    self.riskLetterView = [[RiskLetterView alloc]init];
    [self.bgScrollView addSubview:self.riskLetterView];
    
    self.nextBtn = [[UIButton alloc]init];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setBackgroundColor:color6_text_xgw];
    self.nextBtn.titleLabel.font = font3_common_xgw;
    self.nextBtn.layer.cornerRadius = 3;
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    self.againTestBtn = [[UIButton alloc]init];
    [self.againTestBtn setTitle:@"重新测评" forState:UIControlStateNormal];
    [self.againTestBtn setTitleColor:color6_text_xgw forState:UIControlStateNormal];
    self.againTestBtn.layer.borderWidth = 1;
    self.againTestBtn.layer.cornerRadius =3;
    self.againTestBtn.layer.borderColor =color6_text_xgw.CGColor;
    self.againTestBtn.titleLabel.font = font3_common_xgw;
    [self.againTestBtn addTarget:self action:@selector(againTestBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.againTestBtn];
    
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.nextBtn.frame = CGRectMake(24, self.view.height - 14.0f - 44, kDeviceWidth-2*24, 44);
    self.againTestBtn.frame = CGRectMake(24, CGRectGetMinY(self.nextBtn.frame)-10-44, kDeviceWidth-2*24, 44);
    self.bgScrollView.frame = CGRectMake(0, self.layoutStartY, kDeviceWidth,kDeviceHeight-self.layoutStartY-14-10-14-self.nextBtn.size.height-self.againTestBtn.size.height);
    
    self.riskLetterView.frame = CGRectMake(24, CGRectGetMaxY(self.instrumentView.frame), kDeviceWidth-48, [self.riskLetterView getCurrentHeight]);
    
    self.bgScrollView.contentSize = CGSizeMake(kDeviceWidth, self.riskLetterView.frame.size.height +self.instrumentView.size.height+40);
}
#pragma 初始化仪表视图
-(void)initInstrumentView{
    //弧线
    [self.instrumentView drawArcWithStartAngle:-M_PI*4.5/4 endAngle:M_PI/8 lineWidth:8.0f fillColor:[UIColor clearColor] strokeColor:color16_other_xgw];
    
    //刻度
    [self.instrumentView drawScaleWithDivide:50 andRemainder:5 strokeColor:color16_other_xgw filleColor:[UIColor clearColor]scaleLineNormalWidth:5 scaleLineBigWidth:5];
    
    // 进度的曲线
    [self.instrumentView drawProgressCicrleWithfillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor]];
   // [self.instrumentView setColorGrad:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:2.0/255 green:186.0/255 blue:197.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:44.0/255 green:203.0/255 blue:112.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:254.0/255 green:136.0/255 blue:5.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:247.0/255 green:21.0/255 blue:47.0/255 alpha:1.0] CGColor],nil]];
    
     [self.instrumentView setColorGrad:[NSArray arrayWithObjects:(id)[UIColor colorWithRXHexString:@"0xfd605d"].CGColor,(id)[UIColor colorWithRXHexString:@"0xcd1a50"].CGColor,nil]];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**判断是否请求过网络 如果是从下一界面返回则不需要请求*/
    if ([NSString isBlankString:self.riskLevel]) {
        [self requestClientInfo];
        // [self requestRiskTestQuery];
        [self requestToGetRiskNoticeLetter];
    }

}
#pragma mark--查询客户信息
- (void)requestClientInfo{
    [self.setManager requestQueryClientInfoWithComoletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHClientInfoVo class]]) {
                return;
            }
            self.clientInfoVo = resultData;
            //self.riskLetterView.viewData = self.clientInfoVo;
            [self requestRiskTestQuery];

        }else{
            [self requestRiskTestQuery];

        }
    }];
    
}

#pragma mark 风险测评结果查询 
- (void)requestRiskTestQuery{
   
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
  
    
    [param setObject:self.client_id forKey:@"client_id"];
    //[param setObject:self.local_paper_id forKey:@"local_paper_id"];
    [self requestWithParam:param withUrl:@"crhRiskTestQuery" withRequestType:kRiskTestQuery withRequestManager:self.riskTestManager];
    
   
}
#pragma mark 获取风险公告函
- (void)requestToGetRiskNoticeLetter{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@10084 forKey:@"biz_id"];
    
    __weak typeof(self) welf = self;
    [self.riskNoticeManager requestProtocolListWithParam:param withRequestType:kProtocolList withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                return;
            }
            for (NSDictionary * resultDic in resultData) {
                CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:resultDic];
                welf.protocolVo = vo;
               // [welf requestProtocolContent];
                
            }
        }
        else{
            [CMProgress showEndProgressWithTitle:@"获取风险公告函id失败" message:nil endImage:nil duration:1];
        }
    }];
}

//- (void)requestProtocolContent{
//    if (!self.protocolVo) {
//        return;
//    }
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObject:self.protocolVo.econtract_id forKey:@"econtract_id"];
//    
//    [self.riskNoticeManager requestProtocolContentWithParam:param withRequestType:kProtocolContent withCompletion:^(BOOL success, id resultData) {
//        if (success) {
//            if (!resultData || ![resultData isKindOfClass:[CRHProtocolListVo class]]) {
//                return;
//            }
//            //vo.econtract_content即协议内容
//            CRHProtocolListVo * vo = resultData;
//        }
//    }];
//}
#pragma mark 签署风险公告函
- (void)requestToSignRiskNoticeLetter{
    [self.riskNoticeManager requestProtocolSignWithCRHProtocolListVo:self.protocolVo withCACertSn:@"NOSN" withRequestType:kProtocolSign withBusinessType:@"10084"  withCompletion:^(BOOL success, id resultData) {
        if (success) {
//            [CMProgress showWarningProgressWithTitle:nil message:@"签署成功" warningImage:nil duration:1];
                [self requestConfirm];
           
        }else{
           // [CMProgress showWarningProgressWithTitle:nil message:@"签署失败" warningImage:nil duration:1];
        }
    }];
}
#pragma mark 风险测评结果确认
- (void)requestConfirm{
       if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    
    [self requestWithParam:param withUrl:@"crhRiskResultConfirm" withRequestType:kRiskResultConfirm withRequestManager:self.riskTestManager];
}



#pragma mark ------统一数据处理回调
- (void)requestWithParam:(id)param withUrl:(NSString *)urlString withRequestType:(CRHRequestType)type withRequestManager:(OARequestManager *)manager{
    
    __weak typeof(self) welf = self;
    
    [manager sendCommonRequestWithParam:param withRequestType:type withUrlString:urlString withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData) {
                return;
            }
            
            switch (type) {
                    
                case kRiskTestPaper :{
                    //此处获取试卷编号 当不是从风险测评页过来的
                    if ([resultData isKindOfClass:[NSArray class]]) {
                        NSArray * arr = resultData;
                        if (arr.count) {
                            CRHRiskTestVo * vo = arr[0];
                            welf.local_paper_id = vo.local_paper_id;
                            //[self requestRiskTestQuery];
                            
                        }
                    }
                    
                }break;
                    
                case kRiskTestQuery :
                    if ([resultData isKindOfClass:[CRHRiskResultVo class]]) {
                        CRHRiskResultVo * vo = resultData;
                        self.riskLevel = vo.corp_risk_level;
                        [self.riskLetterView setViewDataWithClientVo:self.clientInfoVo RiskResultVo:vo];
                        self.instrumentView.viewData = vo;
                       // [CMProgress showWarningProgressWithTitle:nil message:@"风险测评结果查询成功" warningImage:nil duration:1];
                        [self.view setNeedsLayout];

                    }

                    break;
   
                case kRiskResultConfirm :
                    
                    if (self.needRectify) {

//                        NSArray * arr = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRectify];
//                        if (arr.count) {
//                            NSString * class = @"";
//                            if ([arr containsObject:@4] || [arr containsObject:@9]){
//                                class = @"RHAccountPasswordController";
//                            }
//                            else if ([arr containsObject:@5]){
//                                class = @"RHBankCardBindController";
//                            }
//                            else if ([arr containsObject:@2]){
//                                class = @"RHReadyToRECController";
//                            }
//                            else if ([arr containsObject:@8]){
//                                class = @"RHQuestionRevisitController";
//                            }
//                            else{
//                                [RHOpenAccStoreData clearOpenAccCachWithKey:kOpenAccountRectify];
//                                class = @"RHOpenAccResultController";
//                            }
//                            if (class.length) {
                                NSMutableDictionary * param = [NSMutableDictionary dictionary];
                                [param setObject:@1 forKey:kOpenAccountRectify];
//                                [MNNavigationManager navigationToUniversalVC:self withClassName:class withParam:param];
                        [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHAccountPasswordController" withParam:param];

                                return;
//                            }
//                        }
                    }
                    
                     [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHAccountPasswordController" withParam:nil];
//                    [CMProgress showWarningProgressWithTitle:nil message:@"风险结果确认成功" warningImage:nil duration:1];
                    
                    break;
                default:
                    break;
            }
        }
        else{
            
            [CMProgress showWarningProgressWithTitle:nil message:@"网络请求失败" warningImage:nil duration:1];
        }

    }];
}

#pragma mark--点击下一步
-(void)nextClick:(UIButton *)btn{
    
    if ([self.riskLevel isEqualToString:@"0"]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"如您确认为是最低风险等级，将不允许开户." warningImage:nil duration:3];
        return;
    }
    
    self.nextBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nextBtn.enabled = YES;
    });
    
    [self requestToSignRiskNoticeLetter];
}

#pragma mark--重新测评
-(void)againTestBtnClick:(UIButton *)btn{
    
 
    for (BaseViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:NSClassFromString(@"RHRiskEvaluationController")]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
    }
    if (self.needRectify) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:@1 forKey:kOpenAccountRectify];
        [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskEvaluationController" withParam:param];
        return;

    }
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskEvaluationController" withParam:nil];
   
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if([scrollView isEqual:self.bgScrollView]){
        
    self.bgScrollView.contentSize = CGSizeMake(kDeviceWidth, [self.riskLetterView getCurrentHeight] +self.instrumentView.size.height+40);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
