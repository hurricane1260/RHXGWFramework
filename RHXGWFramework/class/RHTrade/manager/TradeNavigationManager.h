//
//  TradeNavigationManager.h
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeNavigationManager : NSObject

//跳转到交易
+ (void)navigationToTradeControllerWithCurrentController :(UIViewController *)currentController;

//跳转到交易登录
//+ (void)navigationToTradeLoginControllerWithCurrentController :(UIViewController *)currentController;

+(void)navigationToDealControllerWithCurrentController :(UIViewController *)currentController titleString:(NSString *)string;

//+(void)navigationToKLineWithCurrentController :(UIViewController *)currentController;

//+(void)navigationToTradeComitController:(UIViewController *)currentController withData:(id)data;

//+(void)navigationToMoreController:(UIViewController *)currentController;

+(void)navigationToTransferController:(UIViewController *)currentController;

+(void)navigationToInfomationController:(UIViewController *)currentController titleString:(NSString *)titlestring contentString:(NSString *)contentstring;

+ (void)navigationToIPOController:(UIViewController *)currentController;

+ (void)navigationToFAQController:(UIViewController *)currentController andTabNum:(NSInteger)tabNum;

@end
