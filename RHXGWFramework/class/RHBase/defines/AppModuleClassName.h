//
//  AppModuleClassName.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-28.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#ifndef stockscontest_AppModuleClassName_h
#define stockscontest_AppModuleClassName_h


/**
 *  模块主Controller类名称数组，app启动后会根据该数组构造各个模块的主Controller
 */
static const char *kModuleClassNames[] = {"HomePageController", "SelectSocketController", "FactViewController", "InvestController",  "TradeController"};


/**
 * 导航基类名
 */
static NSString *kBaseNaviControllerClassName = @"BaseNavigationController";
#pragma mark -----------------以下为注册登录部分类名------------------

/**
 *  注册页面Controller类名
 */
static NSString *kRegisterControllerClassName = @"AccountRegisterController";

/**
 *  登录页面Controller类名
 */
static NSString *kLoginControllerClassName = @"AccountLoginController";

/**
 *  忘记密码页面controller类名
 */
static NSString *kForgotPasswdControllerClassName = @"ForgotPasswdController";

#pragma mark -----------------以下为讨论部分类名------------------
/**
 *  讨论首页
 */
static NSString *kForumsControllerClassName = @"ForumsController";

/**
 *  讨论-发送新讨论
 */
static NSString *kForumsSendNewControllerClassName = @"SendNewController";

/**
 *  讨论-消息
 */
static NSString *kForumsMessageControllerClassName = @"MessagesController";

/**
 *  讨论-讨论详情
 */
static NSString *kForumsDetailControllerClassName = @"DetailDiscussionController";

/**
 *  讨论-评论列表cell ID
 */
static NSString *kForumsCommentCellIdentifier = @"commentCell";

/**
 *  讨论-讨论列表cell Item View
 */
static NSString *kForumsCommentListItemViewClassName = @"ForumsCommentItemView";

/**
 *  消息-收到的评论cell item view
 */
static NSString *kMessageCommentItemView = @"MessageCommentItemView";

/**
 *  消息-收到的at的cell item view
 */
static NSString *kMessageAtItemView = @"MessageAtItemView";

/**
 *  消息-收到的系统消息cell item view
 */
static NSString *kMessageSystemItemView = @"MessageSystemItemView";

/**
 *  消息-收到的评论cell identifier
 */
static NSString *kMessageCommentIdentifier = @"MessageCommentCellIdentifier";

/**
 *  消息-收到的at的cell identifier
 */
static NSString *kMessageAtIdentifier = @"MessageAtCellIdentifier";

/**
 *  消息-收到的系统消息cell identifier
 */
static NSString *kMessageSystemIdentifier = @"MessageSystemCellIdentifier";


#pragma mark -----------------以下为账户中心部分类名------------------

/**
 *  我的个人账户主页controller类名
 */
static NSString *kCHomeMyAccountControllerClassName = @"AccountController";

/**
 *  修改跟单费用类名
 */
static NSString *kCDocumentaryPriceControllerClassName = @"CpDocumentaryPriceController";

/**
 *  他的个人主页controller类名
 */
static NSString *kCHomeSomeIndexControllerClassName = @"AHSomeIndexController";

/**
 *  关注某人(包括我)列表controller类名
 */
static NSString *kCHomeSomeAttentionListControllerClassName = @"AHSomeAttentionListController";

/**
 *  粉丝列表controller类名
 */
static NSString *kCHomeFansListControllerClassName = @"AHFansListController";

/**
 *  我关注的人controller类名
 */
static NSString *kCHomeMyAttentionControllerClassName = @"AHMyAttentionController";

/**
 *  持仓列表controller类名
 */
static NSString *kCHomePositionListControllerClassName = @"AHPositionListController";

/**
 *  交易列表controller类名
 */
static NSString *kCHomeDealListControllerClassName = @"AHDealListController";

/**
 *  我的追踪列表controller类名
 */
static NSString *kCHomeMyTrackListControllerClassName = @"AHMyTrackListController";

/**
 *  账户设置controller类名
 */
static NSString *kCHomeMySettingControllerClassName = @"ACMySettingController";

/**
 *  持股/交易controller类名
 */
static NSString *kAHStockDetailListControllerClassName = @"AHStockDetailListController";

/**
 *  编辑资料类名
 */
static NSString *kCHomeEditInfoControllerClassName = @"AHEditInfoController";


static NSString *kACHomeCellRankIndentifier = @"ACHomeCellRankIndentifier";

static NSString *kACHomeCellAttentionUserIndentifier = @"ACHomeCellAttentionUserIndentifier";

static NSString *kACHomeCellDellIndentifier = @"ACHomeCellDellIndentifier";

static NSString *kACHomeCellMessageIndentifier = @"ACHomeCellMessageIndentifier";

static NSString *kACHomeCellAttentionWeiboClassName = @"ForumsListItemView";

static NSString *kACHomeCellAttentionRankClassName = @"AHAttentionRankListItemView";

static NSString *kACHomeCellAttentionDealClassName = @"AHAttentionDealListItemView";

static NSString *kACHomeCellAttentionUserClassName = @"AHAttentionUserListItemView";

static NSString *kAHDetailStockCellIdentifier = @"AHDetailStockCell";

static NSString *kAHDetailTradeCellIdentifier = @"AHDetailTradeCell";

static NSString *kAHDetailForumCellIdentifier = @"AHDetailForumCell";

static NSString *kAHDetailStockCellClassName = @"AHDetailStockListItemView";

/**
 *  个人主页的交易cell，只有名字，可展开
 */
static NSString *kAHDetailTradeCellClassName = @"AHDetailTradeListItemView";

/**
 *  跳转后列表的交易cell，有买卖图标
 */
static NSString *kAHStockDetailListTradeCellClassName = @"AHStockDetailListTradeItemView";

static NSString *kAHDetailForumCellClassName = @"AHDetailForumListItemView";

static NSString *kACPositionVOClassName = @"ACPositionVO";

static NSString *kACRealDealVOClassName = @"ACRealDealVO";

#pragma mark -----------------以下为比赛部分类名------------------

/**
 *  比赛首页controller类名
 */
static NSString *kCompeteIndexControllerClassName = @"CompeteController";

/**
 *  比赛首页列表ITEMVIEW类名
 */
static NSString *kCompeteIndexRankListItemViewClassName = @"CPIndexRankListItemView";

/**
 *  投顾列表ITEMVIEW类名
 */
static NSString *kCompeteInvestRankListItemViewClassName = @"CPInvestRankListItemView";

///**
// *  实盘列表ITEMVIEW类名
// */
//static NSString *kCompeteFactRankListItemViewClassName = @"CPFactRankListItemView";

/**
 *  比赛首页列表cell VO类名
 */
static NSString *kCompeteIndexRankVOClassName = @"RankViewVO";

/**
 *  大赛简介controller类名
 */
static NSString *kCompeteIntroductionControllerClassName = @"CPIntroductionController";

/**
 *  大赛报名controller类名
 */
static NSString *kCompeteEnterNameControllerClassName = @"CPEnterNameController";

/**
 *  赛事报道列表controller类名
 */
static NSString *kDayAspectListControllerClassName = @"CPRecommendListController";

/**
 *  赛事报道列表ITEMVIEW类名
 */
static NSString *kCompeteRecommendListItemViewClassName = @"CPRecommendListItemView";

/**
 *  今日看点详情controller类名
 */
static NSString *kDayAspectDetailControllerClassName = @"CPRecommendDetailController";

/**
 *  绑定华创账户Controller
 */
static NSString *kBindHCAccountControllerClassName = @"CPBindHCAccountController";

/**
 *  牛人列表controller类名
 */
//static NSString *kWorseListControllerClassName = @"CPWorseListController";

/**
 *  大赛广告详情controller类名
 */
static NSString *kCompeteAdvertisementControllerClassName = @"CPAdverDetailController";

/**
 *  实盘榜单列表controller类名
 */
//static NSString *kFactRankListControllerClassName = @"CPFactRankListController";

/**
 *  比赛实盘列表ITEMVIEW类名
 */
static NSString *kCompeteFactRankListItemViewClassName = @"CPFactRankListItemView";

/**
 *  比赛首页榜单列表cellIndentifier
 */
static NSString *kCompeteIndexRankCellIndentifier = @"CompeteIndexRankCellIndentifier";

/**
 *  投顾列表cellIndentifier
 */
static NSString *kCompeteInvestRankCellIndentifier = @"CompeteInvestRankCellIndentifier";

/**
 *  实盘列表cellIndentifier
 */
static NSString *kCompeteFactRankCellIndentifier = @"CompeteFactRankCellIndentifier";

/**
 *  比赛列表通用cellIndentifier
 */
static NSString *kCompeteCellGeneralIndentifier = @"CompeteCellGeneralIndentifier";

/**
 *  比赛牛人列表cellIndentifier
 */
static NSString *kCompeteWorseUserCellIndentifier = @"CompeteWorseUserCellIndentifier";

/**
 *  比赛牛人列表cell展示的data类名
 */
static NSString *kCompeteWorseVOIndentifier = @"WorseViewVO";

/**
 *  投顾挑战赛controller类名
 */
static NSString *kCompeteChallengeControllerClassName = @"InvestChallengeController";

/**
 *  实盘操盘风格controller类名
 */
static NSString *kCompeteFactStyleControllerClassName = @"FactStyleController";

/**
 *  实盘跟单达人controller类名
 */
static NSString *kCompeteFactFollowControllerClassName = @"FactFollowController";

/**
 *  选股王股票详情页
 */
static NSString *kXGWStockDetailControllerClassName = @"RHStockDetailController";


#pragma mark -----------------以下为新股申购类名------------------
/**
 *  新股申购待审购
 */
static NSString *kIPOApplyViewControllerClassName = @"IPOApplyViewController";

/**
 *  新股申购配号查询
 */
static NSString *kIPOMatchInfoViewControllerClassName = @"IPOMatchInfoViewController";

/**
 *  新股申购中签查询
 */
static NSString *kIPOLuckyViewControllerClassName = @"IPOLuckyViewController";

#pragma mark -----------------以下为我的类名------------------
/**
 *  我的牛股
 */
static NSString *kMNBeefBoneControllerClassName = @"MNBeefBoneController";

/**
 *  投资组合
 */
static NSString *kMNInvestGroupControllerClassName = @"MNInvestGroupController";

/**
 *  有声内参
 */
static NSString *kMNVoiceInternalControllerClassName = @"MNVoiceInternalController";

/**
 *  赠送牛骨提示
 */
static NSString *kMNBeefAwardControllerClassName = @"MNBeefAwardController";

/**
 *  寻牛诀
 */
static NSString *kMSSearchBeefServeControllerClassName = @"SearchBeefServeController";

/**
 *  定制消息、买卖信号
 */
static NSString *kMSCustomMsgControllerClassName = @"MSCustomMsgController";

/**
 *  财富管理
 */
static NSString *kMSWealthManageControllerClassName = @"MSWealthManageController";


#pragma mark -----------------以下为B端我的类名------------------
/**
 * 首次登陆提示
 */
static NSString *kBRedPacketControllerClassName = @"BRedPacketController";

#pragma mark ----------------开户类名----------------------

static NSString * kRHOpenAccountControllerClassName = @"RHOpenAccountController";

#endif
