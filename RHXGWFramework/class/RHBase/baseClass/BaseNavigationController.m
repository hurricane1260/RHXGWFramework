//
//  BaseNavigationController.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
        //    [self setNeedsStatusBarAppearanceUpdate];//修改状态栏的颜色，暂时无效
}

//修改状态栏的颜色
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    [super pushViewController:viewController animated:animated];
}

@end
