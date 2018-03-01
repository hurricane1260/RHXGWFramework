//
//  TradeWithdrawController.m
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "TradeWithdrawController.h"
#import "TradeDataManager.h"
#import "TradeErrorParser.h"
//#import "TradeSimulateDataManager.h"

#import "TradeEntrustListView.h"

@interface TradeWithdrawController ()<TradeDataManagerDelegate, TradeEntrustViewDelegate>

//@property (nonatomic,strong) TradeSimulateDataManager *simulateManager;

@property (nonatomic,strong) TradeDataManager *tradeDataManager;

@property (nonatomic,strong) TradeEntrustListView *entrustView;//撤单

@end

@implementation TradeWithdrawController

#pragma mark -------------------------init-------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.entrustView = [[TradeEntrustListView alloc]init];
    [self.view addSubview:self.entrustView];
    self.entrustView.delegate = self;
    self.entrustView.backgroundColor = color18_other_xgw;
}

-(void)setViewType:(TradeControllerType)aType {
    _viewType = aType;
    self.entrustView.viewType = aType;
//    if (_viewType == TradeControllerTypeReal) {
        self.tradeDataManager = [[TradeDataManager alloc]init];
        self.tradeDataManager.delegate = self;
//    }
//    else {
//        self.simulateManager = [[TradeSimulateDataManager alloc]init];
//    }
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    self.entrustView.isSecondTrade = aBool;
}

#pragma mark -------------------------controller-------------------------

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tradeDataManager cancelAllRequest];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.entrustView.width = self.view.width;
    self.entrustView.height = self.view.height;
}

- (void)dealloc {
    self.tradeDataManager.delegate = nil;
    self.tradeDataManager = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

#pragma mark -------------------------request-------------------------

//撤单view，委托列表
-(void)requestEntrustList {
//    if (self.viewType == TradeControllerTypeSimulate) {
//        __block __typeof(self) welf = self;
//        [self.simulateManager requestEntrustListWithCallBack:^(BOOL success, id resultData) {
//            [welf getEntrustWithdrawListResultHandler:resultData andSuccess:success];
//        }];
//    }
//    else {
        [self.tradeDataManager requestEntrustWithdrawList];
//    }
}

//撤单view，委托列表下一页
-(void)requestEntrustListNextPage {
//    if (self.viewType == TradeControllerTypeReal) {
        [self.tradeDataManager requestNextPageEntrustWithdrawList];
//    }
}

//撤单view，撤单请求
-(void)sendEntrustWithdrawWithParam:(NSMutableDictionary *)param {
//    if (self.viewType == TradeControllerTypeSimulate) {
//        __block __typeof(self) welf = self;
//        [self.simulateManager sendWithdrawWithParam:param callBack:^(BOOL success, id resultData) {
//            [welf sendWithdrawRequestResultHandler:resultData andSuccess:success];
//        }];
//    }
//    else {
        [self.tradeDataManager sendWithdrawRequestWith:param];
//    }
}

#pragma mark -------------------------request back-------------------------

//委托列表 & 委托列表下一页
-(void)getEntrustWithdrawListResultHandler:(id)resultData andSuccess:(BOOL)success {
    //    [self.entrustView stopRefreshTableView];
    if (success) {
        self.entrustView.dataList = resultData;
    }
    else {
        self.entrustView.dataList = nil;
        [CMProgress showWarningProgressWithTitle:nil message:@"加载失败" warningImage:img_progress_failure duration:kPopupWindowDurationInterval];
        //        [self.entrustView hideWarningImage:NO];
        NSLog(@"委托列表 & 委托列表下一页-1,%@",resultData);
        //        [CMProgress showWarningProgressWithTitle:nil message:resultData warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
    }
}

//撤单返回
-(void)sendWithdrawRequestResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        [CMProgress showWarningProgressWithTitle:nil message:@"撤单成功" warningImage:nil duration:kPopupWindowDurationInterval];
        NSLog(@"撤单成功");
        [self requestEntrustList];
    }
    else {
        NSLog(@"撤单失败%@",resultData);
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo] warningImage:nil duration:3.0f];
    }
}

#pragma mark -------------------------tradeController,delegate-------------------------

- (void)refreshData {
    [self requestEntrustList];
}

- (void)clearData {
    self.entrustView.dataList = nil;
    [self.tradeDataManager cancelAllRequest];
}

@end
