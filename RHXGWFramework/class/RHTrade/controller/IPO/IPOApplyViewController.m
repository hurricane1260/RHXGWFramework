//
//  IPOApplyViewController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/14.
//
//

#import "IPOApplyViewController.h"
#import "TradeIPOManager.h"
#import "TradeDataManager.h"
#import "RHCustomTableView.h"
#import "IPOTabHeaderView.h"
#import "TradeIPOWeekVO.h"
#import "TradeIPOTodayVO.h"
#import "TradeErrorParser.h"

typedef enum : NSInteger{
    SingleAppleType,//单独申购
    AllApplyType,//一键申购
    
}IPOApplyType;

@interface IPOApplyViewController ()<RHBaseTableViewDelegate,TradeDataManagerDelegate,CMAlertDelegate>

kRhPStrong TradeIPOManager * IPOManager;

kRhPStrong NSMutableArray * applyManagerArr;

kRhPStrong NSMutableArray * weekIPOArray;

kRhPStrong NSMutableArray * todayIPOArray;

kRhPStrong NSMutableArray * todayHeaderArr;

kRhPStrong NSMutableArray * ratioIPOArray;

kRhPStrong UIScrollView * bottomScrView;

kRhPStrong RHCustomTableView * todayTableView;

kRhPStrong RHCustomTableView * weekTableView;

kRhPStrong UIButton * fastApplyBtn;

kRhPAssign IPOApplyType  applyType;

kRhPStrong TradeIPOTodayVO *  applyVO;

kRhPStrong NSMutableArray * applyArr;

kRhPAssign NSInteger fastApplyCount;

kRhPAssign NSInteger fastSucCount;
@end

@implementation IPOApplyViewController

#pragma mark -------------------------初始化及生命周期
- (instancetype)init{
    if (self = [super init]) {
        _IPOManager = [[TradeIPOManager alloc] init];
        _weekIPOArray = [NSMutableArray array];
        _todayIPOArray = [NSMutableArray array];
        _ratioIPOArray = [NSMutableArray array];
        _todayHeaderArr = [NSMutableArray array];
        _applyArr = [NSMutableArray array];
        _applyManagerArr = [NSMutableArray array];
        [self initSubviews];

    }
    return self;
}

- (void)dealloc{
    _IPOManager = nil;
    _weekIPOArray = nil;
    _todayIPOArray = nil;
    _ratioIPOArray = nil;
    _todayHeaderArr = nil;
    _applyArr = nil;
    _bottomScrView = nil;
    _todayTableView = nil;
    _weekTableView = nil;
    _fastApplyBtn = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //此结构会多次调用viewWillAppear 为保证监听只一次，在监听前先移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIPOApplyNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIPOApplyNumModNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IPOApply:) name:kIPOApplyNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IPOApplyModifyNum:) name:kIPOApplyNumModNotificationName object:nil];
//    [self startLoadingData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_IPOManager cancelAllDelegate];
    for (TradeDataManager * applyManager in _applyManagerArr) {
        [applyManager cancelAllRequest];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kIPOApplyNotificationName object:nil];
}

- (void)initSubviews{
    _bottomScrView = [[UIScrollView alloc] init];
    _bottomScrView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bottomScrView];
    
    __weak typeof (self) welf = self;
    _todayTableView = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _todayTableView.scrollEnabled = NO;
    _todayTableView.isShowHeaderView = YES;
    [_todayTableView loadSettingWithDataList:_todayIPOArray withHeight:90.0f withGapHeight:0.5f withCellName:@"TradeIPOWeekTableViewCell" withCellID:@"todayCellId"];

    [_todayTableView setTabHeaderViewWithHeaderList:_todayHeaderArr withHeight:27.0f withHeaderViewName:@"IPOTabHeaderView" withHeadId:@"todayId"];

    [_bottomScrView addSubview:_todayTableView];
    
    _weekTableView = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _weekTableView.scrollEnabled = NO;
    _weekTableView.isShowHeaderView = YES;
    [_weekTableView loadSettingWithDataList:_weekIPOArray withHeight:60.0f withGapHeight:0.5f withCellName:@"TradeIPOWeekTableViewCell" withCellID:@"weekCellId"];
    _weekTableView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.weekTableView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    [_bottomScrView addSubview:_weekTableView];
    
    _fastApplyBtn = [UIButton didBuildB1WithTitle:@"一键申购"];
    _fastApplyBtn.enabled = NO;
    [_fastApplyBtn addTarget:self action:@selector(fastApply:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fastApplyBtn];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _bottomScrView.frame = CGRectMake(0, 0, self.view.width, self.view.height - _fastApplyBtn.height);
    
    if (_todayIPOArray.count) {
         _todayTableView.frame = CGRectMake(0, 0, self.bottomScrView.width, _todayIPOArray.count * 90.0f + 27.0f);
    }
    else{
        _todayTableView.frame = CGRectMake(0, 0, self.bottomScrView.width, 90.0f + 27.0f);
    }
    
    _weekTableView.frame = CGRectMake(0, CGRectGetMaxY(_todayTableView.frame) , self.bottomScrView.width, _weekTableView.height);
    _bottomScrView.contentSize = CGSizeMake(self.bottomScrView.width, _todayTableView.height + _weekTableView.height);

    //防止新股数据与一周新股中的新股数据存在差异导致加载错误
    if (_todayIPOArray.count) {
        _bottomScrView.contentSize = CGSizeMake(self.bottomScrView.width, _todayIPOArray.count * 90.0f + 27.0f + _weekTableView.height);
    }
    else{
        _bottomScrView.contentSize = CGSizeMake(self.bottomScrView.width, 90.0f + 27.0f + _weekTableView.height);
    }
    
    _fastApplyBtn.frame = CGRectMake((self.view.width - _fastApplyBtn.width)/2.0f, self.view.height - _fastApplyBtn.height, self.view.width, _fastApplyBtn.height);
}

#pragma mark ---------------------------请求及回调
#pragma mark --------一周新股 今日新股
- (void)startLoadingData{
    
    [_weekIPOArray removeAllObjects];
    [_todayIPOArray removeAllObjects];
    [_todayHeaderArr removeAllObjects];
    
    __weak typeof (self) welf = self;
    //一周新股
    [CMComponent showLoadingViewWithSuperView:self.view andFrame:self.view.frame];
    [_IPOManager requestForIPOWeekWithModeId:kIPOWeekDetail completion:^(BOOL success, id resultData) {
        [CMComponent removeComponentViewWithSuperView];
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[NSDictionary class]]) {
                return;
            }
            _weekIPOArray = [resultData objectForKey:@"newsArr"];
            _ratioIPOArray = [resultData objectForKey:@"todayArr"];
            NSArray * weekHeaderArr = [resultData objectForKey:@"headerArr"];
            
            [_weekTableView setTabHeaderViewWithHeaderList:weekHeaderArr withHeight:27.0f withHeaderViewName:@"IPOTabHeaderView" withHeadId:@"weekId"];
            if (_weekIPOArray.count && weekHeaderArr.count) {
                [_weekTableView reloadDataWithData:@[_weekIPOArray,weekHeaderArr]];
            }
            
            if ([welf getTodayRatioData]) {
                [_todayTableView reloadDataWithData:@[_todayIPOArray,_todayHeaderArr]];
            }
            
        }
        else{
            [CMComponent showRequestFailViewWithSuperView:welf.view andFrame:CGRectMake(0, 0, welf.view.width, welf.view.height) andTouchRepeatTouch:^{
                [welf startLoadingData];
            }];
            [CMProgress showWarningProgressWithTitle:nil message:@"查询一周新股失败" warningImage:nil duration:2];

        }
        [welf.view setNeedsLayout];

    }];
    
    
    //今日新股
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    //修改参数字段
    [param setObject:[[NSDate date] stringWithyyyyMMddFormat] forKey:@"issueDate"];
    [_IPOManager requestForIPOToday:param withModeId:kIPOTodayDetail completion:^(BOOL success, id resultData) {
        [CMComponent removeComponentViewWithSuperView];
        if (success) {
            if ((!resultData || ![resultData isKindOfClass:[NSArray class]]) && ![resultData isKindOfClass:[TradeIPOTodayVO class]]) {
                
                return ;
            }
            if ([resultData isKindOfClass:[NSArray class]]) {
                NSArray * resultArr = resultData;
                if (resultArr.count) {
                    [_todayIPOArray addObjectsFromArray:resultData];
                    [_todayHeaderArr addObject:_todayIPOArray[0]];
                    [_todayTableView setTabHeaderViewWithHeaderList:_todayHeaderArr withHeight:27.0f withHeaderViewName:@"IPOTabHeaderView" withHeadId:@"todayId"];
                    [self setFastApplyBtnEnable];
                    
                    if ([welf getTodayRatioData]) {
                        
                        [_todayTableView reloadDataWithData:@[_todayIPOArray,_todayHeaderArr]];
                    }
                }
            }
            
            else if([resultData isKindOfClass:[TradeIPOTodayVO class]]){
                TradeIPOTodayVO * today = resultData;
                [_todayHeaderArr addObject:today];
                [_todayTableView setTabHeaderViewWithHeaderList:_todayHeaderArr withHeight:27.0f withHeaderViewName:@"IPOTabHeaderView" withHeadId:@"todayId"];
            
                NSString * weekDay = [NSDate getWeekDayFordate:[today.serverTime longLongValue]];
                if ([weekDay isEqualToString:@"周日"] || [weekDay isEqualToString:@"周六"]) {
                    [_todayTableView setHintText:@"未到申购时间"];
                }
                else{
                    NSString * currentStr = [TimeUtils getTimeStringWithNumber:today.serverTime formatString:@"HH"];
                    if ([currentStr integerValue] >= 9) {
                        [_todayTableView setHintText:@"当日没有可申购新股"];
                    }
                    else{
                        [_todayTableView setHintText:@"未到申购时间，请9点再查看！"];
                    }
                }
            }
        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"查询今日新股失败" warningImage:nil duration:2];
        }
        [welf.view setNeedsLayout];
    }];
}

#pragma mark --------从一周新股中获取今日新股的市盈率
- (BOOL)getTodayRatioData{
    if (_ratioIPOArray.count == 0 || _todayIPOArray.count == 0 || _ratioIPOArray.count != _todayIPOArray.count) {
        return NO;
    }
    NSMutableArray * todayArr = [NSMutableArray array];
    for (int i = 0; i < _todayIPOArray.count; i++) {
         TradeIPOTodayVO * today = _todayIPOArray[i];
        for (int j = 0; j < _ratioIPOArray.count; j++) {
            TradeIPOTodayVO * ratio = _ratioIPOArray[j];
            if ([ratio.stockCode isEqualToString:today.stockCode]) {
                today.peRatio = ratio.peRatio;
                [todayArr addObject:today];
            }
        }
    }
    if (todayArr.count == _todayIPOArray.count) {
        [_todayIPOArray removeAllObjects];
        [_todayIPOArray addObjectsFromArray:todayArr];
        return YES;
    }
    return NO;
}

#pragma mark --------------------------申购处理
#pragma mark-----设置一键申购按钮
- (void)setFastApplyBtnEnable{

    self.fastApplyBtn.enabled = NO;
    if (!_todayIPOArray.count) {
        return;
    }
    for (TradeIPOTodayVO * todayVO in _todayIPOArray) {
        if (![todayVO.entrusted boolValue] && MIN([todayVO.enableAmount integerValue], [todayVO.highAmount integerValue]) != 0) {
            self.fastApplyBtn.enabled = YES;
        }
    }
}

#pragma mark-----新股一键申购
- (void)fastApply:(UIButton *)btn{
    self.applyType = AllApplyType;
    [_applyArr removeAllObjects];
    for (TradeIPOTodayVO * IPOVO in _todayIPOArray) {
        //确保未申购状态且申购数量不为0时进行申购
        if (![IPOVO.entrusted boolValue] && [IPOVO.applyAmount integerValue] != 0) {
            [_applyArr addObject:IPOVO];
        }
    }
    if (!_applyArr.count) {
        self.fastApplyBtn.enabled = NO;
        [self.view setNeedsLayout];
        return;
    }
    _fastApplyCount = 0;
    _fastSucCount = 0;
    NSString * hintStr = @"确定要进行一键申购?";
    [self showAlertViewWithSting:hintStr];

}

#pragma mark----申购按钮点击通知
- (void)IPOApply:(NSNotification *)noti{
    self.applyType = SingleAppleType;
    TradeIPOTodayVO * vo = noti.object;
    
    self.applyVO = vo;
    NSString * hintStr = [NSString stringWithFormat:@"确定要申购%@股%@(%@)吗?",vo.applyAmount,vo.stockName,vo.stockCode];
    [self showAlertViewWithSting:hintStr];
    
}

- (void)showAlertViewWithSting:(NSString *)str{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 1) {
        return;
    }
    switch (self.applyType) {
        case SingleAppleType:{
            [self startApply:self.applyVO];
        }break;
        case AllApplyType:{
            [self startFastApply];
        }break;
        default:
            break;
    }
}


#pragma mark-----申购数量修改
- (void)IPOApplyModifyNum:(NSNotification *)noti{
    if (!_todayIPOArray.count) {
        return;
    }
    
    NSDictionary * param = noti.object;
    NSNumber * index = [param objectForKey:@"index"];
    NSNumber * modifyNum = [param objectForKey:@"modifyNum"];
    
    TradeIPOTodayVO * todayVO =  _todayIPOArray[index.integerValue];
    todayVO.applyAmount = modifyNum;
    [_todayIPOArray replaceObjectAtIndex:[index integerValue] withObject:todayVO];
}


#pragma mark----申购操作
- (void)startApply:(id)applyData{
    if (!applyData || ![applyData isKindOfClass:[TradeIPOTodayVO class]]) {
        return;
    }
    TradeIPOTodayVO * IPOVO =  (TradeIPOTodayVO *)applyData;
    NSDictionary * param = [self buildBuyOrSellParam:IPOVO];
    if (!param || !param.count) {
        return;
    }
    TradeDataManager * tradeDataManager = [[TradeDataManager alloc]init];
    tradeDataManager.delegate = self;
    [_applyManagerArr addObject:tradeDataManager];
    [tradeDataManager sendTradeRequestWithPatam:param];
}

#pragma mark-----申购参数
- (NSDictionary *)buildBuyOrSellParam:(id)itemVO{
    if (!itemVO || ![itemVO isKindOfClass:[TradeIPOTodayVO class]]) {
        return nil;
    }
    TradeIPOTodayVO * IPOVO = (TradeIPOTodayVO *)itemVO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:IPOVO.exchangeType forKey:@"exchangeType"];
    [param setValue:IPOVO.stockCode forKey:@"stockCode"];
    [param setValue:IPOVO.applyAmount forKey:@"entrustAmount"];
    [param setValue:IPOVO.lastPrice forKey:@"entrustPrice"];
    [param setValue:@"1" forKey:@"entrustBs"];
    [param setValue:@"0" forKey:@"entrustProp"];

    return param;
}

#pragma mark---------------------------delegate
//委托买卖
-(void)tradeResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (!success) {
        switch (self.applyType) {
            case SingleAppleType:{
                NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
                [CMProgress showWarningProgressWithTitle:@"委托失败" message:errorInfo warningImage:nil duration:2];
                return;
            }
                break;
            case AllApplyType:{
                if ([self countForFastApply]) {
                    //全部请求完毕 刷新页面
                    [self startLoadingData];
                    if (_fastSucCount == 0) {
                        [CMProgress showWarningProgressWithTitle:nil message:@"委托失败" warningImage:nil duration:2];
                    }
                    else{
                        [CMProgress showWarningProgressWithTitle:nil message:@"申购异常,部分申购失败请重新提交" warningImage:nil duration:2];
                    }
                }
                else{
                    [self startFastApply];
                }
                return;
            }break;
            default:
                break;
        }
    }
    switch (self.applyType) {
        case SingleAppleType:{
            [self startLoadingData];
            [CMProgress showWarningProgressWithTitle:nil message:@"委托成功" warningImage:nil duration:1];

        }break;
        case AllApplyType:{
            if ([self countForFastApply]) {
                //全部请求完毕 刷新页面
                [self startLoadingData];
                //最后一次成功时不走下面的请求方法 需在此处增加成功的计数
                _fastSucCount += 1;
                if (_fastSucCount == _applyArr.count) {
                    [CMProgress showWarningProgressWithTitle:nil message:@"委托成功" warningImage:nil duration:1];
                }
                else{
                    [CMProgress showWarningProgressWithTitle:nil message:@"申购异常,部分申购失败请重新提交" warningImage:nil duration:2];
                }
            }
            else{
                _fastSucCount += 1;
                [self startFastApply];
            }
        }break;
        default:
            break;
    }
}

#pragma mark --------快速申购逐一请求
- (void)startFastApply{
    TradeIPOTodayVO * applyVO = _applyArr[_fastApplyCount];
    [self startApply:applyVO];
    
}
#pragma mark --------快速申购计数
- (BOOL)countForFastApply{
    if (_fastApplyCount == _applyArr.count - 1) {
        
        return YES;
    }
    _fastApplyCount += 1;
    return NO;
}

@end
