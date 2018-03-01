//
//  RHRiskEvaluationController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/15.
//
//

#import "RHRiskEvaluationController.h"
#import "OARequestManager.h"

#import "RHCustomTableView.h"
#import "RiskTableViewDataSource.h"
#import "RiskTestHeaderView.h"

#import "RHOpenAccStoreData.h"

#import "CRHRiskTestVo.h"
#import "CRHRiskQueryVo.h"
#import "CRHRiskResultVo.h"
#import "CRHProtocolListVo.h"
#import "CRHClientInfoVo.h"

#import "MNNavigationManager.h"

@interface RHRiskEvaluationController ()


kRhPStrong OARequestManager * riskTestManager;
kRhPStrong OARequestManager * returnVisitManager;
kRhPStrong OARequestManager * riskNoticeManager;
kRhPStrong OARequestManager * questTestResultManager;
kRhPStrong OARequestManager * setManager;
kRhPStrong OARequestManager * oAManager;
kRhPStrong NSMutableArray * riskTestArr;
kRhPStrong NSMutableArray * returnVisitArr;
kRhPStrong UIScrollView * bgScrollView;
kRhPStrong UITableView *  riskTableView;
kRhPStrong RiskTableViewDataSource * riseTableDataSouse;
kRhPStrong UIButton * nextBtn;
kRhPStrong UIView * lineView;
/**储存用户答案的字典*/
kRhPStrong NSMutableDictionary * riskTestResultDic;
kRhPCopy NSString * local_paper_id;
kRhPCopy NSMutableArray * educationArray;
kRhPCopy NSMutableArray * educationInitArray;
/**客户的学历*/
kRhPCopy NSString * userEducation;
/**客户的年龄*/
kRhPCopy NSString * userAge;


/**是否从上一页跳转过来*/
kRhPAssign BOOL isPreviousPage;

kRhPStrong CRHProtocolListVo * protocolVo;

kRhPCopy NSString * client_id;
kRhPStrong CRHClientInfoVo * clientInfoVo;

kRhPAssign BOOL needRectify;

@end

@implementation RHRiskEvaluationController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"风险测评";
        self.riskTestArr = [NSMutableArray array];
        self.returnVisitArr = [NSMutableArray array];
        self.educationArray = [NSMutableArray array];
        self.needRectify = NO;

        [self initData];
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

- (OARequestManager *)returnVisitManager{
    if (!_returnVisitManager) {
        _returnVisitManager = [[OARequestManager alloc] init];
    }
    return _returnVisitManager;
}
-(OARequestManager  *)questTestResultManager{
    if (!_questTestResultManager) {
        _questTestResultManager = [[OARequestManager alloc] init];
    }
    return _questTestResultManager;
}
-(RiskTableViewDataSource *)riseTableDataSouse{
    if (!_riseTableDataSouse) {
        _riseTableDataSouse = [[RiskTableViewDataSource alloc]init];
    }
    
    return _riseTableDataSouse;
}
- (OARequestManager *)riskNoticeManager{
    if (!_riskNoticeManager) {
        _riskNoticeManager = [[OARequestManager alloc] init];
    }
    return _riskNoticeManager;
}
-(OARequestManager *)setManager{
    if (!_setManager) {
        _setManager = [[OARequestManager alloc] init];
    }
    return _setManager;
}
-(OARequestManager *)oAManager{
    if (!_oAManager) {
        _oAManager = [[OARequestManager alloc] init];
    }
    return _oAManager;
}


@synthesize universalParam = _universalParam;
- (void)setUniversalParam:(id)universalParam{
    if (!universalParam) {
        self.isPreviousPage = NO;
        return;
    }
    
    if ([universalParam isKindOfClass:[NSNumber class]]) {
        NSNumber * num = universalParam;
        self.isPreviousPage = [num boolValue];

    }
    
    if ([universalParam isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = universalParam;
        if ([dic objectForKey:@"hiddenBack"]) {
            self.backButtonHidden = [[dic objectForKey:@"hiddenBack"] boolValue];
        }
        if ([dic objectForKey:@"hasPrePage"]) {
            self.isPreviousPage = [[dic objectForKey:@"hasPrePage"] boolValue];
        }
        if ([dic objectForKey:kOpenAccountRectify]) {
            self.needRectify = [[dic objectForKey:kOpenAccountRectify] boolValue];
        }
    }
    
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (void)initSubviews{
    __weak typeof (self) welf = self;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.backgroundColor = color1_text_xgw;
    [self.view addSubview:self.bgScrollView];
    
    
    
    self.riskTableView = [[UITableView alloc]init];
    self.riskTableView.delegate = self.riseTableDataSouse;
    self.riskTableView.dataSource = self.riseTableDataSouse;
    self.riskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.riskTableView.scrollEnabled = NO;
    self.riskTableView.estimatedRowHeight = 0;
    self.riskTableView.estimatedSectionHeaderHeight = 0;
    self.riskTableView.estimatedSectionFooterHeight = 0;
    [self.bgScrollView addSubview:self.riskTableView];
    
    self.riseTableDataSouse.riskTestNextBlock = ^(NSDictionary *params) {
        
    //下一步按钮的状态
     if (params.count!=0&&self.riskTestArr.count!=0) {
         welf.riskTestResultDic = [NSMutableDictionary dictionaryWithDictionary:params];

            if (params.count==self.riskTestArr.count) {
                welf.nextBtn.enabled = YES;
            }else{
                
                welf.nextBtn.enabled = NO;

            }
        }
        
    };
    
    
    self.riseTableDataSouse.automaticSubjectJump = ^(NSString *subjectIndex,NSString * type) {
        
        if (welf.riseTableDataSouse.cellHeightDic.count==0) {
            return ;
        }
        
        NSInteger index = [subjectIndex integerValue];
        NSInteger cellH = 0;
        while (index>=0) {
           NSString * cellHStr = [welf.riseTableDataSouse.cellHeightDic objectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
            
            cellH += [cellHStr integerValue];
            
            index--;
        }
        
        //只滚动单选题
        if ([type isEqualToString:@"0"]) {
            [welf.bgScrollView setContentOffset:CGPointMake(0, cellH) animated:YES];
        }
        
    };
    
    //修改年龄和学历的弹窗
    self.riseTableDataSouse.warnBlock = ^(ChooseType type) {
        [welf warnRemarkWithType:type];
    };
    
    [self.view addAutoLineWithColor:color16_other_xgw];
    
    self.nextBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    self.nextBtn.enabled = NO;
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];


}
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.bgScrollView.frame = CGRectMake(0, self.layoutStartY, kDeviceWidth,kDeviceHeight-self.layoutStartY-self.nextBtn.height-28);
    
    self.riskTableView.frame = CGRectMake(0, 10, kDeviceWidth, self.riskTableView.contentSize.height);
 
     
    self.nextBtn.frame = CGRectMake(24, self.view.height - 14.0f - 44, kDeviceWidth-2*24, 44);

    
     self.view.autoLine.frame = CGRectMake(0, CGRectGetMinY(self.nextBtn.frame)-14, self.view.width, 0.5f);
    self.bgScrollView.contentSize = CGSizeMake(kDeviceWidth, self.riskTableView.contentSize.height+10);
    
   

}
-(void)backButtonTouchHandler:(id)sender{
    [super backButtonTouchHandler:sender];
//    NSLog(@"%@",self.riskTestResultDic);

    //存储用户没有提交的答案
    if (self.riskTestResultDic==nil||self.riskTestResultDic.count==0) {
        return;
    }
    [RHOpenAccStoreData storeOpenAccCachUserInfo:self.riskTestResultDic withKey:kOpenAccountRiskAnswer];

    
}
#pragma mrak--初始化学历对应的学历代码
-(void)initData{
     NSArray * array = @[@{@"subentry":@"1",@"dict_prompt":@"博士"},@{@"subentry":@"2",@"dict_prompt":@"硕士"},@{@"subentry":@"3",@"dict_prompt":@"本科"},@{@"subentry":@"4",@"dict_prompt":@"大专"},@{@"subentry":@"5",@"dict_prompt":@"中专"},@{@"subentry":@"6",@"dict_prompt":@"高中"},@{@"subentry":@"7",@"dict_prompt":@"初中以下"},@{@"subentry":@"8",@"dict_prompt":@"其他"}];
    self.educationInitArray = [NSMutableArray arrayWithArray:array];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
        if (self.riskTestArr.count==0) {
            
            [self requestRiskTestPaper];
            [self queryDicWithId:@"1014"];
        }
   
}

#pragma mark -----------数据请求
#pragma mark 获取风险测评试卷
- (void)requestRiskTestPaper{
    [self.riskTestArr removeAllObjects];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@1 forKey:@"exam_type"];
    [param setObject:@1 forKey:@"paper_type"];
    [self requestWithParam:param withUrl:@"crhRiskTestPaper" withRequestType:kRiskTestPaper withRequestManager:self.riskTestManager];
}

#pragma mark 风险测评提交 （提交后会返回测评结果）
//- (void)requestRiskTestCommit{
//    if (!self.client_id.length) {
//        return;
//    }
//    
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObject:self.client_id forKey:@"client_id"];
//    
////    ps：参数格式 (形如："1&1^4|2&3|"，1号题的答案是1和4，2号题的答案是3，最后一位也需要分隔符"|")
//    NSString * answer = @"10001&1|10002&1|10003&1|10005&1|10006&1|10007&1|10010&1|10011&1|10012&1|10013&1|10015&1|10009&1|10017&1|400004&1|10019&1|10020&1|400007&1|400008&1|400009&1|400010&1|";
//    if (_riskAnswer.text.length) {
//        answer = _riskAnswer.text;
//    }
////    NSString * aString = [answer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [param setObject:answer forKey:@"paper_answer"];
//    [param setObject:@1 forKey:@"paper_type"];
//    [self requestWithParam:param withUrl:@"crhRiskTestCommit" withRequestType:kRiskTestCommit withRequestManager:self.riskTestManager];
//
//}

#pragma mark 风险测评结果查询 （因上个接口提交后会返回结果，此接口暂时不用）
- (void)requestRiskTestQuery{
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:self.local_paper_id forKey:@"local_paper_id"];
    
    [self requestWithParam:param withUrl:@"crhRiskTestQuery" withRequestType:kRiskTestQuery withRequestManager:self.questTestResultManager];
    
}


#pragma mark 获取回访问卷
- (void)requestReturnVisitPaper{
    [self.returnVisitArr removeAllObjects];
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    
    [self requestWithParam:param withUrl:@"crhReturnVisitPaper" withRequestType:kReturnVisitPaper withRequestManager:self.returnVisitManager];

}

#pragma mark 回访问卷提交
//- (void)requestReturnVisitCommit{
//    if (!self.client_id.length) {
//        return;
//    }
//    
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObject:self.client_id forKey:@"client_id"];
////    ps:参数格式同风险测评提交参数格式
//    NSString * answer = @"1&1|2&1|3&1|4&1|5&1|6&2|";
//    if (_revisitAnswer.text.length) {
//        answer = _revisitAnswer.text;
//    }
//    [param setObject:answer forKey:@"paper_answer"];
//    
//    [self requestWithParam:param withUrl:@"crhReturnVisitCommit" withRequestType:kReturnVisitCommit withRequestManager:self.returnVisitManager];
//
//}

#pragma mark 风险测评结果确认
- (void)requestConfirm{
      if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    
    [self requestWithParam:param withUrl:@"crhRiskResultConfirm" withRequestType:kRiskResultConfirm withRequestManager:self.riskTestManager];
}

#pragma mark 保存风险测用户特殊情况（暂时需求不用）
- (void)requestSaveSpecial{
   
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:self.client_id forKey:@"specific_factor"];

    [self requestWithParam:param withUrl:@"crhRiskResultConfirm" withRequestType:kRiskSpecialResultSave withRequestManager:self.riskTestManager];
}

#pragma mark 适当性匹配检查
- (void)requestMatchCheck{

    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@"100017" forKey:@"prod_code"];
    [param setObject:self.client_id forKey:@"client_id"];

    [self requestWithParam:param withUrl:@"crhRiskMatchCheck" withRequestType:kRiskMatchCheck withRequestManager:self.riskTestManager];
}

#pragma mark 获取风险公告函id
- (void)requestToGetRiskNoticeLetter{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@10084 forKey:@"biz_id"];
    
    __weak typeof(self) welf = self;
    [self.riskTestManager requestProtocolListWithParam:param withRequestType:kProtocolList withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                return;
            }
            for (NSDictionary * resultDic in resultData) {
                CRHProtocolListVo * vo = [CRHProtocolListVo generateWithDict:resultDic];
                welf.protocolVo = vo;
                [welf requestProtocolContent];

            }
        }
        else{
            [CMProgress showEndProgressWithTitle:@"获取风险公告函id失败" message:nil endImage:nil duration:1];
        }
    }];
}

#pragma mark 获取风险公告函内容
- (void)requestProtocolContent{
    if (!self.protocolVo) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.protocolVo.econtract_id forKey:@"econtract_id"];
    
    [self.riskNoticeManager requestProtocolContentWithParam:param withRequestType:kProtocolContent withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHProtocolListVo class]]) {
                return;
            }
            //vo.econtract_content即协议内容
            //CRHProtocolListVo * vo = resultData;
        }
    }];
}

#pragma mark 签署风险公告函
- (void)requestToSignRiskNoticeLetter{
    [self.riskNoticeManager requestProtocolSignWithCRHProtocolListVo:self.protocolVo withCACertSn:@"NOSN" withRequestType:kProtocolSign withBusinessType:@"10084"  withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
        }
    }];

}
#pragma 学历对应的学历代码请求
- (void)queryDicWithId:(NSString *)entry{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:entry forKey:@"dict_entry"];
    
    [self.oAManager sendCommonRequestWithParam:param withRequestType:kQueryDic withUrlString:@"crhQueryDataDic" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            if (resultData ==nil) {
                self.educationArray = self.educationInitArray;
            }else{
                self.educationArray = resultData;
            }
            
        }else{
            
            self.educationArray = self.educationInitArray;
        }
    }];
}
#pragma mark--查询客户信息
- (void)requestClientInfo{
    [self.setManager requestQueryClientInfoWithComoletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHClientInfoVo class]]) {
                return;
            }
            self.clientInfoVo = resultData;
            
            if (self.educationArray.count==0) {
                self.educationArray = self.educationInitArray;
            }
            for (NSDictionary * dic  in self.educationArray) {
                if ([self.clientInfoVo.degree_code intValue] == [dic[@"subentry"] intValue]) {
                    self.userEducation = dic[@"dict_prompt"];
                }
            }
            self.userAge = [self userAge:[NSString stringWithFormat:@"%@",self.clientInfoVo.birthday]];
            NSString * education ;
            NSString * age ;

            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            if ([self.userEducation isEqualToString:@"博士"]||[self.userEducation isEqualToString:@"硕士"]) {
                education = @"4";
            }else if ([self.userEducation isEqualToString:@"本科"]){
                education = @"3";

            }else if ([self.userEducation isEqualToString:@"专科"]){
                education = @"2";
                
            }else {
                education = @"1";
            }
         int uAge =[self.userAge intValue];
            if (uAge > 60) {
                age = @"5";
            }else if (50<uAge && uAge<=60){
                age = @"4";
            }else if (40<uAge && uAge<=50){
                age = @"3";
            }else if (30<uAge && uAge<=40){
                age = @"2";
            }else if (18<=uAge && uAge<=30){
                age = @"1";
            }
            
            for (CRHRiskTestVo * riskTestVO in self.riskTestArr) {
                
                if ([riskTestVO.question_content rangeOfString:@"您的年龄是"].location!= NSNotFound ){
                    [params setValue:[NSArray arrayWithObject:age] forKey:riskTestVO.question_no];
                    
                }else if ([riskTestVO.question_content rangeOfString:@"您的最高学历是"].location!= NSNotFound){
                    [params setValue:[NSArray arrayWithObject:education] forKey:riskTestVO.question_no];
                    
                }
            }
            //             [params setValue:[NSArray arrayWithObject:age] forKey:@"10017"];
            //            [params setValue:[NSArray arrayWithObject:education] forKey:@"10019"];
            
            self.riseTableDataSouse.paperType = ageAndEducationType;
            self.riseTableDataSouse.ageEducationDic = params;
            [self.riskTableView reloadData];
            [self.view setNeedsLayout];
            
        }else{
            
        }
    }];
    
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
                    //风险测评试卷获取成功
                    if ([resultData isKindOfClass:[NSArray class]]) {
                        NSArray * arr = resultData;
                        if (arr.count) {
                            CRHRiskTestVo * vo = arr[0];
                            welf.local_paper_id = vo.local_paper_id;
                        }

                        [welf.riskTestArr addObjectsFromArray:arr];
                            self.riseTableDataSouse.paperType = BlankType;
                            self.riseTableDataSouse.rishQuestionsArray = self.riskTestArr;
                            [self.riskTableView reloadData];
                            [self.view setNeedsLayout];
                      
                        
                            //获取完试卷后,先判断用户有没有进行过测评,如果进行过则请求答案接口 如果用户提交过答案则填充答案，如果没有提交过则读取缓存中的用户的答案，缓存没有则展示空白试卷。不管哪种情况都要请求客户信息更新准确的年龄和学历
                           NSString * risk_serial_no = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRiskTest];
                        
                        if ([NSString isBlankString:risk_serial_no]) {
                            // 读取缓存 此处调用了一个问卷回访的接口 该接口其实没有用返回的任何数据 只是单纯的调用一次网络请求 来解决异步问题的Bug 因为现在的逻辑是必须先显示空白试卷在取缓存赋值 如果在在此处直接取缓存赋值因为self.riseTableDataSouse.paperType = AllType 所以不会再走空白试卷创建。

                            [self requestReturnVisitPaper];
                         
                            
                        }else{
                            //请求答案
                            [self requestRiskTestQuery];
                        }
                  
                        
                    }
                }break;
                case kReturnVisitPaper:{
                    //读缓存
                    NSDictionary * dfDic = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRiskAnswer];
                    
                    if (dfDic.count !=0) {
                        
                        self.riseTableDataSouse.paperType = AllType;
                        self.riseTableDataSouse.defaultResultDic = [NSMutableDictionary dictionaryWithDictionary:dfDic];
                        [self.riskTableView reloadData];
                        [self.view setNeedsLayout];
                        
                    }
                    //请求客户信息  年龄和学历
                    [self requestClientInfo];
                    
                }break;
                case kRiskTestCommit:
                    if ([resultData isKindOfClass:[CRHRiskResultVo class]]) {
                       // CRHRiskResultVo * vo = resultData;
                         [RHOpenAccStoreData storeOpenAccCachUserInfo:@"已评测" withKey:kOpenAccountRiskTest];
                        
                        if (welf.needRectify) {
                            NSMutableDictionary * param = [NSMutableDictionary dictionary];
                            [param setObject:@1 forKey:kOpenAccountRectify];
                            [param setObject:welf.local_paper_id forKey:@"local_paper_id"];
                            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskTestResultController" withParam:param];
                            return;
                        }
                        
                        [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHRiskTestResultController" withParam:welf.local_paper_id];
                       // [CMProgress showWarningProgressWithTitle:nil message:@"风险测评试卷提交成功" warningImage:nil duration:1];
                   

                    }
                    
                    break;
                case kRiskTestQuery :
                    //风险测评结果查询成功
                    if ([resultData isKindOfClass:[CRHRiskResultVo class]]) {
                        CRHRiskResultVo * vo = resultData;
                        
                        if ([NSString isBlankString:vo.answer]) {
                            //获取后台答案为空时 读取缓存
                            NSDictionary * dfDic = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRiskAnswer];
                            
                            if (dfDic.count !=0) {
                                
                                self.riseTableDataSouse.paperType = AllType;
                                self.riseTableDataSouse.defaultResultDic = [NSMutableDictionary dictionaryWithDictionary:dfDic];;
                                
                                [self.riskTableView reloadData];
                                [self.view setNeedsLayout];
                            }

                        }else{
                            NSDictionary * dic = [self dictionaryWithJsonString:vo.answer];
                            self.riseTableDataSouse.paperType = AllType;
                            self.riseTableDataSouse.defaultResultDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                            
                              [self.riskTableView reloadData];
                               [self.view setNeedsLayout];
                        }
                       // [self.riskTableView reloadData]; 该方法不需要在显示空白试卷的时候在次调用 所以移到了上面的判断里面

                        //请求客户信息  年龄和学历
                        [self requestClientInfo];


                    }
                    break;
                case kReturnVisitCommit:
                    [CMProgress showWarningProgressWithTitle:nil message:@"回访问卷提交成功" warningImage:nil duration:1];

                    break;
                    
                case kRiskResultConfirm :
                    [CMProgress showWarningProgressWithTitle:nil message:@"风险结果确认成功" warningImage:nil duration:1];

                    break;
                default:
                    break;
            }
        }
        else{
        
         [CMProgress showWarningProgressWithTitle:nil message:resultData[@"error_info"] warningImage:nil duration:1];
            
            switch (type) {
                case kReturnVisitPaper:{
                    //读缓存
                    NSDictionary * dfDic = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRiskAnswer];
                    
                    if (dfDic.count !=0) {
                        
                        self.riseTableDataSouse.paperType = AllType;
                        self.riseTableDataSouse.defaultResultDic = [NSMutableDictionary dictionaryWithDictionary:dfDic];
                        [self.riskTableView reloadData];
                        [self.view setNeedsLayout];
                        
                    }
                    //请求客户信息  年龄和学历
                    [self requestClientInfo];
                }
                    break;
                    
                default:
                    break;
            }

        }
        
    }];

}

#pragma mark--点击下一步
-(void)nextClick:(UIButton *)btn{
   
    self.nextBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nextBtn.enabled = YES;
    });
    
    //NSLog(@"%@",self.riskTestResultDic);
    NSArray * keys = self.riskTestResultDic.allKeys;
    NSMutableString * answer = [NSMutableString string];
    for (int i = 0; i < keys.count; i++) {
        NSArray * answerArray = [self.riskTestResultDic objectForKey:keys[i]];
        NSMutableString * tempStr = [NSMutableString string];
        if (answerArray.count>1) {
            for (int i = 0; i < answerArray.count; i++) {
                if (i==answerArray.count-1) {
                    [tempStr appendFormat:@"%@",answerArray[i]];
                }else{
                    [tempStr appendFormat:@"%@^",answerArray[i]];
                }
            }
        }else{
            
            [tempStr appendFormat:@"%@",answerArray[0]];
        }
        
        [answer appendFormat:@"%@&%@|",keys[i],tempStr];
            
    }
    //NSLog(@"%@",answer);

       if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:answer forKey:@"paper_answer"];
    [param setObject:@1 forKey:@"paper_type"];
    [self requestWithParam:param withUrl:@"crhRiskTestCommit" withRequestType:kRiskTestCommit withRequestManager:self.riskTestManager];
    
    
    
    
    
    
//    //    ps：参数格式 (形如："1&1^4|2&3|"，1号题的答案是1和4，2号题的答案是3，最后一位也需要分隔符"|")
//    NSString * answer = @"10033&1|10034&1|10035&1|10036&1|10037&1|10038&1|10039&1|";
//    if (_riskAnswer.text.length) {
//        answer = _riskAnswer.text;
//    }
//    //    NSString * aString = [answer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    
}
#pragma 解析服务器返回的数据 
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    NSArray * keys = dic.allKeys;
    for (int i = 0; i < keys.count; i++) {
        NSString * answerStr =dic[keys[i]];
        NSMutableArray * answerArray = [NSMutableArray array];
        if ([answerStr containsString:@","]) {
            answerArray = [[answerStr componentsSeparatedByString:@","] mutableCopy];
        }else{
            [answerArray addObject:answerStr];

        }
        
        [dic setValue:answerArray forKeyPath:keys[i]];
        
    }
    return dic;
}
#pragma mark--生日转年龄
-(NSString *)userAge:(NSString *)birthday{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:birthDay];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
    
    
}
#pragma mark-- 用户点击修改 年龄和学历 提示
-(void)warnRemarkWithType:(ChooseType)type{
    
    __weak typeof (self) welf = self;

    NSString * warnStr;
    if (type==AgeType) {
        warnStr = @"该年龄信息是根据您的身份证号计算出来的,如需修改,请返回重新修改个人信息.";
    }else if (type==EducationType){
        warnStr = @"该学历信息是根据您在个人信息页的选择结果确定的,如需修改,请返回重新修改个人信息.";

    }
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:warnStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actoin){}];//在代码块中可以填写具体这个按钮执行的操作
    [alert addAction:defaultAction];

    UIAlertAction * alterAction =[UIAlertAction actionWithTitle:@"修改信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actoin){
        //存储用户没有提交的答案
        [RHOpenAccStoreData storeOpenAccCachUserInfo:self.riskTestResultDic withKey:kOpenAccountRiskAnswer];
        [MNNavigationManager navigationToUniversalVC:welf withClassName:@"RHIDCardController" withParam:nil];
        
    
    }];
    [alert addAction:alterAction];

    [self presentViewController: alert animated:YES completion:nil];

    
}
@end
