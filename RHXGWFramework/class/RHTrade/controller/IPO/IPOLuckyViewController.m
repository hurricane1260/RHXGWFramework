//
//  IPOLuckyViewController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/14.
//
//

#import "IPOLuckyViewController.h"
#import "TradeIPOManager.h"
#import "TradeDataManager.h"

@interface IPOLuckyViewController ()<TradeDataManagerDelegate>

kRhPStrong TradeIPOManager * IPOManager;

kRhPStrong NSMutableArray * luckyIPOArray;

kRhPStrong TradeDataManager *tradeDataManager;

@end

@implementation IPOLuckyViewController

#pragma mark -------初始化 生命周期
- (instancetype)init{
    if (self = [super init]) {
        _luckyIPOArray = [NSMutableArray array];
        self.tradeDataManager = [[TradeDataManager alloc]init];
        self.tradeDataManager.delegate = self;
    }
    return self;
}

- (void)dealloc{
    _luckyIPOArray = nil;
    _tradeDataManager = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //可用资金
    [self.tradeDataManager requestDetailFund];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tradeDataManager cancelAllRequest];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
        
    self.queryTableView.frame = CGRectMake(0, CGRectGetMaxY(self.dateView.frame) + 0.5f, self.view.width,self.view.height - self.queryTableView.y);
    self.noDataView.frame = CGRectMake(0, 0, self.view.width, self.queryTableView.height);

}

#pragma mark ---------中签查询
- (void)startLoadingData{
    //中签查询
    [_luckyIPOArray removeAllObjects];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[self.startDate stringWithyyyyMMddFormat] forKey:@"beginDate"];
    [param setObject:[self.endDate stringWithyyyyMMddFormat] forKey:@"endDate"];
    __weak typeof (self) welf = self;
    [CMComponent showLoadingViewWithSuperView:self.view andFrame:self.view.frame];
    [self.IPOManager requestForIPOHisLucky:param withModeId:kIPOLucky completion:^(BOOL success, id resultData) {
        [self setNoDataViewHidden:YES];
        [CMComponent removeComponentViewWithSuperView];
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                [welf setNoDataViewHidden:NO];
                [CMProgress showWarningProgressWithTitle:@"暂无记录" message:nil warningImage:nil duration:1];
                [welf.view setNeedsLayout];
                return;
            }
            [_luckyIPOArray addObjectsFromArray:resultData];
            welf.dataSource.dataList = _luckyIPOArray;
            [welf.queryTableView reloadData];
            [welf.view setNeedsLayout];
        }
        else{
            [CMComponent showRequestFailViewWithSuperView:welf.queryTableView andFrame:CGRectMake(0, 0, welf.queryTableView.width, welf.queryTableView.height) andTouchRepeatTouch:^{
                [welf startLoadingData];
            }];

        }
    }];
}

#pragma mark ---------可用资金回调
-(void)getDetailFundResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        self.transView.usableMoney = [resultData objectForKey:@"enableBalance"];
    }
    else {
        self.transView.usableMoney = @0;
    }
}


@end
