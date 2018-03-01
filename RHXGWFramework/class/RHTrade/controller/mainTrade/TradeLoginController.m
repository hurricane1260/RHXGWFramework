//
//  TradeLoginController.m
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015 方海龙. All rights reserved.
//

#import "TradeLoginController.h"
#import "TradeDataManager.h"
#import "TradeSessionManager.h"
#import "TradeErrorParser.h"

#import "Reachability.h"

#import "PresentModalManager.h"
#import "TradeLoginView.h"
//#import "CPAdverDetailController.h"
#import "ChooseStockDataManager.h"
//#import "IQKeyboardManager.h"
#import "MNNavigationManager.h"
#import "RHtoCRHNaviManager.h"
#import "WebViewController.h"
//#import "PrefecturePictureVO.h"
//#import "CMHttpURLManager.h"

    //test


@interface TradeLoginController ()<TradeDataManagerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,ChooseStockDataManagerDelegate>

@property (nonatomic, strong) TradeLoginView *loginView;

/*! @brief 账号 */
@property (nonatomic, strong) NSString *userAccount;

/*! @brief 密码 */
@property (nonatomic, readonly) NSString *password;

/*! @brief 网络请求 */
@property (nonatomic, strong) TradeDataManager *dataManager;

/*! @brief 是选中的index */
@property (nonatomic, assign) BOOL isSelectedIndex;

/*! @brief 开户*/
//@property (nonatomic, strong) CPAdverDetailController *openAccountController;

@property (nonatomic, strong) UIButton *cancleButton;

@property (nonatomic, strong) UIButton *telButton;

/*! @brief 是否显示默认页面*/
kRhPStrong NSNumber * isShowDefault;

//kRhPStrong UIImage * defaultImg;

kRhPStrong id defaultImgParam;

kRhPStrong ChooseStockDataManager * defaultViewManager;

@end

@implementation TradeLoginController

#pragma mark ==============================================初始化&布局================================================

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"交易";
        self.dataManager = [[TradeDataManager alloc]init];
        self.dataManager.delegate = self;
        self.defaultViewManager = [[ChooseStockDataManager alloc] init];
        self.defaultViewManager.delegate = self;
//        [self setNavBarColor];
        self.cancleButton = [UIButton didBuildButtonWithTitle:@"取消" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
        self.leftButtonView = self.cancleButton;
        self.cancleButton.hidden = YES;
        self.cancleButton.titleLabel.font = font4_common_xgw;
        [self.cancleButton addTarget:self action:@selector(cancleButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)initSubviews {
    self.telButton = [UIButton didBuildButtonWithNormalImage:img_trade_tel highlightImage:img_trade_tel];
    [self.telButton addTarget:self action:@selector(phoneToServiceHotLine) forControlEvents:UIControlEventTouchUpInside];
    self.rightButtonView = self.telButton;
    
    __weak typeof (self) welf = self;
    if (self.loginView) {
        [self.loginView removeFromSuperview];
    }
    self.loginView = [[TradeLoginView alloc]initWithVerifyBlock:^{
        [welf verifyButtonTouchHandler];
    } loginBlock:^(NSDictionary *params) {
        [welf loginButtonTouchHandler:params];
    } openAccountBlock:^{
        [welf openAccountButtonTouchHandler];
    } withDefaultViewShow:self.defaultImgParam changeNavBarColorCallback:^(NSDictionary *params) {
        if (![params objectForKey:@"showDefault"]) {
            return;
        }
        BOOL showDefault = [[params objectForKey:@"showDefault"] boolValue];
        BOOL isServerConfig = [[params objectForKey:@"isServerConfig"] boolValue];
        UIColor * configColor =[params objectForKey:@"configColor"];
        if (showDefault) {
            if (configColor) {
                welf.navigationBar.backgroundColor = configColor;
                if (isServerConfig) {
//                    welf.titleLabel.textColor = color1_text_xgw;
                    [welf.telButton setImage:img_trade_tel forState:UIControlStateNormal];
                    
                    [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateNormal];
                    [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateHighlighted];
                }
                else{
                    welf.titleLabel.textColor = color2_text_xgw;
                    welf.navigationBar.backgroundColor = color2_text_xgw;
                    [welf.telButton setImage:img_trade_telBlack forState:UIControlStateNormal];
                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                    
                    [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateNormal];
                    [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateHighlighted];
                }
            }
        }
        else{
            if (isServerConfig) {
                welf.navigationBar.backgroundColor = color2_text_xgw;
                [welf.telButton setImage:img_trade_tel forState:UIControlStateNormal];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }
            else{
                welf.titleLabel.textColor = color1_text_xgw;

                welf.navigationBar.backgroundColor = color2_text_xgw;
//                [welf.telButton setImage:img_trade_tel forState:UIControlStateNormal]
                
//                welf.navigationBar.backgroundColor = color18_other_xgw;
                [welf.telButton setImage:img_trade_telBlack forState:UIControlStateNormal];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

            }
            [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateNormal];
            [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateHighlighted];
        }
//        if (isServerConfig) {
//            [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateNormal];
//            [welf.cancleButton setTitleColor:color1_text_xgw forState:UIControlStateHighlighted];
//        }
//        else{
//            [welf.cancleButton setTitleColor:color2_text_xgw forState:UIControlStateNormal];
//            [welf.cancleButton setTitleColor:color2_text_xgw forState:UIControlStateHighlighted];
//        }
        [welf.view setNeedsLayout];
    } serviceBlock:^{
        [self openCustmServiceVc];
    } forgetPassWordBlock:^{
        [RHtoCRHNaviManager navigationToCRHControllerWithCurrent:welf];
    } andBannerBlock:^{
        NSString * urlString = @"http://moblie.hczq.com/xgw/introduce-hc.html";
        WebViewController * webVc = [[WebViewController alloc] init];
        webVc.UrlString = urlString;
        webVc.webViewTitle = @"了解华创";
        [self presentViewController:webVc animated:NO completion:nil];
    }];
    
    self.loginView.phoneCallBack = ^{
//        [welf phoneToServiceHotLine];
        [welf openCustmServiceVc];

    };
    
    [self.view addSubview:self.loginView];
    self.loginView.delegate = self;
    self.loginView.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    self.navigationBar.height = 0;
    
    if (_showCancleButton) {//二级交易
        self.view.height = keyAppWindow.height;
    }
    else {
        self.view.height = keyAppWindow.height - TabBarHeight;
        
    }
    if (_isNeedFullScreen) {
//        self.view.height = keyAppWindow.height;
    }
    
//    self.navigationController.view.height = self.view.height;
    
    self.loginView.y = self.layoutStartY;
    self.loginView.size = CGSizeMake(self.view.width, self.view.height - self.layoutStartY);
    
    UILabel *tempLabel = self.cancleButton.titleLabel;
    [tempLabel sizeToFit];
    self.cancleButton.size = tempLabel.size;
    
//    self.robotServiceButton.frame = CGRectMake(0, 0, 20.0f, 20.0f);
    self.rightButtonView.frame = CGRectMake(self.view.width - 44.0f, StatusBarHeight, 44.0f, 44.0f);

}

- (void)initLoginView{
    self.isShowDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"tradeHaslogined"];
    if (![self.isShowDefault boolValue]) {
        //后台请求图片
        [self requestActivityAdvData];
//        [self initSubviews];

    }
    else{
        [self initSubviews];
    }
}

//- (CPAdverDetailController *)openAccountController {
//    if (!_openAccountController) {
//        _openAccountController = [[CPAdverDetailController alloc]init];
//        _openAccountController.urlString = kHczqOpenAccountHref;
//        _openAccountController.title = @"开户";
//    }
//    return _openAccountController;
//}

- (void)setShowCancleButton:(BOOL)showCancleButton {
    _showCancleButton = showCancleButton;
    self.cancleButton.hidden = !showCancleButton;
}

#pragma mark ==============================================setter、getter、生命周期================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButtonHidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(containerSelectTrade:) name:@"TradeIsSelectedIndex" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillBecomeForeground) name:@"appEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TradeLoginViewHasPresented" object:@(YES)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
///    if ([TradeSessionManager shareInstance].sessionID) {
//        [self.dataManager requestMagicCode];
//    }
//    else {
//        [[TradeSessionManager shareInstance]createSessionWithBlock:^{
//                //保证sessionID有了再发请求登录
//            [self.dataManager requestMagicCode];
//            [[TradeSessionManager shareInstance] startPing];
//        }];
///    }
//    [self requestPushMsg];
    [self initLoginView];

    self.isShowDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"tradeHaslogined"];
    self.loginView.showDefault = ![self.isShowDefault boolValue];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
///    if (![TradeSessionManager shareInstance].onLine) {//不在线，未登录状态
//        [[TradeSessionManager shareInstance] waitForLogout];
///    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.dataManager cancelAllRequest];
    [self.defaultViewManager cancelAllRequest];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TradeLoginViewHasPresented" object:@(NO)];

}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"TradeIsSelectedIndex" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"appEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    self.loginView = nil;
    self.userAccount = nil;
    _password = nil;
    self.dataManager = nil;
}

#pragma mark ==============================================请求返回================================================

-(void)loginResultHandler:(id)resultData andSuccess:(BOOL)success; {
    if (success) {
        [CMProgress showEndProgressWithTitle:@"登录成功" message:nil endImage:img_progress_success duration:3.0f];
        NSLog(@"-hc login success-");
        NSDictionary *accountDic = resultData;
        [[TradeSessionManager shareInstance] setOnLine:YES];
        [TradeSessionManager shareInstance].onLineAccount = [NSString stringWithFormat:@"%@",[accountDic objectForKey:@"clientId"]];
        
        [self.loginView clearView];
        [PresentModalManager dismissModalView:self.view animation:NO completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hcAccountLogin" object:nil];//告诉mainController 要跳交易
//        [self.view removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"tradeHaslogined"];
        [[NSUserDefaults standardUserDefaults] setObject:resultData[@"clientName"] forKey:@"TradeClientName"];
//
    }
    else {
        NSLog(@"-hc login fail-");
//        [self.dataManager requestMagicCode];
        NSString *errorInfo = [TradeErrorParser parseTradeErrorWithData:resultData];
        [CMProgress showEndProgressWithTitle:@"登录失败" message:errorInfo endImage:img_progress_failure duration:3.0f];
        [[TradeSessionManager shareInstance]createSessionWithBlock:^{
            [[TradeSessionManager shareInstance] startPing];
        }];
    }
}

-(void)getMagicCodeResultHandler:(id)resultData andSuccess:(BOOL)success {
    if (success) {
        UIImage *image = resultData;
        [self.loginView.verifyButton setImage:image forState:UIControlStateNormal];
//        self.verifyButton.size = image.size;
    }
    else {
        [CMProgress showWarningProgressWithTitle:nil message:@"加载验证码失败" warningImage:nil duration:3.0f];
    }
}

//获取默认页面信息
- (void)requestActivityAdvData{
//    [self.defaultViewManager requestChooseStockBannerWithLocation:@"2"];
    self.defaultImgParam = img_trade_default;
    [self initSubviews];
}

- (void)requestChooseStockBannerResultHandler:(id)resultData andSuccess:(BOOL)success
{
    if (success && [resultData isKindOfClass:[NSArray class]]) {
        NSArray * array = resultData;
        if (array.count != 1) {
            self.defaultImgParam = img_trade_default;
            [self initSubviews];
            return;
        }
        self.defaultImgParam = array[0];
    }
    else{
        self.defaultImgParam = img_trade_default;
    }
    [self initSubviews];

}

#pragma mark ==============================================交互================================================

-(void)loginButtonTouchHandler:(NSDictionary *)params{//
    

    [CMProgress showBeginProgressWithMessage:@"正在登录" superView:self.view];
    
    if ([TradeSessionManager shareInstance].sessionID == nil) {
        [[TradeSessionManager shareInstance]createSessionWithBlock:^{
            [[TradeSessionManager shareInstance] startPing];
            [self.dataManager sendLoginRequestWithParam:params];
        }];
    } else {
        [self.dataManager sendLoginRequestWithParam:params];
    }
 
}

-(void)openAccountButtonTouchHandler {
//    [self.navigationController pushViewController:self.openAccountController animated:YES];
//    [self.view addSubview:self.openAccountController.view];
//    [PresentModalManager presentModalView:self.openAccountController.view animation:NO completion:nil];
        //test
//    if (self.showCancleButton) {//二级交易
////        [[NSNotificationCenter defaultCenter]postNotificationName:kTradeLoginPushToCRHNotificationName object:@YES];
//        [RHtoCRHNaviManager navigationToCRHOpenAccountWithCurrent:self];
//    }
//    else {
////        [[NSNotificationCenter defaultCenter]postNotificationName:kTradeLoginPushToCRHNotificationName object:@NO];
//        [RHtoCRHNaviManager navigationToCRHOpenAccountWithHeadBanner:self];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToOpenAccountVC" object:nil];

}
#pragma mark---跳转到客服VC
- (void)openCustmServiceVc{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToCustomServiceVC" object:nil];
}
-(void)verifyButtonTouchHandler {//刷新验证码
//    [self.dataManager requestMagicCode];
}

//reachablity
- (void) reachabilityChanged: (NSNotification*)note {
//    if (!self.isSelectedIndex) {
//        return;
//    }
//    Reachability * reach = [note object];
    
//    if(([reach currentReachabilityStatus] != NotReachable))
//    {
//        [[TradeSessionManager shareInstance]createSessionWithBlock:^{
//            [self.dataManager requestMagicCode];
//            [[TradeSessionManager shareInstance] startPing];
//        }];
//    }
}

//app回到前台
-(void)appWillBecomeForeground {
//    if(![TradeSessionManager shareInstance].sessionID && self.isSelectedIndex)
//    {
//        [[TradeSessionManager shareInstance]createSessionWithBlock:^{
//            [self.dataManager requestMagicCode];
//            [[TradeSessionManager shareInstance] startPing];
//        }];
//    }
}

//是否选择了交易
-(void)containerSelectTrade:(NSNotification *)notify {
    NSNumber *number = notify.object;
    self.isSelectedIndex = number.boolValue;
    if (!_isSelectedIndex) {
        [self.view removeFromSuperview];
        [PresentModalManager dismissModalView:self.view animation:NO completion:nil];
    }
}

- (void)cancleButtonTouchHandler {
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.view removeFromSuperview];
    [self.dataManager cancelAllRequest];
    [PresentModalManager dismissModalView:self.view animation:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TradeLoginViewHasPresented" object:@(NO)];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTradeLoginCancledNotificationName object:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)phoneToServiceHotLine{

    NSString *number = @"4000885558";
    //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
//    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number];
    //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
            NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号

    [MTA trackCustomEvent:@"deal_call" args:nil];

}

#pragma mark ==============================================delegate================================================

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.loginView resignFirstResponder];
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
            self.loginView.y = self.layoutStartY;
            self.loginView.height -= height;
        }
        else {
            self.loginView.y = self.layoutStartY;
            self.loginView.height = self.view.height - self.layoutStartY;
        }
    } completion:nil];
//    NSLog(@"--------%f",self.loginView.height);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (![self.loginView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:YES keyboardInfo:userInfo];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (![self.loginView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    [self adjustTextViewByKeyboardState:NO keyboardInfo:userInfo];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 1) {
//        NSString *number = @"4000885558";
//        //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
//        NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number];
//        //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中
//        //        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
//    }
//}

@end
