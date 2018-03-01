//
//  TradeBuySellController.m
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "TradeBuySellController.h"
#import "TradeDataManager.h"
#import "TradeErrorParser.h"
//#import "TradeSocketManager.h"
#import "TradeSimulateDataManager.h"
#import "XgwSevenManager.h"

//#import "STKManager.h"
//#import "AppDelegateManager.h"

#import "StockListSocketManager.h"

#import "BuyAndSellView.h"
#import "SKCodeTable.h"
#import "SKFiveReportVO.h"
#import "PopupRiskBookView.h"


@interface TradeBuySellController ()<TradeDataManagerDelegate, TradeViewBuyAndSellDelegate, UIScrollViewDelegate, StockListSocketDelegate>

//@property (nonatomic,strong) TradeSimulateDataManager *simulateManager;

@property (nonatomic,strong) TradeDataManager *tradeDataManager;

@property (nonatomic,strong) StockListSocketManager *socketManager;
@property (nonatomic,strong) XgwSevenManager * STRiskManager;

@property (nonatomic,strong) BuyAndSellView *buyOrSellView;
@property (nonatomic,strong) PopupRiskBookView * popRishBookView;

@property (nonatomic,copy) NSString *tempCode;

@property (nonatomic,copy) NSString *tempType;

@property (nonatomic,assign) BOOL firstRequest;


@end

@implementation TradeBuySellController

#pragma mark -------------------------init-------------------------

static CGFloat kHintTimeInterval = 3.0f;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    

    self.socketManager = [[StockListSocketManager alloc]init];
    self.socketManager.delegate = self;
    
    self.buyOrSellView = [[BuyAndSellView alloc]init];
    [self.view addSubview:self.buyOrSellView];
    self.buyOrSellView.stockDelegate = self;
    self.buyOrSellView.delegate = self;
    
    
}
- (XgwSevenManager *)STRiskManager{
    
    if (!_STRiskManager) {
        _STRiskManager = [[XgwSevenManager alloc]init];
    }
    return _STRiskManager;
}
#pragma mark--风险警示书
- (void)riskCautionBook{
    
    __weak typeof (self) welf = self;

    NSDictionary * params  = @{@"promptTitle":@"您还未签署《风险警示股票风险揭示书》,无法买入风险警示股",@"signBtnTitle":@"阅读并同意签署揭示书",@"checkText":@"点击查看风险揭示书"};
    self.popRishBookView = [[PopupRiskBookView alloc]initRiskBookViewWithParams:params];
    [self.view.window addSubview:self.popRishBookView];
    [self.view setNeedsLayout];
    
    self.popRishBookView.singBtnBlock = ^{
        //签署风险警示书
        [welf.STRiskManager signRiskCautionWithParam:nil completion:^(BOOL isSuccess, id resultData) {
            if (isSuccess) {
                //签署成功
                [CMProgress showWarningProgressWithTitle:nil message:@"签署成功" warningImage:nil duration:kHintTimeInterval];
            }else{
                //签署失败
                NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
           [CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo]  warningImage:nil duration:kHintTimeInterval];
            }
        }];
        [welf.popRishBookView removeFromSuperview];
    };
    //点击背景移除弹窗
    self.popRishBookView.removeRiskBookView = ^{
        [welf.popRishBookView removeFromSuperview];

    };
    
}
-(void)setControllerType:(TradeControllerType)aType {
    _controllerType = aType;
    self.buyOrSellView.controllerType = aType;
//    if (_controllerType == TradeControllerTypeReal) {
        self.tradeDataManager = [[TradeDataManager alloc]init];
        self.tradeDataManager.delegate = self;
//    }
//    else {
//        self.simulateManager = [[TradeSimulateDataManager alloc]init];
//    }
}

- (void)setViewType:(TradeBuySellViewType)aType {
    _viewType = aType;
    self.buyOrSellView.viewType = aType;
}

- (void)setViewStockCode:(NSString *)aCode {
    if (_viewStockCode) {
        _viewStockCode = nil;
    }
    _viewStockCode = aCode;
//    NSLog(@"--------3,%@",aCode);
    self.buyOrSellView.stockCode = aCode;
}

- (void)setViewStockName:(NSString *)aName {
    if (_viewStockName) {
        _viewStockName = nil;
    }
    _viewStockName = aName;
    self.buyOrSellView.stockName = aName;
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    self.buyOrSellView.isSecondTrade = aBool;
}

#pragma mark -------------------------controller-------------------------

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//     [AppDelegateManager configSocket];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stockCodeClearHandler) name:kTradeStockClearNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hcAccountLoginSuccesshandler) name:@"hcAccountLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTradeBalance:) name:kTradeBalanceNotificationName object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tradeDataManager cancelAllRequest];
    [self.STRiskManager cancelAllDelegate];
//    [self.simulateManager cancelAllRequest];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTradeStockClearNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"hcAccountLogin"
                                                  object:nil];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.buyOrSellView.width = self.view.width;
    self.buyOrSellView.height = self.view.height;
    
}

- (void)dealloc {
    self.tradeDataManager.delegate = nil;
    self.tradeDataManager = nil;
//    self.simulateManager = nil;
    self.buyOrSellView = nil;
    self.STRiskManager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

#pragma mark -------------------------socket request-------------------------

-(void)saveTempBuyOrSellCodeAndType:(NSString *)stockCode andExchangeType:(NSString *)exchangeType {
    if (!stockCode) {
        NSLog(@"error-stockCode:%@,exchangeType:%@",stockCode,exchangeType);
        return;
    }
    if ([stockCode isEqualToString:self.tempCode]) {
        return;
    }
    //    NSLog(@"-saveTempBuyOrSellCodeAndType--%@,%@",stockCode,exchangeType);
//    [self cancelStockPriceRequestWithStockCode:self.tempCode andExchangeType:self.tempType];
    self.tempCode = stockCode;
    self.tempType = exchangeType;
    self.firstRequest = NO;
}

//buy view delegate,行情
-(void)requestStockPriceWithStockCode:(NSString *)stockCode andExchangeType:(NSString *)exchangeType{
    if (self.tempType.length > 0 && self.tempCode.length > 0) {//如果之前有过缓存
        [self cancelStockPriceRequestWithStockCode:self.tempCode andExchangeType:self.tempType];//1.取消之前的订阅
        [self saveTempBuyOrSellCodeAndType:stockCode andExchangeType:exchangeType];//2.保存新的code和type
    }
    else {//没有缓存，是第一次请求，先保存code和type
        self.tempCode = stockCode;
        self.tempType = exchangeType;
        self.firstRequest = YES;
    }
    
    //    NSLog(@"---%@,,,%@",stockCode,exchangeType);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:stockCode forKey:@"symbol"];
//    [param setValue:exchangeType forKey:@"exchangeType"];
    [self.socketManager requestStockMarketPriceWithParam:param.copy];//请求一次
    [self.socketManager requestStockRealtimePriceWithParam:param.copy];//订阅推送
}

-(void)cancelStockPriceRequestWithStockCode:(NSString *)stockCode andExchangeType:(NSString *)exchangeType {
    if (!stockCode) {
        NSLog(@"error-stockCode:%@,exchangeType:%@",stockCode,exchangeType);
        return;
    }
    //if ([stockCode isEqualToString:self.tempCode] || [exchangeType isEqualToString:self.tempType]) {
    //    return;
    //}
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:stockCode forKey:@"symbol"];
//    [param setValue:exchangeType forKey:@"exchangeType"];
    [self.socketManager cancelStockMarketPriceWithParam:param];
}

- (void)cancelPriceRequest {
    if (!self.tempCode || !self.tempType) {
        return;
    }
    [self cancelStockPriceRequestWithStockCode:self.tempCode andExchangeType:self.tempType];
    self.tempCode = nil;
    self.tempType = nil;
}

#pragma mark -------------------------http request-------------------------

//buy view delegate,最大可买
-(void)requestStockCountWithParam:(id)param {
//    if (self.controllerType == TradeControllerTypeReal) {
        [self.tradeDataManager requestStockCountWithPatam:param];
//    }
//    else {
//        __block __typeof(self) welf = self;
//        [self.simulateManager requestMaxTradeAmountWithParam:param callBack:^(BOOL success, id resultData) {
//            [welf getStockCountResultHandler:resultData andSuccess:success];
//        }];
//    }
}

//buy view delegate,请求股票的exchangeType,改从本地获取
-(void)requestStockExchangeTypeWithStockCode:(NSString *)stockCode {
    if (!stockCode || [stockCode isEqualToString:@""]) {
        [self cancelPriceRequest];
        return;
    }
    NSArray *tempArray = nil;
    if (self.controllerType == TradeControllerTypeSimulate) {
        tempArray = [[SKCodeTable instance] getCodeItemListByKeyword:stockCode type:adviserData];
    }
    else {
        tempArray = [[SKCodeTable instance] getCodeItemListByKeyword:stockCode type:tradeData];
    }
    
    if (tempArray.count > 1) {
        SKCodeItemVO * first = [tempArray objectAtIndex:0];
        SKCodeItemVO * second = [tempArray objectAtIndex:1];
        NSLog(@"waring:stockCode查到%ld项,%@-%@,%@-%@",(long int)tempArray.count,first.name,first.symbol,second.name,second.symbol);
    }
    SKCodeItemVO * codeItemVo = tempArray.firstObject;
    self.buyOrSellView.stockName = codeItemVo.name;
//    if (stockCode.length < 6) {
//        self.buyOrSellView.stockCode = codeItemVo.code;
//    }
    if ([codeItemVo.prefix isEqualToString:@"sha"]) {
        self.buyOrSellView.stockExchangeType = @"1";
    }
    else if ([codeItemVo.prefix isEqualToString:@"sza"]) {
        self.buyOrSellView.stockExchangeType = @"2";
    }
    else if ([codeItemVo.prefix isEqualToString:@"sh"]) {
        self.buyOrSellView.stockExchangeType = @"1";
    }
    else if ([codeItemVo.prefix isEqualToString:@"sz"]) {
        self.buyOrSellView.stockExchangeType = @"2";
    }
    
    if (self.controllerType == TradeControllerTypeReal) {//实盘需判断是基金还是股票
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:stockCode forKey:@"stockCode"];
        [self.tradeDataManager requestStockExchangeTypeWithPatam:param];
        /**更改股票时请求持仓更新可卖*/
        [self.tradeDataManager requestHoldPositionList];
    }
}

///buy view delegate,查询股东账号
-(void)requestShareHolderAccount {
    if (self.controllerType == TradeControllerTypeSimulate) {
        return;
    }
//    [CMProgress showBeginProgressWithMessage:@"正在处理" superView:self.view];
    [self.tradeDataManager requestShareHolderAccountNumber];
}

///buy view delegate,发购买请求
- (void)sendEntrustRequestWithParam:(NSDictionary *)param {
//    if (self.controllerType == TradeControllerTypeReal) {
//        [self.tradeDataManager sendTradeRequestWithPatam:param];
//    }
//    else {
//        __block __typeof(self) welf = self;
//        [self.simulateManager sendTradeRequestWithParam:param.mutableCopy callBack:^(BOOL success, id resultData) {
//            [welf tradeResultHandler:resultData andSuccess:success];
//        }];
//    }
    if ([[param[@"stockCode"] substringToIndex:3] isEqualToString:@"131"] || [[param[@"stockCode"] substringToIndex:3] isEqualToString:@"204"]) {
        NSMutableDictionary * tmpDic = [NSMutableDictionary dictionaryWithDictionary:param];
        NSNumber * entrustAmount = param[@"entrustAmount"];
        [tmpDic setValue:[NSNumber numberWithInteger:entrustAmount.integerValue / 100] forKey:@"entrustAmount"];
        param = tmpDic;
    }
    [self.tradeDataManager sendTradeRequestWithPatam:param];

}

#pragma mark -------------------------request back-------------------------

//socket查五档详情
-(void)getStockMarketPriceSuccess:(id)resultData {
    if (![resultData isKindOfClass:[SKFiveReportVO class]]) {
        return;
    }
    SKFiveReportVO *resultVO = resultData;
    if (![resultVO.symbol isEqualToString:self.tempCode]) {
        return;
    }
    self.buyOrSellView.priceData = resultData;
}

/**
 *  @brief 获得主动请求的股票详情
 *
 *  @param requestData 返回的数据，SKFiveReportVO类型
 */
-(void)getRequestStockData:(id)requestData {
    self.buyOrSellView.priceData = requestData;
}

/**
 *  @brief 获得推送的股票详情
 *
 *  @param reportData 返回的数据，SKFiveReportVO类型
 */
- (void)getStockReportData:(id)reportData
{
    if (![reportData isKindOfClass:[SKFiveReportVO class]]) {
        return;
    }
    SKFiveReportVO *resultVO = reportData;
    if (![resultVO.symbol isEqualToString:self.tempCode]) {
        return;
    }
    self.buyOrSellView.priceData = reportData;
    
}

//持仓列表
-(void)getHoldPositionListResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        
             self.buyOrSellView.holdStockList = resultData;
    }
    else {
       // NSLog(@"持仓列表-1,%@",resultData);
        [TradeErrorParser parseTradeErrorWithData:resultData];
//        [CMProgress showWarningProgressWithTitle:nil message:errorInfo warningImage:img_progress_warning duration:kHintTimeInterval];

    }
}

//大约可买
-(void)getStockCountResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        self.buyOrSellView.countDic = resultData;
    }
    else {
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
        if ([errorInfo isEqualToString:@"客户无此币种"]) {
            [CMProgress showWarningProgressWithTitle:@"获取大约可买失败" message:errorInfo warningImage:nil duration:kHintTimeInterval];
        }
        else {
            NSLog(@"获取大约可买失败-1,%@",errorInfo);
           // [CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo] warningImage:img_progress_warning duration:kHintTimeInterval];
        }
    }
}

//exchangeType
-(void)getStockExchangeTypeResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        self.buyOrSellView.priceDic = resultData;
    }
    else {
        static int i = 0;
        NSLog(@"exchangeType-1,%@",resultData);
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
        if (i == 0) {
            [CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo] warningImage:img_progress_warning duration:kHintTimeInterval];
            i++;
        }
    }
}

//委托买卖
-(void)tradeResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (!success) {
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
        
        if ([errorInfo rangeOfString:@"未签署"].location != NSNotFound && [errorInfo rangeOfString:@"风险警示股票风险揭示书"].location != NSNotFound ) {
            //弹风险警示书
            [self riskCautionBook];
            [MTA trackPageViewBegin:@"jy_st_stock_agreement"];

            return;
        }
        
        [CMProgress showWarningProgressWithTitle:nil message:[NSString tradeRemindString:errorInfo] warningImage:nil duration:kHintTimeInterval];
        return;
    }
    [CMProgress showWarningProgressWithTitle:nil message:@"下单成功" warningImage:nil duration:kHintTimeInterval];
    //重新获取一次行情，更新价格、可买数量
    self.buyOrSellView.hasChangedPrice = NO;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.tempCode forKey:@"stockCode"];
    [param setValue:self.tempType forKey:@"exchangeType"];
    [self.socketManager requestStockMarketPriceWithParam:param.copy];
    //重新请求持仓接口 刷新数据
    [self.tradeDataManager requestHoldPositionList];
}

//股东代码
-(void)requestShareHolderAccountNumberResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (!success) {
        [CMProgress showEndProgressWithTitle:nil message:@"加载失败" endImage:img_progress_failure duration:kHintTimeInterval];
        NSLog(@"股东代码失败,%@",resultData);
        return;
    }
//    [CMProgress showEndProgressWithTitle:nil message:@"加载成功" endImage:img_progress_success duration:kPopupWindowDurationInterval];
    self.buyOrSellView.stockHolderAccount = [NSString stringWithFormat:@"%@",resultData];
//    NSLog(@"--%@",resultData);
}

#pragma mark -------------------------tradeController,delegate-------------------------

//键盘
- (void)adjustTextViewByKeyboardState:(BOOL)showKeyboard keyboardInfo:(NSDictionary *)info {
    // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask
    UIViewAnimationCurve animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
    if (animationCurve == UIViewAnimationCurveEaseIn) {
        animationOptions |= UIViewAnimationOptionCurveEaseIn;
    }
    else if (animationCurve == UIViewAnimationCurveEaseInOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseInOut;
    }
    else if (animationCurve == UIViewAnimationCurveEaseOut) {
        animationOptions |= UIViewAnimationOptionCurveEaseOut;
    }
    else if (animationCurve == UIViewAnimationCurveLinear) {
        animationOptions |= UIViewAnimationOptionCurveLinear;
    }
    
    NSValue *keyboardFrameVal = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameVal CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
        if (showKeyboard) {
            self.buyOrSellView.y = 0.0f;
            self.buyOrSellView.height = self.view.height - height + TabBarHeight;
        }
        else {
            self.buyOrSellView.y = 0.0f;
            self.buyOrSellView.height = self.view.height;
        }
    } completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.buyOrSellView.needToUp) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.buyOrSellView.needToUp) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

- (void)getTradeBalance:(NSNotification *)notification
{
    NSDictionary * dic = notification.object;
    
    //assetBalance  总资产
    //enableBalance 可用
    //fetchBalance  可取
    //marketValue   市值
    
    self.buyOrSellView.enableBalance = dic[@"enableBalance"];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.buyOrSellView hideKeyboards];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.buyOrSellView hideKeyboards];
}

//股票代码输入框清空了，需要退订行情
- (void)stockCodeClearHandler {
    [self cancelPriceRequest];
}

- (void)refreshData {
//    if (self.controllerType == TradeControllerTypeReal) {
        [self.tradeDataManager requestHoldPositionList];
        if (self.viewStockCode) {
            self.buyOrSellView.stockCode = self.viewStockCode;
            _viewStockCode = nil;
        }
        else if (self.tempCode.length > 0 && self.tempType.length > 0) {
            [self requestStockPriceWithStockCode:self.tempCode andExchangeType:self.tempType];
        }
//    }
//    else {
//        [self.simulateManager requestHoldPositionListWithCallBack:^(BOOL success, id resultData) {
//            [self getHoldPositionListResultHandler:resultData andSuccess:success];
//        }];
//        [self requestStockPriceWithStockCode:self.tempCode andExchangeType:self.tempType];//不存在自选股跳模拟盘的问题
//    }
}

- (void)clearData {//退出登录时调用
    [self.buyOrSellView hideKeyboards];
    [self.tradeDataManager cancelAllRequest];
    [self.STRiskManager cancelAllDelegate];
//    [self.simulateManager cancelAllRequest];
    [self cancelPriceRequest];
    self.viewStockCode = nil;
    self.tempCode = nil;
    self.tempType = nil;
//    [self.buyOrSellView clearForm];
}

- (void)stopReceivePushData {
    [self.buyOrSellView hideKeyboards];
    [self cancelStockPriceRequestWithStockCode:self.tempCode andExchangeType:self.tempType];
}

//hc账号登录通知反馈
-(void)hcAccountLoginSuccesshandler {
    
    [self requestShareHolderAccount];
}

@end
