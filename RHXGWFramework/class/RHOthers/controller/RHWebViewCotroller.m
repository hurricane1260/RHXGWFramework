//
//  RHWebViewCotroller.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/14.
//
//

#import "RHWebViewCotroller.h"
#import "MNHotSpotVO.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface RHWebViewCotroller ()<UIWebViewDelegate>

kRhPStrong UIWebView * webView;

kRhPCopy NSString * urlString;//web链接

kRhPAssign BOOL isShowShare;//是否显示分享

kRhPStrong UIButton * shareBtn;

//分享
kRhPCopy NSString * shareTitle;
kRhPCopy NSString * shareContent;
kRhPCopy NSString * shareUrl;//分享链接若分享原页面可不传 分享其他页面时使用

//操作信号使用
kRhPCopy NSString * stockName;

//新闻详情页
kRhPCopy NSString * newsTitle;
kRhPCopy NSString * newsContent;


@end


@implementation RHWebViewCotroller

- (instancetype)init{
    if (self = [super init]) {
//        self.title = @"热点详情";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    self.webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.webView) {
        self.webView = [[UIWebView alloc] init];
        self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }
    if (self.isShowShare) {
        [self initNavBar];
    }
    [self loadData];
    
//    if ([self.urlString isEqualToString:@"http://staging.robot.jinhui001.com"]) {
//        [MTA trackPageViewBegin:@"zx_robot"];
//    }
//    else if ([self.title isEqualToString:@"热点详情"]) {
//        [MTA trackPageViewBegin:@"wd_selected hotspot"];
//    }
//    else if([self.title isEqualToString:@"牛骨介绍"]){
//        [MTA trackPageViewBegin:@"wd_NIUGU introduction"];
//    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    
//    if ([self.urlString isEqualToString:@"http://staging.robot.jinhui001.com"]) {
//        [MTA trackPageViewEnd:@"zx_robot"];
//    }
//    else if ([self.title isEqualToString:@"热点详情"]) {
//        [MTA trackPageViewEnd:@"wd_selected hotspot"];
//    }
//    else if([self.title isEqualToString:@"牛骨介绍"]){
//        [MTA trackPageViewBegin:@"wd_NIUGU introduction"];
//    }
}

- (void)initNavBar{
    self.shareBtn = [UIButton didBuildButtonWithNormalImage:img_share highlightImage:img_share];
    [self.shareBtn addTarget:self action:@selector(shareApp) forControlEvents:UIControlEventTouchUpInside];
    self.rightButtonView = self.shareBtn;
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
    if (self.isShowShare) {
        self.rightButtonView.frame = CGRectMake(self.view.width - 44.0f, 20, 44.0f, 44.0f);
    }
}

- (void)setParam:(id)param{
    if ([param isKindOfClass:[MNHotSpotVO class]]) {
        
        MNHotSpotVO * pushVO = (MNHotSpotVO *)param;
        switch ([pushVO.type integerValue]) {
            case 1:
                self.title = @"内参";
                break;
            case 3:
                self.title = @"活动";
                break;
            default:
                break;
        }
        if ([pushVO.url rangeOfString:@"http"].location == NSNotFound) {
            self.urlString = [NSString stringWithFormat:@"http://%@",pushVO.url];
        }
        else{
            self.urlString = pushVO.url;
        }
        self.urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else if ([param isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = param;
        self.title = dic[@"title"];
        self.urlString = dic[@"urlString"];
        if ([param objectForKey:@"shareUrl"]) {
            self.shareUrl = [param objectForKey:@"shareUrl"];
        }
        if ([param objectForKey:@"share"]) {
            self.isShowShare = [[param objectForKey:@"share"] boolValue];
        }
        if ([param objectForKey:@"webType"]) {
            self.webViewType = [[param objectForKey:@"webType"] integerValue];
        }
        switch (self.webViewType) {
            case operateSignalWebType:{
                if ([param objectForKey:@"stockName"]) {
                    self.stockName = [param objectForKey:@"stockName"];
                }
            }
                break;
            case newsDetailWebType:{
                if ([param objectForKey:@"newsTitle"]) {
                    self.newsTitle = [param objectForKey:@"newsTitle"];
                }
                if ([param objectForKey:@"newsContent"]) {
                    self.newsContent = [param objectForKey:@"newsContent"];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)loadData{
    if ([self.urlString rangeOfString:@"http"].location == NSNotFound) {
        self.urlString = [NSString stringWithFormat:@"http://%@",self.urlString];
    }
    else{
        self.urlString = self.urlString;
    }

    NSURL * url = [NSURL URLWithString:self.urlString];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
}

#pragma mark------delegate------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    JSContext * context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js停止loading
    context[@"stopLoading"] = ^() {
        [CMComponent removeComponentViewWithSuperView];
    };
    
    return YES;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"web load fail");
    
    if (error.code == -1004 || error.code == -1009) {
        __weak typeof (self)welf = self;
        [CMComponent showRequestFailViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY) andTouchRepeatTouch:^{
            [welf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0]];
        }];
    }

//    [CMProgress showEndProgressWithTitle:nil message:@"加载失败" endImage:img_progress_failure duration:kPopupWindowDurationInterval];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"web finish");
    [CMComponent removeComponentViewWithSuperView];
//    [CMProgress showEndProgressWithTitle:nil message:@"加载成功" endImage:img_progress_success duration:kPopupWindowDurationInterval];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"web start");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];//开始加载前，清空缓存
    [CMComponent showLoadingViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY)];

//    [CMProgress showBeginProgressWithMessage:@"正在加载" superView:self.view];
}

- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY - _keyboardRect.size.height);
        [self.view addSubview:self.webView];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark ---------分享
- (void)shareApp{
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:@3 forKey:@"shareType"];
    [param setObject:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/shareIcon"] forKey:@"shareImage"];
    if (self.shareUrl) {
        [param setObject:self.shareUrl forKey:@"targetUrl"];
    }
    else{
        NSString * shareUrl = [NSString stringWithFormat:@"%@&openType=NonAPP",self.urlString];
        [param setObject:shareUrl forKey:@"targetUrl"];
    }
    switch (self.webViewType) {
        case operateSignalWebType:{
            self.shareTitle = [NSString stringWithFormat:@"智能大数据分析，%@股票在最优指标下的收益表现",self.stockName];
            self.shareContent = @"分享股票指标信号";
        }
            break;
        case newsDetailWebType:{
            if (self.newsTitle.length > 30) {
                self.shareTitle = [NSString stringWithFormat:@"%@...",[self.newsTitle substringToIndex:30]];
            }
            else{
                self.shareTitle = self.newsTitle;
            }
            if (self.newsContent.length > 10) {
                self.shareContent = [NSString stringWithFormat:@"%@...",[self.newsContent substringToIndex:10]];
            }
            else{
                self.shareContent = self.newsContent;
            }
        }
            break;
        default:
            self.shareTitle = self.title;
            self.shareContent = @" ";
            break;
    }
    if (!self.shareTitle.length || !self.shareContent.length) {
        return;
    }
    [param setObject:self.shareTitle forKey:@"shareTitle"];
    [param setObject:self.shareContent forKey:@"shareContent"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUMShareNotificationName object:param];
    
}



@end
