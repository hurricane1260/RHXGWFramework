//
//  DealListController.m
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "DealListController.h"
#import "DealListViewCell.h"
#import "TradeEntrustTableViewCell.h"

#import "TradeListHeadView.h"
#import "IPOFiltDateView.h"
#import "TradeNoneDataView.h"

#import "TradeDataManager.h"
#import "TradeSessionManager.h"
#import "TradeSimulateDataManager.h"

#import "EntrustListVO.h"
#import "DealListVO.h"
#import "DealHistoryListVO.h"
#import "TradeSessionManager.h"


typedef enum : NSUInteger {
    DealListViewTypeTodayEntrust,
    DealListViewTypeTodayDeal,
    DealListViewTypeHistoryDeal,
    DealListViewTypeClearanStock,
    DealListViewTypeSimulateHistoryDeal,
} DealListViewType;

static NSString * const kDealListViewCellId = @"dealListViewCellId";
static NSString * const kEntrustListViewCellId = @"entrustListViewCellId";

@interface DealListController () <UITableViewDelegate, UITableViewDataSource,TradeDataManagerDelegate>

kRhPAssign DealListViewType viewType;

kRhPStrong IPOFiltDateView * dateView;
/*! @brief 列表*/
kRhPStrong UITableView *tableView;
/*! @brief 无数据显示的view*/
kRhPStrong TradeNoneDataView *noneDataView;
/*! @brief 用于发送数据请求*/
kRhPStrong TradeDataManager *dataManager;


kRhPStrong TradeSimulateDataManager *simulateManager;//模拟盘

/*! @brief 数组*/
kRhPStrong NSArray *dataList;

kRhPStrong TradeListHeadView *listHeadView;

kRhPCopy NSString * dateType;

kRhPStrong UIDatePicker * datePicker;

kRhPStrong UIButton * cancelBtn;

kRhPStrong UIButton * confirmBtn;

kRhPStrong UILabel * hintLabel;

kRhPStrong NSDate * todayTime;

kRhPStrong NSDate * monthAgo;

kRhPStrong NSDate * startDate;

kRhPStrong NSDate * endDate;

kRhPStrong UIView * dateBackView;




@end

@implementation DealListController

#pragma mark ==============================================初始化&布局================================================

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataList = nil;
        self.dataManager = [[TradeDataManager alloc]init];
        self.dataManager.delegate = self;
        self.simulateManager = [[TradeSimulateDataManager alloc]init];
        self.backButtonHidden = NO;
        [self getDefaultDate];
        [self initSubviews];
    }
    return self;
}


- (void)setTitleString:(NSString *)aString {
    if (_titleString) {
        _titleString = nil;
    }
    _titleString = aString.copy;
    self.title = _titleString;
    if ([_titleString isEqualToString:@"当日成交"]) {
        self.viewType = DealListViewTypeTodayDeal;
        self.listHeadView.titleList = @[@"委托时间",@"成交价",@"成交量",@"成交额"];
    }
    else if ([_titleString isEqualToString:@"当日委托"]) {
        self.viewType = DealListViewTypeTodayEntrust;
        self.listHeadView.titleList = @[@"委托时间",@"委托价格",@"委托/成交",@"状态"];
    }
    else if ([_titleString isEqualToString:@"历史成交"]) {
        self.viewType = DealListViewTypeHistoryDeal;
        self.listHeadView.titleList = @[@"委托时间",@"成交价",@"成交量",@"成交额"];
        [self initQueryView];
        [self initDatePickerView];
    }
    else if ([_titleString isEqualToString:@"已清仓股票"]){
        self.viewType = DealListViewTypeClearanStock;
        self.listHeadView.titleList = @[@"持股时间",@"持股天数",@"盈亏额",@"盈亏比"];

    }
}

- (void)setControllerType:(TradeControllerType)aType {
    _controllerType = aType;
    if (_controllerType == TradeControllerTypeSimulate) {
        self.viewType = DealListViewTypeSimulateHistoryDeal;
        self.listHeadView.titleList = @[@"委托时间",@"成交价",@"成交量",@"成交额"];
        self.navigationBarHidden = YES;
    }
}

- (TradeListHeadView *)listHeadView {
    if (!_listHeadView) {
        _listHeadView = [[TradeListHeadView alloc]init];
        _listHeadView.backgroundColor = [UIColor whiteColor];
    }
    return _listHeadView;
}

-(void)initSubviews {
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView addPullRefreshView];
    [self.tableView registerClass:[DealListViewCell class] forCellReuseIdentifier:kDealListViewCellId];
    [self.tableView registerClass:[TradeEntrustTableViewCell class] forCellReuseIdentifier:kEntrustListViewCellId];
    
   
    // 初始化无数据时显示的图片和文字
    self.noneDataView = [[TradeNoneDataView alloc]init];
    [self.tableView addSubview:self.noneDataView];
    self.noneDataView.hidden = YES;
    self.noneDataView.titleLabel.text = @"暂无数据";
}

- (void)initQueryView{
    
    __weak typeof (self) welf = self;
    _dateView = [[IPOFiltDateView alloc] init];
    _dateView.startDate = _monthAgo;
    _dateView.endDate = _todayTime;
    _dateView.startCallBack = ^{
        welf.dateType = @"start";
        [welf showCalendar];
    };
    _dateView.endCallBack = ^{
        welf.dateType = @"end";
        [welf showCalendar];
    };
    _dateView.queryBtnCallBack = ^{
        [welf dismissCalendar];
        [welf startLoadingData];
    };
    [self.view addSubview:_dateView];
}

- (void)initDatePickerView{
    _dateBackView = [[UIView alloc] init];
    _dateBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    _dateBackView.hidden = YES;
    [self.view addSubview:_dateBackView];
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.backgroundColor = color1_text_xgw;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.maximumDate = _todayTime;
    [_dateBackView addSubview:_datePicker];
    
    self.cancelBtn = [UIButton didBuildButtonWithTitle:@"取消" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color1_text_xgw highlightBGColor:color1_text_xgw disabledBGColor:color1_text_xgw];
    [self.cancelBtn addTarget:self action:@selector(touchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.titleLabel.font = font4_common_xgw;
    [self.dateBackView addSubview:self.cancelBtn];
    
    self.confirmBtn = [UIButton didBuildButtonWithTitle:@"确认" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color1_text_xgw highlightBGColor:color1_text_xgw disabledBGColor:color1_text_xgw];
    self.confirmBtn.titleLabel.font = font4_common_xgw;
    [self.confirmBtn addTarget:self action:@selector(touchConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.dateBackView addSubview:self.confirmBtn];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
    self.hintLabel.hidden = YES;
    [_dateBackView addSubview:_hintLabel];
    [_dateBackView bringSubviewToFront:self.hintLabel];
    
}

- (void)getDefaultDate{
    _todayTime = [NSDate date];
    _monthAgo = [NSDate dateWithTimeInterval:- (3600 * 30 * 24) sinceDate:_todayTime];
    _startDate = _monthAgo;
    _endDate = _todayTime;
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat layoutY = self.layoutStartY;
    if (self.viewType == DealListViewTypeHistoryDeal) {
        _dateView.frame = CGRectMake(0, layoutY, self.view.width, 50.0f);
        layoutY += 50.0f;
        
        _dateBackView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
        _datePicker.frame = CGRectMake(0, _dateView.height, self.view.width, 200.0f);
        
        self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_datePicker.frame) + 0.5f, self.view.width/2.0f - 0.25f, 50.0f);
        self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) +0.5f, self.cancelBtn.y, self.view.width/2.0f - 0.25f, 50.0f);
        
        [_hintLabel sizeToFit];
        _hintLabel.frame = CGRectMake((_dateBackView.width - _hintLabel.width)/2.0f, CGRectGetMaxY(self.datePicker.frame) - _hintLabel.height - 3.0f, _hintLabel.width, _hintLabel.height);
    }
    
    if (self.controllerType == TradeControllerTypeSimulate) {
        self.tableView.y = 0.0f;
    }
    else {
        self.tableView.y = layoutY;
    }
    self.tableView.height = self.view.height - layoutY;
    self.tableView.width = self.view.width;
    
    self.noneDataView.frame = CGRectMake(0, 0, self.view.width, self.tableView.height - 64);
    
    self.listHeadView.size = CGSizeMake(self.view.width, 27.0f);
    self.tableView.tableHeaderView = self.listHeadView;
    
    
}

- (void)refreshDataList {
    [self requestDataList];
}

- (void)setNoDataViewHidden:(BOOL)hidden{
    _noneDataView.hidden = hidden;
    [self.view setNeedsLayout];
}

- (void)showCalendar{
    _dateBackView.hidden = NO;
    if ([self.dateType isEqualToString:@"end"]) {
        _datePicker.date = _endDate;
    }
    else if ([self.dateType isEqualToString:@"start"]){
        _datePicker.date = _startDate;
    }
    [self.view setNeedsLayout];
}

- (void)dismissCalendar{
    _dateBackView.hidden = YES;
    [self.view setNeedsLayout];
}

- (void)showHintLabel:(NSString *)title{
    [UIView animateWithDuration:0.5 animations:^{
        self.hintLabel.text = title;
        self.hintLabel.hidden = NO;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.hintLabel.hidden = YES;
        }];
    });
}

- (void)touchCancelButton:(UIButton *)btn{
    [self dismissCalendar];
}

- (void)touchConfirmButton:(UIButton *)btn{
    
    NSString * start = [_startDate yyyy_MM_ddFormat];
    NSString * end = [_endDate yyyy_MM_ddFormat];
    NSString * picker = [self.datePicker.date yyyy_MM_ddFormat];
    if ([self.dateType isEqualToString:@"start"]) {
        if ([self.datePicker.date compare:self.endDate] == NSOrderedDescending && ![end isEqualToString:picker]) {
            [self showHintLabel:@"起始时间不能大于截止时间"];
            [self.view setNeedsLayout];
            return;
        }
        else{
            _dateView.startDate = [self.datePicker.date transDateToCurrentDate];
            self.startDate = [self.datePicker.date transDateToCurrentDate];
        }
    }
    else if ([self.dateType isEqualToString:@"end"]){
        if ([self.datePicker.date compare:_todayTime] == NSOrderedDescending) {
            [self showHintLabel:@"截止时间不能大于当前时间"];
            [self.view setNeedsLayout];
            return;
        }
        else if ([_startDate compare:self.datePicker.date] == NSOrderedDescending && ![start isEqualToString:picker]){
            [self showHintLabel:@"截止时间不能小于起始时间"];
            [self.view setNeedsLayout];
            return;
        }
        else{
            _dateView.endDate = [self.datePicker.date transDateToCurrentDate];
            self.endDate = [self.datePicker.date transDateToCurrentDate];
        }
    }
    [self dismissCalendar];
    [self.view setNeedsLayout];
    
}

- (void)startLoadingData{
    [self requestDataList];
}

#pragma mark ==============================================setter、getter、生命周期================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillBecomeForeground) name:@"appEnterForeground" object:nil];
}

//程序回到前台
-(void)appWillBecomeForeground {
    if ([[TradeSessionManager shareInstance] onLine]) {//在线
        [[TradeSessionManager shareInstance]cancelLogout];//取消退出登录
        [self requestDataList];
    }
    else {//不在线
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.controllerType == TradeControllerTypeReal) {
        [self requestDataList];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"-dealListController-viewWillDisappear-");
    [self.dataManager cancelAllRequest];
    [self.simulateManager cancelAllRequest];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"-dealListController-viewDidDisappear-");
    [self.dataManager cancelAllRequest];
    [self.simulateManager cancelAllRequest];
}

-(void)dealloc {
    [self.tableView removePullRefreshView];
    self.tableView.delegate = nil;
    self.tableView = nil;
    self.noneDataView = nil;
    self.dataManager.delegate = nil;
    self.dataManager = nil;
    self.simulateManager = nil;
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"appEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"appEnterForeground" object:nil];
}

#pragma mark ==============================================数据请求================================================

- (void)requestDataList {
    switch (self.viewType) {
        case DealListViewTypeTodayDeal:
            [self.dataManager requestDealList];
            break;
        case DealListViewTypeTodayEntrust:
            [self.dataManager requestEntrustWithdrawList];
            break;
        case DealListViewTypeHistoryDeal:
            [self.dataManager requestDealHistoryListWithStartDate:self.startDate endDate:self.endDate];
            break;
        case DealListViewTypeSimulateHistoryDeal: {
            __block DealListController *welf = self;
            [self.simulateManager requestHistoryTradeListWithCallBack:^(BOOL success, id resultData) {
                [welf requestDealHistoryListResultHandler:resultData andSuccess:success];
            }];
            break;
       
        }
        case DealListViewTypeClearanStock:
      
            break;
    }
}


- (void)requestDataListNextPage {
    switch (self.viewType) {
        case DealListViewTypeTodayDeal:
            break;
        case DealListViewTypeTodayEntrust:
            [self.dataManager requestNextPageEntrustWithdrawList];
            break;
        case DealListViewTypeHistoryDeal:
//            [self.dataManager requestDealHistoryListForNextPage];
            break;
            
        case DealListViewTypeClearanStock:
            
            
//            [self.dataManager requestDealHistoryListForNextPage];
            break;
        case DealListViewTypeSimulateHistoryDeal: {
            __block DealListController *welf = self;
            [self.simulateManager requestHistoryTradeListNextPageWithCallBack:^(BOOL success, id resultData) {
                [welf requestDealHistoryListResultHandler:resultData andSuccess:success];
            }];
            break;
        }
    }
}

#pragma mark ==============================================请求返回================================================

//委托列表 & 委托列表下一页
-(void)getEntrustWithdrawListResultHandler:(id)resultData andSuccess:(BOOL)success {
    [self.tableView stopRefresh];
    if (success) {
        self.dataList = resultData;
        // 先把无数据图片隐藏掉
        if(self.dataList && self.dataList.count > 0) {
            self.listHeadView.hidden = NO;
            self.noneDataView.hidden = YES;;
        }
        else {
            self.listHeadView.hidden = YES;
            self.noneDataView.hidden = NO;
        }
        [self.tableView reloadData];
    }
    else {
        self.dataList = nil;
//        [self.entrustView hideWarningImage:NO];
        NSLog(@"委托列表 & 委托列表下一页-1,%@",resultData);
        [CMProgress showWarningProgressWithTitle:nil message:resultData warningImage:nil duration:3.0f];
    }
}

//当日成交
-(void)requestDealListResultHandler:(id)resultData andSuccess:(BOOL)success {
    [self.tableView stopRefresh];
    if (success) {
        if (![resultData isKindOfClass:[NSArray class]]) {
            NSLog(@"成交列表数据不是数组");
            return;
        }
        _dataList = (NSArray *)resultData;
        
        // 先把无数据图片隐藏掉
        if(self.dataList && self.dataList.count > 0) {
            self.listHeadView.hidden = NO;
            self.noneDataView.hidden = YES;
        }
        else {
            self.listHeadView.hidden = YES;
            self.noneDataView.hidden = NO;
        }
        [self.tableView reloadData];
        [self.view setNeedsLayout];
    }
    else {
        if (![TradeSessionManager shareInstance].sessionID) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [CMProgress showWarningProgressWithTitle:nil message:resultData warningImage:nil duration:3.0f];
    }
}

//历史成交
-(void)requestDealHistoryListResultHandler:(id)resultData andSuccess:(BOOL)success {
    [self.tableView stopRefresh];
    if (success) {
        if (![resultData isKindOfClass:[NSArray class]]) {
            NSLog(@"历史成交列表数据不是数组");
            return;
        }
        self.dataList = resultData;
        // 先把无数据图片隐藏掉
        if(self.dataList && self.dataList.count > 0) {
            self.listHeadView.hidden = NO;
            self.noneDataView.hidden = YES;
        }
        else {
            self.listHeadView.hidden = YES;
            self.noneDataView.hidden = NO;
        }
        [self.tableView reloadData];
    }
    else {
        [CMProgress showWarningProgressWithTitle:nil message:resultData warningImage:nil duration:3.0f];
        if (self.controllerType == TradeControllerTypeSimulate) {
            return;
        }
        if (![TradeSessionManager shareInstance].sessionID) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark ==============================================delegate================================================

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewType == DealListViewTypeTodayEntrust) {//委托
       
        TradeEntrustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEntrustListViewCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.itemVO = [self.dataList objectAtIndex:indexPath.row];
        return cell;
    }
    
    else {//当日or历史成交

        DealListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDealListViewCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.viewType = self.controllerType;
        cell.itemVO = [self.dataList objectAtIndex:indexPath.row];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.dataList.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


#pragma mark -- 下拉刷新和加载下一页

-(void)pullRefreshData{
    
    [self requestDataList];
}

/**
 *  停止滚动时加载下一页数据
 *
 *  @param scrollView 列表TableView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![scrollView isKindOfClass:[UITableView class]]){
        return;
    }
    UITableView *aTableView = (UITableView *)scrollView;
    NSArray *currCells = aTableView.visibleCells;
    if(!currCells || currCells.count == 0){
        return;
    }
    
    UITableViewCell *lastCell = [currCells objectAtIndex:(currCells.count - 1)];
    
    NSIndexPath *indexPath = [aTableView indexPathForCell:lastCell];
    if (indexPath.row != self.dataList.count - 1) {
        return;
    }
    NSLog(@"Next page request...");
    [self requestDataListNextPage];
}

@end
