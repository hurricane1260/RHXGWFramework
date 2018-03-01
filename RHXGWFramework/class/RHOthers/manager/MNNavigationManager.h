//
//  MNNavigationManager.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 2016/10/10.
//
//

#import <Foundation/Foundation.h>

@interface MNNavigationManager : NSObject

//+ (void)navToSettingController:(UIViewController *)currentController withParam:(BOOL)params;

//+ (void)navigationToEditInfoController:(UIViewController *)currentController andParams:(id)params;

//+ (void)navigationToSettingPushController:(UIViewController *)currentController;

//+ (void)naviToAboutController:(UIViewController *)currentController;

/**
 *  跳转H5webview
 *
 *  @param currentController 当前页
 *  @param urlString         url参数 
 *  @param title             页面标题
 */
//+ (void)naviToWebViewController:(UIViewController *)currentController withUrlString:(NSString *)urlString withWebTitle:(NSString *)title;

//+ (void)naviToEventDetailController:(UIViewController *)currentController withParam:(id)aParam;

/**
 *  跳转热点精选详情页
 *
 *  @param currentController 当前页
 *  @param aParam            热点id
 */
//+ (void)navigationToHotSpotDetailVC:(UIViewController *)currentController withParam:(id)aParam;

/**
    跳转好友消息列表
 */
//+ (void)navigationToFriendMsgListVC:(UIViewController *)currentController share:(BOOL)share andFrom:(NavigationFrom)from;

/**
    跳转二维码分享页面
 */
//+ (void)navigationToInviteCodeVC:(UIViewController *)currentController;
/**
    跳转联系客服页面
 */
+ (void)navigationToCustomServiceVC:(UIViewController *)currentController;
/**
    跳转我的牛股页面
 */
//+ (void)navigationToMyBeefBoneVC:(UIViewController *)currentController withClassName:(NSString *)className;

/**
    跳转页面的通用方法
 *  @param currentController    当前页
 *  @param className            要跳转页面的类名（字符串）
 *  @param aParam               要传入的参数
 */
+ (void)navigationToUniversalVC:(UIViewController *)currentController withClassName:(NSString *)className withParam:(id)aParam;

/**
    弹出模态页面的通用方法
 *  @param className            要跳转页面的类名（字符串）
 *  @param aParam               要传入的参数
 */
//+ (void)presentModalVcWithClassName:(NSString *)className withParam:(id)aParam;

/**
 跳转新的h5webView
 *  @param currentController       当前页
 *  @param urlString               要传入的参数
 *  @param title                   页面标题
*/
//+ (void)naviToH5WebViewController:(UIViewController *)currentController withUrlString:(NSString *)urlString withWebTitle:(NSString *)title;
/**
 
 跳转主题下一级界面
 */
//+ (void)naviToSubThemeViewController:(UIViewController *)currentController withThemeID:(NSString *)themeID;
@end
