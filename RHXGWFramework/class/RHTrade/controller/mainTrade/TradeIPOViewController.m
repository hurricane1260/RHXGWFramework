//
//  TradeIPOViewController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/14.
//
//

#import "TradeIPOViewController.h"
#import "TradeNavigationManager.h"

@interface TradeIPOViewController ()

@property (nonatomic,strong) UIButton * helpButton;

@end

@implementation TradeIPOViewController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"新股申购";
        
        UIButton * rightButton = [UIButton didBuildButtonWithTitle:@"帮助" normalTitleColor:color5_text_xgw highlightTitleColor:color5_text_xgw disabledTitleColor:color5_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
        [rightButton addTarget:self action:@selector(touchRightButton) forControlEvents:UIControlEventTouchUpInside];
        UILabel *tempLabel = rightButton.titleLabel;
        tempLabel.font = font2_common_xgw;
        [tempLabel sizeToFit];
        rightButton.width = tempLabel.width;
        rightButton.height = 44.0f;
        rightButton.x = self.view.width - rightButton.width - 15.0f;
        self.rightButtonView = rightButton;

    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navToTransAccVC:) name:kTradeToTransAccNotificationName object:nil];
    [self didBarSelectedVCLoadData:@"0"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTradeToTransAccNotificationName object:nil];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    [self.bottomScrollView removePullRefreshView];
    for (UIViewController * vc in self.vcMutArray) {
        if ([vc isKindOfClass:[BaseViewController class]]) {
            BaseViewController * followVC = (BaseViewController *)vc;
            followVC.navigationBarHidden = YES;
        }
    }
}

- (void)navToTransAccVC:(NSNotification *)noti{
    
    [TradeNavigationManager navigationToTransferController:self];
}

- (void)touchRightButton
{
    [TradeNavigationManager navigationToFAQController:self andTabNum:4];
}

@end
