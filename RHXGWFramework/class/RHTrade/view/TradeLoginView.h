//
//  TradeLoginView.h
//  stockscontest
//
//  Created by rxhui on 16/3/9.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradeLoginView : UIScrollView

/*! @brief 验证码按钮 */
kRhPStrong UIButton *verifyButton;

kRhPCopy ButtonCommonCallBack verifyCallback;

kRhPCopy ButtonCallBackWithParams loginCallback;

kRhPCopy ButtonCommonCallBack openAccountCallback;

kRhPCopy ButtonCallBackWithParams changeNavBarColorCallback;

kRhPCopy ButtonCommonCallBack phoneCallBack;

kRhPCopy ButtonCommonCallBack serviceForYouCallBack;

kRhPCopy ButtonCommonCallBack forgetPassWordCallBack;

kRhPCopy ButtonCommonCallBack bannerCallBack;

kRhPAssign BOOL showDefault;

- (instancetype)initWithVerifyBlock:(ButtonCommonCallBack)verifyCallback loginBlock:(ButtonCallBackWithParams)loginCallback openAccountBlock:(ButtonCommonCallBack)openAccountCallback withDefaultViewShow:(id)defaultImgParam changeNavBarColorCallback:(ButtonCallBackWithParams )colorCallBack serviceBlock:(ButtonCommonCallBack)serviceCallback forgetPassWordBlock:(ButtonCommonCallBack)forgetPassWordCallBack andBannerBlock:(ButtonCommonCallBack)bannerCallBack;

- (void)resignFirstResponder;

- (void)clearView;

//- (void)removeKeyboardNotification;

- (BOOL)isFirstResponder;

@end
