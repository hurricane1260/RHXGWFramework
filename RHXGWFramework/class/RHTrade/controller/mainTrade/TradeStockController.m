//
//  TradeStockController.m
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "TradeStockController.h"
#import "TradeStockView.h"
#import "TradeDataManager.h"
#import "TradeErrorParser.h"
#import "TradeSimulateDataManager.h"
#import "StockListVO.h"

@interface TradeStockController ()<TradeDataManagerDelegate,TradeControllerSwitchViewDelegate>

@property (nonatomic, strong) TradeDataManager *tradeDataManager;

@property (nonatomic, strong) TradeSimulateDataManager *simulateManager;

@property (nonatomic, strong) TradeStockView *stockView;//持仓

@end

@implementation TradeStockController

#pragma mark -------------------------init-------------------------

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"requestTradeBalance" object:nil];
    }
    return self;
}

- (void)initSubviews {
    self.stockView = [[TradeStockView alloc]init];
    [self.view addSubview:self.stockView];
    self.stockView.tradeControllerDelegate = self;
    self.stockView.backgroundColor = [UIColor whiteColor];
}

-(void)setViewType:(TradeControllerType)aType {
    _viewType = aType;
    self.stockView.viewType = aType;
    if (_viewType == TradeControllerTypeReal) {
        self.tradeDataManager = [[TradeDataManager alloc]init];
        self.tradeDataManager.delegate = self;
    }
    else {
        self.simulateManager = [[TradeSimulateDataManager alloc]init];
    }
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    self.stockView.isSecondTrade = aBool;
}

#pragma mark -------------------------controller-------------------------

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tradeDataManager cancelAllRequest];
    [self.simulateManager cancelAllRequest];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.stockView.width = self.view.width;
    self.stockView.height = self.view.height;
}

- (void)dealloc {
    self.tradeDataManager.delegate = nil;
    self.tradeDataManager = nil;
    self.stockView = nil;
    self.simulateManager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

#pragma mark -------------------------request-------------------------

- (void)refreshStockView {
    if (self.viewType == TradeControllerTypeReal) {
        [self.tradeDataManager requestDetailFund];
        [self.tradeDataManager requestHoldPositionList];
    }
    else {
        __block __typeof(self) welf = self;
        [self.simulateManager requestDetailFundWithCallBack:^(BOOL success, id resultData) {
            [welf getDetailFundResultHandler:resultData andSuccess:success];
        }];
        [self.simulateManager requestHoldPositionListWithCallBack:^(BOOL success, id resultData) {
            [welf getHoldPositionListResultHandler:resultData andSuccess:success];
        }];
    }
}

//持仓下一页
- (void)stockViewNextPage {
    if (self.viewType == TradeControllerTypeReal) {
        [self.tradeDataManager requestHoldListNextPage];
    }
    else {
        __block __typeof(self) welf = self;
        [self.simulateManager requestHoldPositionListNextPageWithCallBack:^(BOOL success, id resultData) {
            [welf getHoldPositionListResultHandler:resultData andSuccess:success];
        }];
    }
}

#pragma mark -------------------------request back-------------------------

//持仓资金详情
-(void)getDetailFundResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        self.stockView.dataDic = resultData;
        [[NSNotificationCenter defaultCenter] postNotificationName:kTradeBalanceNotificationName object:resultData];
    }
    else {
        NSLog(@"持仓资金详情-1,%@",resultData);
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];

        //[CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo] warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
    }
}

//持仓列表
-(void)getHoldPositionListResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        NSArray * stockList = resultData;
        if (self.stockView.stockList.count > 0 && stockList.count == 0) {
        } else {
            
            self.stockView.stockList = resultData;
            [self.stockView onGetHoldPositionListResult];
        }
    }
    else {
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
        NSLog(@"持仓列表-1,%@",errorInfo);

//        [CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo] warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
    }
}

#pragma mark -------------------------tradeController,delegate-------------------------

- (void)refreshData {
    [self refreshStockView];
}

- (void)clearData {
    [self.tradeDataManager cancelAllRequest];
    [self.simulateManager cancelAllRequest];
    self.stockView.stockList = nil;
    self.stockView.dataDic = nil;
}

//持仓view delegate,跳转到买卖、看行情
- (void)tradeControllerSwitchTo:(TradeControllerViewIndex)viewIndex withStockName:(NSString *)stockName andStockCode:(NSString *)stockCode
{
    if ([self.delegate respondsToSelector:@selector(tradeControllerSwitchTo:withStockName:andStockCode:)]) {
        [self.delegate tradeControllerSwitchTo:viewIndex withStockName:stockName andStockCode:stockCode];
    }
}

- (void)navigateToBankTransferController {
//    NSLog(@"合并后添加跳转");
    if ([self.delegate respondsToSelector:@selector(navigateToBankTransferController)]) {
        [self.delegate navigateToBankTransferController];
    }
}

@end
