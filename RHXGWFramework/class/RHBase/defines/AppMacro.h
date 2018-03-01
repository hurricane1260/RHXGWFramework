//
//  AppMacro.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  app宏定义头文件
//

#ifndef stockscontest_AppMacro_h
#define stockscontest_AppMacro_h

#pragma mark ----------------------方便调用的方法---------------------------
//顶层UIWindow实例
#define keyAppWindow [UIApplication sharedApplication].keyWindow

#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

//状态栏高度
#define StatusBarHeight ([[UIScreen mainScreen] bounds].size.height == 812?44:20)
//navigationBar高度 + 状态栏高度
#define NavgationBarHeight ([[UIScreen mainScreen] bounds].size.height == 812?88:64)
//tabbar高度
#define TabBarHeight ([[UIScreen mainScreen] bounds].size.height == 812?83:49)
#define TabbarSafeBottomMargin  ([[UIScreen mainScreen] bounds].size.height == 812 ? 34.f : 0.f)

//IPhone6P适配项
#define IS_IPHONE_6P (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )736) < DBL_EPSILON )
//IPhone6适配项
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
//IPhone5适配项
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
//IPhone4适配项
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )

#define MAIN_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
//#define MAIN_SCREEN_WIDTH 375 //适配时测试用
//#define MAIN_SCREEN_WIDTH 540 //适配时测试用
#define MAIN_SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
//#define MAIN_SCREEN_HEIGHT 580 //适配时测试用

#pragma mark ----------------------UI规范，颜色----------------------

/**
 *文字颜色 命名：UI名_类型名_项目名
 */
#define color1_text_xgw             ([UIColor colorWithRXHexString:@"0xffffff"])
#define color2_text_xgw             ([UIColor colorWithRXHexString:@"0x021c3d"])
#define color3_text_xgw             ([UIColor colorWithRXHexString:@"0x333333"])
#define color4_text_xgw             ([UIColor colorWithRXHexString:@"0xa7aabe"])
#define color5_text_xgw             ([UIColor colorWithRXHexString:@"0xd6d7e0"])
#define color6_text_xgw             ([UIColor colorWithRXHexString:@"0xe2373f"])
#define color6_1_text_xgw           ([UIColor colorWithRXHexString:@"0xb82d34"])
#define color6_2_text_xgw           ([UIColor colorWithRXHexString:@"0xffd7d7"])
#define color7_text_xgw             ([UIColor colorWithRXHexString:@"0x01b78a"])
#define color7_1_text_xgw           ([UIColor colorWithRXHexString:@"0x088a68"])
#define color8_text_xgw             ([UIColor colorWithRXHexString:@"0x2a67c1"])
#define color9_text_xgw             ([UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f])
#define color10_text_xgw            ([UIColor colorWithRXHexString:@"0xcf343b"])

/**
 *图标颜色 命名：UI名_类型名_项目名
 */
#define color11_icon_xgw            ([UIColor colorWithRXHexString:@"0x0b318f"])
#define color12_icon_xgw            ([UIColor colorWithRXHexString:@"0x1b4077"])
#define color12_1_icon_xgw          ([UIColor colorWithRXHexString:@"0x3f6d9d"])
#define color12_2_icon_xgw          ([UIColor colorWithRXHexString:@"0x5c8fc4"])
#define color12_3_icon_xgw          ([UIColor colorWithRXHexString:@"0x79a6d4"])
#define color13_icon_xgw            ([UIColor colorWithRXHexString:@"0xe2373f"])
#define color14_icon_xgw            ([UIColor colorWithRXHexString:@"0xa7aabe"])
#define color15_icon_xgw            ([UIColor colorWithRXHexString:@"0xffffff"])

/**
 *其它颜色 命名：UI名_类型名_项目名
 */
#define color16_other_xgw           ([UIColor colorWithRXHexString:@"0xecedf1"])
#define color17_other_xgw           ([UIColor colorWithRXHexString:@"0xf5f7fa"])
#define color18_other_xgw           ([UIColor colorWithRXHexString:@"0xf5f5f5"])

/**
 *以下为遗留的尚未规范化的颜色，保留之前的命名
 */
#define color_font_orange           ([UIColor colorWithRXHexString:@"0xff9c00"])
#define color_bg_gray_f456          ([UIColor colorWithRXHexString:@"0xf4f5f6"])

#define color_textBg_blue           ([UIColor colorWithRXHexString:@"0x2aa6ed"])
#define color_textBg_orange         ([UIColor colorWithRXHexString:@"0xf49836"])
//#define color_textBg_purple         ([UIColor colorWithRXHexString:@"0x6060f2"])
//#define color_textBg_red            ([UIColor colorWithRXHexString:@"0xff4e4e"])
#define color_clear                 ([UIColor clearColor])

#define color_open_notselect      ([UIColor colorWithRXHexString:@"0xf7c5d8"])

//#define color_id_blue           ([UIColor colorWithRXHexString:@"0x38a7da"])
//#define color_id_red            ([UIColor colorWithRXHexString:@"0xf54e4f"])
//#define color_id_inblue         ([UIColor colorWithRXHexString:@"0xe9f9ff"])
//#define color_id_inred          ([UIColor colorWithRXHexString:@"0xfff5f5"])
#define color_black_alpha       ([UIColor colorWithRed:0 green:0 blue:0 alpha:.4])
#define color_rec_orange          ([UIColor colorWithRXHexString:@"0xff7200"])
#define color_rec_red           ([UIColor colorWithRXHexString:@"0xc43d3d"])

#pragma mark ----------------------UI规范，字体----------------------

/**
 *数字 命名：UI名_类型名_项目名
 */
#define font0_number_xgw                       [UIFont setNumFontWithSize:10]
#define font1_number_xgw                       [UIFont setNumFontWithSize:12]
#define font2_number_xgw                       [UIFont setNumFontWithSize:14]
#define font3_number_xgw                       [UIFont setNumFontWithSize:16]
#define font4_number_xgw                       [UIFont setNumFontWithSize:18]
#define font5_number_xgw                       [UIFont setNumFontWithSize:20]
#define font6_number_xgw                       [UIFont setNumFontWithSize:22]
#define font7_number_xgw                       [UIFont setNumFontWithSize:40]

/**
 *普通文字
 */
#define font0_common_xgw                       [UIFont systemFontOfSize:10]
#define font1_common_xgw                       [UIFont systemFontOfSize:12]
#define font2_common_xgw                       [UIFont systemFontOfSize:14]
#define font3_common_xgw                       [UIFont systemFontOfSize:16]
#define font4_common_xgw                       [UIFont systemFontOfSize:18]
#define font5_common_xgw                       [UIFont systemFontOfSize:20]
#define font6_common_xgw                       [UIFont systemFontOfSize:22]
#define font7_common_xgw                       [UIFont systemFontOfSize:40]

/**
 *加粗的普通文字
 */
#define font0_boldCommon_xgw                   [UIFont boldSystemFontOfSize:10]
#define font1_boldCommon_xgw                   [UIFont boldSystemFontOfSize:12]
#define font2_boldCommon_xgw                   [UIFont boldSystemFontOfSize:14]
#define font3_boldCommon_xgw                   [UIFont boldSystemFontOfSize:16]
#define font4_boldCommon_xgw                   [UIFont boldSystemFontOfSize:18]
#define font5_boldCommon_xgw                   [UIFont boldSystemFontOfSize:20]
#define font6_boldCommon_xgw                   [UIFont boldSystemFontOfSize:22]
#define font7_boldCommon_xgw                   [UIFont boldSystemFontOfSize:40]

/**
 *细的文字
 */
#define font0_lightCommon_xgw                  [UIFont systemFontOfSize:10 weight:UIFontWeightUltraLight]
#define font1_lightCommon_xgw                  [UIFont systemFontOfSize:12 weight:UIFontWeightUltraLight]
#define font2_lightCommon_xgw                  [UIFont systemFontOfSize:14 weight:UIFontWeightUltraLight]
#define font3_lightCommon_xgw                  [UIFont systemFontOfSize:16 weight:UIFontWeightUltraLight]
#define font4_lightCommon_xgw                  [UIFont systemFontOfSize:18 weight:UIFontWeightUltraLight]
#define font5_lightCommon_xgw                  [UIFont systemFontOfSize:20 weight:UIFontWeightUltraLight]
#define font6_lightCommon_xgw                  [UIFont systemFontOfSize:22 weight:UIFontWeightUltraLight]
#define font7_lightCommon_xgw                  [UIFont systemFontOfSize:40 weight:UIFontWeightUltraLight]


#pragma mark ----------------------配置宏------------------------
#define ISDEV           @"isDevelopment"
#define ISPRODUCTION    @"isProduction"
#define ISSTAGING       @"isStaging"

#pragma mark ----------------------大小----------------------

//static const CGFloat margin_5 = 5.0f;
//static const CGFloat margin_6 = 6.0f;
static const CGFloat margin_8 = 8.0f;
//static const CGFloat margin_10 = 10.0f;
static const CGFloat margin_12 = 12.0f;
//static const CGFloat margin_15 = 15.0f;
//static const CGFloat margin_20 = 20.0f;
//static const CGFloat margin_25 = 25.0f;
//static const CGFloat margin_34 = 34.0f;


#pragma mark ----------------------图片----------------------

//导航返回按钮
#define img_navigation_bar_return_up        ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_fh_nor"])
#define img_navigation_bar_return_down      ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_fh_nor"])
#define img_clear_form                      ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_dzz_qc_nor"])
//进度相关图片
#define img_progress_success                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_ts_dh_nor"])
#define img_progress_failure                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_ts_th_nor"])
#define img_progress_warning                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_ts_wwl_nor"])

#define img_share                           ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_share_xuangu"])

#define img_noData                          ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_nonedata"])
//交易
#define img_trade_logo                      ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_logo_login_transaction"])
#define img_trade_default                   ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_kaihu_transaction"])
#define img_trade_tel                       ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_tel_transaction"])
#define img_trade_telBlack                  ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_tel_transactionBlack"])

//登录注册
#define img_login_tel                       ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_tel_login"])
#define img_login_telcode                   ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_telcode_login"])

//新股申购
#define img_IPO_unLucky                     ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/pic-weizhongqian"])
#define img_IPO_lucky                       ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/pic-yizhongqian"])
#define img_IPO_wait                        ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/pic-daigongbu"])
#define img_IPO_default                     ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/pic-default"])

//投资组合
#define img_group_arrow                     ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_arrow_portfolio-details"])


#pragma mark -------------------------开户
#define img_open_bank               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_card_set"])
#define img_open_id                 ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_identity"])
#define img_open_wifi               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_wifi"])
#define img_open_click              ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_click"])
#define img_open_deselect           ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_nonclick"])
#define img_open_set                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_set"])
#define img_open_trash              ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_trash_set"])
#define img_open_tel                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_tel_set"])
#define img_open_question           ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_question_set"])
#define img_open_triangle           ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_triangle_set"])
#define img_open_down               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_down"])
#define img_open_idfront            ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_blueidcard_click"])
#define img_open_idback               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_redidcard_click"])
#define img_open_mark                 ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_mark_survey"])
#define img_open_pencil               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_pencil_surveyresult"])
#define img_open_circleClick          ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_click_survey-1"])
#define img_open_circleNoClick        ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_nonclick_survey-1"])
#define img_open_rightArrow           ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_add_right"])
#define img_open_bankjs               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_js"])
#define img_open_bankms               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_ms"])
#define img_open_bankzg               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_zg"])
#define img_open_bankny               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_ny"])
#define img_open_bankpf               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_pf"])
#define img_open_bankgf               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_gf"])
#define img_open_bankxy               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_xy"])
#define img_open_bankgd               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_gd"])
#define img_open_banksh               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_sh"])
#define img_open_bankjt               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_jt"])
#define img_open_banknb               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_nb"])
#define img_open_bankzx               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_zx"])
#define img_open_bankyz               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_yz"])
#define img_open_bankpa               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_pa"])
#define img_open_bankzs               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_zs"])
#define img_open_bankgs               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_bank_gs"])
#define img_open_face                 ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_face_video"])
#define img_open_light                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_light_video"])
#define img_open_volume               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_volume_video"])
#define img_open_microphone           ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_microphone_video"])
#define img_open_photo                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_photo_video"])
#define img_open_id                   ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_identity"])
#define img_open_card                 ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_card_set"])
#define img_open_wifi                 ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_wifi"])
#define img_open_sucSubmit            ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_success_submit"])
#define img_open_sucPass              ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_success_return"])
#define img_open_failPass             ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_check_return"])
#define img_open_camera               ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_camera"])
#define img_open_eye                  ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_codeeyes"])
#define img_open_noeye                ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_codenoeyes"])

#define img_open_bcPhoto              ([UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_photo"])


#define IPOArray @[@"待申购",@"配号查询",@"中签缴款"]

#define kRhPStrong @property(nonatomic,strong)
#define kRhPCopy @property(nonatomic,copy)
#define kRhPAssign @property(nonatomic,assign)
#define kRhPRetain @property(nonatomic,retain)
#define kRhPWeak @property(nonatomic,weak)
#define kRhPReadonly @property(nonatomic,readonly)


#endif
