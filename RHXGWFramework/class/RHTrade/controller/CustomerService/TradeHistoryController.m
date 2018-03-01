//
//  TradeHistoryController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/18.
//
//

#import "TradeHistoryController.h"
#import "IPOFiltDateView.h"
#import "LeftTableHeaderView.h"
#import "RightTableHeaderView.h"
#import "TradeSessionManager.h"
#import "LeftTableCell.h"
#import "RightTableCell.h"
#import "XgwSevenManager.h"
#import "HistoryTreadVO.h"
@interface TradeHistoryController ()<UITableViewDelegate,UITableViewDataSource>

kRhPStrong IPOFiltDateView * dateView;
kRhPStrong UIDatePicker * datePicker;
kRhPStrong UIButton * cancelBtn;
kRhPStrong UIButton * confirmBtn;
kRhPStrong UILabel * hintLabel;
kRhPStrong UIView * dateBackView;
kRhPStrong UIView * lineView;
kRhPCopy   NSString * dateType;
kRhPStrong NSDate * startDate;
kRhPStrong NSDate * todayTime;
kRhPStrong NSDate * monthAgo;
kRhPStrong NSDate * endDate;

kRhPStrong UITableView *leftTableView;
kRhPStrong UITableView *rightTableView;
kRhPStrong UIScrollView *leftScrollView;
kRhPStrong UIScrollView *rightScrollView;

kRhPStrong LeftTableHeaderView * leftHeaderView;
kRhPStrong RightTableHeaderView * rightHeaderView;
/*! @brief 用于发送数据请求*/
kRhPStrong XgwSevenManager * historyTreadListManager;
kRhPStrong NSMutableArray *dataList;
kRhPAssign BOOL hasNextPage;
kRhPAssign NSInteger page;
/**提示优化可看更多的箭头*/
kRhPStrong UIImageView * RightPromptArrow;
kRhPStrong UIView * arrowBgView;
kRhPAssign BOOL isRequest;


@end

@implementation TradeHistoryController

-(instancetype)init{
    if (self = [super init ]) {
        self.title= @"历史成交";
        self.view.backgroundColor = color1_text_xgw;
        
        self.historyTreadListManager = [[XgwSevenManager alloc]init];
        self.page = 1;
        self.isRequest = YES;
        [self getDefaultDate];
        [self initSubViews];
    }
    
    return self;
}
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(void)initSubViews{
    
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = color16_other_xgw;
    self.lineView = lineView;
    [self.view addSubview:self.lineView];
    
    
    UIScrollView * leftScrollView = [[UIScrollView alloc]init];
    leftScrollView.showsVerticalScrollIndicator = NO;
    leftScrollView.showsHorizontalScrollIndicator = NO;
    self.leftScrollView = leftScrollView;
    [self.view addSubview:self.leftScrollView];
    
    
    UIScrollView * rightScrollView = [[UIScrollView alloc]init];
    rightScrollView.showsVerticalScrollIndicator = NO;
    rightScrollView.showsHorizontalScrollIndicator = NO;
    rightScrollView.delegate = self;
    rightScrollView.bounces = NO;
    self.rightScrollView = rightScrollView;
    [self.view addSubview:self.rightScrollView];
    
    
    UITableView *leftTableView = [[UITableView alloc] init];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.showsVerticalScrollIndicator = NO;
    leftTableView.showsHorizontalScrollIndicator = NO;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.leftTableView = leftTableView;
    [self.leftScrollView addSubview:self.leftTableView];
    
    self.leftHeaderView = [[LeftTableHeaderView alloc]init];
    self.leftTableView.tableHeaderView = self.leftHeaderView;
    
    
    UITableView *rightTableView = [[UITableView alloc] init];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.showsVerticalScrollIndicator = NO;
    rightTableView.showsHorizontalScrollIndicator = NO;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView = rightTableView;
    [self.rightScrollView addSubview:self.rightTableView];
    
    self.rightHeaderView = [[RightTableHeaderView alloc]init];
    self.rightTableView.tableHeaderView = self.rightHeaderView;
    self.rightHeaderView.titleList = @[@"成交价",@"成交量",@"成交额",@"佣金",@"印花税",@"过户费",@"备注"];
    
    [self.leftTableView registerClass:[LeftTableCell class] forCellReuseIdentifier:[LeftTableCell reuseIdentifier]];
    [self.rightTableView registerClass:[RightTableCell class] forCellReuseIdentifier:[RightTableCell reuseIdentifier]];
    
    self.arrowBgView = [[UIView alloc]init];
    self.arrowBgView.backgroundColor = color1_text_xgw;
    [self.view addSubview:self.arrowBgView];
    
    self.RightPromptArrow = [[UIImageView alloc]init];
    self.RightPromptArrow.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/historyicon_move"];
    [self.arrowBgView addSubview:self.RightPromptArrow];

    

    [self initQueryView];
    [self initDatePickerView];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat layoutY = self.layoutStartY;
    _dateView.frame = CGRectMake(0, layoutY, self.view.width, 50.0f);
    layoutY += 50.0f;
    
    _lineView.frame = CGRectMake(0, layoutY, self.view.width, 8);
    layoutY+=8.0f;
    
    UIImage * image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/historyicon_move"];

    self.arrowBgView.frame =CGRectMake(self.view.width-15-image.size.width, CGRectGetMaxY(self.lineView.frame), image.size.width+15, 30);
    
    self.RightPromptArrow.frame = CGRectMake(0, (self.arrowBgView.height-image.size.height)/2, image.size.width, image.size.height);
  
    
    _dateBackView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
    _datePicker.frame = CGRectMake(0, _dateView.height, self.view.width, 200.0f);
    
    self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_datePicker.frame) + 0.5f, self.view.width/2.0f - 0.25f, 50.0f);
    self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) +0.5f, self.cancelBtn.y, self.view.width/2.0f - 0.25f, 50.0f);
    
    [_hintLabel sizeToFit];
    _hintLabel.frame = CGRectMake((_dateBackView.width - _hintLabel.width)/2.0f, CGRectGetMaxY(self.datePicker.frame) - _hintLabel.height - 3.0f, _hintLabel.width, _hintLabel.height);
    
    CGFloat leftScrollWidth = 100;
    self.leftScrollView.frame = CGRectMake(0, layoutY, leftScrollWidth, kDeviceHeight-layoutY);
    
    self.rightScrollView.frame = CGRectMake(leftScrollWidth, layoutY, self.view.size.width-leftScrollWidth,self.view.size.height-layoutY);
    
    self.leftTableView.frame = CGRectMake(0, 0, leftScrollWidth, self.view.size.height-layoutY);
    
    self.leftHeaderView.frame = CGRectMake(0, 0, 100, 30);
    self.leftTableView.tableHeaderView = self.leftHeaderView;

    self.rightHeaderView.frame = CGRectMake(0, 0, [self.rightHeaderView getCurrentWidth], 30);
    self.rightTableView.frame = CGRectMake(0, 0, self.rightHeaderView.frame.size.width, self.view.size.height-layoutY);
    
    self.rightTableView.tableHeaderView = self.rightHeaderView;
    
    [self.leftScrollView setContentSize:_leftTableView.frame.size];
    [self.rightScrollView setContentSize:_rightTableView.frame.size];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillBecomeForeground) name:@"appEnterForeground" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDataList];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.historyTreadListManager cancelAllDelegate];
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
        welf.page = 1;
        if (welf.isRequest) {
            welf.isRequest = NO;
            [welf startLoadingData];
            
        }
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
- (void)startLoadingData{
    [self requestDataList];
}
- (void)getDefaultDate{
    _todayTime = [NSDate date];
    _monthAgo = [NSDate dateWithTimeInterval:- (3600 * 30 * 24) sinceDate:_todayTime];
    _startDate = _monthAgo;
    _endDate = _todayTime;
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

#pragma mark--数据请求
- (void)requestDataList {
    
    if (self.page == 1) {
        if (self.dataList) {
            [self.dataList removeAllObjects];
        }
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
     [param setObject:[TradeSessionManager shareInstance].onLineAccount forKey:@"fundAccount"];
    [param setObject:[self.startDate stringWithyyyyMMddFormat] forKey:@"startDate"];
    [param setObject:[self.endDate stringWithyyyyMMddFormat] forKey:@"endDate"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:@"cp"];
//    [param setValue:@"1" forKey:@"cp"];
    [param setObject:@"" forKey:@"ps"];
    
    
    
   [self.historyTreadListManager requestHistoryTreadListParam:param completion:^(BOOL isSuccess, id resultData) {
       [CMComponent removeComponentViewWithSuperView];
       self.isRequest = YES;
       if (isSuccess) {
           HistoryTreadVO * VO  = resultData;
           
           if (VO.data!= nil && ![VO.data isKindOfClass:[NSNull class]] && VO.data.count != 0){
           }else{
               //数据源数据为空
               [CMComponent showNoDataWithSuperView:self.view andFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.view.width, self.view.size.height-self.lineView.origin.y-self.lineView.size.height)];
               
               [self.view bringSubviewToFront:_dateBackView];

           }
           self.hasNextPage = VO.hasNextPage;
           self.page = [VO.currentPage integerValue];
           [self.dataList addObjectsFromArray:VO.data];
           [self.leftTableView reloadData];
           [self.rightTableView reloadData];
           
       }else{
           
           //请求失败
           [CMComponent showRequestFailViewWithSuperView:self.view andFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.view.width, self.view.size.height-self.lineView.origin.y-self.lineView.size.height ) andTouchRepeatTouch:^{
               [self requestDataList];

           }];
           [self.view bringSubviewToFront:_dateBackView];

           
       }
       [self.view setNeedsLayout];
   }];
}

#pragma mark-- tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        LeftTableCell * leftCell = [tableView dequeueReusableCellWithIdentifier:[LeftTableCell reuseIdentifier]];
        if (self.dataList.count!=0) {
            leftCell.cellData = self.dataList[indexPath.row];
 
        }
        leftCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return leftCell;
    }else if(tableView == self.rightTableView){
        RightTableCell * rightCell = [tableView dequeueReusableCellWithIdentifier:[RightTableCell reuseIdentifier]];
        if (self.dataList.count!=0) {
            rightCell.cellData = self.dataList[indexPath.row];
        }
        rightCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return rightCell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_leftTableView]) {
        self.rightTableView.contentOffset = _leftTableView.contentOffset;
    } else {
        self.leftTableView.contentOffset = _rightTableView.contentOffset;
    }
    if ([scrollView isEqual:_rightScrollView]) {
        if (_rightScrollView.contentOffset.x>80) {
            self.arrowBgView.hidden = YES;
        }
    }
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
-(void)requestDataListNextPage{
    
    if (self.hasNextPage) {
        self.page++;
        [self requestDataList];
    }else{
        [CMProgress showWarningProgressWithTitle:nil message:@"已无更多" warningImage:nil duration:0.5f];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
