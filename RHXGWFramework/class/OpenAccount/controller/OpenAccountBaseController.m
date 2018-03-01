//
//  OpenAccountController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/5.
//
//

#import "OpenAccountBaseController.h"
#import "OARequestManager.h"

@interface OpenAccountBaseController ()

kRhPStrong UIButton * quitBtn;

@end

@implementation OpenAccountBaseController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   self.quitBtn  = [UIButton didBuildButtonWithTitle:@"退出" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    [self.quitBtn addTarget:self action:@selector(quitOpenAccount) forControlEvents:UIControlEventTouchUpInside];
    self.rightButtonView = self.quitBtn;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.rightButtonView.frame = CGRectMake(self.view.width - 10.0f - 44.0f, 20.0f, 44.0f, 44.0f);

}

- (void)quitOpenAccount{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
