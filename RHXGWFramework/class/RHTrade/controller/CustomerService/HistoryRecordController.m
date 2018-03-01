//
//  HistoryRecordController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/27.
//
//

#import "HistoryRecordController.h"
#import "IPOFiltDateView.h"
#import "HistoryRecordCell.h"
#import "XgwSevenManager.h"
#import "HistoryRecordVO.h"
#import "MJRefresh.h"
#import "TradeSessionManager.h"


@interface HistoryRecordController ()<UITableViewDelegate,UITableViewDataSource>

kRhPStrong IPOFiltDateView * dateView;
kRhPStrong UIDatePicker * datePicker;
kRhPCopy NSString * dateType;

kRhPStrong UIButton * cancelBtn;

kRhPStrong UIButton * confirmBtn;

kRhPStrong UILabel * hintLabel;

kRhPStrong NSDate * todayTime;

kRhPStrong NSDate * monthAgo;

kRhPStrong NSDate * startDate;

kRhPStrong NSDate * endDate;

kRhPStrong UIView * dateBackView;

kRhPStrong UIView * lineView;
/**列表*/
kRhPStrong UITableView * tabelView;
kRhPStrong NSMutableArray * dataArray;
kRhPStrong XgwSevenManager * requestManger;
kRhPAssign MJRefreshAutoNormalFooter *footer;
kRhPAssign BOOL hasNextPage;
kRhPAssign NSInteger page;





@end

@implementation HistoryRecordController

-(instancetype)init{
    if (self = [super init]) {
        self.title= @"历史转账记录";
        self.view.backgroundColor = color1_text_xgw;
        self.requestManger = [[XgwSevenManager alloc]init];
        self.page = 1;
        [self getDefaultDate];
        [self initSubViews];
    }
    return self;
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}
#pragma 获取默认时间段
-(void)getDefaultDate{
    
    _todayTime = [NSDate date];
    _monthAgo = [NSDate pastDateAndAfterDateWithCurrentDate:_todayTime year:0 month:-1 day:0];
    _startDate = _monthAgo;
    _endDate = _todayTime;
}
- (void)initSubViews{
    [self initQueryView];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = color16_other_xgw;
    [self.view addSubview:self.lineView];
    
    
    UITableView *TableView = [[UITableView alloc] init];
    [TableView addPullRefreshView];
    TableView.delegate = self;
    TableView.dataSource = self;
    TableView.showsVerticalScrollIndicator = NO;
    TableView.showsHorizontalScrollIndicator = NO;
    TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabelView = TableView;
    [self.view addSubview:self.tabelView];
    
     self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tabelView.mj_footer =  self.footer;

    
    
    [self initDatePickerView];

    
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
         welf.page = 1;
        [welf requestHistoryRecordData];
        [welf dismissCalendar];
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
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat layoutY = self.layoutStartY;
    _dateView.frame = CGRectMake(0, layoutY, self.view.width, 50.0f);
    layoutY += 50.0f;
    
    self.lineView.frame = CGRectMake(0, layoutY, self.view.width, 8);
    
    _dateBackView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
    _datePicker.frame = CGRectMake(0, _dateView.height, self.view.width, 200.0f);
    
    self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_datePicker.frame) + 0.5f, self.view.width/2.0f - 0.25f, 50.0f);
    self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) +0.5f, self.cancelBtn.y, self.view.width/2.0f - 0.25f, 50.0f);
    
    [_hintLabel sizeToFit];
    _hintLabel.frame = CGRectMake((_dateBackView.width - _hintLabel.width)/2.0f, CGRectGetMaxY(self.datePicker.frame) - _hintLabel.height - 3.0f, _hintLabel.width, _hintLabel.height);
    
    self.tabelView.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.view.width, self.view.height-self.lineView.origin.y-self.lineView.size.height);
    
    
 }
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"jy_yzzz_history_list"];

    [self requestHistoryRecordData];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.requestManger cancelAllDelegate];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)requestHistoryRecordData{
    [CMComponent removeComponentViewWithSuperView];
 
    if (self.page ==1) {
        if (self.dataArray) {
            [self.dataArray removeAllObjects];
        }
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
     [param setObject:[TradeSessionManager shareInstance].onLineAccount forKey:@"fundAccount"];
   // [param setObject:@"65502706" forKey:@"fundAccount"];
    
    [param setObject:[self.startDate stringWithyyyyMMddFormat] forKey:@"startDate"];
    [param setObject:[self.endDate stringWithyyyyMMddFormat] forKey:@"endDate"];
    //[param setObject:@"20120131" forKey:@"startDate"];
    //[param setObject:@"20120131" forKey:@"endDate"];
    [param setValue:[NSString ifStringisNull:[NSString stringWithFormat:@"%ld",(long)self.page]] forKey:@"cp"];
    [param setObject:@"" forKey:@"ps"];
     [CMComponent showLoadingViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY+self.dateView.size.height+self.lineView.size.height, self.view.width,self.view.size.height-self.dateView.size.height-self.lineView.size.height-self.layoutStartY)];
    
    [self.requestManger requestHistoryRecordWithParam:param completion:^(BOOL isSuccess, id resultData) {
        [self.tabelView stopRefresh];
        [CMComponent removeComponentViewWithSuperView];

        if (isSuccess) {
            HistoryRecordVO * VO = resultData;
            self.hasNextPage = VO.hasNextPage;
            self.page = [VO.currentPage integerValue];
            [self.dataArray addObjectsFromArray:VO.data];
            [self.tabelView.mj_footer endRefreshing];

            if (self.dataArray!= nil && ![self.dataArray isKindOfClass:[NSNull class]] && self.dataArray.count != 0){
            }else{
                //数据源数据为空
                [CMComponent showNoDataWithSuperView:self.tabelView andFrame:CGRectMake(0, 0, self.view.width, self.tabelView.size.height)];
            }
            
            //判断是否有下一页对下方加载提示文字的显示不同状态
            if (self.page ==1) {
                if (!self.hasNextPage) {
                    
                    if (self.dataArray.count*60+self.layoutStartY+self.dateView.size.height+self.lineView.size.height>kDeviceHeight) {
                         self.tabelView.mj_footer.hidden = NO;
                         [self.tabelView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        self.tabelView.mj_footer.hidden = YES;

                    }
                }else{
                    self.tabelView.mj_footer.hidden = NO;
 
                }
            }else{
                if (!self.hasNextPage) {
//                    [self.footer setTitle:@"数据加载完毕" forState:MJRefreshStateNoMoreData];
                    [self.tabelView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            [self.tabelView reloadData];

            
        }else{
            
            //请求失败
            [CMComponent showRequestFailViewWithSuperView:self.tabelView andFrame:CGRectMake(0, 0, self.view.width, self.tabelView.size.height ) andTouchRepeatTouch:^{
                [self requestHistoryRecordData];
            }];
        }

        [self.view setNeedsLayout];
    }];
    

}
#pragma mark--下拉刷新
-(void)pullRefreshData{
   
    self.page = 1;
    [self requestHistoryRecordData];
}
-(void)loadMoreData{
    
    if (self.hasNextPage) {
        self.page++;
        
        [self requestHistoryRecordData];
        
    }else{
        [self.tabelView.mj_footer endRefreshingWithNoMoreData];
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:[HistoryRecordCell cellReuseIdentifier]];
    if (!cell) {
        cell = [[HistoryRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HistoryRecordCell cellReuseIdentifier]];
    }
    if (self.dataArray.count!=0) {
        cell.cellData = self.dataArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
