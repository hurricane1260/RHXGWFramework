//
//  TradeNavigationManager.m
//  stockscontest
//
//  Created by rxhui on 15/6/9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeNavigationManager.h"
#import "DealListController.h"
//#import "TradeKLineController.h"
//#import "TradeBuyEnsureController.h"
//#import "TradeMoreController.h"
#import "TradeTransferController.h"
#import "TradeInfoController.h"
#import "TradeController.h"
#import "TradeLoginController.h"
#import "PresentModalManager.h"
#import "TradeIPOViewController.h"
#import "WebViewController.h"
#import "CMHttpURLManager.h"

@implementation TradeNavigationManager


//1.跳转到交易
+ (void)navigationToTradeControllerWithCurrentController :(UIViewController *)currentController {
    TradeController *tradeView = [[TradeController alloc]init];
//    if ([currentController isKindOfClass:NSClassFromString(@"BrokerSelfPageController")]) {
//        tradeView.isBTrade = YES;
//    }
//    tradeView.viewType = TradeControllerTypeReal;
    tradeView.isSecondTrade = YES;
    [currentController.navigationController pushViewController:tradeView animated:YES];
}

//2.跳转到交易登录
+ (void)navigationToTradeLoginControllerWithCurrentController :(UIViewController *)currentController {
    TradeLoginController *tradeLoginView = [[TradeLoginController alloc]init];
    tradeLoginView.showCancleButton = YES;
    [PresentModalManager presentModalView:tradeLoginView.view animation:NO completion:nil];
}

+(void)navigationToDealControllerWithCurrentController:(UIViewController *)currentController titleString:(NSString *)string{
    DealListController *dealController = [[DealListController alloc]init];
    dealController.titleString = string;
    [currentController.navigationController pushViewController:dealController animated:YES];
}

//+(void)navigationToKLineWithCurrentController:(UIViewController *)currentController {
//    TradeKLineController *klineController = [[TradeKLineController alloc]init];
//    [currentController.navigationController pushViewController:klineController animated:YES];
//}

//+(void)navigationToTradeComitController:(UIViewController *)currentController withData:(id)data{
//    TradeBuyEnsureController *comitController = [[TradeBuyEnsureController alloc]init];
//    comitController.receivedData = data;
//    [currentController.navigationController pushViewController:comitController animated:YES];
//}

//+(void)navigationToMoreController:(UIViewController *)currentController{
//    TradeMoreController *moreController = [[TradeMoreController alloc]init];
//    [currentController.navigationController pushViewController:moreController animated:YES];
//}

//跳转银证转账
+(void)navigationToTransferController:(UIViewController *)currentController{
    TradeTransferController *transController = [[TradeTransferController alloc]init];
    [currentController.navigationController pushViewController:transController animated:YES];
}

+(void)navigationToInfomationController:(UIViewController *)currentController titleString:(NSString *)titlestring contentString:(NSString *)contentstring {
    TradeInfoController *info = [[TradeInfoController alloc]init];
    info.title = titlestring;
    info.contentString = contentstring;
    [currentController.navigationController pushViewController:info animated:YES];
}

+ (void)navigationToIPOController:(UIViewController *)currentController{
    TradeIPOViewController * IPOVC = [[TradeIPOViewController alloc] init];
    IPOVC.headerBarList = IPOArray;
    IPOVC.vcArray = @[kIPOApplyViewControllerClassName,kIPOMatchInfoViewControllerClassName,kIPOLuckyViewControllerClassName];
    [currentController.navigationController pushViewController:IPOVC animated:YES];

}

+ (void)navigationToFAQController:(UIViewController *)currentController andTabNum:(NSInteger)tabNum
{
    WebViewController * webView = [[WebViewController alloc] init];
    webView.webViewTitle = @"常见问题";
    NSString * host = [CMHttpURLManager getHostIPWithServID:@"h5PageUrl"];
    webView.UrlString = [NSString stringWithFormat:@"%@/questions.html?tabNum=%ld",host,(long)tabNum];
    [currentController.navigationController pushViewController:webView animated:YES];

}

@end
