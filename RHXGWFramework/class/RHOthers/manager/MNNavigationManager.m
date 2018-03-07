//
//  MNNavigationManager.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 2016/10/10.
//
//

#import "MNNavigationManager.h"
//#import "MNSettingController.h"
//#import "AHEditInfoController.h"
//#import "RHSettingPushController.h"
//#import "MNAboutController.h"
//#import "WebViewController.h"
//#import "MyHotSpotDetailViewController.h"
//#import "CMHttpURLManager.h"
//#import "MNFriendMsgListController.h"
//#import "MyFriendsController.h"
//#import "MyInviteCodeController.h"
//#import "MNBeefBoneController.h"
//#import "MNBeefAwardController.h"
#import "CustomServiceViewController.h"
//#import "SubThemeViewController.h"
@implementation MNNavigationManager
/*
//设置
+ (void)navToSettingController:(UIViewController *)currentController withParam:(BOOL)params{
    MNSettingController * setVC = [[MNSettingController alloc] init];
    setVC.isLogin = params;
    [currentController.navigationController pushViewController:setVC animated:YES];

}

//编辑资料
+ (void)navigationToEditInfoController:(UIViewController *)currentController andParams:(id)params{
    AHEditInfoController *editInfo = [[AHEditInfoController alloc]init];
    editInfo.detailVO = params;
    [currentController.navigationController pushViewController:editInfo animated:YES];
}

//推送设置
+ (void)navigationToSettingPushController:(UIViewController *)currentController{
    RHSettingPushController * vc = [[RHSettingPushController alloc] init];
    [currentController.navigationController pushViewController:vc animated:YES];
}

//关于
+ (void)naviToAboutController:(UIViewController *)currentController{
    MNAboutController * aboutVC = [[MNAboutController alloc] init];
    [currentController.navigationController pushViewController:aboutVC animated:YES];
}

//跳转webView
+ (void)naviToWebViewController:(UIViewController *)currentController withUrlString:(NSString *)urlString withWebTitle:(NSString *)title{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;

    NSString * host = [CMHttpURLManager getHostIPWithServID:@"htmlPageUrl"];
#pragma warning
    //测试
//    host = @"http://192.168.111.88:9093";
    NSString * h5Str = [NSString stringWithFormat:@"%@/r/common/xgwh5/%@&platform=ios&t=%f",host,urlString,time];
    NSString * url = [h5Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.UrlString = url;
    [currentController.navigationController pushViewController:webVC animated:YES];
}


////跳转事件详情页
//+ (void)naviToEventDetailController:(UIViewController *)currentController withParam:(id)aParam{
//    MNEventDetailController * eventVC = [MNEventDetailController new];
//    eventVC.param = aParam;
//    [currentController.navigationController pushViewController:eventVC animated:YES];
//
//}

//跳转事件详情页
+ (void)navigationToHotSpotDetailVC:(UIViewController *)currentController withParam:(id)aParam{
    MyHotSpotDetailViewController * hotSpotVC = [[MyHotSpotDetailViewController alloc] init];
    hotSpotVC.param = aParam;
    [currentController.navigationController pushViewController:hotSpotVC animated:YES];
}

+ (void)navigationToFriendMsgListVC:(UIViewController *)currentController share:(BOOL)share andFrom:(NavigationFrom)from{
//    MNFriendMsgListController * friendMsgVC = [[MNFriendMsgListController alloc] init];
    MyFriendsController * friendsController = [[MyFriendsController alloc] init];
    friendsController.contactsController = currentController;
    friendsController.share = share;
    friendsController.from = from;
    friendsController.delegate = currentController;
    [currentController.navigationController pushViewController:friendsController animated:YES];

}

 //跳转二维码分享页面

+ (void)navigationToInviteCodeVC:(UIViewController *)currentController{
    MyInviteCodeController * vc = [[MyInviteCodeController alloc]init];
    [currentController.navigationController pushViewController:vc animated:YES];
    
}
*/

 //跳转联系客服页面

+ (void)navigationToCustomServiceVC:(UIViewController *)currentController{
    CustomServiceViewController * vc = [[CustomServiceViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [currentController presentViewController:nav animated:NO completion:nil];
}

//+ (void)navigationToMyBeefBoneVC:(UIViewController *)currentController withClassName:(NSString *)className{
//    Class class = NSClassFromString(className);
//    UIViewController * beefBoneVC = [[class alloc] init];
//    [currentController.navigationController pushViewController:beefBoneVC animated:YES];
//
//}

+ (void)navigationToUniversalVC:(UIViewController *)currentController withClassName:(NSString *)className withParam:(id)param{
    Class class = NSClassFromString(className);
    BaseViewController * universalVC = [[class alloc] init];
    universalVC.universalParam = param;
    [currentController.navigationController pushViewController:universalVC animated:YES];

}
/*
+ (void)presentModalVcWithClassName:(NSString *)className withParam:(id)aParam{
    Class class = NSClassFromString(className);
    BaseViewController * modalVC = [[class alloc] init];
    modalVC.universalParam = aParam;
    UIViewController * rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    rootVc.definesPresentationContext = YES;
    modalVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    modalVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [rootVc presentViewController:modalVC animated:NO completion:nil];
    
}

//跳转新的h5链接(张达写)webView
+ (void)naviToH5WebViewController:(UIViewController *)currentController withUrlString:(NSString *)urlString withWebTitle:(NSString *)title{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString * host = [CMHttpURLManager getHostIPWithServID:@"h5PageUrl"];
    NSString * h5Str;
    if ([urlString containsString:@"?"]) {
        h5Str = [NSString stringWithFormat:@"%@/%@&platform=ios&t=%f",host,urlString,time];

    }
    else{
        h5Str = [NSString stringWithFormat:@"%@/%@?platform=ios&t=%f",host,urlString,time];

    }
    NSString * url = [h5Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WebViewController * webVC = [[WebViewController alloc] init];
    webVC.UrlString = url;
    webVC.webViewTitle = title;
    [currentController.navigationController pushViewController:webVC animated:YES];
}
//跳转主题下一级界面
+ (void)naviToSubThemeViewController:(UIViewController *)currentController withThemeID:(NSString *)themeID{
    SubThemeViewController * subThemeVc = [[SubThemeViewController alloc]init];
    subThemeVc.themeId = themeID;
    [currentController.navigationController pushViewController:subThemeVc animated:YES];
}
*/
@end
