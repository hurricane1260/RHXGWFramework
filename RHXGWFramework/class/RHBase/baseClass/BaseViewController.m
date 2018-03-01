//
//  BaseViewController.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BaseViewController.h"

#import "Reachability.h"

@interface BaseViewController(){
    UIButton *_backButton;
//    UILabel *_titleLabel;
}

@property (nonatomic,strong)UIButton *buttonWiden;

@property (nonatomic,strong)Reachability *networkReach;
@end

@implementation BaseViewController

static CGFloat kBaseStatusBarHeight;

static const CGFloat kBaseNavigationBarHeight = 44.0f;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        kBaseStatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        [self initNavigationBar];

        [self initTitleLabel];

        [self initBackButton];
        
        self.view.backgroundColor = color18_other_xgw;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkChange:) name:kReachabilityChangedNotification object:nil];
//        self.networkReach = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)netWorkChange:(NSNotification *)notify {
//    NSLog(@"--netWorkChange-%@",notify.object);
//    Reachability *reachNotify = notify.object;
//    self.isNetWorkReachable = reachNotify.isReachable;
    
//    Reachability * reach = notify.object;;
//    NetworkStatus status = [reach currentReachabilityStatus];
//    if (status == NotReachable) {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hsNetConnect"];
//    }
}

/**
 *  初始化导航栏
 */
-(void)initNavigationBar{
    _navigationBar = [[UIView alloc] init];
    _navigationBar.backgroundColor = color2_text_xgw;
}

/**
 *  初始化默认的返回按钮
 */
-(void)initBackButton{
    _backButton = [UIButton didBuildButtonWithNormalImage:img_navigation_bar_return_up highlightImage:img_navigation_bar_return_down];
    
    [_backButton addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonWiden = [[UIButton alloc]init];
    [self.buttonWiden addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  返回按钮点击动作，子类可以覆盖该方法，实现自己的动作逻辑
 */
-(void)backButtonTouchHandler:(id)sender{
    if([self.parentViewController isKindOfClass:[UINavigationController class]]){
//        CATransition* transition = [CATransition animation];
//        transition.type = kCATransitionReveal;//可更改为其他方式
//        transition.subtype = kCATransitionFromRight;//可更改为其他方式
//        transition.duration = 0.3f;
//        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

/**
 *  初始化title
 */
-(void)initTitleLabel{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.textColor = [UIColor whiteColor];
}

-(void)cellLIne:(UITableViewCell *)cell withtabbleview:(UITableView *)tableview{
    
    //分割线长度
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

@synthesize navigationBarHidden = _navigationBarHidden;

-(void)setNavigationBarHidden:(BOOL)hidden{
    _navigationBarHidden = hidden;
    _navigationBar.hidden = _navigationBarHidden;
}

@synthesize navigationBarColor = _navigationBarColor;

-(void)setNavigationBarColor:(UIColor *)aColor{
    _navigationBarColor = aColor;
    if(_navigationBarColor){
        _navigationBar.backgroundColor = _navigationBarColor;
    }
}

@synthesize backButtonHidden = _backButtonHidden;

-(void)setBackButtonHidden:(BOOL)aValue{
    _backButtonHidden = aValue;
    _backButton.hidden = _backButtonHidden;
    self.buttonWiden.hidden = _backButtonHidden;
    if(_backButtonHidden){
        [_backButton removeTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonWiden removeTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_backButton addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonWiden addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@synthesize layoutStartY = _layoutStartY;

-(CGFloat)layoutStartY{
    _layoutStartY = _navigationBar.y + _navigationBar.height;
    return _layoutStartY;
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    if(!_titleLabel){
        [self initTitleLabel];
    }
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    [self viewWillLayoutSubviews];
}

@synthesize rightButtonView = _rightButtonView;

-(void)setRightButtonView:(UIView *)rView{
    [_rightButtonView removeFromSuperview];
    
    _rightButtonView = rView;
    
    if(_rightButtonView){
        [_navigationBar addSubview:_rightButtonView];
        [self viewWillLayoutSubviews];
    }
}

@synthesize leftButtonView = _leftButtonView;

-(void)setLeftButtonView:(UIView *)aView{
    [_backButton removeFromSuperview];
    [self.buttonWiden removeFromSuperview];
    [_backButton removeTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonWiden removeTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_leftButtonView removeFromSuperview];
    _leftButtonView = aView;
    
    if(_leftButtonView){
        [_navigationBar addSubview:_leftButtonView];
        [self viewWillLayoutSubviews];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:_navigationBar];
    
    [_navigationBar addSubview:_titleLabel];
    [_navigationBar addSubview:_backButton];
    [_navigationBar addSubview:self.buttonWiden];
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    CGSize imgSize = img_navigation_bar_return_up.size;
    [_titleLabel sizeToFit];
    CGSize titleSize = _titleLabel.size;

    if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0){
        _navigationBar.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kBaseNavigationBarHeight + kBaseStatusBarHeight);
        _backButton.frame = CGRectMake(0.0f, (kBaseNavigationBarHeight - imgSize.height) * 0.5f + kBaseStatusBarHeight, imgSize.width + kDefaultMargin, imgSize.height);
        //加大按钮的触摸范围
        self.buttonWiden.frame = CGRectMake(0, kBaseStatusBarHeight, kBaseNavigationBarHeight, kBaseNavigationBarHeight);
        _titleLabel.frame = CGRectMake((_navigationBar.frame.size.width - titleSize.width) * 0.5f, (kBaseNavigationBarHeight - titleSize.height) * 0.5f + kBaseStatusBarHeight, titleSize.width, titleSize.height);
        _rightButtonView.frame = CGRectMake(_navigationBar.frame.size.width - kDefaultMargin - _rightButtonView.frame.size.width, (kBaseNavigationBarHeight - _rightButtonView.frame.size.height) * 0.5f + kBaseStatusBarHeight, _rightButtonView.frame.size.width, _rightButtonView.frame.size.height);
        _leftButtonView.frame = CGRectMake(kDefaultMargin, (kBaseNavigationBarHeight - _leftButtonView.frame.size.height) * 0.5f + kBaseStatusBarHeight, _leftButtonView.frame.size.width, _leftButtonView.frame.size.height);
    }else{
        _navigationBar.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kBaseNavigationBarHeight);
        _backButton.frame = CGRectMake(kDefaultMargin, (kBaseNavigationBarHeight - imgSize.height) * 0.5f, imgSize.width, imgSize.height);
        self.buttonWiden.frame = CGRectMake(0, 0, kBaseNavigationBarHeight, kBaseNavigationBarHeight);
        _titleLabel.frame = CGRectMake((_navigationBar.frame.size.width - titleSize.width) * 0.5f, (_navigationBar.frame.size.height - titleSize.height) * 0.5f, titleSize.width, titleSize.height);
        _rightButtonView.frame = CGRectMake(_navigationBar.frame.size.width - kDefaultMargin - _rightButtonView.frame.size.width, (kBaseNavigationBarHeight - _rightButtonView.frame.size.height) * 0.5f, _rightButtonView.frame.size.width, _rightButtonView.frame.size.height);

        _leftButtonView.frame = CGRectMake(kDefaultMargin, (kBaseNavigationBarHeight - _leftButtonView.frame.size.height) * 0.5f, _leftButtonView.frame.size.width, _leftButtonView.frame.size.height);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSArray *controllers = self.navigationController.viewControllers;
    BOOL isPush = NO;
    NSUInteger count = self.curentStackCount.intValue;
    if(count > controllers.count){
        isPush = NO;
    }else if(count <= controllers.count){
        isPush = YES;
    }
    self.isPushView = isPush;

    self.curentStackCount = [NSNumber numberWithInteger:self.navigationController.viewControllers.count];
    
    self.navigationController.navigationBarHidden = YES;
//    [UINavigationBar appearance].translucent = NO;
//    [UINavigationBar appearance].barTintColor = color2_text_xgw;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
//    [UINavigationBar appearance].translucent = NO;
//    [UINavigationBar appearance].barTintColor = color2_text_xgw;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
//    [UINavigationBar appearance].translucent = NO;
//    [UINavigationBar appearance].barTintColor = color2_text_xgw;
    [self hiddenKeyboard];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    [self hiddenKeyboard];
}

-(void)hiddenKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}



@end
