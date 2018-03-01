//
//  AppConstants.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  app常量定义头文件
//

#ifndef stockscontest_AppConstants_h
#define stockscontest_AppConstants_h

/**
 *  网络请求完成后的回调，一般是由交互层持有该回调的引用，解析数据完成后调用该回调，返回是否成功
 */
typedef void(^RequestDataManagerCompletionCallback)(BOOL success, id resultData);

/**
 *  网络请求完成后的回调，一般是由数据管理层持有该回调的引用，数据管理层请求网络数据完毕后不做解析直接调用该回调返回数据给交互层
 */
typedef void(^RequestNetwortCompletionCallback)(id resultData);

/* @brief 通用按钮回调block类型，不带参数 */
typedef void (^ButtonCommonCallBack)(void);

/* @brief 通用按钮回调block类型，带参数 */
typedef void (^ButtonCallBackWithParams)(NSDictionary *params);

/* @brief 网络请求回调block类型，返回是否成功、数据 */
typedef void(^RequestCompletionCallback)(BOOL success, id resultData);

/**
 *  牛人列表分组字段名称
 */
static NSString *kCompeteWorseUserGroupFieldName = @"createAt";

/**
 *  比赛栏目头高－－－－－不固定
 */
//static const CGFloat kCompeteHeaderHeight = 107.0f;

/**
 *  列表标题文字大小
 */
static const CGFloat kCellTitleFontSize = 18.0f;

/**
 *  列表小标题文字大小
 */
static const CGFloat kCellSubTitleFontSize = 14.0f;

/**
 *  app默认边距
 */
static const CGFloat kDefaultMargin = 15.0f;

/**
 *  app动画持续时间
 */
static const NSTimeInterval kAnimationTimerInterval = 0.35f;

/**
 *  信息弹出框默认显示时间
 */
static const NSTimeInterval kPopupWindowDurationInterval = 1.0f;

/**
 *  大按钮的默认高度
 */
static const CGFloat kDefaultUIButtonHeight = 40.0f;

/**
 *  中号按钮默认高度
 */
static const CGFloat kDefaultMiddleUIButtonHeight = 30.0f;

/**
 *  中号按钮默认宽度
 */
static const CGFloat kDefaultMiddleUIButtonWidth = 100.0f;

/**
 *  表单元素默认高度
 */
static const CGFloat kDefaultFormHeight = 50.0f;

/**
 *  忘记密码默认高度
 */
static const CGFloat kForgetFormHeight = 50.0f;


/**
 *  短信验证码倒计时数
 */
static const NSInteger kSMSDownCount = 60;

/**
 *  头像大小
 */
static const CGFloat kPhotoWidthAndHeight = 100.0f;

/**
 *  竞赛首页列表CELL高度
 */
static const CGFloat kCompeteIndexRankCellHeight = 110.0f;

/**
 *  投顾列表CELL高度
 */
static const CGFloat kCompeteInvestRankCellHeight = 129.0f + 8.0f;


/**
 *  实盘列表CELL高度
 */
static const CGFloat kCompeteFactRankCellHeight = 175.0f + 8.0f;

/**
 *  竞赛赛事报道列表cell高度
 */
static const CGFloat kCompeteRecommendCellHeight = 100.0f;

///**
// *  竞赛实盘列表cell高度
// */
//static const CGFloat kCompeteFactRankCellHeight = 50.0f;

/**
 *  竞赛推荐牛人列表cell高度
 */
static const CGFloat kCompeteWorseUserCellHeight = 84.0f;

/**
 *  比赛导航头小字体大小
 */
static const CGFloat kCompeteHeaderTextFontSize = 12.0f;

/**
 *  比赛首页列表title字体大小
 */
static const CGFloat kCompeteIndexCellTitleFontSize = 16.0f;

/**
 *  比赛首页列表SubTitle字体大小
 */
static const CGFloat kCompeteIndexCellSubTitleFontSize = 12.0f;

/**
 *  比赛首页列表数字大小
 */
static const CGFloat kCompeteIndexCellNumberFontSize = 18.0f;

/**
 *  缴纳跟单费优惠券高度
 */
static const CGFloat kMessageCouponViewHeight = 35.0f;

/**
 *  缴纳跟单费cell栏目高度
 */
static const CGFloat kMessageCellHeight = 52.0f;

/**
 *  缴纳跟单费cell间隔高度
 */
static const CGFloat kMessageCellGapHeight = 0.5f;


/**
 *  请求列表数据时的pageCount字段值
 */
static NSString *kReqPageCountString = @"15";

/**
 *  注册类型
 */
static const NSString *kTypeReg = @"reg";

/**
 *  找回密码类型
 */
static const NSString *kTypeFindPass = @"findPass";

/**
 *  昵称最长长度
 */
static const NSUInteger kNickNameMaxLength = 20;

/**
 *  密码最长长度
 */
static const NSUInteger kPasswordMaxLength = 16;

/**
 *  密码最小长度
 */
static const NSUInteger kPasswordMinLength = 6;

/**
 *  性别类型：男
 */
static NSString *kGenderMan = @"1";

/**
 *  性别类型：女
 */
static NSString *kGenderWoman = @"2";

/**
 *  YES字符串表示
 */
static NSString *kBOOLYES = @"YES";

/**
 *  NO字符串表示
 */
static NSString *kBOOLNO = @"NO";

/**
 *  true字符串表示
 */
static NSString *kBOOLTrue = @"true";

/**
 *  false字符串表示
 */
static NSString *kBOOLFalse = @"false";

/**
 *  头像园半径
 */
static const CGFloat kPhotoRadius = 45.0f;

/**
 *  赛事报道详情页图片高度
 */
static const CGFloat kRecommendDetailImageHeight = 120.0f;

/**
 *  请求排行榜是收益率参数名称KEY值
 */
static NSString *kRankRequestOrderFieldName = @"orderBy";

/**
 *  收益率总排行字段
 */
static NSString *kRankOrderFieldValueTotal = @"totalEarningsRate";

/**
 *  收益率月排行字段
 */
static NSString *kRankOrderFieldValueMonth = @"monthEarningsRate";

/**
 *  收益率周排行字段
 */
static NSString *kRankOrderFieldValueWeek = @"weekEarningsRate";

/**
 *  收益率日排行字段
 */
static NSString *kRankOrderFieldValueDay = @"dayEarningsRate";


/**
 *  标题最长字数
 */
static const NSInteger kTitleMaxNum = 36;

/**
 *  内容最长字数
 */
static const NSInteger kContentMaxNum = 5000;

/**
 *  评论最长字数
 */
static const NSInteger kCommentMaxNum = 2000;

/**
 *  个人简介最长字数
 */
static const NSInteger kIntroductionMaxNum = 100;

/**
 *  个人主页持股列表cell高度
 */
static const CGFloat kAHStockCellHeight = 65.0f;

/**
 *  个人主页交易列表cell高度
 */
static const CGFloat kAHTradeCellHeight = 54.0f;

/**
 *  讨论首页内容的最大行数
 */
static const NSInteger kForumsContentMaxLines = 3;

/**
 *  消息AT内容的最大行数
 */
static const NSInteger kMessageAtContentMaxLines = 4;

/**
 *  消息评论中显示原文的最长字数
 */
static const NSInteger kMessageCommentOriginalMaxCount = 12;

/**
 *  讨论和评论的pageSize
 */
static const NSInteger kForumsPageSize = 40;

/**
 *  榜单的pageSize
 */
static const NSInteger kCompetePageSize = 5;

/**
 *  交易记录的pageSize
 */
static const NSInteger kTradePageSize = 20;

/**
 *  持股列表显示的最大行数
 */
static const NSInteger kStockMaxShowNumber = 8;

/**
 *  买卖方向，买入
 */
static NSString *kTradeEntrustBsIn = @"1";

/**
 *  买卖方向，卖出
 */
static NSString *kTradeEntrustBsOut = @"2";

/**
 *  发新讨论的类型，问股
 */
static NSString *kForumNewAskStock = @"0";

/**
 *  发新讨论的类型，微博
 */
static NSString *kForumNewWeibo = @"1";

/**
 *  发新讨论的类型，转发
 */
static NSString *kForumNewRetweet = @"2";

/**
 *  发新讨论的类型，回答
 */
static NSString *kForumNewAnswer = @"3";

/**
 *  点赞的类型，对message进行点赞
 */
static NSString *kForumLikeMessage = @"m";

/**
 *  点赞的类型，对comment进行点赞
 */
static NSString *kForumLikeComment = @"c";

/**
 *  关注的类型，关注
 */
static NSString *kMessageFocusAdd = @"add";

/**
 *  关注的类型，取消关注
 */
static NSString *kMessageFocusCancel = @"cancel";

/**
 *  清空气泡的类型，评论
 */
static NSString *kMessageTipClearComment = @"1";

/**
 *  清空气泡的类型，at
 */
static NSString *kMessageTipClearAt = @"0";

/**
 *  清空气泡的类型，系统
 */
static NSString *kMessageTipClearSystem = @"3";

/**
 *  比赛首页榜单类型，散户
 */
static NSString *kCompeteIndexRankPrivate = @"1";

/**
 *  比赛首页榜单类型，百万
 */
static NSString *kCompeteIndexRankMillion = @"2";

/**
 *  比赛首页榜单类型，千万
 */
static NSString *kCompeteIndexRankHonor = @"3";

/**
 *  比赛用户类型，普通
 */
static NSString *kCompeteUserCommon = @"0";

/**
 *  比赛用户类型，融资融券
 */
static NSString *kCompeteUserRong = @"7";

/**
 *  跟投类型实盘
 */
static NSString * kCompeteStock = @"1";

/**
 *  跟投类型投顾
 */
static NSString * kCompeteInvest = @"3";

/**
 *  跟投类型投顾自由
 */
static NSString * kCompeteInvestAuto = @"4";

/**
 *  投顾未跟单
 */
static NSString *kInvestNotFollowed = @"1";

/**
 *  投顾已跟单
 */
static NSString * kInvestHasFollowed = @"2";

#pragma mark ----------------------app网络请求与返回数据通用字段----------------------

/**
 *  当请求数据时传递的当前页码的参数名称
 */
static NSString *kReqCurrentPage = @"cp";


/**
 *  数据返回时的当前页码字段
 */
static NSString *kResCurrentPageField = @"currentPage";


/**
 *  数据返回时总页数字段
 */
static NSString *kResTotalPageField = @"totalPage";

/**
 *  数据返回时列表数据字段
 */
static NSString *kResListDataField = @"list";

/**
 *  数据返回时总数字段
 */
static NSString *kResTotalCountField = @"totalCount";

/**
 *  数据返回时data字段
 */
static NSString *kResDataField = @"data";

//缴纳跟单费用bankNo字段
static NSString * kResBankNo = @"HCZF";

//开户
static NSString * kOpenAccClientId = @"client_id";
static NSString * kOpenAccMobile = @"mobile";
static NSString * kOpenAccCardId = @"cardId";
static NSString * kOpenAccBindBank = @"bindBank";
static NSString * kOpenAccBankCode = @"bankAccountCode";
static NSString * kOpenAccountRiskAnswer = @"riskAnswer";
static NSString * kOpenAccountRectify = @"rectify";
static NSString * kOpenAccountRiskTest = @"riskTest";


#pragma mark ----------------------app所用到的链接----------------------


/// 华创开户链接
static NSString *kHczqOpenAccountHref = @"http://phone.hczq.com/p/p/jinhui1";

/// 选股网宣传链接
static NSString *kXGWIntroducHref = @"http://www.hczq.com/r/common/kingApp.html";

// 注册
static NSString *kWebRegistHref =@"http://www.hczq.com/appUser/register.do?type=ios";
//static NSString *kWebRegistHref =@"https://www.hczq.com/appUser/register.do?type=ios";


#pragma mark ----------------------app所用到的通知----------------------

/**
 *  通知名，监听个人主页详情view的高度
 */
static NSString *kAHDetailViewHeightNotificationName = @"detailHeightChange";


/**
 *  通知名，监听已发送新讨论
 */
static NSString *kFNewDissNotificationName = @"post";

/**
 *  通知名，监听已登录
 */
static NSString *kACLogInNotificationName = @"login";

/**
 *  通知名，监听已退出登录
 */
static NSString *kACLogOutNotificationName = @"logout";

/**
 *  通知名，监听已注册
 */
static NSString *kACRegisterNotificationName = @"register";

/**
 *  通知名，监听交易账号已登录
 */
static NSString *kTradeLogInNotificationName = @"TradeLogin";

/**
 *  通知名，交易持仓用户资产
 */
static NSString *kTradeBalanceNotificationName = @"TradeBalance";

/**
 *  通知名，跟单推送，我跟了谁
 */
static NSString *kPushToIFollowNotificationName = @"FollowOrderPushToIFollowWho";

/**
 *  通知名，跟单推送，我的跟单
 */
static NSString *kPushToWhoFollowNotificationName = @"FollowOrderPushToWhoFollowMe";

/**
 *  通知名，跟单推送，跟单提示
 */
static NSString *kPushToFollowRemindNotificationName = @"MessageFollowRemind";

/**
 *  通知名，跟单推送，一键跟单提示
 */
static NSString *kPushToAutoFollowRemindNotificationName = @"AutoFollowRemind";

/**
 *  通知名，跟单推送，投顾一键跟单跟单提示
 */
static NSString *kPushToAdviserAutoFollowRemindNotificationName = @"AdviserAutoFollowRemind";

/**
 *  通知名，跳转到我
 */
static NSString *kChangeIndexNotPopNotificationName = @"kChangeIndexNotPopNotificationName";

static NSString *kPushToMeHomeNotificationName = @"kPushToMeHomeNotification";

static NSString *kModuleNotificationSelectedZXG = @"kModuleNotificationSelectedZXG";//自选股
static NSString *kModuleNotificationSelectedSP = @"kModuleNotificationSelectedSP";//实盘
static NSString *kModuleNotificationSelectedTrade = @"kModuleNotificationSelectedTrade";//交易
static NSString *kModuleNotificationSelectedHome = @"kModuleNotificationSelectedHome";//主页
static NSString *kModuleNotificationSelectedTG = @"kModuleNotificationSelectedTG";//投顾
static NSString *kModuleNotificationSelectedZHPH = @"kModuleNotificationSelectedZHPH";//组合排行
static NSString *kModuleNotificationSelectedTGPH = @"kModuleNotificationSelectedTGPH";//投顾排行
static NSString *kModuleNotificationSelectedSS = @"kModuleNotificationSelectedSS";//搜索
static NSString *kModuleNotificationSelectedSY = @"kModuleNotificationSelectedSY";//收益

static NSString *kAllowRemotePushNotification = @"kAllowRemotePushNotification";//设置接收远程推送

static NSString * kTabBarHiddenNoti = @"kTabBarHiddenNotification";//隐藏tabBar

static NSString * kTabBarShowNoti = @"kTabBarShowNotification";//显示tabBar

static NSString * kShowPushWebNoti = @"kShowPushWebNoti";//活动内参h5

static NSString * kTradeLoginCancledNotificationName = @"kTradeLoginCancledNotification";//交易登录取消（二级交易）

static NSString * kShowTabBubbleNoti = @"kShowTabBubbleNoti";//气泡提示

/**
 *  通知名,跳转到全部好友
 */
static NSString *kPushToMyFriendNotificationName = @"kPushToMyFriendNotificationName";

/**
 *  通知名，跳转到我的定制消息
 */
static NSString *kPushToMeCustomNotificationName = @"kPushToMeCustomNotification";

static NSString *kPushToMeUnactiveCustomNotificationName = @"kPushToMeUnactiveCustomNotificationName";


/**
 *  通知名，跳转到我的买卖信号
 */
static NSString *kPushToMeBuySellNotificationName = @"kPushToMeBuySellNotification";

static NSString *kPushToMeUnactiveBuySellNotificationName = @"kPushToMeUnactiveBuySellNotification";


static NSString * kChangeSelfStockNoti = @"kChangeSelfStockNotification";

/**
 *  全栈通知跳转新闻详情
 */
static NSString *kPushToWebNotificationName = @"kPushToWebNotification";

static NSString *kPushToUnactiveWebNotificationName = @"kPushToUnactiveWebNotification";

//全站通知跳h5
static NSString *kPushToH5NotificationName = @"kPushToH5Notification";

static NSString *kPushToUnactiveH5NotificationName = @"kPushToUnactiveH5Notification";

static NSString *kHsNetDownNotificationName = @"kHsNetDownNotification";

static NSString *kHsNetConnectNotificationName = @"kHsNetConnectNotification";

/**
 *  刷新个股详情页数据
 */
static NSString *kUpdateStockDetailDataNotificationName = @"kUpdateStockDetailDataNotificationName";

/**
 *  交易登录通知交易跳转财人汇
 */
static NSString *kTradeLoginPushToCRHNotificationName = @"kTradeLoginPushToCRHNotification";

/**
 *  财人汇返回
 */
static NSString *kCRHPopNotificationName = @"kCRHPopNotification";


/**
 *  入群成功通知
 */
static NSString *kYWEnterTribeNotificationName = @"kYWEnterTribeNotification";

/**
 *  退群成功通知
 */
static NSString *kYWExitTribeNotificationName = @"kYWExitTribeNotification";

/**
 *  音频播放进度通知
 */
static NSString *kAudioPlayerProgressNotificationName = @"kAudioPlayerProgressNotificationName";

/**
 *  音频播放完成通知
 */
static NSString *kAudioPlayerEndNotificationName = @"kAudioPlayerEndNotificationName";


static const NSInteger homeIndex = 0;
static const NSInteger selectStockIndex = 1;
static const NSInteger competeIndex = 2;
static const NSInteger investCompeteIndex = 3;
static const CGFloat investZHPHIndex = 3.1;
static const CGFloat investTGPHIndex = 3.2;
static const NSInteger tradeIndex = 4;
//static const NSInteger forumsIndex = 3;
//static const NSInteger meIndex = 4;

/**
 *  通知名，通知cell的ItemView隐藏股票代码等字段
 */
static NSString *kInvestHideStockCodeNotificationName = @"kHideStockCodeNameUse";

/**
 *  通知名，通知交易展示委托页
 */
static NSString *kTradeSelectEntrustListNotificationName = @"kTradeSelectEntrustList";

/**
 *  通知名，分享
 */
static NSString *kUMShareNotificationName = @"kUMShareNoti";

/**
 *  通知名，三方微信登录
 */
static NSString *kWXLoginNotificationName = @"kWXLoginNoti";

/**
 *  通知名，三方qq登录
 */
static NSString *kQQLoginNotificationName = @"kQQLoginNoti";

/**
 *  通知名，交易跳转新股申购
 */
static NSString *kTradeToIPONotificationName = @"kTradeToIPONoti";

/**
 *  通知名，新股申购跳转银证转账
 */
static NSString *kTradeToTransAccNotificationName = @"kTradeToTransAccNoti";

/**
 *  通知名，新股申购按钮
 */
static NSString *kIPOApplyNotificationName = @"kIPOApplyNoti";

/**
 *  通知名，新股申购修改申购数量
 */
static NSString *kIPOApplyNumModNotificationName = @"kIPOApplyNumModNoti";

/**
 *  通知名，加载下一页cell
 */
static NSString *kLoadNextPageNotificationName = @"kLoadNextPageNoti";

/**
 *  通知名，修改tabbarvc
 */
static NSString *kChangeTabBarVCNotificationName = @"kChangeTabBarVCNoti";

/**
 *  通知名，tabbar初始化完毕
 */
static NSString *kTabBarVCInitedNotificationName = @"kTabBarVCInitedNoti";

/**
 *  通知名，账号更新
 */
static NSString *kAccountUpdateNotificationName = @"kAccountUpdateNoti";

/**
 *  通知名，股票代码被清空，行情退订
 */
static NSString *kTradeStockClearNotificationName = @"kTradeStockClearNotification";

/**
 *  通知名，前台通知被点击（适用于iOS10）
 */
static NSString *kForegroundPushNotiHasClicked = @"kForegroundPushNotiHasClicked";

/**
 *  通知名，牛股奖励页跳转到二维码
 */
static NSString *kPushToBInviteCodeVCNotificationName = @"kPushToBInviteCodeVCNoti";

/**
 *  通知名，设置自动打赏点击好友列表
 */
static NSString *kSettingAutoRewardToFriendListNotificationName = @"kSettingAutoRewardToFriendListNoti";

/**
 *  通知名，跳到好友列表开启分享
 */
static NSString *kOpenShareToFriendListNotificationName = @"kOpenShareToFriendListNoti";

/**
 *  通知名，点击有声内参按钮动画通知
 */
static NSString *kVoiceInternalStopAnimationNotificationName = @"kVoiceInternalStopAnimationNoti";

/**
 *  通知名，h5分享成功后回调js
 */
static NSString *kHtml5ShareSuccessNotificationName = @"kHtml5ShareSuccessNotification";

/**
 *  通知名，h5登录成功后跳转聊天
 */
static NSString *kNaviToInvestChatNotificationName = @"kNaviToInvestChatNotification";



#pragma mark ----------------------app所用到的汉字----------------------

/**
 *  提示标题
 */
static NSString *kCHSInvalidTip = @"友情提示";

/**
 *  确定提示文字
 */
static NSString *kCHSYES = @"确定";

/**
 *  取消提示文字
 */
static NSString *kCHSCancel = @"取消";

/**
 *  注册提示文字
 */
static NSString *kCHSRegist = @"注册";

/**
 *  下一步提示文字
 */
static NSString *kCHSNextStep = @"下一步";

/**
 *  完成提示文字
 */
static NSString *kCHSComplete = @"完成";

/**
 *  短信验证码placeholder
 */
static NSString *kCHSSMSTextFieldPlaceholder = @"输入短信验证码";

/**
 *  重新发送验证码提示
 */
static NSString *kCHSSMSResend = @"重新发送";

/**
 *  登录提示文字
 */
static NSString *kCHSLogin = @"登录";

/**
 *  登录框上边提示文字
 */
static NSString *kCHSLoginTip = @"跟着实盘高手买, 真的可以赚钱";

/**
 *  登录用户名表单placeholder
 */
static NSString *kCHSLoginUserNameTextFieldPlaceholder = @"请输入手机号";

/**
 *  注册时电话表单placeholder
 */
static NSString *kCHSRegisterMobileTextFieldPlaceholder = @"输入您的手机号";

/**
 *  密码输入框表单placeholder
 */
static NSString *kCHSPasswdTextFieldPlaceholder = @"创建登陆密码,6位以上数字、字母";

/**
 *  登录密码名表单placeholder
 */
static NSString *kCHSLoginPassWordTextFieldPlaceholder = @"请输入密码";

/**
 *  登录验证码表单placeholder
 */
static NSString *kCHSLoginVerifyCodeTextFieldPlaceholder = @"请输入图形验证码";

/**
 *  登录短信验证码表单placeholder
 */
static NSString *kCHSPhoneVerifyCodeTextFieldPlaceholder = @"请输入手机验证码";

/**
 *  电话号码验证没有通过汉字提示
 */
static NSString *kCHSMobileInvalid = @"请输入正确格式的电话号码或用户名";

/**
 *  密码验证没有通过汉字提示
 */
static NSString *kCHSPasswdInvalid = @"密码必须是六位以上";

/**
 *  确认密码没有输入汉字提示
 */
static NSString *kCHSConfirmPasswdInvalid = @"请确认密码";

/**
 *  两次密码不一致汉字提示
 */
static NSString *kCHSTwoPasswdNotSame = @"两次密码不一致";

/**
 *  图形验证码不符合规则提示
 */
static NSString *kCHSImgInvalid = @"图形验证码不能为空";

/**
 *  短信验证码不符合规则提示
 */
static NSString *kCHSSMSInvalid = @"短信验证码不能为空";

/**
 *  获取头像图片失败提示
 */
static NSString *kCHSPhotoInvalid = @"获取头像失败";

/**
 *  上传头像失败提示
 */
static NSString *kCHSUploadPhotoFailure = @"上传头像失败, 请尝试上传小图片";

/**
 *  昵称不合法提示
 */
static NSString *kCHSNickNameInvalid = @"您输入昵称的字符太短或者超过字符限制";

/**
 *  性别选择提示
 */
static NSString *kCHSGenderInvalid = @"请选择性别";

/**
 *  注册时阅读协议提示
 */
static NSString *kCHSRegisterProtocol = @"我已经阅读并同意";

/**
 *  阅读协议不合法提示
 */
static NSString *kCHSRegisterProtocolInvalid = @"请阅读并同意协议";

/**
 *  协议名称
 */
static NSString *kCHSRegisterProtocolName = @"股票跟投王服务协议";

/**
 *  跟单页面阅读协议提示
 */

static NSString *FollowOrderLoginProtocol = @"我同意";

/**
 *  投顾一键跟单页面阅读协议提示
 */

static NSString *kCHSAdviserAutoFollowProtocol = @"确认已阅读并接受";

/**
 *  跟单协议名称&风险提示
 */

static NSString *FollowOrderLoginProtocolName = @"《跟单协议及风险提示》";
static NSString *FollowOrderRiskProtocolName = @"《跟投风险揭示书》";
static NSString *FollowOrderAdviserProtocolName = @"《找投顾专区领投业务协议》";
static NSString *FollowOrderAdviserAutoProtocolName = @"《一键跟单服务协议》";

/**
 * 跟单确认页面协议名称
*/
static NSString *FollowOrderarrifmSureprotocolName = @"《跟单协议及风险提示》";

/**
 *  找回密码提示
 */
static NSString *kCHSFindPasswdTip = @"手机验证码找回密码";

/**
 *  正在加载数据提示
 */
static NSString *kCHSProgressing = @"正在加载";

/**
 *  正在处理提示
 */
static NSString *kCHSProgressRequestProcessing = @"处理中, 请稍后";

/**
 *  处理成功提示
 */
static NSString *kCHSProgressRequestProcessSuccess = @"处理成功";

/**
 *  处理失败提示
 */
static NSString *kCHSProgressRequestProcessFailure = @"处理失败";

/**
 *  数据加载成功提示
 */
static NSString *kCHSProgressingSuccess = @"加载成功";

/**
 *  数据加载失败提示
 */
static NSString *kCHSProgressingFailure = @"加载失败";

/**
 *  数据无下一页提示
 */
static NSString *kCHSProgressingNoNextPage = @"暂无更多";

/**
 *  发送短信验证码进度
 */
static NSString *kCHSProgressSMSSending = @"正在向手机发送短信验证码";

/**
 *  短信验证码发送成功消息
 */
static NSString *kCHSProgressSMSSendSuccess = @"验证码发送成功";

/**
 *  短信验证码发送失败标题
 */
static NSString *kCHSProgressSMSSendFailure = @"发送失败";

/**
 *  正在校验短信验证码进度提示
 */
static NSString *kCHSProgressCheckSMSCodeing = @"正在校验短信验证码";

/**
 *  校验短信验证码成功进度提示
 */
static NSString *kCHSProgressCheckSMSCodeSuccess = @"验证码校验成功";

/**
 *  校验短信验证码失败提示
 */
static NSString *kCHSProgressCheckSMSCodeFailure = @"校验失败";

/**
 *  正在修改密码进度提示
 */
static NSString *kCHSProgressModifyPasswding = @"正在修改账户密码";

/**
 *  修改密码成功进度提示
 */
static NSString *kCHSProgressModifyPasswdSuccess = @"账户密码修改成功";

/**
 *  修改密码失败进度提示
 */
static NSString *kCHSProgressModifyPasswdFailure = @"修改失败";

/**
 *  设置头像进度提示
 */
static NSString *kCHSProgressUploading = @"正在设置账户头像";

/**
 *  设置头像成功进度提示
 */
static NSString *kCHSProgressUploadSuccess = @"账户头像设置成功";

/**
 *  设置头像失败进度提示
 */
static NSString *kCHSProgressUploadFailure = @"设置失败";

/**
 *  正在设置账户资料进度提示
 */
static NSString *kCHSProgressSetPersonInformationing = @"正在设置账户资料";

/**
 *  设置账户资料成功进度提示
 */
static NSString *kCHSProgressSetPersonInformationSuccess = @"设置账户资料成功";

/**
 *  设置账户资料失败进度提示
 */
static NSString *kCHSProgressSetPersonInformationFailure = @"设置失败";

/**
 *  正在注册进度提示
 */
static NSString *kCHSProgressRegistering = @"注册中,请稍后";

/**
 *  注册成功进度提示
 */
static NSString *kCHSProgressRegisterSuccess = @"注册成功";

/**
 *  注册失败进度提示
 */
static NSString *kCHSProgressRegisterFailure = @"注册失败";

/**
 *  正在登录进度提示
 */
static NSString *kCHSProgressLogining = @"登录中,请稍后";

/**
 *  登录成功提示
 */
static NSString *kCHSProgressLoginSuccess = @"登录成功";

/**
 *  登录失败提示
 */
static NSString *kCHSProgressLoginFailure = @"登录失败";

/**
 *  未登录提示
 */
static NSString *kCHSProgressUnLog = @"未登录";

/**
 *  昵称TextField提示
 */
static NSString *kCHSNickNameTextFieldPlaceholder = @"可中英文昵称,最长8字符";

/**
 *  已点赞提示
 */
static NSString *kCHSProgressHaveLiked = @"您已赞过";

/**
 *  正在发送评论提示
 */
static NSString *kCHSProgressSendComment = @"正在发送";

/**
 *  发送评论成功提示
 */
static NSString *kCHSProgressSendCommenSuccess = @"评论成功";

/**
 *  发送评论失败提示
 */
static NSString *kCHSProgressSendCommentFailure = @"评论失败";

/**
 *  正在发送新讨论提示
 */
static NSString *kCHSProgressSendDiscussion = @"正在发送";

/**
 *  发送新讨论成功提示
 */
static NSString *kCHSProgressSendDiscussionSuccess = @"发送成功";

/**
 *  发送新讨论失败提示
 */
static NSString *kCHSProgressSendDiscussionFailure = @"发送失败";

static NSString *kCHSProfitTitle = @"综合收益率";

static NSString *kCHSProgressCheckAccount = @"正在验证账户信息";

static NSString *kCHSProgressCheckAccountFailureTitle = @"验证失败";

static NSString *kCHSProgressBindHCAccount = @"正在绑定账户";

static NSString *kCHSProgressBindHCAccountFailureTitle = @"绑定失败";

static NSString *kCHSProgressEnterNameing = @"正在报名";

static NSString *kCHSProgressEnterNameFailure = @"报名失败, 请重试";

static NSString *kCHSLike = @"赞";

static NSString *kCHSComment = @"评论";

static NSString *kCHSAtMe = @"@我";

static NSString *kCHSSystem = @"系统";

static NSString *kCHSRank = @"实盘排名";

static NSString *kCHSRankRong = @"两融排名";

static NSString *kCHSTotalEarningRate = @"总收益率";

static NSString *kCHSMaxDrawBack = @"最大回撤";

static NSString *kCHSComEarningRate = @"综合收益率";

static NSString *kCHSIntroduceNone = @"暂无简介";

static NSString *kCHSAddAttention = @"加关注";

static NSString *kCHSCancleAttention = @"取消关注";

static NSString *kCHSAtSomeone = @"@TA";

static NSString *kCHSEditIntroduce = @"编辑资料";

static NSString *kDefaultProfitAndRank = @"--";

static NSString *kCHSStockSectionTitleName = @"名称代码";

static NSString *kCHSStockSectionTitleCost = @"成本价/收益率";

static NSString *kCHSStockSectionTitleYield = @"仓位占比";

static NSString *kCHSTradeSectionTitleCost = @"成交价（元）";

static NSString *kCHSTradeSectionTitleTime = @"时间";

static NSString *kCHSHoldShars = @"持股";

static NSString *kCHSDiscussion = @"帖子";

static NSString *kCHSNoneStock = @"暂无持股";

static NSString *kCHSNoneTrade = @"暂无交易";

static NSString *kCHSNoneStockAndTrade = @"暂无持股与交易记录";

static NSString *kCHSNoneDiscussion = @"没有发布任何帖子";

static NSString *kCHSTradeSectionTitle = @"实盘交易";

static NSString *kCHSStockDetailListTitleStock = @"详细持股";

static NSString *kCHSStockDetailListTitleTrade = @"交易记录";

static NSString *kCHSSettingAccountManage = @"账号管理";

static NSString *kCHSSettingEdit = @"修改资料";



static NSString *kCHSSettingServiceProtocol = @"服务协议";

static NSString *kCHSSettingUpdate = @"版本更新";

static NSString *kCHSSettingLogout = @"退出当前账号";

static NSString *kCHSSettingTitle = @"设置";

static NSString *kCHSEditHead = @"头像";

static NSString *kCHSEditUsercode = @"账号";

static NSString *kCHSEditNickname = @"昵称";

static NSString *kCHSEditGender = @"性别";

static NSString *kCHSEditAbstract = @"简介";

static NSString *kCHSEditAbstractHint = @"介绍一下自己";

static NSString *kCHSEditRevertInfoHint = @"是否放弃对资料的修改？";

static NSString *kCHSEditRevertInfoCommit = @"放弃";

static NSString *kCHSEditRevertInfoCancle = @"继续编辑";

static NSString *kCHSStockDetailStockTitle = @"详细持股";

static NSString *kCHSStockDetailTradeTitle = @"交易记录";

static NSString *kCHSStockDetailTradeCost = @"成交价（元）";

static NSString *kCHSStockDetailTradeTime = @"时间";

static NSString *kCHSForumsLike = @"赞";

static NSString *kCHSForumsComment = @"评论";

static NSString *kCHSForumsReply = @"回复";

static NSString *kCHSMessageComment = @"评论我的帖子：";

static NSString *kCHSMessageReply = @"回复我的评论：";

static NSString *kCHSMessageHasFocused = @"已关注";

static NSString *kCHSMessageHasNotFocused = @"未关注";

static NSString *kCHSMessageSystem = @"系统消息";

static NSString *kCHSForumsNewTitle = @"标题";

static NSString *kCHSNoneDataHint = @"无数据，检查网络连接或重试";

static NSString *kCHSNoneDataRefresh = @"再刷一次";

/**
 *  性别类型：男,汉字
 */
static NSString *kCHSGenderMan = @"男";

/**
 *  性别类型：女,汉字
 */
static NSString *kCHSGenderWoman = @"女";

/**
 *  跟单清空持仓名称
 */
static NSString *followOrderCleanTrackStock = @"followOrderCleanStock";

/**
 *  投顾一键跟单服务协议
 */
static NSString * kCHSAdviserAutoFollowResponProtocol = @"欢迎申请定制华创证券有限责任公司股票跟投王平台（以下简称“跟投王平台”或“平台”）一键跟单服务。一键跟单服务协议（以下简称“本协议”）是平台与平台注册用户(以下简称“用户”或“您”)就申请定制一键跟单服务相关事项所订立的有效合约。您通过网络页面点击勾选并确认接受本协议，即表示您申请定制跟投王平台一键跟单服务并同意接受本协议所载全部内容、条款和条件以及同意向平台支付相关费用。\n达成如下协议，供双方共同遵守。\n\n第一条 双方声明\n（一）用户自愿选择平台提供的本协议约定的服务产品。\n（二）用户签约前，应详细阅读本协议的所有内容，尤其是本协议中免除、减轻平台责任或者限制用户权利的条款。如发生纠纷，用户不得以未仔细阅读本协议条款为由进行抗辩。\n（三）用户签约前，应充分阅读、完全理解并签署《一键跟单服务协议》和《风险揭示书》，愿意承担证券市场的各种风险，参考使用平台产品，平台对用户的投资损失不承担责任。\n\n第二条 平台产品介绍\n投顾专区是指为入驻平台的领投人展示综合能力及为定制服务的用户提供服务的互联网应用平台。\n用户通过本协议定制的是一键跟单服务，定制一键跟单业务后，跟投人账户关联领投人账户，用户可通过注册平台的手机接收短信及登录APP接收所选投资组合的交易信息，同时用户有解约的权利，领投人有为用户提供服务的义务和收取服务费的权利。\n\n第三条 产品收费标准\n（一）根据用户选择组合的不同，用户向平台支付不同费用，平台所展示的一键跟单服务均为单月价格。产品服务期限1个月。\n（二）用户在定制一键跟单服务时，请仔细了解相关产品及费用收取方式，并确认总的支付价格后再付款，用户定制产品前如有疑问可拨打客服电话（4008-6666-89），一旦用户成功定制产品则视为已充分知晓产品服务内容并接受服务价格及费用收取方式。\n（三）固定收取一键跟单定制服务费。按月核算，如领投人账户收益大于0，则收取跟单定制服务费；如领投人账户收益小于0，则跟单定制费用退还跟投人。\n（四）服务期约定\n产品服务期限1个月，服务开始日期以用户成功定制产品之日起计。\n\n第四条 跟投规则说明\n(一)跟投账户可以有持仓或现金，可以随时交易、转存取款；\n(二)系统自动校验跟投账户创业板等交易权限，如无，提示可能因交易品种受限，无法完全实现一键跟单；\n(三)领投账户不做投资品种限制；\n(四)跟投账户从定制一键跟单业务T+1交易日、领投账户第一笔买入交易起一键跟单；不自动复制领投人账户已有的持仓；\n(五)跟投人可设定跟投金额；\n(六)参考买入股数按最大比例跟投：\n按照领投账户买入个股占总资产的比例，跟单资金按最接近此比例计算跟投买入股数，不足一手，则提示跟单资金不足，无法跟投；如果实际资金账户有资金会提示用户修改买入股数；\n卖出时，按照领投账户卖出个股占该股总持股的比例，跟投账户按最接近此比例计算跟投卖出股数，如无可以跟投卖出的持仓，则提示股票余额不足，无法跟投；\n(七)跟投账户定制一键跟单后，自己买卖交易不受限制；\n(八)一键跟单同时以App信息的方式实时推送、提醒跟投人；\n\n第五条 用户权利和义务\n（一）用户享有使用所选产品的权利。\n（二）用户有权要求平台在签约当日或次日提供本协议所选产品。\n（三）用户有权通过平台的客户服务电话（4008-6666-89）进行咨询或投诉。\n（四）用户应遵守中华人民共和国相关法律、法规、规章以及其他规范性文件的要求。\n（五）用户不得以盈利为目的，复制、修改、使用、摘编、传播平台产品。\n\n第六条 平台权利和义务\n（一）平台有权利对本协议条款进行解释。\n（二）如用户有违反本协议的行为，平台有权停止为用户提供产品。\n（三）平台应当遵循诚实信用原则，勤勉、审慎地为客户提供产品服务。\n（四）入驻找投顾专区的领投人禁止以任何方式向用户承诺或者保证投资收益。\n（五）入驻找投顾专区的领投人严禁接受客户的全权委托，严禁接受未经客户授权的非全权委托。\n（六）平台不得向他人泄露用户的信息。\n\n第七条 协议的修改、生效及终止\n（一）协议的修改\n1、平台保留随时修改本协议的权利。修改本协议时，平台将公告新的协议文本，不对用户进行个别通知。用户签订本协议的视为用户同意本条约定。\n2、用户不同意本协议修订版内容的，应书面通知平台停止向其提供产品，否则视为同意协议补充或变更内容。\n（二）协议生效、终止\n1、本协议自用户确认勾选之日起生效。\n2、用户定制的产品到期本协议自动终止，如需续约则需重新定制产品并确认勾选本协议。\n3、用户单方要求解除协议的，用户应联系客服中心，并上传本人有效身份证件及相关身份证明材料，次日终止协议。\n\n第八条 争议的解决\n因本协议引起的或与本协议有关的任何争议，由本协议签订各方协商解决；协商不成，可以提向中国证券业协会申请调解；调解不成的，本协议项下争议应向平台所在地方法院起诉。争议期间，各方仍应履行未涉争议的条款。\n";

static NSString * kCHSAdviserAutoFollowRiskProtocol = @"尊敬的用户：\n\n您在点选找投顾专区“一键跟单”进行跟投时，需明确如下潜在风险，请您认真仔细阅读。\n\n1、“一键跟单”功能只是找投顾专区领投人所管理模拟投资组合的一个交易提示，具有针对性和时效性，不能在任何市场环境下长期有效，仅供投资者参考，请投资者自主决策审慎跟投，固定收取一键跟单定制服务费。按月核算，如领投人账户收益大于0，则收取跟单定制服务费；如领投人账户收益小于0，则跟单定制费用退还跟投人。\n\n2、目标计划所称目标投资收益并非对该计划投资收益的承诺和保证，投资者需了解选择跟投目标计划所带来的风险。\n\n3、已充分了解本平台找投顾专区服务的收费标准和方式，并按照公平、合理、自愿的原则签署《股票跟投王找投顾专区目标计划服务协议》或《股票跟投王找投顾专区短信跟投服务协议》。找投顾业务服务收费应通过本平台支付，不得向领投人或其他个人账户支付。\n\n4、已充分了解找投顾专区领投人可能存在的道德风险，如发现领投人存在违法违规行为或利益冲突情形，如泄露用户投资决策计划、传播虚假信息、进行关联交易等，投资者可以向本平台投诉或向有关部门举报。\n\n5、本平台领投人存在因离开本平台等原因导致影响服务连续性的风险。\n\n6、平台已对领投人的模拟投资组合进行了投资范围规定及限制，但如仍出现购买ST、*ST、S*ST、SST、分级基金及其它高风险品种的情形，请投资者审慎自主决策，与本平台无关。\n\n7、投资者跟模拟投投资组合在极端行情下出现可能无法及时止盈或止损的风险。\n\n8、可能存在因跟投人数及跟投金额的限制从而导致跟投失败的风险。\n\n9、因网络、通讯等非本平台原因导致本平台发送的跟投信息传输不及时或未送达造成的后果，本平台不承担责任。\n\n10、平台只是展示组合账户的数据，并无能力去操控其账户，因此对于组合账户出现异常、或不可抗力等因素而导致投资组合与平台断开，以及由于跟投方账户出现异常或跟投方个人原因、不可抗力等因素而导致，从而引起跟投方无法100%跟随组合账户交易的风险，跟投方需对此有所警示，届时需跟投方人为地进行个人判断和干预。平台不承担任何风险赔偿及法律责任。\n\n11、本人已阅读以上风险声明。\n";


/**
 *  短信跟单协议名称&风险提示详情
 */
static NSString *MessageFollowOrderLoginProtocolNameDetail = @"尊敬的投资者：\n\n您在点选“短信跟单”进行跟单时，需明确如下潜在风险：\n\n1、华创证券实盘炒股大赛上的“短信跟单”功能只是跟随交易的一个辅助功能，供投资者自主决策选择；\n\n2、大赛平台上所有组合展现的均为参赛选手账户，跟随组合进行交易可能产生亏损的风险，与大赛组织方无关；\n\n3、可能存在因跟单人数及跟单金额的限制从而导致跟单失败的风险；\n\n4、因网络、通讯等非本公司原因导致本公司发送的跟单信息传输不及时或未送达造成的后果，本公司不承担责任。\n\n5、大赛平台只是展示组合账户的数据，并无能力去操控其账户，因此对于组合账户出现异常、或不可抗力等因素而导致参赛期间与大赛平台断开，以及由于跟单方账户出现异常或跟单方个人原因、不可抗力等因素而导致与大赛平台连接断开，从而引起跟单方无法100%跟随组合账户交易的风险，跟单方需对此有所警示，届时需跟单方人为地进行个人判断和干预。炒股大赛平台不承担任何风险赔偿及法律责任\n\n6、本人已阅读以上风险声明。\n";

/**
 *  投顾跟单协议名称&风险提示详情
 */
//static NSString *AdviserFollowOrderLoginProtocolNameDetail = @"您在点选“短信跟单”进行投顾模拟组合进行跟单时，需明确如下潜在风险：\n\n1、“短信跟单”功能只是投顾模拟组合的一个交易提示，供投资者自主决策选择；\n\n2、大赛平台上的所有模拟组合均为具备投顾资格的人员管理，如跟随模拟组合进行交易产生亏损，由跟单方自已承担，与组合管理人和大赛组织方无关；\n\n3、可能存在因跟单人数及跟单金额的限制从而导致跟单失败的风险；\n\n4、因网络、通讯等非本公司原因导致本公司发送的跟单信息传输不及时或未送达造成的后果，本公司不承担责任。\n\n5、大赛平台只是展示组合账户的数据，并无能力去操控其账户，因此对于组合账户出现异常、或不可抗力等因素而导致参赛期间与大赛平台断开，以及由于跟单方账户出现异常或跟单方个人原因、不可抗力等因素而导致与大赛平台连接断开，从而引起跟单方无法100%跟随组合账户交易的风险，跟单方需对此有所警示，届时需跟单方人为地进行个人判断和干预。炒股大赛平台不承担任何风险赔偿及法律责任。\n\n6、本人已阅读以上风险声明。\n";

static NSString * RiskFollowOrderLoginProtocolNameDetail = @"尊敬的用户：\n\n您在点选找投顾专区“马上跟单”进行跟投时，需明确如下潜在风险，请您认真仔细阅读。\n“马上跟单”功能只是找投顾专区领投人所管理模拟投资组合的一个交易提示，具有针对性和时效性，不能在任何市场环境下长期有效，仅供投资者参考，请投资者自主决策审慎跟投，如跟随投资组合进行交易产生亏损，由跟投方自已承担，与领投人和平台无关，平台仅收取服务定制费。\n\n2、目标计划所称目标投资收益并非对该计划投资收益的承诺和保证，投资者需了解选择跟投目标计划所带来的风险。\n\n3、已充分了解本平台找投顾专区服务的收费标准和方式，并按照公平、合理、自愿的原则签署《目标计划服务协议》或《短信跟投服务协议》。领投跟投业务服务收费应通过本平台支付，不得向领投人或其他个人账户支付。\n\n4、已充分了解找投顾专区领投人可能存在的道德风险，如发现领投人存在违法违规行为或利益冲突情形，如泄露用户投资决策计划、传播虚假信息、进行关联交易等，投资者可以向本平台投诉或向有关部门举报。\n\n5、本平台领投人存在因离开本平台等原因导致影响服务连续性的风险。\n\n6、平台已对领投人的模拟投资组合进行了投资范围规定及限制，但如仍出现购买ST、*ST、S*ST、SST、分级基金及其它高风险品种的情形，请投资者审慎自主决策，与本平台无关。\n\n7、投资者跟模拟投投资组合在极端行情下出现可能无法及时止盈或止损的风险。\n\n8、可能存在因跟投人数及跟投金额的限制从而导致跟投失败的风险。\n\n9、因网络、通讯等非本平台原因导致本平台发送的跟投信息传输不及时或未送达造成的后果，本平台不承担责任。\n\n10、平台只是展示组合账户的数据，并无能力去操控其账户，因此对于组合账户出现异常、或不可抗力等因素而导致投资组合与平台断开，以及由于跟投方账户出现异常或跟投方个人原因、不可抗力等因素而导致，从而引起跟投方无法100%跟随组合账户交易的风险，跟投方需对此有所警示，届时需跟投方人为地进行个人判断和干预。平台不承担任何风险赔偿及法律责任。\n\n本风险揭示书的揭示事项仅为列举性质，未能详尽列明投资者接受跟投所面临的全部风险和可能导致投资者投资损失的所有因素。\n投资者在接受跟投前，应认真阅读并理解相关业务规则、本风险揭示书的全部内容。接受跟投的投资者，自行承担投资风险，本平台不以任何方式向投资者作出不受损失或者取得最低收益的承诺。\n\n特别提示：投资者应签署本风险揭示书，表明投资者已经理解并愿意自行承担接受跟投所带来的风险和损失。";

/**
 *  短信跟投服务协议
 */
static NSString * AdviserFollowOrderLoginProtocolNameDetail = @"欢迎申请定制华创证券有限责任公司股票跟投王平台（以下简称“平台”）短信跟投服务。短信跟投服务协议（以下简称“本协议”）是平台与平台注册用户(以下简称“用户”或“您”)就申请定制短信跟投服务相关事项所订立的有效合约。您通过网络页面点击勾选并确认接受本协议，即表示您申请定制短信跟投服务并同意接受本协议所载全部内容、条款和条件以及同意向平台支付相关费用。\n达成如下协议，供双方共同遵守。\n\n第一条 双方声明\n（一）用户自愿选择平台提供的本协议约定的服务产品。\n（二）用户签约前，应详细阅读本协议的所有内容，尤其是本协议中免除、减轻平台责任或者限制用户权利的条款。如发生纠纷，用户不得以未仔细阅读本协议条款为由进行抗辩。\n（三）用户签约前，应充分阅读、完全理解并签署《短信跟投服务协议》和《跟投风险揭示书》，愿意承担证券市场的各种风险，参考使用平台产品，平台对用户的投资损失不承担责任。\n\n第二条 平台产品介绍\n投顾专区是指为入驻平台的领投人展示综合能力及为定制服务的用户提供服务的互联网应用平台。\n用户通过本协议定制的是短信跟投服务，成功定制后用户可通过注册平台的手机接收短信及登录App接收所选投资组合的交易信息，同时用户有解约的权利，领投人有为用户提供服务的义务和收取服务费的权利。\n\n第三条 产品收费标准\n（一）根据用户选择组合的不同，用户向平台支付不同费用，平台所展示的短信跟投服务均为单月价格。产品服务期限有1个月、3个月和6个月，可供用户自行选择服务期限。\n（二）用户在定制一键跟单服务时，请仔细了解相关产品及费用收取方式，并确认总的支付价格（总的支付价格=单月价格*服务期限）后再付款，用户定制产品前如有疑问可拨打客服电话（4008-6666-89），一旦用户成功定制产品则视为已充分知晓产品服务内容并接受服务价格及费用收取方式。\n（三）用户定制短信跟投业务的费用仅为平台为用户提供所选模拟组合交易信息的服务费，不论产品到期所选投资组合是否盈亏，用户成功定制后即收取该费用。\n（四）服务期约定\n产品服务期限有1个月、3个月和6个月，以用户定制产品时自行选择为准，服务开始日期以用户成功定制产品之日起计。\n\n第四条 用户权利和义务\n（一）用户享有使用所选产品的权利。\n（二）用户有权要求平台在签约当日或次日提供本协议所选产品。\n（三）用户有权通过平台的客户服务电话（4008-6666-89）进行咨询或投诉。\n（四）用户应遵守中华人民共和国相关法律、法规、规章以及其他规范性文件的要求。\n（五）用户不得以盈利为目的，复制、修改、使用、摘编、传播平台产品。\n\n第五条 平台权利和义务\n（一）平台有权利对本协议条款进行解释。\n（二）如用户有违反本协议的行为，平台有权停止为用户提供产品。\n（三）平台应当遵循诚实信用原则，勤勉、审慎地为客户提供产品服务。\n（四）入驻找投顾专区的领投人禁止以任何方式向用户承诺或者保证投资收益。\n（五）入驻找投顾专区的领投人严禁接受客户的全权委托，严禁接受未经客户授权的非全权委托。\n（六）平台不得向他人泄露用户的信息。\n\n第六条 协议的修改、生效及终止\n（一）协议的修改\n1、平台保留随时修改本协议的权利。修改本协议时，平台将公告新的协议文本，不对用户进行个别通知。用户签订本协议的视为用户同意本条约定。\n2、用户不同意本协议修订版内容的，应书面通知平台停止向其提供产品，否则视为同意协议补充或变更内容。\n（二）协议生效、终止\n1、本协议自用户确认勾选之日起生效。\n2、用户定制的产品到期本协议自动终止，如需续约则需重新定制产品并确认勾选本协议。\n3、用户单方要求解除协议的，用户应联系客服中心，并上传本人有效身份证件及相关身份证明材料，次日终止协议。\n\n第七条 争议的解决\n因本协议引起的或与本协议有关的任何争议，由本协议签订各方协商解决；协商不成，可以提向中国证券业协会申请调解；调解不成的，本协议项下争议应向平台所在地方法院起诉。争议期间，各方仍应履行未涉争议的条款。\n";

/**
 *  找投顾专区领投业务协议
 */
static NSString *InteresFollowOrderLoginProtocolNameDetail = @"欢迎申请入驻华创证券综合金融服务平台（以下简称“平台”）找投顾专区。找投顾专区业务协议（以下简称“本协议”）是平台与领投申请人(以下简称“申请人”或“您”)就申请加入找投顾专区等相关事项所订立的有效合约。您通过网络页面点击勾选并确认接受本协议，即表示您申请加入找投顾专区并同意接受本协议所载全部内容、条款和条件以及与本协议所述事项相关的各项规则及其他文件。\n\n一、找投顾专区简介\n为满足日益增长的财富管理需求，华创证券综合金融服务平台平台以互联网方式，推出找投顾专区，鼓励入驻专区的领投人更好的为用户服务，方便投资者选择专业服务。\n找投顾专区是指为为注册、登记为平台领投人的投资顾问展示综合能力及为用户提供定制服务的互联网应用平台。平台对领投人进行统一管理，领投人根据服务产品规范要求向平台提供投资咨询类服务产品，平台向注册用户提供跟投服务，注册用户可自行定制所选的服务产品，并支付相关服务费。\n\n二、入驻领投人标准\n您在申请入驻找投顾专区时，请确认您符合以下标准：1、具有证券投资咨询业务(分析师)或证券投资咨询业务(投资顾问)执业资格的；\n2、具备财富管理业务能力；\n3、具备良好的职业操守和专业的服务能力，不得有违反中华人民共和国现行法律法规、证券法律法规的行为，不存在市场禁入的情形。\n\n三、申请人权责\n您一旦成功申请注册为找投顾专区领投人，即享有以下权利：\n1、在平台发表投资观点、市场评论等文章；\n2、申请初始资金为100万的模拟投资组合，并在找投顾专区进行排名展示；\n3、享受所管理投资组合获得跟投收入的分成。如投资组合产生跟投收入，短信跟投费用的30%为平台收取，剩余部分（平台代扣个税）归投资组合领投人所有，跟投收入按季度将发放到管理人理财账户；\n4、参加平台组织的找投顾专区其他相关活动。\n同时您有义务遵守以下规则：\n（一）身份信息真实\n1、提供真实、详尽及准确的个人资料。申请人提供的的个人资料作为认定申请人身份的唯一依据。\n2、不断更新自己的注册资料，符合及时、详尽准确的要求。\n3、不冒用他人资料（包括不限于姓名、照片、职业资格等）如果申请人提供的资料不准确，不真实，不合法有效，或者冒用他人资料，平台保留直接修改资料或者结束申请人使用各项服务的权利，并且由此带来的各项损失由申请人承担。\n（二）遵守找投顾专区要求\n申请人参与找投顾专区，需符合以下要求：\n1.注册申请入驻找投顾专区需注册平台账号且绑定银行卡；\n2.注册申请入驻找投顾专区时需填写真实姓名、执业资格证书编号，并上传清晰的身份证正反面照及本人手持身份证正面照片，以及拟管理组合的基本信息等；\n3.审慎设定投资组合名称及简介，包括但不限于以下不适当的名称：不得带有不文明、不健康，易产生歧义、引起他人误解的词汇；不得带有图形符号或让人难以理解的字符。投资组合名称一经设定不可修改；\n4、申请人成功注册入驻找投顾专区后，其所管理的投资组合仅限投资A股，其中，单一股票持仓不能超过50%，不能申购新股、买卖分级基金、债券逆回购、B股以及带有ST、*ST、S*ST、SST等警示标志的A股股票；\n5、申请成为找投顾专区领投人，则平台有权公示、发布、转载其发表的观点、文章和管理的投资组合（包括管理人真实姓名及职业资格证书号等），并进行宣传推广。\n6、平台方有权对所有入驻专区的领投人及其管理的投资组合进行监督，如领投人被用户投诉，平台方将调查落实，领投人需积极配合，一旦发现违规行为将采取警告、停止推广、罚款等方式进行处罚。\n\n四、禁止行为\n申请人必须遵守国家法律和平台的有关规定，并独立承担在找投顾专区管理投资组合、发布投资观点等活动相关的所有责任。\n申请人已经知晓并且承诺：\n1、不得发表攻击中华人民共和国政府、中国共产党及其领导人的言论；\n2、不得发表侮辱、中伤、恐吓他人的言论以及宣扬暴力、迷信和色情淫秽的言论；\n3、不得发表煽动民族仇恨、民族歧视，破坏民族团结，破坏国家宗教政策，宣扬邪教和封建迷信以及散布谣言，扰乱社会秩序，破坏社会稳定的言论；\n4、不得发表泄露国家机密的言论和教唆犯罪的言论、技术资料；\n5、不得发表其他有违国家法律法规的内容；\n6、不得发表误导平台用户的言论及虚假信息；\n7、不得发表内容与主题不符的文章；\n8、不得讨论盗版软件、注册码、软件破解相关内容；\n9、未经同意不得发表任何纯属广告内容的文章；\n10、不得利用跟投业务操纵市场价格；\n11、不得进行内幕交易；\n12、不得为拉客户、诋毁平台、推介非法产品和服务等恶意目的，蓄意收集平台用户信息；\n13、凡属违例行为，平台管理员有权编辑、转移、锁定甚至删除发帖，删除投资组合，注销平台领投资格，（屡屡违规者，将取消入驻找投顾专区的资格)；涉嫌违纪违法的，平台将向监管机关或执法机关报案查处，产生的法律责任由发表人承担。\n\n五、知识产权\n本平台中包含的任何文本、图片、图形、音频、视频资料、数据、文章、设计、源代码、软件及其他全部信息（以下称“平台内容”）均受著作权、商标和其它财产所有权法律的保护。您同意并承诺，未经相关权利人事先书面同意，不以任何方式、不以任何形式复制、模仿、传播、出版、公布、展示平台内容，包括但不限于电子的、机械的、复印的、录音录像的方式和形式等。您承认本平台内容是属于本公司或其他相关权利人的财产。未经相关权利人书面同意，您亦不得将本平台包含的资料等任何内容镜像到任何其他网站或者服务器。任何未经授权对平台内容的使用均属于违法行为，本公司或相关权利人将追究您的法律责任。\n\n六、免责声明\n1、由于非故意及不可抗拒的原因（含系统维护和升级），导致的用户数据丢失、服务暂停或停止，本平台不承担赔偿及其他连带的法律责任。\n2、入驻找投顾专区的领投人因为违反本平台规定而触犯中华人民共和国法律的，责任自负，本平台不承担任何责任。\n3、本平台系统维护、程序修改以及规章制度制定、修改、完善和解释由华创证券有限责任公司负责。\n4、华创证券有限责任公司可根据需要，对本协议进行补充、修改和调整。\n\n七、适用法律及争议解决\n本协议的订立、生效、履行和解释应适用中国现行的法律、法规。因本协议引起的或与本协议有关的争议，各方可协商解决。协商不成的，任何一方有权就争议事项向本公司所在地有管辖权的法院起诉。\n\n八、解释权\n在法律允许的最大范围内，华创证券有限责任公司保留对本协议的最终解释权。\n";
/**
 *  跟单协议名称&风险提示详情
 */
static NSString *FollowOrderLoginProtocolNameDetail = @"《跟单协议及风险揭示》\n\n1、您接受一键跟单服务后须独立作出投资决策，风险自担；无论付费或是免费服务，融汇金信都不能确保您获得盈利或本金不受损失。\n\n2、您选择实盘跟单服务后，由于您账户资金不足、创业板权限未开通等问题而导致跟单失败、盈利不同步的情况，融汇金信不承担责任。\n\n3、融汇金信上所有组合管理人发布的内容均由其负责，融汇金信不对内容的准确性、真实性、有效性、原创性负责。\n\n4、组合管理人发布内容所涉及的任何投资品种以及任何操作，您须充分了解其合规性，融汇金信不作任何信用担保。\n\n5、为保障您的权益，请务必通过融汇金信来接受组合管理人的各项服务；通过其他平台或者线下接受组合管理人的服务，融汇金信不予认可并不承担由此产生的风险和责任。\n\n6、请您对自己的各类账号密码严格保密，勿将个人资产直接交由组合管理人管理，否则由此导致的风险将由您自行承担。\n\n7、如您发现组合管理人出现发布广告信息、线下揽客等违反融汇金信服务规范的行为，请致电融汇金信电话服务中心或联系客服，融汇金信将及时处理。\n\n8、因无法预测或无法控制的设备故障、通讯故障、网络故障等技术原因以及其它不可抗力而造成一键跟单失败，融汇金信不承担责任。\n\n9、如您已经使用融汇金信一键跟单服务，则代表您已同意本协议。\n\n10、本协议的最终解释权归融汇金信所有。\n";

/**
 *融汇金信跟单协议详情
 */

static NSString *FollowOrderarrifmSureprotocolNameDetail = @"1、一键跟单帐户要求是空仓，只能有跟单资金，不能持有股票，如果没有帐户需要新开华创账户。\n\n2、两融账户不能跟单和被跟单。\n\n3、成功一键跟单后会首先复制牛人的仓位，以后会自动跟牛人一起换仓，复制和换仓按照牛人持仓换仓股占总资产比例进行调整。\n\n4、一键跟单期限为1个月，使用跟单第一天开始到30天结算并结束跟单，如果在1个月内收盘清算后收益率达到20%，则一键跟单提前结束。跟单结束后客户要手动卖出帐户中股票。\n\n5、客户可以在期限内取消一键跟单，盘中取消跟单，按昨日收盘价进行结算，盘后取消一键跟单，则按当日收盘价进行结算。\n\n6、客户在跟单账户进行充值、提现、买入股票、卖出股票等操作时，跟单将被取消并在收盘后进行结算。\n\n7、客户一次只能一键跟单一人，取消当前跟单后，方可一键跟单下一人，再次一键跟单需重新缴纳保证金。\n\n8、如果资金量较小或者和选择的牛人资金量差别较大，可能会造成一键跟单买入失败。\n\n9、一键跟单需要交纳跟单金额3%作为保证金，客户盈利部分的15%会从保证金中作为费用扣除，其他结算后退还。以10万元跟单金额为例，缴纳保证金金额为3000元。如果一键跟单盈利达到20%，即2万元，则3000元保证金作为费用扣除；如果跟单亏损则3000元全部退还；如果假定到期只盈利10%，即1万元，则退还1500元保证金。\n\n10、止损（占跟单金额比例）：亏损金额/跟单金额的比例，范围取-20%至0%，用户账户触发止损时推送消息和短信通知用户。\n\n11、保证金分配，被跟单人获取13/15，平台收取2/15服务费。\n\n12、如果您被其他人一键跟单，则不能一键跟单其他人，如果需要一键跟单他人，则需联系融汇金信平台解除他人跟单关系，提前进行结算。\n\n13、跟单操作只限于A股买卖，其他操作，如国债逆回购、基金、债券、新股申购、配股等不会进行一键跟单。\n";

static NSString *kServiceProtocol = @"股票跟投王服务协议\n特别提示\n欢迎申请使用华创证券（包括网站、手机应用平台）提供的服务。请服务使用人（以下称\"用户\"）仔细阅读以下全部内容。如用户不同意本服务协议任意内容，请不要注册或使用华创证券网络服务。如用户通过进入注册程序，即表示用户与华创证券达成协议，自愿接受本服务协议的所有内容。此后，用户不得以未阅读本服务协议内容作任何形式的抗辩。用户注册成功后，华创证券将给予每个用户一个用户帐号及相应的密码，该用户帐号和密码由用户自行负责保管；用户应当对以其用户帐号进行的所有活动和事件负法律责任。\n\n服务内容\n(1) 华创证券服务的具体内容由华创证券根据实际情况提供，例如发帖、评论、消息、比赛排名、持股、交易、股票行情、公司信息等等。华创证券并不承诺服务在开始、变更或者结束时，均事先知会用户。\n\n(2) 华创证券服务若为收费的网络服务，用户使用收费网络服务需要向华创证券支付一定的费用。对于收费的网络服务，华创证券会在用户使用之前给予用户明确的提示，只有用户根据提示确认其愿意支付相关费用，用户才能使用该等收费网络服务。如用户拒绝支付相关费用，则华创证券有权不向用户提供该收费网络服务。\n\n(3) 华创证券仅提供相关的互联网服务，用户必须自行负责上网设备，如个人电脑、手机或其他上网设备，以及自行解决互联网接入和支付与此服务有关的费用。\n\n服务协议变更\n华创证券有权在必要时通过在网页上发出公告等合理方式修改本服务协议以及各单项服务的相关协议。用户在享受各项服务时，应当及时查阅了解修改的内容，并自觉遵守本服务协议以及该单项服务的相关协议。用户如继续使用本服务协议涉及的服务，则视为对修改内容的同意；用户在不同意修改内容的情况下，有权停止使用本服务协议涉及的服务。\n\n服务变更、中断或终止\n鉴于互联网服务的特殊性，用户同意华创证券有权随时变更、中断或终止部分或全部的网络服务（包括收费网络服务）。如变更、中断或终止的网络服务，华创证券无需通知用户，也无需对任何用户或任何第三方承担任何责任；\n\n用户资料合法性和真实性\n考虑到华创证券产品服务的重要性，用户同意：\n\n(1) 提供及时、详尽及准确的个人资料。\n\n•	不断更新自己的注册资料，符合及时、详尽准确的要求。所有原始键入的资料将引用为注册资料。\n\n(3) 参赛者同意公开其持仓股票、股票交易信息及允许被用户跟单。\n\n(3) 不冒用他人资料（包括不限于姓名、图片、公司机构名称、昵称等）如果用户提供的资料不准确，不真实，不合法有效，或者冒用他人资料，华创证券保留直接修改资料或者结束用户使用华创证券各项服务的权利。用户同意，用户提供的准确的个人资料作为认定用户与帐号的关联性以及用户身份的唯一证据。用户在享用各项服务的同时，同意接受华创证券提供的各类信息及交易服务。\n\n隐私保护\n保护用户隐私是华创证券的基本政策，非经用户许可，华创证券保证不对外公开或向第三方提供单个用户的注册资料及用户在使用网络服务时存储在华创证券的非公开内容，但下列情况除外：\n\n(1) 遵守有关法律、法规的规定，包括在国家有关机关查询时，提供用户的注册信息、用户在华创证券的网页上发布的信息内容及其发布时间、互联网地址或者域名。\n\n(2) 保持维护华创证券的知识产权和其他重要权利。\n\n(3) 在紧急情况下竭力维护用户个人和社会大众的隐私安全。\n\n(4) 根据本协议相关规定或者华创证券认为必要的其他情况下。\n\n免责声明\n(1) 用户明确同意其使用华创证券服务所存在的风险将完全由其自己承担；因其使用华创证券服务而产生的一切后果也由其自己承担，华创证券对用户不承担任何责任。\n\n(2) 华创证券所提供的任何信息（包括但不限于华创证券官方提供的、华创证券用户发布的、华创证券邀请的嘉宾提供的），华创证券并不能保证其完全实时或完全准确，也不表明华创证券证实其描述或赞同其观点。所有内容仅供参考，不构成投资建议或者其他实际的操作意见，用户据此操作所造成的后果自行负责。\n\n(3) 华创证券不保证服务一定能满足用户的要求，也不保证服务不会中断，对服务的及时性、安全性、准确性也都不作保证。对于各种原因造成的网络服务中断、资料丢失、数据损毁或其他缺陷，华创证券不承担任何责任。\n\n(4) 用户明确同意使用华创证券的风险由用户个人承担。对于所有的用户注册资料、姓名、身份、发言内容以及其他行为，华创证券拒绝提供任何担保。\n\n(5) 用户知晓并且同意，对于华创证券因为计算机系统、网络安全等问题，而导致用户资料意外泄漏，华创证券并不对此负责。除非用户能证明，该泄漏是由于华创证券的故意行为。\n\n内容的所有权\n(1) 内容的定义包括：文字、软件、声音、相片、视频、图表等。\n\n(2) 用户同意，其发布上传到华创证券的任何内容，华创证券获得其全世界范围内免费的、永久性的、不可撤销的、非独家的、完全许可的权利和许可。华创证券有权将内容用于其他合法用途，包括但不限于部分或者全部地复制、修改、改编、翻译、组装、分拆、推广、分发、广播、表演、演绎、出版。\n\n用户责任和义务\n用户独立承担其发布内容相关的所有责任。用户对华创证券服务的使用必须遵守所有适用于服务的地方法律、国家法律和国际法律。用户已经知晓并且承诺：\n\n(1) 用户在华创证券的网页上发布信息或者利用华创证券的服务时必须符合中国有关法律法规，不得在华创证券的网页上或者利用华创证券的服务制作、复制、发布、传播以下信息：\n\n违反宪法确定的基本原则的；\n\n危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n\n损害国家荣誉和利益的；\n\n煽动民族仇恨、民族歧视，破坏民族团结的；\n\n破坏国家宗教政策，宣扬邪教和封建迷信的；\n\n散布谣言，扰乱社会秩序，破坏社会稳定的；\n\n散布淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的；\n\n侮辱或者诽谤他人，侵害他人合法权益的；\n\n煽动非法集会、结社、游行、示威、聚众扰乱社会秩序的；\n\n以非法民间组织名义活动的；\n\n含有法律、行政法规禁止的其他内容的。\n\n(2) 用户在华创证券的网页上发布信息或者利用华创证券的服务时还必须符合其他有关国家和地区的法律规定以及国际法的有关规定。\n\n(3) 用户发表在华创证券上的任何内容，华创证券可以根据自己标准和立场进行管理或者删除，而无需提前或者事后向用户说明；管理或者删除的标准，也完全由华创证券独立制订，无需征求用户意见，也无需向用户公开。\n\n(4) 用户不得以任何方式干扰华创证券的服务。\n\n(5) 用户应遵守华创证券的所有其他规定和程序。\n\n(6) 用户须对自己在使用华创证券服务过程中的行为承担法律责任。用户承担法律责任的形式包括但不限于：对受到侵害者进行赔偿，以及在华创证券首先承担了因用户行为导致的行政处罚或侵权损害赔偿责任后，用户应给予华创证券等额的赔偿。\n\n(7) 用户理解，如果华创证券发现其网站传输的信息明显属于上段第(1)条所列内容之一，依据中国法律，华创证券有义务立即停止传输，保存有关记录，向国家有关机关报告，并且删除含有该内容的地址、目录或关闭服务器。\n\n(8) 用户使用华创证券电子公告服务，包括电子布告牌、电子白板、电子论坛、网络聊天室和留言板等以交互形式为上网用户提供信息发布条件的行为，也须遵守本条的规定。若用户的行为不符合以上提到的服务协议，华创证券将作出独立判断立即取消用户服务帐号或者其他有必要的措施。\n\n帐号的有效期限\n用户在华创证券注册的帐号，如果连续超过3个月没有登录，华创证券有权删除用户的帐号，而无需另行通知。\n\n通知和送达\n用户知晓并且同意，华创证券的各类通知，通过网页公告、系统通知、官方管理帐号通知（公开或者私下）、电子邮件或者常规信件进行，通知发出时，即被视为已送达收件人。 用户对华创证券的通知，需要通过华创证券正式公布的通信地址、传真号码、电子邮件地址等联系信息进行送达。\n\n适用法律和管辖权\n本协议适用中华人民共和国的法律，并且排除一切冲突法规定的适用。 如出现纠纷，用户和华创证券一致同意将纠纷交由华创证券所在地法院管辖。\n\n解释权\n在法律允许的最大范围内，华创证券保留对本服务协议的最终解释权。\n\n修订时间\n本协议最后修订时间：2014年11月16日";

static NSString * prompt = @"通知：";

static NSString * comingSoon = @"敬请期待!";

static NSString * simulateTradeFees = @"1、过户费（单位为元）：max(买入总股数或卖出总股数/1000,1)\n\n2、券商佣金（单位为元）：max(买入总股数或卖出总股数*买入价格或卖出价格*0.05%,5)\n\n3、印花税（单位为元，只卖出方收取）：卖出总股数*卖出价格*0.1%";


#pragma mark ----------------------app所用到的key值 标记字段----------------------

static NSString * kSettingServiceMark = @"kSettingServiceMark";

static NSString * kSettingPushSetMark = @"kSettingPushSetMark";

static NSString * kMinAttHeight = @"kMinAttHeight";

static NSString * kMaxAttHeight = @"kMaxAttHeight";

static NSString * kAttString = @"kAttString";

static NSString * kAttHeight = @"kAttHeight";

static NSString * kMatch = @"match";

static NSString * kLucky = @"lucky";

#pragma mark ----------------------app 财人汇 字段----------------------

static NSString * kCRHRequestUrl = @"crhOpenAccount";

#endif
