//
//  TradeController.m
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeController.h"
#import "CMHeaderBar.h"

#import "TradeStockController.h"
#import "TradeBuySellController.h"
#import "TradeWithdrawController.h"
#import "TradeListsController.h"
#import "DealListController.h"

//#import "CandleStickController.h"
#import "TradeLoginController.h"
//#import "BaseNavigationController.h"
#import "TradeNavigationManager.h"
#import "TradeSessionManager.h"
#import "PresentModalManager.h"

#import "Reachability.h"
#import "SKCodeTable.h"

//#import "RHStockDetailNavManager.h"
#import "RHtoCRHNaviManager.h"
#import "MNNavigationManager.h"

@interface TradeController ()<UIScrollViewDelegate, CMHeaderBarDelegate, CMAlertDelegate, TradeStockDelegate, TradeListsDelegate>

@property (nonatomic, assign) TradeControllerType viewType;

@property (nonatomic, strong) CMHeaderBar *headBar;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) TradeLoginController *loginView;

@property (nonatomic, strong) TradeStockController *stockController;//持仓

@property (nonatomic, strong) TradeBuySellController *buyController;//买入

@property (nonatomic, strong) TradeBuySellController *sellController;//卖出

@property (nonatomic, strong) TradeWithdrawController *entrustController;//撤单

@property (nonatomic, strong) TradeListsController *itemizeController;//明细

@property (nonatomic, strong) UIButton *logoutButton;//退出

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *tempBuyCode;

@property (nonatomic, copy) NSString *tempSellCode;

/*! @brief 是选中的index */
@property (nonatomic, assign) BOOL isSelectedIndex;

@property (nonatomic, assign) BOOL loginViewHasPresented;

@property (nonatomic, assign) BOOL isLogout;

@property (nonatomic, assign) BOOL isCRHOpenAccount;

@property (nonatomic,strong)  NSDictionary * openAccountParam;

@end

@implementation TradeController

#pragma mark ==============================================初始化&布局================================================

static CGFloat kHintTimeInterval = 3.0f;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"交易";
        [self initSubviews];
        self.viewType = TradeControllerTypeReal;
        self.tempBuyCode = nil;
        self.tempSellCode = nil;
        self.isLogout = NO;
        self.isCRHOpenAccount = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipToBuy:) name:@"ToBuy" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipToSell:) name:@"ToSell" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tradeLoginCancled) name:kTradeLoginCancledNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigationToCRH:) name:kTradeLoginPushToCRHNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crhPopHandler) name:kCRHPopNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutButtonTouchHandler) name:@"logoutTradeNotificationName" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ToCustomServiceVC) name:@"ToCustomServiceVC" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ToOpenAccountVC) name:@"ToOpenAccountVC" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeBackground) name:@"appEnterBackground" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillBecomeForeground) name:@"appEnterForeground" object:nil];
        //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillResignActive) name:@"appResignActive" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(containerSelectTrade:) name:@"TradeIsSelectedIndex" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillTerminate) name:@"appWillTerminate" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hcAccountLoginSuccesshandler) name:@"hcAccountLogin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccessHandler) name:@"transferMoneySuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tradeLoginViewPresentHandler:) name:@"TradeLoginViewHasPresented" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        /**接收外面传的过来的渠道号 还有佣金*/
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Receiveparam:) name:@"Receiveparam" object:nil];

        
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)initSubviews {
    NSArray *titleList = @[@"持仓",@"买入",@"卖出",@"撤单",@"更多"];
    NSArray *valueList = @[@"0",@"1",@"2",@"3",@"4"];
    NSDictionary *titleMap = [NSDictionary dictionaryWithObjects:valueList forKeys:titleList];
    self.headBar = [[CMHeaderBar alloc]initWithTitleList:titleMap titleList:titleList titleColor:color2_text_xgw highlightedColor:color6_text_xgw titleFontSize:14 delegate:self];
    [self.view addSubview:self.headBar];
    [self.headBar setSelectedIndex:0];
    self.headBar.backgroundColor = [UIColor whiteColor];
    
    UIView *headBarLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5f, self.view.width, 0.5f)];
    headBarLine.backgroundColor = color16_other_xgw;
    [self.headBar addSubview:headBarLine];
    
    self.contentView = [[UIScrollView alloc]init];
    [self.view addSubview:self.contentView];
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.pagingEnabled = YES;
    
    self.stockController  = [[TradeStockController alloc]init];
    [self addChildViewController:self.stockController];
    self.stockController.delegate = self;
    [self.contentView addSubview:self.stockController.view];
    
    self.buyController = [[TradeBuySellController alloc]init];
    [self addChildViewController:self.buyController];
    [self.contentView addSubview:self.buyController.view];
    self.buyController.viewType = TradeBuySellViewTypeBuy;
    
    self.sellController = [[TradeBuySellController alloc]init];
    [self addChildViewController:self.sellController];
    [self.contentView addSubview:self.sellController.view];
    self.sellController.viewType = TradeBuySellViewTypeSell;
    
    self.entrustController = [[TradeWithdrawController alloc]init];
    [self addChildViewController:self.entrustController];
    [self.contentView addSubview:self.entrustController.view];
    
    self.itemizeController = [[TradeListsController alloc]init];
    [self addChildViewController:self.itemizeController];
    [self.contentView addSubview:self.itemizeController.view];
    self.itemizeController.delegate = self;
    
    self.logoutButton = [UIButton didBuildButtonWithTitle:@"掌厅" normalTitleColor:color5_text_xgw highlightTitleColor:color5_text_xgw disabledTitleColor:color5_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
    self.logoutButton.titleLabel.font = font2_common_xgw;
    self.rightButtonView = self.logoutButton;
    [self.logoutButton addTarget:self action:@selector(navigationToCRHBusiness) forControlEvents:UIControlEventTouchUpInside];

}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat layoutY = self.layoutStartY;
    
    self.headBar.y = layoutY;
    self.headBar.width = self.view.width;
    self.headBar.height = 44.0f;
    layoutY += self.headBar.height;
    
    self.contentView.y = layoutY;
    self.contentView.height = self.view.height - layoutY;
    self.contentView.width = self.view.width;
    self.contentView.contentSize = CGSizeMake(self.view.width * 5, self.contentView.height);
    self.contentView.delegate = self;
    
    CGFloat layoutX = 0.0f;
    CGFloat width = self.view.width;
    CGFloat height = self.contentView.height;
    
    self.stockController.view.x = 0.0f;
    self.stockController.view.width = width;
    self.stockController.view.height = height;
    layoutX += width;
    
    self.buyController.view.x = layoutX;
    self.buyController.view.width = width;
    self.buyController.view.height = height;
    layoutX += width;
    
    self.sellController.view.x = layoutX;
    self.sellController.view.width = width;
    self.sellController.view.height = height;
    layoutX += width;
    
    self.entrustController.view.x = layoutX;
    self.entrustController.view.width = width;
    self.entrustController.view.height = height;
    layoutX += width;
    
    self.itemizeController.view.x = layoutX;
    self.itemizeController.view.width = width;
    self.itemizeController.view.height = height;
    
    UILabel *tempLabel = self.logoutButton.titleLabel;
    [tempLabel sizeToFit];
    self.logoutButton.width = tempLabel.width;
    self.logoutButton.height = 44.0f;
    self.logoutButton.x = self.view.width - self.logoutButton.width - 15.0f;
}

#pragma mark ==============================================setter、getter、生命周期================================================

-(TradeLoginController *)loginView {
    if (!_loginView) {
        _loginView = [[TradeLoginController alloc]init];
    }
    NSNumber * secondTradeNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"isSecondTrade"];
    if (secondTradeNum.boolValue) {
        _loginView.showCancleButton = YES;
    } else {
        _loginView.showCancleButton = NO;
    }
    return _loginView;
}

- (void)setViewType:(TradeControllerType)aType {
    _viewType = aType;
    self.stockController.viewType = aType;
    self.buyController.controllerType = aType;
    self.sellController.controllerType = aType;
    self.entrustController.viewType = aType;
    self.itemizeController.viewType = aType;
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    self.backButtonHidden = !aBool;
    self.stockController.isSecondTrade = aBool;
    self.buyController.isSecondTrade = aBool;
    self.sellController.isSecondTrade = aBool;
    self.entrustController.isSecondTrade = aBool;
    [[NSUserDefaults standardUserDefaults] setObject:@(aBool) forKey:@"isSecondTrade"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.backButtonHidden = !self.isSecondTrade;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.isSecondTrade) forKey:@"isSecondTrade"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.navigationController.view.height = keyAppWindow.height;
        //    NSLog(@"---%s------2",__func__);
    if (![[TradeSessionManager shareInstance] onLine]) {
        if (self.loginViewHasPresented) {
            return;
        }
        [PresentModalManager presentModalView:self.loginView.view animation:NO completion:nil];
    }
//    else {
//        [self requestPushMsg];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navToIPOPage) name:kTradeToIPONotificationName object:nil];
    

    [MTA trackPageViewBegin:@"c_transaction_page"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[TradeSessionManager shareInstance] onLine]) {
        [self refreshControllerData];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTradeToIPONotificationName object:nil];
    
    if (self.headBar.selectedIndex == 2) {
        [self.sellController stopReceivePushData];
    }
    else if (self.headBar.selectedIndex == 1) {
        [self.buyController stopReceivePushData];
    }

        [self.timer invalidate];
        self.timer = nil;
   
    [MTA trackPageViewEnd:@"c_transaction_page"];
}

#pragma mark ==============================================交互================================================

- (void)backButtonTouchHandler:(id)sender {
    [[TradeSessionManager shareInstance]waitForLogout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeButtonTouchHandler {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutButtonTouchHandler {
    [CMAlert show:@"确定退出登录？" superView:self.view titleList:@[@"取消",@"确认"] andDelegate:self];
}

- (void)navigationToCRHBusiness
{
    [RHtoCRHNaviManager navigationToCRHControllerWithCurrent:self];
}

- (void)refreshControllerData {
    if (self.isLogout) {
        return;
    }
    if (self.headBar.selectedIndex == 0) {
        [self.stockController refreshData];
    }
    else if (self.headBar.selectedIndex == 1) {
        [self.buyController refreshData];
    }
    else if (self.headBar.selectedIndex == 2) {
        [self.sellController refreshData];
    }
    else if (self.headBar.selectedIndex == 3){
        [self.entrustController refreshData];
    }
    NSLog(@"刷新持仓数据");
}

#pragma mark ==============================================通知================================================

//hc账号登录通知反馈
-(void)hcAccountLoginSuccesshandler {
    if (self.tempBuyCode) {
        self.buyController.viewStockCode = self.tempBuyCode;
        self.tempBuyCode = nil;
    }
    if (self.tempSellCode) {
        self.sellController.viewStockCode = self.tempSellCode;
        self.tempSellCode = nil;
    }
    [self refreshControllerData];
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(refreshControllerData) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}

//程序到后台
-(void)appDidBecomeBackground {
    [[TradeSessionManager shareInstance]waitForLogout];//准备退出交易登录
    if (self.headBar.selectedIndex == 2) {
        [self.sellController stopReceivePushData];
    }
    else if (self.headBar.selectedIndex == 1) {
        [self.sellController stopReceivePushData];
    }
}

//程序进入非活动状态
//- (void)appWillResignActive {
//
//}

//程序退出
- (void)appWillTerminate {
    [[TradeSessionManager shareInstance]destroySession];
}

//程序回到前台
-(void)appWillBecomeForeground {
    if (self.isCRHOpenAccount) {
        return;
    }
    if ([[TradeSessionManager shareInstance] onLine]) {//在线
        [[TradeSessionManager shareInstance] cancelLogout];//取消退出登录
        [self refreshControllerData];
    }
    else {//不在线
        if (!self.isSelectedIndex) {//当前没选择交易
            return;
        }
        if (self.loginViewHasPresented) {
            return;
        }
        if (self.navigationController.viewControllers.count > 1) {
            self.loginView.isNeedFullScreen = YES;
        }
//        [PresentModalManager presentModalView:self.loginView.view animation:NO completion:nil];
    }
}

//reachablity
- (void) reachabilityChanged: (NSNotification*)note {
///    [TradeSessionManager shareInstance].onLine = NO;
///    [TradeSessionManager shareInstance].sessionID = nil;
    if (!self.isSelectedIndex && !self.isSecondTrade) {
        return;
    }
        Reachability * reach = [note object];
    
    //    if(reach.currentReachabilityStatus == NotReachable) {//网络不可用
    //        [TradeSessionManager shareInstance].sessionID = nil;
    //        return;
    //    }
    //    else {
    //        if ([TradeSessionManager shareInstance].sessionID) {
    //            NSLog(@"sessionId存在");
    //            return;
    //        }
//    if (self.loginViewHasPresented) {
//        return;
//    }
//    if (self.navigationController.viewControllers.count > 1) {
//        self.loginView.isNeedFullScreen = YES;
//    }
//    [PresentModalManager presentModalView:self.loginView.view animation:NO completion:nil];
    //    }
    
    if (reach.currentReachabilityStatus == NotReachable) {
        
        [self.timer setFireDate:[NSDate distantFuture]];
        
    } else {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}
-(NSTimer *)timer{
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(refreshControllerData) userInfo:nil repeats:YES];
        [_timer fire];
    }
    return _timer;
}
//是否选择了交易
-(void)containerSelectTrade:(NSNotification *)notify {
    NSNumber *number = notify.object;
    self.isSelectedIndex = number.boolValue;
}

//转账成功
-(void)transferSuccessHandler {
    [CMProgress showWarningProgressWithTitle:nil message:@"转账申请提交成功" warningImage:nil duration:kHintTimeInterval];
}

- (void)tradeLoginCancled {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

//自选股
- (void)skipToBuy:(NSNotification *)sender {
//    NSLog(@"---------1");
    if (!self.isSecondTrade) {//不是二级交易
        return;
    }
    [self.headBar setSelectedIndex:1];
    NSArray *list = [sender.object componentsSeparatedByString:@"_"];
    NSString *stockCode = [list lastObject];
    if ([TradeSessionManager shareInstance].onLine) {
        self.buyController.viewStockCode = stockCode;
    }
    else {//还没有创建session，缓存之
        self.tempBuyCode = stockCode;
    }
}

- (void)skipToSell:(NSNotification *)sender {
//    NSLog(@"---------2");
    if (!self.isSecondTrade) {//不是二级交易
        return;
    }
    [self.headBar setSelectedIndex:2];
    NSArray *list = [sender.object componentsSeparatedByString:@"_"];
    NSString *stockCode = [list lastObject];
    if ([TradeSessionManager shareInstance].onLine) {
        self.sellController.viewStockCode = stockCode;
    }
    else {//还没有创建session，缓存之
        self.tempSellCode = stockCode;
    }
}

    //登录界面正在展示
- (void)tradeLoginViewPresentHandler:(NSNotification *)notify {
    NSNumber *boolNumber = notify.object;
    self.loginViewHasPresented = boolNumber.boolValue;
}

- (void)navigationToCRH:(NSNotification *)notify {
    self.isCRHOpenAccount = YES;//标记已经present了开户
    NSNumber *isSecondTrade = notify.object;
    [PresentModalManager dismissModalView:self.loginView.view animation:NO completion:nil];
    
    if (isSecondTrade.boolValue) {
        [RHtoCRHNaviManager navigationToCRHOpenAccountWithCurrent:self];
    }
    else {

      [RHtoCRHNaviManager navigationToCRHOpenAccountWithHeadBanner:self];
    }
    
}
-(void)ToCustomServiceVC{

    self.isCRHOpenAccount = YES;//标记已经present了开户
    [PresentModalManager dismissModalView:self.loginView.view animation:NO completion:nil];
    [MNNavigationManager navigationToCustomServiceVC:self];
}
- (void)crhPopHandler {
    self.isCRHOpenAccount = NO;
}

- (void)navToIPOPage{
    [TradeNavigationManager navigationToIPOController:self];
}

- (void)ToOpenAccountVC{
    

    NSString * channel = [self.openAccountParam objectForKey:@"channel"];
    NSString * commission = [self.openAccountParam objectForKey:@"commission"];
    if (commission.length==0) {
        commission = @"0.025%";
    }
    
    self.isCRHOpenAccount = YES;//标记已经present了开户
    [PresentModalManager dismissModalView:self.loginView.view animation:NO completion:nil];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    if ([self.openAccountParam objectForKey:@"channel"]) {
        [param setObject:channel forKey:@"short_url"];
    }
        [param setObject:commission forKey:@"commission"];
    
    [MNNavigationManager navigationToUniversalVC:self withClassName:kRHOpenAccountControllerClassName withParam:param];

}
-(void)Receiveparam:(NSNotification *)noti{
    if ([noti.object isKindOfClass:[NSDictionary class]]) {
        
        self.openAccountParam = noti.object;
    }
    
}


#pragma mark ==============================================delegate================================================

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = self.contentView.contentOffset.x / self.view.width;
//    NSLog(@"-----%d",index);
    [self.headBar setSelectedIndex:index];
}

-(void)didBarItemSelected:(id)selectedData {
//    NSLog(@"---------2");
    NSNumber *indexNumber = selectedData;
    NSUInteger index = indexNumber.integerValue;
    [UIView animateWithDuration:kAnimationTimerInterval animations:^{
        self.contentView.contentOffset = CGPointMake(index * self.view.width, 0.0f);
    }];
    if (![TradeSessionManager shareInstance].onLine && self.viewType == TradeControllerTypeReal) {
        return;
    }
    if (index != 1) {
        [self.buyController stopReceivePushData];
    }
    else {
        self.buyController.view.height = self.contentView.height;
    }
    
    if (index != 2) {
        [self.sellController stopReceivePushData];
    }
    else {
        self.sellController.view.height = self.contentView.height;
    }
    [self refreshControllerData];
}

//持仓view delegate,跳转到买卖、看行情
-(void)tradeControllerSwitchTo:(TradeControllerViewIndex)viewIndex withStockName:(NSString *)stockName andStockCode:(NSString *)stockCode
{
    switch (viewIndex) {
        case tradeBuyViewIndex: {
            [self.headBar setSelectedIndex:1];
            self.buyController.viewStockCode = stockCode;
            self.buyController.viewStockName = stockName;
//            NSLog(@"---%@",stockCode);
            break;
        }
        case tradeSellViewIndex: {
            [self.headBar setSelectedIndex:2];
//            NSLog(@"-tradeControllerSwitchTo-%@",stockName);
            self.sellController.viewStockCode = stockCode;
            self.sellController.viewStockName = stockName;
            break;
        }
        case tradeKLineIndex:{
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            NSArray *tempArray = [[SKCodeTable instance] getCodeItemListByKeyword:stockCode type:tradeData];
            if (tempArray.count > 1) {
                SKCodeItemVO * first = [tempArray objectAtIndex:0];
                SKCodeItemVO * second = [tempArray objectAtIndex:1];
                NSLog(@"waring:stockCode查到%ld项,%@-%@,%@-%@",(long int)tempArray.count,first.name,first.symbol,second.name,second.symbol);
            }
            SKCodeItemVO * codeItemVo = tempArray.firstObject;
            stockCode = [NSString stringWithFormat:@"%@",codeItemVo.symbol];
            [param setValue:stockCode forKey:@"stockCode"];
            [param setValue:codeItemVo.name forKey:@"stockName"];
            
            if (self.navigationToStockDetailBlock) {
                self.navigationToStockDetailBlock(param);
            }
            
//            if (_isSecondTrade && !_isBTrade) {
//            if (_isSecondTrade) {
//                [self backButtonTouchHandler:nil];
//                [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateStockDetailDataNotificationName object:param];
//            } else {
//                if (self.navigationToStockDetailBlock) {
//                    self.navigationToStockDetailBlock(param);
//                }
////                [RHStockDetailNavManager navigationToStockDetailController:self param:param];
//            }
        }
        default:
            break;
    }
}

//持仓view delegate
- (void)navigateToBankTransferController {
//    [self.view addSubview:self.transferController.view];
    [TradeNavigationManager navigationToTransferController:self];
}

//明细view delegate
- (void)navigationToDealDetailListWithTitle:(NSString *)titleString {
    
    
    if ([titleString isEqualToString:@"历史成交"]) {
       [MNNavigationManager navigationToUniversalVC:self withClassName:@"TradeHistoryController" withParam:nil];
    }
    else if ([titleString isEqualToString:@"已清仓股票"]){
        [MNNavigationManager navigationToUniversalVC:self withClassName:@"ClearnStockController" withParam:nil];
        
    }
    else{
        [TradeNavigationManager navigationToDealControllerWithCurrentController:self titleString:titleString];
    }
    
    
}

- (void)navigationToFAQControllerWithTabNum:(NSInteger)tabNum
{
    [TradeNavigationManager navigationToFAQController:self andTabNum:tabNum];
}

//CMAlertDelegate
- (void)comitButtonTouchHandler {
    //退出前清空持仓
//    self.isLogout = YES;
    [self.headBar setSelectedIndex:0];
    
    [self.stockController clearData];
    [self.buyController clearData];
    [self.sellController clearData];
    [self.entrustController clearData];
    __block typeof(self) welf = self;
    [[TradeSessionManager shareInstance]destroySessionWithBlock:^{
        welf.isLogout = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarShowNoti object:@0];
        self.loginView.isNeedFullScreen = NO;
        [PresentModalManager presentModalView:self.loginView.view animation:NO completion:nil];
    }];
    
    [self.timer invalidate];
    self.timer = nil;
}

@end
