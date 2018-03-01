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
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定退出开户吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actoin){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];//在代码块中可以填写具体这个按钮执行的操作
    UIAlertAction *quitAction=[UIAlertAction actionWithTitle:@"继续开户" style:UIAlertActionStyleDefault handler:^(UIAlertAction *actoin){
        
        
    }];
    
    [alert addAction:defaultAction];
    [alert addAction:quitAction];
    [self presentViewController: alert animated:YES completion:nil];
    
}

@end
