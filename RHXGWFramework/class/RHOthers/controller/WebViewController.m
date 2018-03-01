//
//  WebViewController.m
//  JinHuiXuanGuWang
//
//  Created by Zzbei on 2016/11/10.
//
//

#import "WebViewController.h"
#import "StockListSocketManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SKFiveReportVO.h"
#import "JSONKit.h"
//#import "RHStockDetailNavManager.h"
//#import "StockDataManager.h"
//#import "AccountVO.h"
#import "CMComponent.h"
#import "SKCodeTable.h"
#import "SKCodeItemVO.h"
#import <WebKit/WebKit.h>
//#import "SPShareNewsBubbleViewModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "RHSignTool.h"
#import "RHtoCRHNaviManager.h"
#import "MNNavigationManager.h"
//#import "MainRequestManager.h"
//#import "ClientTypeVO.h"


//#import "MySelfController.h"

typedef enum{
    wealthManageType = 101,   //财富管理
    investOneVOne,      //投顾一对一
} AccountLoginPageType;


@interface WebViewController () <UIWebViewDelegate,StockListSocketDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIWebView * webView;

@property (nonatomic,strong) UIView * navigationView;

@property (nonatomic,strong) UILabel * navigationTitle;

@property (nonatomic,strong) UIButton * backButton;

@property (nonatomic,strong) StockListSocketManager * listSocketManager;

//@property (nonatomic,strong) StockDataManager * stockDataManager;

//@property (nonatomic,strong) AccountVO *currentAccount;

@property (nonatomic,strong) NSArray * stockCodeArray;

@property (nonatomic,strong) UIButton * rightButton;

@property (nonatomic,copy) NSString * stockCode;

@property (nonatomic,copy) NSString * titleString;

@property (nonatomic,copy) NSString * tarPageName;

//kRhPStrong MainRequestManager * mainManager;

kRhPAssign AccountLoginPageType  loginPageType;

kRhPAssign BOOL needRefresh;
@end

@implementation WebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needRefresh = NO;
        [self initSubViews];
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kACLogInNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeSelfStockNoti object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kACLogInNotificationName object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kACLogOutNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initSubViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStockDetailNotification:) name:kChangeSelfStockNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAccount) name:kACLogInNotificationName object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAccount) name:kACLogOutNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccessNotificationHandler:) name:kHtml5ShareSuccessNotificationName object:nil];
    
    self.navigationBarHidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.navigationView = [[UIView alloc] init];
    self.navigationView.frame = CGRectMake(0, 0, self.view.width, self.layoutStartY);
    self.navigationView.backgroundColor = color2_text_xgw;
    self.navigationView.alpha = 0;
    [self.view addSubview:self.navigationView];
    
    self.navigationTitle = [[UILabel alloc] init];
    self.navigationTitle.textColor = color1_text_xgw;
    self.navigationTitle.font = font3_common_xgw;
    self.navigationTitle.textAlignment = NSTextAlignmentCenter;
    [self.navigationView addSubview:self.navigationTitle];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 20, 44, 44)];
    [self.backButton setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/top_icon_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.listSocketManager = [[StockListSocketManager alloc] init];
    self.listSocketManager.delegate = self;
    
//    self.stockDataManager = [[StockDataManager alloc] init];
//    self.stockDataManager.delegate = self;
    
//    self.currentAccount = [AccountDataManager currentOnlineAccount];
    
    self.rightButton = [[UIButton alloc] init];
    self.rightButton.frame = CGRectMake(self.view.width - 44.0f, 20, 44, 44);
    self.rightButton.titleLabel.font = font3_common_xgw;
    [self.rightButton addTarget:self action:@selector(requestShareInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
}

- (void)setUrlString:(NSString *)UrlString
{    
    NSTimeInterval time= [[NSDate date] timeIntervalSince1970];
    
    if ([UrlString rangeOfString:@"http"].location == NSNotFound) {
        UrlString = [NSString stringWithFormat:@"http://%@",UrlString];
    }
    if ([UrlString rangeOfString:@"?"].location == NSNotFound) {
        UrlString = [NSString stringWithFormat:@"%@?platform=ios&t=%f",UrlString,time];
    } else {
        if ([UrlString rangeOfString:@"platform="].location == NSNotFound) {
            UrlString = [NSString stringWithFormat:@"%@&platform=ios",UrlString];
        }
        if ([UrlString rangeOfString:@"t="].location == NSNotFound) {
            UrlString = [NSString stringWithFormat:@"%@&t=%f",UrlString,time];
        }
    }
    
    _UrlString = UrlString;
    
//    if (self.currentAccount) {
//        [self setCookie:self.currentAccount.mobilePhone];
//    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0]];

}

- (void)setWebViewTitle:(NSString *)webViewTitle
{
    _webViewTitle = webViewTitle;
    
    if (webViewTitle.length > 0) {
        
        self.title = webViewTitle;
        if (webViewTitle.length > 14) {
            self.title = [NSString stringWithFormat:@"%@...",[webViewTitle substringToIndex:14]];
        }
        self.rightButton.hidden = YES;
        self.navigationBarHidden = NO;
        self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
        self.navigationView.hidden = YES;
        self.backButton.hidden = YES;
    }
}

- (void)setSourceType:(NSNumber *)sourceType
{
    _sourceType = sourceType;
    
    if (sourceType.integerValue == 2) {
        self.rightButton.hidden = NO;
    }
}

- (void)setStockCodeArray:(NSArray *)stockCodeArray
{
    _stockCodeArray = stockCodeArray;
    
    [self addRealtimeReport];
}

//- (AccountVO *)currentAccount{
//    _currentAccount = [AccountDataManager currentOnlineAccount];
//    if (_currentAccount) {
//        return _currentAccount;
//    }
//    return nil;
//}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addRealtimeReport];
    
    if (self.needRefresh) {
        
        [self.webView reload];
        
        self.needRefresh = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeRealtimeReport];
//    [self.stockDataManager cancelAllRequest];
    
    if (self.tarPageName) {
        [MTA trackPageViewEnd:self.tarPageName];
    }

}

#pragma mark ==================代理方法=====================

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.webView.scrollView]) {
        self.navigationView.alpha = scrollView.contentOffset.y / self.layoutStartY;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //截取request修改navigationBar的信息
    if ([request.URL.absoluteString rangeOfString:@"ReportList"].location != NSNotFound){
        NSArray * array = [request.URL.absoluteString componentsSeparatedByString:@"&"];
        for (NSString * str in array) {
            if ([str rangeOfString:@"stockName"].location != NSNotFound) {
                self.navigationTitle.text = [[str componentsSeparatedByString:@"="][1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.navigationTitle sizeToFit];
                self.navigationTitle.frame = CGRectMake((self.navigationView.width - self.navigationTitle.width) / 2, (44 - self.navigationTitle.height) / 2 + 20, self.navigationTitle.width, self.navigationTitle.height);
            }
            if ([str rangeOfString:@"stockCode"].location != NSNotFound) {
                self.stockCode = [str componentsSeparatedByString:@"="][1];
            }
        }
        self.rightButton.hidden = NO;
        [self.rightButton setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_quotation_xuangu"] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(touchRightButtonToStockDetail) forControlEvents:UIControlEventTouchUpInside];
    } else if ([request.URL.absoluteString rangeOfString:@"updatePassword"].location != NSNotFound) {
        self.rightButton.hidden = YES;
        self.title = @"修改密码";
        self.navigationBarHidden = NO;
        self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
        self.navigationView.hidden = YES;
        self.backButton.hidden = YES;
    } else if ([request.URL.absoluteString rangeOfString:@"openAccount"].location != NSNotFound) {
//        [RHtoCRHNaviManager navigationToCRHOpenAccountWithCurrent:self];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:@"xgw" forKey:@"short_url"];
        [MNNavigationManager navigationToUniversalVC:self withClassName:kRHOpenAccountControllerClassName withParam:param];
    } else {
        [self.rightButton setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_share_xuangu"] forState:UIControlStateNormal];
        self.navigationTitle.text = self.titleString;
    }
    //js返回股票列表
    if ([request.URL.absoluteString rangeOfString:@"passStockCode"].location != NSNotFound) {
        
        NSArray * array = [request.URL.absoluteString componentsSeparatedByString:@"="];
        NSArray * stockArray = [array[1] componentsSeparatedByString:@","];
        self.stockCodeArray = stockArray;
    }
    //js点击添加股票
    if ([request.URL.absoluteString rangeOfString:@"addStock"].location != NSNotFound) {
//        if ([SLModuleManager loadLoginModuleWithAnimation:NO]) {
            //            NSArray * array = [request.URL.absoluteString componentsSeparatedByString:@"="];
            //            NSString * stockCode = array[1];
            //            [self addStockWithStockCode:stockCode];
//        }
    }
    //js点击自选股详情页
//    if ([request.URL.absoluteString rangeOfString:@"stockDetail"].location != NSNotFound) {
//        NSArray * array = [request.URL.absoluteString componentsSeparatedByString:@"="];
//        NSString * stockCode = [array[1] componentsSeparatedByString:@"&"][0];
//        NSString * stockList = array[2];
//        [self navToStockDetailPage:stockCode andStockListString:stockList];
//    }
    //js操作提示
    if ([request.URL.absoluteString rangeOfString:@"showToast"].location != NSNotFound){
        NSArray * array = [request.URL.absoluteString componentsSeparatedByString:@"="];
        NSString * data = array[1];
        NSString * str = [data stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        alert.delegate = self;
        [alert show];
    }
    [self createJScontext];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [CMComponent showLoadingViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [CMComponent removeComponentViewWithSuperView];
    
    [self createJScontext];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == -1004 || error.code == -1009) {
        __weak typeof (self)welf = self;
        [CMComponent showRequestFailViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY) andTouchRepeatTouch:^{
            [welf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0]];
        }];
        self.navigationView.alpha = 1;
    }
}

#pragma mark ==================创建JS方法=====================
- (void)createJScontext
{
    JSContext * context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) welf = self;

    //js请求用户信息
//    context[@"getIOSAccountInfo"] = (NSString *)^(NSString * string) {
//        return [welf.currentAccount valueForKey:string];
//    };
    
    //js请求活动资金账号token
    context[@"getAccountToken"] = (NSString *)^(NSString * string) {
        return [RHSignTool activityTokenWithAccountId:string];
    };
    //js请求guid
//    context[@"getIOSUserInfo"] = (NSString * )^() {
//        return welf.currentAccount.guid;
//    };
    //js请求tabid
//    context[@"getIOStabid"] = (NSNumber *)^() {
//        return welf.currentAccount.tabId;
//    };
    //js停止loading
    context[@"stopLoading"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CMComponent removeComponentViewWithSuperView];
        });
    };
    
    //js返回分享信息
    context[@"setIOSShareInfo"] = ^(NSString * url,NSString * title,NSString * content,NSString * circleContent) {
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"shareUrl"];
        [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"shareTitle"];
        [[NSUserDefaults standardUserDefaults] setObject:content  forKey:@"shareSummary"];
        [[NSUserDefaults standardUserDefaults] setObject:@"您有一条好友分享的消息" forKey:@"shareLastMessage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self shareWithUrlSting:url andTitle:title andContent:content andCircleContent:circleContent];
    };
    //js设置右上角按钮(10分享按钮,11个股详情,12什么都不显示)
    context[@"setRightBtnState"] = ^(NSString * button) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([button isEqualToString:@"10"]) {
                self.rightButton.hidden = NO;
                [self.rightButton setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_share_xuangu"] forState:UIControlStateNormal];
                [self.rightButton addTarget:self action:@selector(requestShareInfo) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqualToString:@"11"]) {
                self.rightButton.hidden = NO;
                [self.rightButton setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_quotation_xuangu"] forState:UIControlStateNormal];
                [self.rightButton addTarget:self action:@selector(touchRightButtonToStockDetail) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqualToString:@"12"]) {
                self.rightButton.hidden = YES;
            }
        });
    };
    
    //js设置左上角按钮(10显示返回按钮,11什么都不显示)
    context[@"setLeftBtnState"] = ^(NSString * button) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([button isEqualToString:@"10"]) {
                welf.backButton.hidden = NO;
            } else if ([button isEqualToString:@"11"]) {
                welf.backButton.hidden = YES;
            }
        });
    };
    
    //js调用返回按钮
    context[@"touchBackButton"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [welf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    //js设置title
    context[@"setTopViewTitle"] = ^(NSString * title) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleString = title;
            self.navigationTitle.text = title;
            [self.navigationTitle sizeToFit];
            self.navigationTitle.frame = CGRectMake((self.navigationView.width - self.navigationTitle.width) / 2, (44 - self.navigationTitle.height) / 2 + 20, self.navigationTitle.width, self.navigationTitle.height);
        });
    };
    
    //js设置title的隐藏
    context[@"setTopViewHidden"] = ^() {
        welf.navigationView.hidden = YES;
    };
    
    //js设置股票名称
    context[@"setStockCode"] = ^(NSString * stockCode) {
        welf.stockCode = stockCode;
    };
    
    //js点击事件埋点
    context[@"buryTarget"] = ^(NSString * pageName) {
        NSLog(@"%@",pageName);
        [MTA trackCustomEvent:pageName args:nil];
    };
    
    //js页面埋点begin
    context[@"pageTargetBegin"] = ^(NSString * pageName) {
        NSLog(@"%@",pageName);
        welf.tarPageName = pageName;
        [MTA trackPageViewBegin:pageName];
    };
    
    //js页面埋点end
    context[@"pageTargetEnd"] = ^(NSString * pageName) {
        NSLog(@"%@",pageName);
        [MTA trackPageViewEnd:pageName];
    };
    
    //开户
    context[@"naviToOpenAccout"] = ^(NSString * str){
//        [RHtoCRHNaviManager navigationToCRHOpenAccountEightWithCurrent:welf];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:@"xycf" forKey:@"short_url"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MNNavigationManager navigationToUniversalVC:welf withClassName:kRHOpenAccountControllerClassName withParam:param];

        });

    };
    
    //组合
    context[@"naviToInvestGroup"] = ^(){
        welf.needRefresh = YES;
        
        [MNNavigationManager navigationToUniversalVC:welf withClassName:kMNInvestGroupControllerClassName withParam:nil];
        
    };
    
    //成功提佣
    context[@"openAccEightSuc"] = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [welf.navigationController popViewControllerAnimated:YES];
        });
    };
    
    //显示弹框
    context[@"showHint"] = ^(NSString * str){
        [CMProgress showWarningProgressWithTitle:nil message:str warningImage:nil duration:2];
    };
    
//    context[@"loginAccount"] = ^(NSString * pageCode){
//
//        switch ([pageCode integerValue]) {
//            case 101:
//                welf.loginPageType = wealthManageType;
//                break;
//            case 102:
//                welf.loginPageType = investOneVOne;
//                break;
//
//            default:
//                break;
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SLModuleManager loadLoginModuleWithAnimation:NO];
//
//        });
//    };
    
    context[@"naviToWealthManagePage"] = ^{
        
        [MNNavigationManager navigationToUniversalVC:welf withClassName:kMSWealthManageControllerClassName withParam:@"popRootVC"];
    };
    
}

#pragma mark ==================调用JS方法=====================

- (void)changeStockSuccessWithSymbols:(NSString *)symbol andType:(changeStockType)type
{
    NSString * json = [symbol JSONString];
    JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString * alertJS;
    if (type == addStock) {
        alertJS = [NSString stringWithFormat:@"addStockSuccess('%@')",json];
    }
    if (type == deleteStock) {
        alertJS = [NSString stringWithFormat:@"deleteOptStock('%@')",json];
    }
    [postContext evaluateScript:alertJS];
}

- (void)postStockDataWith:(NSDictionary *)dic
{
    NSString * json = [dic JSONString];
    JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS = [NSString stringWithFormat:@"refreshTradeQuota('%@')",json];
    [postContext evaluateScript:alertJS];
}

- (void)requestShareInfo
{
//    if (self.viewModel) {
//        if (self.viewModel.url) {
//            [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.url forKey:@"shareUrl"];
//        }
//        if (self.viewModel.title) {
//            [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.title forKey:@"shareTitle"];
//        }
//        if (self.viewModel.summary) {
//            [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.summary forKey:@"shareSummary"];
//        }
//        if (self.viewModel.lastMessage) {
//            [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.lastMessage forKey:@"shareLastMessage"];
//        }
//        if (self.viewModel.imageString) {
//            [[NSUserDefaults standardUserDefaults] setObject:self.viewModel.imageString forKey:@"shareImage"];
//        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self shareWithUrlSting:self.viewModel.url andTitle:self.viewModel.title andContent:self.viewModel.summary andCircleContent:nil];
//    } else {
        if (self.sourceType.integerValue == 2) {
            [self shareWithUrlSting:self.UrlString andTitle:self.webViewTitle   andContent:self.shareContent andCircleContent:nil];
        } else {
            JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            NSString *alertJS = [NSString stringWithFormat:@"sharePage()"];
            [postContext evaluateScript:alertJS];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"shareIcon" forKey:@"shareImage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
//    }
}

- (void)closeAudio
{
    JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *audioClose = [NSString stringWithFormat:@"audioClose()"];
    [postContext evaluateScript:audioClose];
}

- (void)didCreateJSContext:(NSNotification *)notification{
//    JSContext *context = notification.object;
    //js请求用户信息
//    context[@"getIOSAccountInfo"] = (NSString *)^(NSString * string) {
//        return [self.currentAccount valueForKey:string];
//    };
}

#pragma mark ==================网络请求=====================

//- (void)addStockWithStockCode:(NSString *)stockCode
//{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:self.currentAccount.guid forKey:@"userId"];
//    [param setValue:stockCode forKey:@"symbols"];
//    [param setValue:@"create" forKey:@"action"];
//    [self.stockDataManager requestEditStockSelectListWithPatam:param];
//}

- (void)addRealtimeReport
{
    for (NSString *stockCode in self.stockCodeArray)
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:stockCode forKey:@"symbol"];
        [self.listSocketManager requestStockMarketPriceWithParam:param];
        [self.listSocketManager requestStockRealtimePriceWithParam:param];
    }
}

- (void)removeRealtimeReport
{
    for (NSString *stockCode in self.stockCodeArray)
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:stockCode forKey:@"symbol"];
        [self.listSocketManager cancelStockMarketPriceWithParam:param];
    }
}

#pragma mark ==================请求返回=====================

- (void)getRequestStockData:(id)requestData
{
    SKFiveReportVO * vo = requestData;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%@",vo.symbol] forKey:@"stockCode"];
    [param setValue:[NSString stringWithFormat:@"%@",vo.name] forKey:@"stockName"];
    [param setValue:[NSString stringWithFormat:@"%f",vo.close] forKey:@"newPrice"];
    [param setValue:[NSString stringWithFormat:@"%f",vo.rise] forKey:@"raise"];
    [param setValue:[NSString stringWithFormat:@"%f",vo.change] forKey:@"change"];
    
    [self postStockDataWith:param];
}

- (void)getStockReportData:(id)reportData
{
    SKFiveReportVO * vo = reportData;
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%@",vo.symbol] forKey:@"stockCode"];
    [param setValue:[NSString stringWithFormat:@"%@",vo.name] forKey:@"stockName"];
    [param setValue:[NSString stringWithFormat:@"%f",vo.close] forKey:@"newPrice"];
    [param setValue:[NSString stringWithFormat:@"%f",vo.rise] forKey:@"raise"];
    [param setValue:[NSString stringWithFormat:@"%f",vo.change] forKey:@"change"];
    
    [self postStockDataWith:param];
}

- (void)requestEditSelectListResultHandler:(id)resultData andSuccess:(BOOL)success
{
    if (success) {
        [self changeStockSuccessWithSymbols:[resultData[@"symbols"] componentsSeparatedByString:@"_"][1] andType:addStock];
    }
}

- (void)getStockDetailNotification:(NSNotification *)notification
{
    NSDictionary * dic = notification.object;
    NSString * stockCode = dic[@"stockCode"];
    if (stockCode.length > 6) {
        if ([dic[@"isSelect"] integerValue] == 1) {
            [self changeStockSuccessWithSymbols:[stockCode componentsSeparatedByString:@"_"][1] andType:addStock];
        } else if ([dic[@"isSelect"] integerValue] == 0) {
            [self changeStockSuccessWithSymbols:[stockCode componentsSeparatedByString:@"_"][1] andType:deleteStock];
        }
    }
}

//- (MainRequestManager *)mainManager{
//    if (!_mainManager) {
//        _mainManager = [[MainRequestManager alloc] init];
//    }
//    return _mainManager;
//}

//- (void)requestClientInfo{
//
//    if (!self.currentAccount) {
//        return;
//    }
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setObject:self.currentAccount.userId forKey:@"userId"];
//    __weak typeof(self) welf = self;
//    [self.mainManager requestFoClientTypeWithParam:dic withModeId:kClientType completion:^(BOOL success, id resultData) {
//        if (success) {
//            if (!resultData || ![resultData isKindOfClass:[NSDictionary class]]) {
//                return;
//            }
//
//            NSDictionary * dic = resultData;
//            if (![dic objectForKey:@"userInfo"]) {
//                //                [CMProgress showWarningProgressWithTitle:nil message:@"获取用户数据错误" warningImage:nil duration:2];
//                return;
//            }
//            ClientTypeVO * vo = [dic objectForKey:@"userInfo"];
//
//            if (![dic objectForKey:@"agent"]) {
//                //                [CMProgress showWarningProgressWithTitle:nil message:@"获取用户数据错误" warningImage:nil duration:2];
//                return;
//            }
//            NSArray * agent = [dic objectForKey:@"agent"];
//            [[NSUserDefaults standardUserDefaults] setObject:agent  forKey:@"agentIMInfo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            if ([vo.state integerValue] == 1 || [vo.state integerValue] == 2) {
//
//                [self.webView reload];
//
//            }
//            else if ([vo.state integerValue] == 3 || [vo.state integerValue] == 4){
//                if ([welf.UrlString containsString:@"management.html"]) {
//                    [MNNavigationManager navigationToUniversalVC:welf withClassName:kMSWealthManageControllerClassName withParam:@"popRootVC"];
//
//                }
//                else if ([welf.UrlString containsString:@"adviser.html"]){
//                    if ([vo.state integerValue] == 3) {
//                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"1分钟内将会为您分配专属投顾" delegate:welf cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
//                        alert.delegate = welf;
//                        [alert show];
//
//                    }
//                    else if ([vo.state integerValue] == 4){
//                        //[YunWangManager openConversationWithIMId:vo.imId and:welf.navigationController];
//
//
//                        NSArray * vcArr = self.navigationController.viewControllers;
//                        for (BaseViewController * vc in vcArr) {
//                            if ([vc isKindOfClass:[MySelfController class]]) {
//                                [self.navigationController popViewControllerAnimated:NO];
//
//                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                    MySelfController * mVC = vc;
//                                    [mVC naviToInvestChat:nil];
//                                });
//
//                            }
//                        }
//                    }
//                }
//            }
//            else if(!self.currentAccount.mobilePhone.length && [vo.state integerValue] == 0){
//
//                [self.webView reload];
//
//            }
//        }
//        else{
//            [CMProgress showEndProgressWithTitle:nil message:@"获取用户数据失败" endImage:nil duration:2];
//        }
//    }];
//}


#pragma mark ==================页面跳转=====================

- (void)touchRightButtonToStockDetail
{
//    if (self.stockCode.length == 6) {
//        NSArray * array = [[SKCodeTable instance] getCodeItemListByKeyword:self.stockCode type:tradeData];
//        if (array.count > 0) {
//
//            SKCodeItemVO * codeItemVo = array[0];
//            [self navToStockDetailPage:codeItemVo.symbol andStockListString:nil];
//        }
//    }
//    if (self.stockCode.length > 6) {
//        [self navToStockDetailPage:self.stockCode andStockListString:nil];
//    }
}

//- (void)navToStockDetailPage:(NSString *)stockCode andStockListString:(NSString *)stockList {
//
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObject:stockCode forKey:@"stockCode"];
//    if (stockList) {
//        [param setObject:stockList forKey:@"stockList"];
//    }
//
//    [RHStockDetailNavManager navigationToStockDetailController:self param:param];
//}

-(void)backButtonTouchHandler:(id)sender{
    
    if ([_webView canGoBack]) {
        [_webView goBack];
        return;
    }
    [self closeAudio];

    if([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"修改成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([alertView.message isEqualToString:@"1分钟内将会为您分配专属投顾"]){
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

- (void)shareWithUrlSting:(NSString *)url andTitle:(NSString *)title andContent:(NSString *)content andCircleContent:(NSString *)circleContent
{
    NSLog(@"%@  %@  %@  %@",url,title,content,circleContent);

    if (url && title && content) {
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:@3 forKey:@"shareType"];
//        if (_viewModel.imageString.length > 0) {
//            [param setObject:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_niudafa"] forKey:@"shareImage"];
//        }
//        else {
            [param setObject:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/shareIcon"] forKey:@"shareImage"];
//        }
        [param setObject:url forKey:@"targetUrl"];
        [param setObject:title forKey:@"shareTitle"];
        [param setObject:content forKey:@"shareContent"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUMShareNotificationName object:param];
    }
}

//static int i = 0;
//- (void)loginAccount {
//
//    self.curentStackCount = [NSNumber numberWithInteger:self.navigationController.viewControllers.count];
//    if (self.curentStackCount.integerValue > 1) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarHiddenNoti object:@1];
//    }
//    else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarShowNoti object:@0];
//    }
//
//    if (i == 0) {
//        NSString * json = [self.currentAccount.guid JSONString];
//        JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        NSString *alertJS = [NSString stringWithFormat:@"setUserInfo('%@')",json];
//        [postContext evaluateScript:alertJS];
//        i++;
//    }
//
//    if (!self.currentAccount) {
////        JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
////        NSString *alertJS = @"delCookie('')";
////        [postContext evaluateScript:alertJS];
//    }else{
//        JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        if (self.currentAccount.mobilePhone.length > 0) {
//            NSString *alertJS = [NSString stringWithFormat:@"setCookie('phone','%@')",self.currentAccount.mobilePhone];
//            [postContext evaluateScript:alertJS];
//        } else {
//            NSString *alertJS = [NSString stringWithFormat:@"setCookie('phone','')"];
//            [postContext evaluateScript:alertJS];
//        }
//
////        if (!self.needRefresh) {
////            if (self.loginPageType == wealthManageType || self.loginPageType == investOneVOne) {
////                [self requestClientInfo];
////            }
////        }
//    }
//    [self.view insertSubview:self.webView atIndex:0];
//}

- (void)deleteCookies{
    JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS = @"delCookie('')";
    [postContext evaluateScript:alertJS];
}

- (void)shareSuccessNotificationHandler:(NSNotification *)notify {
    NSNumber * tempNumber = notify.object;
    NSString * json;
    switch (tempNumber.integerValue) {
        case -2:
            json = @"UMSocialPlatformType_UnKnown";
            break;
        case -1:
            json = @"UMSocialPlatformType_Predefine_Begin";
            break;
        case 1:
//            json = @"UMSocialPlatformType_WechatSession";
            json = @"Wechat";
            break;
        case 2:
//            json = @"UMSocialPlatformType_WechatTimeLine";
            json = @"WechatMoments";
            break;
        case 3:
            json = @"UMSocialPlatformType_WechatFavorite";
            break;
        case 4:
//            json = @"UMSocialPlatformType_QQ";
            json = @"QQ";
            break;
        case 5:
            json = @"UMSocialPlatformType_Qzone";
            break;
        case 13:
            json = @"UMSocialPlatformType_Sms";
            break;
        case 1000:
            json = @"UMSocialPlatformType_UserDefine_Begin";
            break;
        case 1001:
            json = @"UMSocialPlatformType_MyFriend";
            break;
        case 2000:
            json = @"UMSocialPlatformType_UserDefine_End";
            break; 
        default:
            break;
    }
    JSContext * postContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS = [NSString stringWithFormat:@"shareSuccess('%@')",json];
    [postContext evaluateScript:alertJS];
}

//资金账号加密
- (NSString *)encryptAccount:(NSString *)aString {
    NSString *tempString = [NSString stringWithFormat:@"hCZq-%@|2017",aString];
    tempString = [self md5:tempString];
    return tempString;
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
