//
//  RHtoCRHNaviManager.h
//  TZYJ_IPhone
//
//  Created by rxhui on 16/9/21.
//
//  跳转到财人汇的开户

#import <Foundation/Foundation.h>

@interface RHtoCRHNaviManager : NSObject

+ (void)navigationToCRHOpenAccountWithCurrent:(UIViewController *)currentController;

    //仅一级页面banner跳开户时调用这个方法，多了隐藏/显示tabBar的通知
+ (void)navigationToCRHOpenAccountWithHeadBanner:(UIViewController *)currentController;

//调掌厅
+ (void)navigationToCRHControllerWithCurrent:(UIViewController *)currentController;

//跳转万8开户
+ (void)navigationToCRHOpenAccountEightWithCurrent:(UIViewController *)currentController;
@end
