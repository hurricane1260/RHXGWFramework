//
//  OAPersonalInfoConfirmController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/11.
//
//

#import "OAPersonalInfoConfirmController.h"
#import "PersonalInfoView.h"
#import "PersonalInfoConfirmView.h"
#import "PersonInfoVo.h"
#import "RHCustomTableView.h"
#import "PersonInfoPickView.h"
#import "protocolView.h"
#import "BenefitView.h"
#import "RevenueView.h"


#import "OARequestManager.h"

#import "IdInfo.h"
#import "CRHClientInfoVo.h"

#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

#define CAREER @"career"
#define EDUC   @"educ"

@interface OAPersonalInfoConfirmController ()<RHBaseTableViewDelegate,UIScrollViewDelegate>

kRhPStrong UIScrollView * bottomScrollow;

kRhPStrong UILabel * hintLabel;

kRhPStrong PersonalInfoView * nameView;

kRhPStrong PersonalInfoView * cardIdView;

kRhPStrong PersonalInfoView * addressIdView;

kRhPStrong PersonalInfoView * addressConnectView;

kRhPStrong PersonalInfoView * careerView;

kRhPStrong PersonalInfoView * educView;

kRhPStrong BenefitView * benefitView;

kRhPStrong UIButton * nextStepBtn;

kRhPStrong PersonalInfoConfirmView * alertView;

kRhPStrong NSMutableDictionary * dic;

kRhPStrong RHCustomTableView * careerTabview;

kRhPStrong RHCustomTableView * educTableview;

kRhPStrong PersonInfoPickView * careerPickView;

kRhPStrong PersonInfoPickView * educPickView;

kRhPStrong NSMutableArray * careerList;

kRhPStrong NSMutableArray * educList;

kRhPStrong OARequestManager * requestManager;

kRhPStrong OARequestManager * dicManager;

kRhPStrong OARequestManager * infoManager;
kRhPStrong OARequestManager * revenueManager;//个人税收信息提交


kRhPCopy NSString * selectItem;

kRhPStrong IdInfo * idInfo;

kRhPCopy NSString * careerStr;

kRhPCopy NSString * educStr;

//kRhPStrong protocolView * nextStepBtn;

//kRhPAssign BOOL isSelected;

kRhPCopy NSString * client_id;

kRhPAssign BOOL needRectify;

kRhPStrong RevenueView * revenueView;

@end

@implementation OAPersonalInfoConfirmController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"个人信息确认";
//        self.isSelected = YES;
        self.view.backgroundColor = color1_text_xgw;
        self.needRectify = NO;

//        self.careerList = @[@"工人",@"农民",@"白领",@"蓝领",@"挖掘机的"];
//        self.educList = @[@"博士后",@"博士",@"研究生",@"本科",@"专科",@"高中",@"初中",@"小学",@"自学成才"];
        self.careerList = [NSMutableArray array];
        self.educList = [NSMutableArray array];
        [self initSubviews];
        
    }
    return self;
}

- (void)setUniversalParam:(id)universalParam{
//    if (!universalParam ) {
//        return;
//    }
    
    if ([universalParam isKindOfClass:[IdInfo class]] ) {
        self.idInfo = universalParam;
    }
    if ([universalParam isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = universalParam;
        if ([dic objectForKey:@"idInfo"]) {
            self.idInfo = [dic objectForKey:@"idInfo"];
        }
        if ([dic objectForKey:kOpenAccountRectify]) {
            self.needRectify = [[dic objectForKey:kOpenAccountRectify] boolValue];
        }
    }
    
    [self requestCareerAndEduc];

    
    if (!self.idInfo) {
        [self requestClientInfo];
    }
    else{
        [self loadInfoData];

    }

    
//    self.dic = [NSMutableDictionary dictionary];
//    [self.dic setObject:@"鲍云敏" forKey:@"name"];
//    [self.dic setObject:@"33108119900203392x" forKey:@"idCard"];
//    [self.dic setObject:@"我家住在哪里啊 啊啊南宁路就是肯定路上看到九分裤" forKey:@"address"];
//    [self.dic setObject:@"我家住在哪里啊 啊啊南宁路就是肯定路上看到九分裤" forKey:@"addressConnct"];
    
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
    self.bottomScrollow.showsVerticalScrollIndicator = NO;
    self.bottomScrollow.delegate = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboards)];
    self.bottomScrollow.userInteractionEnabled = YES;
    [self.bottomScrollow addGestureRecognizer:tap];
    [self.view addSubview:self.bottomScrollow];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"请核对您的身份信息" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
    self.hintLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [self.bottomScrollow addSubview:self.hintLabel];
    
    [self.bottomScrollow addAutoLineWithColor:color16_other_xgw];
    
    self.nameView = [[PersonalInfoView alloc] initWithTitle:@"姓名"];
    self.nameView.needHeightCal = YES;
    [self.bottomScrollow addSubview:self.nameView];
    self.nameView.endEditCallBack = ^{
        [welf checkEnableNextBtn];
    };
    self.nameView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.nameView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
        
    };
    
    self.cardIdView = [[PersonalInfoView alloc] initWithTitle:@"身份证号"];
    self.cardIdView.needLimit = YES;
    [self.bottomScrollow addSubview:self.cardIdView];
    self.cardIdView.endEditCallBack = ^{
        [welf checkEnableNextBtn];
    };

    self.addressIdView = [[PersonalInfoView alloc] initWithTitle:@"证件地址"];
    self.addressIdView.needHeightCal = YES;
    self.addressIdView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.addressIdView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    
    };
    self.addressIdView.endEditCallBack = ^{
        [welf checkEnableNextBtn];
    };

    [self.bottomScrollow addSubview:self.addressIdView];
    
    self.addressConnectView = [[PersonalInfoView alloc] initWithTitle:@"联系地址"];
    self.addressConnectView.needHeightCal = YES;
    self.addressConnectView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.addressConnectView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    self.addressConnectView.endEditCallBack = ^{
        [welf checkEnableNextBtn];
    };

    [self.bottomScrollow addSubview: self.addressConnectView];
    
    self.careerView = [[PersonalInfoView alloc] initWithTitle:@"职业"];
    self.careerView.textView.editable = NO;
    self.careerView.showExpendView = YES;
    self.careerView.expendClickCallBack = ^(NSDictionary * dic){
        if ([dic objectForKey:@"expand"]) {
            BOOL isExpand = [[dic objectForKey:@"expand"] boolValue];
            welf.careerTabview.hidden = !isExpand;
            welf.careerPickView.dataArr = welf.careerList;
            welf.careerPickView.hidden = !isExpand;
            welf.selectItem = CAREER;
            if (CGRectGetMaxY(welf.educView.frame) > welf.bottomScrollow.height) {
                  welf.bottomScrollow.contentOffset = CGPointMake(welf.bottomScrollow.contentOffset.x,259.0f - welf.nextStepBtn.height + CGRectGetMaxY(welf.educView.frame) - welf.bottomScrollow.height - 28.0f);
            }else{
               welf.bottomScrollow.contentOffset = CGPointMake(welf.bottomScrollow.contentOffset.x,259.0f - welf.nextStepBtn.height - (welf.bottomScrollow.height - CGRectGetMaxY(welf.educView.frame)) - 28.0f);
            }
        }
        
    };
    [self.bottomScrollow addSubview:self.careerView];
    
    self.educView = [[PersonalInfoView alloc] initWithTitle:@"学历"];
    self.educView.textView.editable = NO;
    self.educView.showExpendView = YES;
    self.educView.expendClickCallBack = ^(NSDictionary * dic){
        if ([dic objectForKey:@"expand"]) {
            BOOL isExpand = [[dic objectForKey:@"expand"] boolValue];
            welf.educTableview.hidden = !isExpand;
            welf.careerPickView.dataArr = welf.educList;
            welf.careerPickView.hidden = !isExpand;
            welf.selectItem = EDUC;
//            welf.bottomScrollow.contentOffset = CGPointMake(welf.bottomScrollow.contentOffset.x,259.0f - self.nextStepBtn.height);
            if (CGRectGetMaxY(welf.educView.frame) > welf.bottomScrollow.height) {
                welf.bottomScrollow.contentOffset = CGPointMake(welf.bottomScrollow.contentOffset.x,259.0f - welf.nextStepBtn.height + CGRectGetMaxY(welf.educView.frame) - welf.bottomScrollow.height - 28.0f);
            }else{
                welf.bottomScrollow.contentOffset = CGPointMake(welf.bottomScrollow.contentOffset.x,259.0f - welf.nextStepBtn.height - (welf.bottomScrollow.height - CGRectGetMaxY(welf.educView.frame)) -28.0f);
            }
        }
    };
    [self.bottomScrollow addSubview:self.educView];
    
    [self.bottomScrollow addSubview:self.benefitView];
    [self.bottomScrollow addSubview:self.revenueView];
    self.revenueView.btnBlock = ^{
        
        [welf checkEnableNextBtn];
    };
    self.revenueView.heightBlock = ^(NSInteger height) {
        
        welf.revenueView.height = height;
    };
    self.revenueView.itemBlock = ^(ResidentType type) {
        [welf warnRemarkWithType:type];
    };

    
    self.nextStepBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    [self.nextStepBtn addTarget:self action:@selector(nextStepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.nextStepBtn = [[protocolView alloc] init];
//    self.nextStepBtn.agreeLabel.text = @"账户实际控制人及受益人是本人";
//    self.nextStepBtn.selectCallBack = ^(NSDictionary * param){
//        if ([param objectForKey:@"select"]) {
//            welf.isSelected = [[param objectForKey:@"select"] boolValue];
//            [welf checkEnableNextBtn];
//        }
//    };
//    self.nextStepBtn.nextCallBack = ^{
//        [welf nextStepBtnClick:nil];
//    };
    [self.view addSubview:self.nextStepBtn];
    
    self.alertView = [[PersonalInfoConfirmView alloc] init];
    self.alertView.modifyCallBack = ^{
        welf.alertView.hidden = YES;
    };
    self.alertView.sureCallBack = ^{
        
//        welf.alertView.hidden = YES;
        [welf naviToAccountPage];
    };
    self.alertView.hidden = YES;
    [self.view addSubview:self.alertView];
    
    self.careerPickView = [[PersonInfoPickView alloc] init];
    self.careerPickView.hidden = YES;
    self.careerPickView.selectCallBack = ^(NSDictionary * param){
        welf.careerPickView.hidden = YES;
        [welf hideKeyboards];
        if ([param objectForKey:@"select"]) {
            PersonInfoVo * vo = [param objectForKey:@"select"];
            if ([welf.selectItem isEqualToString:CAREER]) {
                welf.careerView.detail = vo.dict_prompt;
                welf.careerStr = vo.subentry;

            }
            else if ([welf.selectItem isEqualToString:EDUC]){
                welf.educView.detail = vo.dict_prompt;
                welf.educStr = vo.subentry;

            }
            [welf.view setNeedsLayout];
        }
        welf.bottomScrollow.contentOffset = CGPointMake(welf.bottomScrollow.contentOffset.x,0);
    };
    [self.view addSubview:self.careerPickView];
    
}

- (BenefitView *)benefitView{
    if (!_benefitView) {
        _benefitView = [[BenefitView alloc] init];
    }
    return _benefitView;
}

-(RevenueView *)revenueView{
    if (!_revenueView) {
        _revenueView = [[RevenueView alloc]init];
    }
    return _revenueView;
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
    self.bottomScrollow.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY - self.nextStepBtn.height - 28.0f);
    
    CGFloat offsetY = 0.0f;
    CGFloat offsetX = 24.0f;
    
    CGFloat itemHeight = 50.0f;
//    [self.hintLabel sizeToFit];
    self.hintLabel.frame = CGRectMake(offsetX, 0, self.view.width - offsetX, 50.0f);

    self.bottomScrollow.autoLine.frame = CGRectMake(0, CGRectGetMaxY(self.hintLabel.frame), self.bottomScrollow.width, 0.5f);
    
    self.nameView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomScrollow.autoLine.frame), self.view.width, self.nameView.height);
    
    self.cardIdView.frame = CGRectMake(0, CGRectGetMaxY(self.nameView.frame), self.view.width, itemHeight);
    
    if (self.addressIdView.height == 0) {
        self.addressIdView.height = itemHeight;
    }
    self.addressIdView.frame = CGRectMake(0, CGRectGetMaxY(self.cardIdView.frame), self.view.width, self.addressIdView.height);
    
    if (self.addressConnectView.height == 0) {
        self.addressConnectView.height = itemHeight;
    }
    self.addressConnectView.frame = CGRectMake(0, CGRectGetMaxY(self.addressIdView.frame) , self.view.width, self.addressConnectView.height);
    
    self.careerView.frame = CGRectMake(0, CGRectGetMaxY(self.addressConnectView.frame) , self.view.width, itemHeight);
    
    self.educView.frame = CGRectMake(0, CGRectGetMaxY(self.careerView.frame) , self.view.width, itemHeight);
    
    self.benefitView.frame = CGRectMake(0, CGRectGetMaxY(self.educView.frame), self.view.width, 150.0f);
    
      self.revenueView.frame = CGRectMake(0, CGRectGetMaxY(self.benefitView.frame), self.view.width, self.revenueView.height);
    
    self.nextStepBtn.frame = CGRectMake((self.view.width - self.nextStepBtn.width) /2.0f, self.view.height - self.nextStepBtn.height - 14.0f, self.nextStepBtn.width, self.nextStepBtn.height);
//    self.nextStepBtn.frame = CGRectMake(0, self.view.height - 110.0f, self.view.width, 110.0f);
    
    self.alertView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
//    self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, self.bottomScrollow.height + 259.0f);
    
//    if (CGRectGetMaxY(self.educView.frame) < self.bottomScrollow.height) {
//        self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, self.bottomScrollow.height + 259.0 + 150.0f - self.nextStepBtn.height);
//    }
//    else{
//        self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, self.bottomScrollow.height + 259.0 + 150.0f - self.nextStepBtn.height - (CGRectGetMaxY(self.educView.frame) - self.bottomScrollow.height));
//    }
    
    if (CGRectGetMaxY(self.educView.frame) < self.bottomScrollow.height) {
        self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, self.bottomScrollow.height + 259.0 + 150.0f+self.revenueView.height - self.nextStepBtn.height);
    }
    else{
        self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, self.bottomScrollow.height + 259.0 + 150.0f+self.revenueView.height - self.nextStepBtn.height - (CGRectGetMaxY(self.educView.frame) - self.bottomScrollow.height));
    }


    self.careerPickView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self loadInfoData];
//
//    [self requestCareerAndEduc];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.requestManager cancelAllDelegate];
    [self.dicManager cancelAllDelegate];

    if (self.needRectify) {
        [RHOpenAccStoreData cancelRequestStatus];
    }
}

- (void)loadInfoData{
    if (!self.idInfo) {
//        self.nameView.detail = [self.dic objectForKey:@"name"];
//        self.cardIdView.detail = [self.dic objectForKey:@"idCard"];
//        self.addressIdView.detail = [self.dic objectForKey:@"address"];
//        self.addressConnectView.detail = [self.dic objectForKey:@"address"];
        return;
    }
//    else{
    
        self.nameView.detail = self.idInfo.name;
        self.cardIdView.detail = self.idInfo.code;
        self.addressIdView.detail = self.idInfo.address;
        self.addressConnectView.detail = self.idInfo.address;
//    }
    
    
#warning
    if (self.idInfo.degree_code.length) {
        self.educStr = self.idInfo.degree_code;
        self.educView.detail = @"本科";//需要查字典修改
    }
    else{
        self.educStr = @"3";
        self.educView.detail = @"本科";
    }
    if (self.idInfo.profession_code.length) {
        self.careerStr = self.idInfo.profession_code;
        self.careerView.detail = @"其他";//需要查字典修改
    }
    else{
        self.careerView.detail = @"其他";
        self.careerStr = @"99";
    }

}

- (void)checkEnableNextBtn{
    
    NSString * name = self.nameView.detail;
    NSString * cardId = self.cardIdView.detail;
    NSString * addId = self.addressIdView.detail;
    NSString * addCon = self.addressConnectView.detail;
    if (!name.length || !cardId.length || !addId.length || !addCon.length|| !self.revenueView.isSelectBtn) {
        self.nextStepBtn.enabled = NO;
    }
//    else if (!self.isSelected){
//        self.nextStepBtn.enabled = NO;
//    }
    else{
        self.nextStepBtn.enabled = YES;
    }
}

- (void)nextStepBtnClick:(UIButton *)btn{
    
    if (!self.nameView.detail.length || !self.cardIdView.detail.length || !self.addressIdView.detail.length) {
        [CMProgress showWarningProgressWithTitle:nil message:@"身份信息不完全，请补充完整后再进行下一步" warningImage:nil duration:1];
        return;
    }
    if (self.addressIdView.detail.length < 8 || self.addressConnectView.detail.length < 8) {
        [CMProgress showWarningProgressWithTitle:nil message:@"地址最少需输入8个字符" warningImage:nil duration:1];

        return;
    }
    [self submitRevenueCertificate];
    
//    //读取信息
//    PersonInfoVo * infoVo = [[PersonInfoVo alloc] init];
//    infoVo.name = self.nameView.detail;
//    infoVo.cardId = self.cardIdView.detail;
//    infoVo.address = self.addressIdView.detail;
//    self.alertView.detailData = infoVo;
//    [self.view setNeedsLayout];
//
//    self.alertView.hidden = NO;
}

- (void)naviToAccountPage{
    //信息保存  产品设计是在视频之前上传
    [self upLoadPersonalMsgToSever];
    
}

- (OARequestManager *)requestManager{
    if (!_requestManager) {
        _requestManager = [[OARequestManager alloc] init];
    }
    return _requestManager;
}

- (OARequestManager *)dicManager{
    if (!_dicManager) {
        _dicManager = [[OARequestManager alloc] init];
    }
    return _dicManager;
}

- (OARequestManager *)infoManager{
    if (!_infoManager) {
        _infoManager = [[OARequestManager alloc] init];
    }
    return _infoManager;
}

- (OARequestManager *)revenueManager{
    if (!_revenueManager) {
        _revenueManager = [[OARequestManager alloc] init];
    }
    return _revenueManager;
}
#pragma mark--提交个人税收证明
-(void)submitRevenueCertificate{
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:self.client_id forKey:@"user_id"];
    [param setValue:@"1" forKey:@"revenue_inmate_type"];
    
    [self.revenueManager sendCommonRequestWithParam:param withRequestType:kUploadPersonRevenue withUrlString:@"crhUploadPersonRevenve" withCompletion:^(BOOL success, id resultData) {
        
        if (success) {
            NSLog(@"========提交成功=========");
            //读取信息
            PersonInfoVo * infoVo = [[PersonInfoVo alloc] init];
            infoVo.name = self.nameView.detail;
            infoVo.cardId = self.cardIdView.detail;
            infoVo.address = self.addressIdView.detail;
            self.alertView.detailData = infoVo;
            [self.view setNeedsLayout];
            self.alertView.hidden = NO;
            
        }else{
            [CMProgress showWarningProgressWithTitle:nil message:@"税收证明提交失败" warningImage:nil duration:1];
        }
        
    }];
    
}


- (void)requestClientInfo{
    __weak typeof(self) welf = self;
    
    [self.infoManager requestQueryClientInfoWithComoletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHClientInfoVo class]]) {
                return;
            }
            CRHClientInfoVo * vo = resultData;
            welf.idInfo = [[IdInfo alloc] init];
            welf.idInfo.beginDate = [NSString stringWithFormat:@"%@",vo.id_begindate];
            welf.idInfo.endDate = [NSString stringWithFormat:@"%@",vo.id_enddate];
            welf.idInfo.birthday = [NSString stringWithFormat:@"%@",vo.birthday];
            welf.idInfo.gender = vo.client_gender;
            welf.idInfo.issue = vo.issued_depart;
            
            welf.idInfo.degree_code = vo.degree_code;
            welf.idInfo.profession_code = vo.profession_code;
            
            welf.idInfo.code = vo.id_no;
            welf.idInfo.name = vo.client_name;
            welf.idInfo.address = vo.id_address;
            welf.idInfo.connectAddress = vo.address;
            
            [welf loadInfoData];
        }
    }];
    
}

- (void)requestCareerAndEduc{
    
    [self requestCareer];
    
}

- (void)requestCareer{
    [self.careerList removeAllObjects];

    [self requestDicWithId:@"1015" withManager:self.requestManager];
}

- (void)requestEduc{
    [self.educList removeAllObjects];

    [self requestDicWithId:@"1014" withManager:self.dicManager];
}

- (void)requestDicWithId:(NSString *)idStr withManager:(OARequestManager *)manager{
    __weak typeof(self) welf = self;
    [manager queryDicWithId:idStr withCompletion:^(BOOL success, id resultData) {
        if (success) {
            //数据为空情况 采用默认选项 防止空数据
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {

                [welf dealResultFromDicQuery:idStr];
                return;
            }
            NSArray * arr = resultData;
            if (!arr.count) {

                [welf dealResultFromDicQuery:idStr];

                return;
            }
            if ([idStr isEqualToString:@"1015"]) {
                for (NSDictionary * dic in arr) {
                    PersonInfoVo * vo = [PersonInfoVo generateWithDict:dic];
                    [welf.careerList addObject:vo];
                }

                [welf requestEduc];
            }
            else if([idStr isEqualToString:@"1014"]) {
                for (NSDictionary * dic in arr) {
                    PersonInfoVo * vo = [PersonInfoVo generateWithDict:dic];
                    [welf.educList addObject:vo];
                }
            }
            welf.careerTabview.dataList = self.careerList;
            welf.educTableview.dataList = self.careerList;
            [welf.careerTabview reloadData];
            [welf.educTableview reloadData];

            [welf.view setNeedsLayout];
        }
    }];

}

- (void)dealResultFromDicQuery:(NSString *)idStr{
    if ([idStr isEqualToString:@"1015"]) {
        NSArray * arr = @[@"文教科卫专业人员",@"党政（在职，离退休）机关干部",@"企事业单位干部",@"行政企事业单位工人",@"农民",@"个体",@"无业",@"军人",@"学生",@"证券从业人员",@"其他",@"离退休",@"企事业单位职工",@"党政机关工作人员"];
        [self.careerList addObjectsFromArray:arr];
        [self requestEduc];
    }
    else if([idStr isEqualToString:@"1014"]) {
        NSArray * arr = @[@"博士",@"硕士",@"本科",@"大专",@"中专",@"高中",@"初中及以下",@"其他"];
        [self.educList addObjectsFromArray:arr];
    }
}

- (void)upLoadPersonalMsgToSever{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];

    if (!self.client_id.length) {
        self.alertView.hidden = YES;
        return;
    }
    
    if (!self.idInfo) {
//        [param setObject:@"20150605" forKey:@"id_begindate"];
//        [param setObject:@"20350605" forKey:@"id_enddate"];
//        [param setObject:@"19900203" forKey:@"birthday"];//需满足[yyyyMMdd]格式
//        [param setObject:@"女" forKey:@"client_gender"];
//        [param setObject:@"北京市公安局" forKey:@"issued_depart"];
//        [param setObject:@"100000" forKey:@"zipcode"];//degree_code
        return;
    }
//    else {
    NSInteger  currentDate = [[NSDate currentDate] yyyyMMddFormat];
    if ([self.idInfo.endDate length] && [self.idInfo.endDate integerValue] < currentDate) {
        [CMProgress showWarningProgressWithTitle:nil message:@"您的身份证已过期，请更新身份证后再进行开户" warningImage:nil duration:2];
        return;
    }
    NSInteger threeMonthLater = [[NSDate pastDateAndAfterDateWithCurrentDate:[NSDate currentDate] year:0 month:3 day:0] yyyyMMddFormat];
    if (self.idInfo.endDate.length && [self.idInfo.endDate integerValue] <= threeMonthLater) {
        [CMProgress showWarningProgressWithTitle:nil message:@"您的身份证即将过期，后期请及时更新信息" warningImage:nil duration:2];
    }
    self.nextStepBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nextStepBtn.enabled = YES;
    });
    
        [param setObject:self.idInfo.beginDate forKey:@"id_begindate"];
        if (self.idInfo.endDate.length) {
            [param setObject:self.idInfo.endDate forKey:@"id_enddate"];
        }
        [param setObject:self.idInfo.birthday forKey:@"birthday"];//需满足[yyyyMMdd]格式
        [param setObject:self.idInfo.gender forKey:@"client_gender"];
        [param setObject:self.idInfo.issue forKey:@"issued_depart"];
        [param setObject:@"100000" forKey:@"zipcode"];
//        [param setObject:self.idInfo.nation forKey:@"minzu_code"];
//    }
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:@"" forKey:@"id_kind"];
    [param setObject:self.cardIdView.detail forKey:@"id_no"];
    [param setObject:self.nameView.detail forKey:@"client_name"];
    [param setObject:self.addressIdView.detail forKey:@"id_address"];
    [param setObject:self.addressConnectView.detail forKey:@"address"];
    [param setObject:@33 forKey:@"open_branch_no"];
//    [param setObject:@10 forKey:@"open_branch_no"];

    [param setObject:@1 forKey:@"beneficiaryPerson"];
    [param setObject:@1 forKey:@"controlNaturePerson"];
    [param setObject:self.nameView.detail forKey:@"benefitPersonName"];
    [param setObject:self.cardIdView.detail forKey:@"benefitIdentityCode"];
    NSString * phoneNum = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccMobile];
    if (phoneNum.length) {
        [param setObject:phoneNum forKey:@"benefitMobile"];
    }
    [param setObject:@1 forKey:@"creditFlg"];
    [param setObject:self.educStr forKey:@"degree_code"];
    [param setObject:self.careerStr forKey:@"profession_code"];

    __weak typeof(self) welf = self;

    [self.requestManager requestUploadPersonMsgToSever:param withRequestType:kUploadPersonMsg withCompletion:^(BOOL success, id resultData) {
        welf.alertView.hidden = YES;

        if (success) {
            
            //存入身份证号 后续需要
//            NSString * tel = [defaults objectForKey:client_id];
//            [defaults setObject:self.cardIdView.detail forKey:tel];
//            [defaults synchronize];
            
            [RHOpenAccStoreData storeOpenAccCachUserInfo:welf.cardIdView.detail withKey:kOpenAccCardId];
            
            if (self.needRectify) {
                
                [RHOpenAccStoreData requestUserStatus:self];
                return ;
                
                NSArray * arr = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccountRectify];
                if (arr.count) {
                    NSString * class = @"";
//   open_status状态位：0证件照上传、1基本资料提交、2视频见证完成、协议已签署、4账户设置、5存管设置、暂未定义、7风险问卷、8回访设置、9密码设置
                    if ([arr containsObject:@7]) {
                        class = @"RHRiskEvaluationController";
                    }
                    else if ([arr containsObject:@4] || [arr containsObject:@9]){
                        class = @"RHAccountPasswordController";
                    }
                    else if ([arr containsObject:@5]){
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
            }    //跳转
            [MNNavigationManager navigationToUniversalVC:welf withClassName:@"RHRiskEvaluationController" withParam:@1];
           
        }
        else{
            NSString * error_info = [resultData objectForKey:@"error_info"];
            [CMProgress showWarningProgressWithTitle:nil message:error_info warningImage:nil duration:2.0f];
        }
    }];
}

#pragma mark --------delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideKeyboards];
}

- (void)hideKeyboards{
    [self.nameView.textView resignFirstResponder];
    [self.cardIdView.textView resignFirstResponder];
    [self.addressIdView.textView resignFirstResponder];
    [self.addressConnectView.textView resignFirstResponder];
}

- (void)didSelectWithData:(id)data{
    if (!data || ![data isKindOfClass:[PersonInfoVo class]]) {
        return;
    }
    PersonInfoVo * vo = data;
    if ([self.selectItem isEqualToString:CAREER]) {
        self.careerView.detail = vo.dict_prompt;
        self.careerStr = vo.subentry;
        self.careerTabview.hidden = YES;
        [self.careerView expandSelectItems];
    }
    else if ([self.selectItem isEqualToString:EDUC]){
        self.educView.detail = vo.dict_prompt;
        self.educStr = vo.subentry;
        self.educTableview.hidden = YES;
        [self.educView expandSelectItems];
    }
    [self.view setNeedsLayout];
}
-(void)warnRemarkWithType:(ResidentType)type{
    
    
    NSString * warnStr;
    if (type==notResident) {
        warnStr = @"如果是非税收居民，不能继续网上开户，请详询客服热线400-088-5558";
    }else if (type==otherResident){
        warnStr = @"如果是既是中国税收居民又是其他国家（地区）税收居民不能继续网上开户，请详询客服热线400-088-5558";
    }else{
        return;
    }
    
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:warnStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actoin){
    }];//在代码块中可以填写具体这个按钮执行的操作
    [alert addAction:defaultAction];
    
    [self presentViewController: alert animated:YES completion:nil];
    
    
}


@end
