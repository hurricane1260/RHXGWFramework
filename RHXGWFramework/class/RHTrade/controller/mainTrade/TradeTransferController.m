//
//  TradeTransferController.m
//  stockscontest
//
//  Created by rxhui on 15/7/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeTransferController.h"
#import "CMHeaderBar.h"
#import "BankSecurityTransferView.h"
#import "TradeFundFlowDataSorce.h"

#import "TradeDataManager.h"
#import "TradeErrorParser.h"
#import "RHWebViewCotroller.h"
#import "CMHttpURLManager.h"
#import "MNNavigationManager.h"
#import "TradeController.h"


@interface TradeTransferController ()<CMHeaderBarDelegate,UIScrollViewDelegate,ITableVisible,TradeDataManagerDelegate,BankSecurityTransferDelegate>

@property (nonatomic, strong) CMHeaderBar *headerBar;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) BankSecurityTransferView *transferView;

@property (nonatomic, strong) TradeFundFlowDataSorce *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TradeDataManager *dataManager;

/*! @brief 币种类别 */
@property (nonatomic, copy) NSString *moneyType;

/*! @brief 银行代码 */
@property (nonatomic, copy) NSString *bankNo;

/*! @brief 用于查余额的流水号 */
@property (nonatomic, copy) NSString *entrustNo;

@property (nonatomic, assign) NSInteger historyRequestCount;

#pragma mark-----智能选股七期新加的样式--------
/**切换当日和历史资金流水*/
@property (nonatomic, strong)UIView * topView;
/**分割线*/
@property (nonatomic, strong)UIView * lineView;
/**当日流水Title*/
@property (nonatomic, strong)UILabel * thatTimeLb;
/**历史转账记录Btn*/
@property (nonatomic, strong)UIButton * historyRecordBtn;
@property (nonatomic, assign)NSInteger index;
@end

@implementation TradeTransferController

#pragma mark ==============================================初始化&布局================================================

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"银证转账";
        [self initSubviews];
        self.dataManager = [[TradeDataManager alloc]init];
        self.dataManager.delegate = self;
        self.historyRequestCount = 0;
        self.backButtonHidden = NO;
    }
    return self;
}
-(void)initSubviews {
    
    UIButton * rightButton = [UIButton didBuildButtonWithTitle:@"帮助" normalTitleColor:color5_text_xgw highlightTitleColor:color5_text_xgw disabledTitleColor:color5_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
    [rightButton addTarget:self action:@selector(touchRightButton) forControlEvents:UIControlEventTouchUpInside];
    UILabel *tempLabel = rightButton.titleLabel;
    tempLabel.font = font2_common_xgw;
    [tempLabel sizeToFit];
    rightButton.width = tempLabel.width;
    rightButton.height = 44.0f;
    rightButton.x = self.view.width - rightButton.width - 15.0f;
    self.rightButtonView = rightButton;
    
    NSArray *titleArray = @[@"银证转账",@"资金流水"];
    NSDictionary *titleDictionary = @{@"银证转账":@"0",@"资金流水":@"1"};
    self.headerBar = [[CMHeaderBar alloc]initWithTitleList:titleDictionary titleList:titleArray titleColor:color4_text_xgw highlightedColor:color2_text_xgw titleFontSize:16.0f delegate:self];
    [self.view addSubview:self.headerBar];
    
    UIView *headBarLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43.0f, self.view.width, 1.0)];
    headBarLine.backgroundColor = color16_other_xgw;
    [self.headerBar addSubview:headBarLine];
    
    self.contentView = [[UIScrollView alloc]init];
    [self.view addSubview:self.contentView];
    self.contentView.delegate = self;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.pagingEnabled = YES;
    
    self.transferView = [[BankSecurityTransferView alloc]init];
    [self.contentView addSubview:self.transferView];
    self.transferView.delegate = self;
    self.transferView.transDelegate = self;
    
    self.dataSource = [[TradeFundFlowDataSorce alloc]init];
    self.dataSource.delegate = self;
    self.dataSource.cellHeight = 85.0f;
    self.dataSource.cellIndentifier = @"fundFlowCellIdentifier";
    self.dataSource.itemViewClassName = @"TradeFundFlowListItemView";
    
    self.tableView = [[UITableView alloc]init];
    [self.contentView addSubview:self.tableView];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.dataSource;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addPullRefreshView];
    
    
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = color1_text_xgw;
    [self.contentView addSubview:self.topView];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = color16_other_xgw;
    [self.contentView addSubview:self.lineView];
    
    
    self.thatTimeLb = [UILabel didBuildLabelWithText:@"当日流水" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.topView addSubview:self.thatTimeLb];
    
    self.historyRecordBtn = [[UIButton alloc]init];
    [self.historyRecordBtn setTitle:@"历史转账记录 >" forState:UIControlStateNormal];
    self.historyRecordBtn.titleLabel.font = font2_common_xgw;
    [self.historyRecordBtn setTitleColor:color2_text_xgw forState:UIControlStateNormal];
    [self.historyRecordBtn addTarget:self action:@selector(historyRecordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.historyRecordBtn];
    
    
    
}

#pragma mark ==============================================生命周期================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.headerBar.y = self.layoutStartY;
    self.headerBar.height = 44.0f;
    self.headerBar.width = self.view.width;
    
    self.contentView.y = self.headerBar.y + self.headerBar.height;
    self.contentView.width = self.view.width;
    self.contentView.height = keyAppWindow.height - self.contentView.y;
    self.contentView.contentSize = CGSizeMake(self.view.width * 2, self.contentView.height);
    
    self.transferView.width = self.contentView.width;
    self.transferView.height = self.contentView.height;
    
    
    self.topView.frame = CGRectMake(self.transferView.width, 0, self.contentView.width, 40);
    self.lineView.frame = CGRectMake(self.transferView.width, CGRectGetMaxY(self.topView.frame), self.contentView.width, 8);
    [self.thatTimeLb sizeToFit];
    self.thatTimeLb.origin = CGPointMake(12, self.topView.size.height/2-self.thatTimeLb.size.height/2);
    self.historyRecordBtn.frame = CGRectMake(self.topView.size.width-12-100, 0, 100, self.topView.height);
    
    
    self.tableView.x = self.transferView.width;
    self.tableView.y = CGRectGetMaxY(self.lineView.frame);
    self.tableView.width = self.contentView.width;
    self.tableView.height = self.contentView.height-self.topView.size.height-self.lineView.size.height;
    
    
   
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.index == 0) {
        [self requestBankAccountInfo];//请求银行账户
    }else if (self.index == 1){
        [self requestTransferList];//请求当日流水

    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self.dataManager cancelAllRequest];
}

-(void)dealloc {
    
    self.headerBar = nil;
    self.contentView = nil;
    self.transferView = nil;
    self.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ==============================================请求数据================================================

-(void)requestBankAccountInfo {
    [self.dataManager requestBankAccount];
    [self.dataManager requestDetailFund];
}

-(void)sendTransferRequestWithParam:(NSMutableDictionary *)param {
    [self.dataManager sendTransferRequestWithParam:param];
}

-(void)requestTransferList {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.bankNo forKey:@""];
    [self.dataManager requestTransferFlowListWithParam:param];
}

-(void)requestTransferHistoryList {
    self.historyRequestCount++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.bankNo forKey:@""];
    [self.dataManager requestTransferHistoryListWithParam:param];
}

-(void)requestTransferHistoryListNextPage {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.bankNo forKey:@""];
    [self.dataManager requestTransferHistoryListNextPageWithParam:param];
}

#pragma mark ==============================================请求返回================================================

-(void)getBankAccountResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        self.transferView.bankName = [resultData objectForKey:@"bankName"];
        self.moneyType = [resultData objectForKey:@"moneyType"];
        self.bankNo = [resultData objectForKey:@"bankNo"];
    }
    else {
        NSString *message = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showWarningProgressWithTitle:nil message:message warningImage:nil duration:3.0f];
    }
}

-(void)getBankMoneyResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        self.entrustNo = [NSString stringWithFormat:@"%@",resultData];//只能取到流水号
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:self.entrustNo forKey:@"entrustNo"];
        [param setValue:self.bankNo forKey:@"bankNo"];
        NSLog(@"-流水号-%@",self.entrustNo);
        
        [UIView animateWithDuration:1.0f animations:^{
            self.view.height = self.view.height;
        } completion:^(BOOL finished) {
            [self.dataManager requestBankSerialMoneyWithParam:param];
        }];
    }
    else {
        NSString *message = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showWarningProgressWithTitle:nil message:message warningImage:nil duration:3.0f];
    }
}

-(void)getBankMoneySerialResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        NSString *result = [NSString stringWithFormat:@"%@",resultData];
        self.transferView.bankMoney = [NSNumber numberWithInteger:[result integerValue]];
    }
    else {
        NSString *message = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showWarningProgressWithTitle:nil message:message warningImage:nil duration:3.0f];
    }
}

-(void)getDetailFundResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        NSNumber *money = [resultData objectForKey:@"fetchBalance"];
        self.transferView.canTransferMoney = money;
    }
    else {
        NSString *message = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showWarningProgressWithTitle:nil message:message warningImage:nil duration:3.0f];
    }
}

-(void)sendTransferRequestResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
//        [CMProgress showWarningProgressWithTitle:nil message:@"转账申请已提交" warningImage:nil duration:3.0f];
        

        [[NSNotificationCenter defaultCenter] postNotificationName:@"transferMoneySuccess" object:nil];

        [self.navigationController popViewControllerAnimated:YES];
      
    }
    else {
        NSString *message = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showWarningProgressWithTitle:nil message:message warningImage:nil duration:3.0f];
    }
}

-(void)requestTransferFlowListResultHandler:(id)resultData andSuccess:(BOOL)success {
    [self.tableView stopRefresh];
    [CMComponent removeComponentViewWithSuperView];
    if (success) {
        NSArray *list = resultData;
        if (list.count == 0) {
            //[self requestTransferHistoryList];
            //数据源数据为空
            [CMComponent showNoDataWithSuperView:self.tableView andFrame:CGRectMake(0, 0, self.view.width, self.tableView.size.height)];
        }
        else {
            self.dataSource.dataList = resultData;
            [self.tableView reloadData];
            [self.view setNeedsLayout];

        }
    }
    else {
        NSString *message = [TradeErrorParser parseTradeErrorWithData:resultData];
        //请求失败
        [CMComponent showRequestFailViewWithSuperView:self.tableView andFrame:CGRectMake(0, 0, self.view.width, self.tableView.size.height ) andTouchRepeatTouch:^{
            
            [self requestTransferList];
        }];
        [CMProgress showWarningProgressWithTitle:nil message:message warningImage:nil duration:3.0f];
        
    }
}

-(void)requestTransferHistoryListResultHandler:(id)resultData andSuccess:(BOOL)success {
    [self.tableView stopRefresh];
    if (success) {
        NSMutableArray * arr = [NSMutableArray arrayWithArray:resultData];
        self.dataSource.dataList = arr;
        
        [self.tableView reloadData];
        [self.view setNeedsLayout];

    }
    else {
        [CMProgress showWarningProgressWithTitle:nil message:resultData warningImage:nil duration:3.0f];
    }
}

#pragma mark ==============================================delegate================================================

- (void)touchRightButton
{
    RHWebViewCotroller * webViewController = [[RHWebViewCotroller alloc] init];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@"转账帮助" forKey:@"title"];
    NSString *h5PageUrl =[CMHttpURLManager getHostIPWithServID:@"h5PageUrl"];
    [param setObject:[NSString stringWithFormat:@"%@/problem.html",h5PageUrl] forKey:@"urlString"];
    webViewController.param = param;
    [self.navigationController pushViewController:webViewController animated:YES];
}

-(void)didBarItemSelected:(id)selectedData {
    [self.transferView hideKeyboard];
    NSUInteger index = [(NSNumber *)selectedData integerValue];
    self.index = index;
    if (index == 1) {
        
        [self requestTransferList];
    }
    [UIView animateWithDuration:kAnimationTimerInterval animations:^{
        self.contentView.contentOffset = CGPointMake(index * self.view.width, 0.0f);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentView) {
        NSInteger index = self.contentView.contentOffset.x / self.view.width;
        [self.headerBar setSelectedIndex:index];
    }
    if (scrollView == self.transferView) {
        [self.transferView hideKeyboard];
    }
}

-(void)comitTransferWithParam:(NSDictionary *)param{
    NSMutableDictionary *mutaParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [mutaParam setValue:self.moneyType forKey:@"moneyType"];
    [mutaParam setValue:self.bankNo forKey:@"bankNo"];
    [self sendTransferRequestWithParam:mutaParam];
    
}

- (void)popRemindBankInfo
{
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:@"首次转账提醒" message:@"平安银行,浦发银行,招商银行,首次银证转账需要去银行网站或手机APP操作" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVc animated:NO completion:nil];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertVc removeFromParentViewController];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"查看指引" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self touchRightButton];
    }]];

}

//-(void)requestBankMoneyWithParam:(NSMutableDictionary *)param{
//    [param setValue:self.moneyType forKey:@"moneyType"];
//    [param setValue:self.bankNo forKey:@"bankNo"];
//    [self.dataManager requestBankMoneyWithParam:param];
//}

-(void)pullRefreshDataHandler {
    [self requestTransferList];
}

-(void)loadNextPageDataHandler {
//    if (self.historyRequestCount == 0) {
//        [self requestTransferHistoryList];
//    }
//    else {
//        [self requestTransferHistoryListNextPage];
//    }
}

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
            if (self.headerBar.selectedIndex == 0) {
                self.transferView.y = 0.0f;
                self.transferView.height = self.contentView.height - height;
            }
            
        }
        else {
            if (self.headerBar.selectedIndex == 0) {
                self.transferView.y = 0.0f;
                self.transferView.height = self.contentView.height;
            }
        }
    } completion:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}
#pragma mark--点击历史记录
-(void)historyRecordClick{
    
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"HistoryRecordController" withParam:nil];
    
}
@end
