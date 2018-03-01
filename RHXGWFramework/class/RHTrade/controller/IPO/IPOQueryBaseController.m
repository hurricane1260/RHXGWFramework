//
//  IPOQueryBaseController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/16.
//
//

#import "IPOQueryBaseController.h"
#import "RHCustomTableView.h"
#import "PlaceholderView.h"

@interface IPOQueryBaseController ()

kRhPCopy NSString * dateType;

kRhPStrong RHCustomTableView * tableview;

kRhPStrong UIDatePicker * datePicker;

kRhPStrong UIButton * cancelBtn;

kRhPStrong UIButton * confirmBtn;

kRhPStrong UILabel * hintLabel;

kRhPStrong NSDate * todayTime;

kRhPStrong NSDate * fiveDaysAgo;
@end

@implementation IPOQueryBaseController

#pragma mark -------初始化及生命周期
- (instancetype)init{
    if (self = [super init]) {
        _IPOManager = [[TradeIPOManager alloc] init];
        [self getDefaultDate];
        [self initSubviews];
    }
    return self;
}

- (void)dealloc{
    _IPOManager = nil;
    _tableview = nil;
    _datePicker = nil;
    _cancelBtn = nil;
    _confirmBtn = nil;
    _hintLabel = nil;
    _todayTime = nil;
    _fiveDaysAgo = nil;
    _dateView = nil;
    _queryTableView = nil;
    _transView = nil;
    _dataSource = nil;
    _startDate = nil;
    _endDate = nil;
    _dateBackView = nil;
    _noDataView = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_IPOManager cancelAllDelegate];

}

- (void)initSubviews{
    [self initTransView];
    [self initQueryView];
    [self initTabelView];
    [self initDatePickerView];
}


- (void)initTransView{
    
    _transView = [[IPOTransAccView alloc] init];
    _transView.transCallBack = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kTradeToTransAccNotificationName object:nil];
    };
    [self.view addSubview:_transView];
}

- (void)initQueryView{
    
    __weak typeof (self) welf = self;
    _dateView = [[IPOFiltDateView alloc] init];
    _dateView.startDate = _fiveDaysAgo;
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

- (void)initTabelView{
  
    _dataSource = [[RHDataSource alloc] init];
    _dataSource.cellHeight = 80.0f;
    _dataSource.itemViewClassName = @"IPOQueryTableViewCell";
    _dataSource.cellIndentifier = @"queryCellId";
    
    _queryTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _queryTableView.dataSource = self.dataSource;
    _queryTableView.delegate = self.dataSource;
    _queryTableView.scrollEnabled = YES;
    [self.view addSubview:_queryTableView];
    _queryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.queryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.queryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.queryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.queryTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.noDataView = [[PlaceholderView alloc] initPlaceHolderViewWithCGRect:CGRectMake(0, 0, self.view.width, 200.0f) WithImage:img_noData WithTitle:@"暂无记录"];
    self.noDataView.hidden = YES;
    [self.queryTableView addSubview:self.noDataView];
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

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _transView.frame = CGRectMake(0, 0, self.view.width, 50.0f);
    
    _dateView.frame = CGRectMake(0, CGRectGetMaxY(_transView.frame) + margin_8, self.view.width, 50.0f);
    
    _dateBackView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _datePicker.frame = CGRectMake(0, _dateView.height, self.view.width, 200.0f);

    self.cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(_datePicker.frame) + 0.5f, self.view.width/2.0f - 0.25f, 50.0f);
    self.confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.cancelBtn.frame) +0.5f, self.cancelBtn.y, self.view.width/2.0f - 0.25f, 50.0f);

    [_hintLabel sizeToFit];
    _hintLabel.frame = CGRectMake((_dateBackView.width - _hintLabel.width)/2.0f, CGRectGetMaxY(self.datePicker.frame) - _hintLabel.height - 3.0f, _hintLabel.width, _hintLabel.height);
}


- (void)getDefaultDate{
    _todayTime = [NSDate date];
    _fiveDaysAgo = [NSDate dateWithTimeInterval:- (3600 * 5 * 24) sinceDate:_todayTime];
    _startDate = _fiveDaysAgo;
    _endDate = _todayTime;
}

#pragma mark ------交互、逻辑处理
- (void)setNoDataViewHidden:(BOOL)hidden{
    _noDataView.hidden = hidden;
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

#pragma mark-------请求
- (void)startLoadingData{
    //子类重写
}

@end
