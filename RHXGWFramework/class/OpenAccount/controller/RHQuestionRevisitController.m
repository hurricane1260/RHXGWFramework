//
//  RHQuestionRevisitController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import "RHQuestionRevisitController.h"
#import "OARequestManager.h"
#import "RevisitTableDataSource.h"
#import "RiskTestHeaderView.h"
#import "CRHRiskTestVo.h"
#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

@interface RHQuestionRevisitController ()
kRhPStrong NSMutableArray * returnVisitArr;
kRhPStrong UITableView *  questionreVisitTableView;
kRhPStrong OARequestManager * returnVisitManager;
kRhPStrong OARequestManager * requestManager;
kRhPStrong RevisitTableDataSource * dataSource;
kRhPStrong UIScrollView * bgScrollView;
kRhPStrong RiskTestHeaderView * tabHeaderView;
kRhPStrong UIButton * nextBtn;
kRhPCopy NSString * client_id;

kRhPAssign BOOL needRectify;

@end

@implementation RHQuestionRevisitController
- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"问卷回访";
        self.returnVisitArr = [NSMutableArray array];
        self.needRectify = NO;

        [self initSubviews];
        
    }
    return self;
}

- (OARequestManager *)returnVisitManager{
    if (!_returnVisitManager) {
        _returnVisitManager = [[OARequestManager alloc] init];
    }
    return _returnVisitManager;
}

- (OARequestManager *)requestManager{
    if (!_requestManager) {
        _requestManager = [[OARequestManager alloc] init];
    }
    return _requestManager;
}

-(RevisitTableDataSource*)dataSource{
    if (!_dataSource) {
        _dataSource = [[RevisitTableDataSource alloc]init];
    }
    return _dataSource;
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

-(void)initSubviews{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.backgroundColor = color1_text_xgw;
    [self.view addSubview:self.bgScrollView];
    
    self.questionreVisitTableView = [[UITableView alloc]init];
    self.questionreVisitTableView.delegate = self.dataSource;
    self.questionreVisitTableView.dataSource = self.dataSource;
    self.questionreVisitTableView.scrollEnabled = NO;
    self.questionreVisitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bgScrollView addSubview:self.questionreVisitTableView];
    
   
    
    [self.view addAutoLineWithColor:color16_other_xgw];
    
    self.nextBtn = [[UIButton alloc]init];
    self.nextBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];

    self.dataSource.warnTipBlock = ^(NSDictionary *params) {
        [CMProgress showWarningProgressWithTitle:nil message:[params objectForKey:@"warn"] warningImage:nil duration:1];
    };
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
       self.bgScrollView.frame = CGRectMake(0, self.layoutStartY, kDeviceWidth,kDeviceHeight-self.layoutStartY-self.nextBtn.height-28);
    
    self.questionreVisitTableView.frame = CGRectMake(0, 10, kDeviceWidth, self.questionreVisitTableView.contentSize.height);
   
    self.nextBtn.frame = CGRectMake(24, self.view.height - 14.0f - 44, kDeviceWidth-2*24, 44);
    
    self.view.autoLine.frame = CGRectMake(0, CGRectGetMinY(self.nextBtn.frame)-14, self.view.width, 0.5f);

    self.bgScrollView.contentSize = CGSizeMake(kDeviceWidth, self.questionreVisitTableView.contentSize.height+10);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.questionreVisitTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    if (self.returnVisitArr.count==0) {
        [self requestReturnVisitPaper];

    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.requestManager cancelAllDelegate];
    [self.returnVisitManager cancelAllDelegate];
     [self.questionreVisitTableView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 方式1.匹配keypath
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.questionreVisitTableView.frame = CGRectMake(0, 10, kDeviceWidth, self.questionreVisitTableView.contentSize.height);
         self.bgScrollView.contentSize = CGSizeMake(kDeviceWidth, self.questionreVisitTableView.contentSize.height+10);
    }
    
    
}


-(void)requestReturnVisitPaper{
    [self.returnVisitArr removeAllObjects];
    
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    
    [self requestWithParam:param withUrl:@"crhReturnVisitPaper" withRequestType:kReturnVisitPaper withRequestManager:self.returnVisitManager];
    
  
    
    
}
- (void)requestWithParam:(id)param withUrl:(NSString *)urlString withRequestType:(CRHRequestType)type withRequestManager:(OARequestManager *)manager{
    __weak typeof(self) welf = self;
    [manager sendCommonRequestWithParam:param withRequestType:type withUrlString:urlString withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData) {
                return;
            }
            
            switch (type) {
                case kReturnVisitPaper:{
                    if ([resultData isKindOfClass:[NSArray class]]) {
                        [welf.returnVisitArr addObjectsFromArray:resultData];
                        welf.dataSource.rishQuestionsArray =welf.returnVisitArr;
                        [welf.questionreVisitTableView reloadData];
                        [welf.view setNeedsLayout];
//                        
//                        [CMProgress showWarningProgressWithTitle:nil message:@"回访问卷获取成功" warningImage:nil duration:1];
                    }
                }break;
                
                case kReturnVisitCommit:
//
//                    [CMProgress showWarningProgressWithTitle:nil message:@"回访问卷提交成功" warningImage:nil duration:1];
                    
                    //提交开户申请
                    [welf applyOpenAcc];
                    break;
            
                default:
                    break;
            }
        }
        else{
            
            NSString * error_info = [resultData objectForKey:@"error_info"];
            [CMProgress showWarningProgressWithTitle:nil message:error_info warningImage:nil duration:2];
            
            
        }
        
        
    }];

}
#pragma mark--点击下一步
-(void)nextClick:(UIButton *)btn{
   
    if (self.returnVisitArr!= nil && ![self.returnVisitArr isKindOfClass:[NSNull class]] && self.returnVisitArr.count != 0){
        
        self.nextBtn.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.nextBtn.enabled = YES;
        });
        
        NSMutableString * revisitStr = [NSMutableString string];
        for (CRHRiskTestVo * VO in self.returnVisitArr) {
            [revisitStr appendFormat:@"%@&%@|",VO.question_no,VO.default_answer];
        }
        
        [self requestReturnVisitCommit:revisitStr];
        
    }else{
        return;
    }

    
}
#pragma mark 回访问卷提交
-(void)requestReturnVisitCommit:(NSString *)revisitStr{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    
    //    ps:参数格式同风险测评提交参数格式
    if (![NSString isBlankString:revisitStr]) {
        [param setObject:revisitStr forKey:@"paper_answer"];

    }
    
    [self requestWithParam:param withUrl:@"crhReturnVisitCommit" withRequestType:kReturnVisitCommit withRequestManager:self.returnVisitManager];
    
}

- (void)applyOpenAcc{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    
    [self.requestManager sendCommonRequestWithParam:param withRequestType:kOpenAccApply withUrlString:@"crhOpenAccApply" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHOpenAccResultController" withParam:nil];
        }
        else{
            NSString * error_info = [resultData objectForKey:@"error_info"];
            [CMProgress showWarningProgressWithTitle:nil message:error_info warningImage:nil duration:2];
            NSLog(@"申请开户失败");
            if ([error_info isEqualToString:@"用户开户流程还未完成无法提交审核"]) {
                
            }
            else if([error_info isEqualToString:@"用户已有未完成的审核任务无法再次提交"]){
                [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHOpenAccResultController" withParam:nil];
            }
        }
    }];
}
@end
