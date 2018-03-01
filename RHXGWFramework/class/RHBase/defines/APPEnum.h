//
//  APPEnum.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  app枚举头文件
//

#ifndef stockscontest_APPEnum_h
#define stockscontest_APPEnum_h

/**
 *  定义视图运动方向
 */
typedef NS_ENUM(NSUInteger, Direction){
    DirectionLeft = 0,
    DirectionRight = 1,
    DirectionTop = 2,
    DirectionDown = 3,
    DirectionNone = 4
};

/**
 *  定义登录状态
 */
typedef NS_ENUM(NSUInteger, APPLoginState){
    APPLoginStateNOCache = 0,
    APPLoginStateHaveCache = 1
};


/**
 *  定义是否绑定华创账号状态
 */
typedef NS_ENUM(NSUInteger, AccountOpenState){
    AccountOpenStateNo = 0,
    AccountOpenStateOpen = 1
};

/**
 *  定义比赛模块页面类型枚举,因为比赛模块有四个栏目有列表，需要请求统一个方法，所以需要该枚举进行页面类型区分
 */
typedef NS_ENUM(NSUInteger, CompeteModuleViewType){
    CompeteIndexRankList = 0,
    CompeteRecommendList = 1,
    CompeteWorseList = 2,
    CompeteFactRankList = 3,
    CompeteInvestList = 4,
    CompeteChangeList = 5
};

/**
 *  定义我的主页模块所有的数据列表类型
 */
typedef NS_ENUM(NSUInteger, ACHomeModuleListType){
    ACHomeListTypeFans = 0,//粉丝列表
    ACHomeListTypeRealDeal = 1,//实盘交易列表
    ACHomeListTypePosition = 2,//个人持仓列表
    ACHomeListTypeAttentionWeibo = 3,//关注帖子列表
    ACHomeListTypeAttentionDeal = 4, //关注交易列表
    ACHomeListTypeAttentionUser = 5, //关注排名列表
    ACHomeListTypeSelfMessage = 6,//个人帖子列表
    ACHomeListTypeInterestRealDeal = 7//投顾交易列表
};

///主要区分交易请求是实盘还是模拟盘
typedef enum : NSUInteger {
    TradeControllerTypeReal,
    TradeControllerTypeSimulate,
} TradeControllerType;

///区分买卖
typedef enum : NSUInteger {
    TradeBuySellViewTypeBuy = 0,
    TradeBuySellViewTypeSell
} TradeBuySellViewType;

///由持仓跳转到买卖、还是k线
typedef enum _TradeControllerViewIndex{
    tradeStockViewIndex = 0,
    tradeBuyViewIndex,
    tradeSellViewIndex,
    tradeKLineIndex,
    // 也许还有其它可能跳转的地方
}TradeControllerViewIndex;

///主要区分是“我的组合”还是投顾专区列表
typedef enum : NSUInteger {
    InvestRankListTypeFollow,
    InvestRankListTypeMine,
} InvestRankListType;

typedef enum : NSUInteger {
    CompeteListTypeOfAdviserInvest,//投顾
    CompeteListTypeOfAdviserChallenge,//投顾挑战赛
    CompeteListTypeOfFact,//实盘
    CompeteListTypeOfFactTradeType,//实盘风格页
} CompeteListType;

//定义投顾/实盘列表展示筛选类型
typedef enum : NSUInteger {
    SortListTypeTotalProfit,//总收益率
    SortListTypeMonthProfit,//月收益率
    SortListTypeCompositeProfit,//综合收益率
    SortListTypeMaxDrawdown,//最大回撤
    SortListTypeWeekProfit//周收益率
} SortListType;

//typedef enum NSUInteger{
//    CompeteListTypeOfFactPrivate,//实盘五万组
//    CompeteListTypeOfFactMillion,//实盘百万组
//    CompeteListTypeOfFactHonor,//实盘千万组
//    CompeteListTypeOfFactTypeSteady,//实盘稳操证券
//    CompeteListTypeOfFactTypeShort,//实盘短线高手
//    CompeteListTypeOfFactTypeVast,//实盘重装奇兵
//    CompeteListTypeOfFactTypeFollow//实盘跟单达人
//}FactSortListType;

///跟单费用修改，区分短信跟单和一键跟单
typedef enum : NSUInteger {
    InvestFollowPriceTypeMessage,
    InvestFollowPriceTypeMessageRong,//实盘修改跟单费用
    InvestFollowPriceTypeAuto,
} InvestFollowPriceType;

typedef enum : NSUInteger {
    ViewTypeTradeinterval = 1,             //交易账号锁定时间设置
    
} ViewType;

typedef enum : NSUInteger {
    newsType = 0,             //资讯页面type
    researchType,
    
} informationType;

typedef enum : NSUInteger {
    operateSignalType,//个股详情操作推荐
    operateCurveType,//个股详情操作曲线
    stockDetailBubbleType,//个股详情新闻研报公告气泡
    selfStockListType,//个股详情获取自选股
    editSelfStockType,//个股详情编辑自选股
    stockDetBasicType,//个股详情基本面
    stockDetBasicDataType,//个股详情基本面财务业绩
} RequireType;

typedef enum TouchTableViewType {
    NewsTableView,
    ResearchTableView,
    NoticeTableView
} TableViewType;

typedef enum : NSUInteger{
    kBuySellMessage = 10,//自选股买卖信号
    kCustomMessage,//定制消息
    kHotSpotMessage,//热点精选
    kHotDetailMessage,//热点精选详情
    kBubbleCountMessage,//气泡数量
    kEventDetailMessage,//事件详情
    kIPOTodayDetail,//新股申购今日
    kIPOWeekDetail,//新股申购一周
    kIPOMatch,//新股申购配号查询
    kIPOLucky,//新股中签查询
    kBeefBoneRecord,//c端我的牛股记录
    kImportantNews,//指数下重大新闻
}PersonalMessageType;

typedef enum : NSUInteger{
    kAllMessage,//所有消息
    kSelfStockBuySellMessage,//自选股买卖信号
    kSelfStockImportMessage,//自选股重大事项
    kTradeServiceMessage,//交易服务
    kSystemNotiMessage,//系统通知
    kSelfStockPriceMessage,//自选股股价提醒
    kPriceLimitMessage,//涨跌幅达
}PushSetType;

typedef enum : NSUInteger{
    kClientType,//客户类型
    kOnlineState,//登录状态
}MainRequestType;

typedef enum : NSUInteger{
    kQueryBeefBoneState,//查询牛骨自动打赏状态
    kSetBeefBoneState,//设置牛骨是否自动打赏
    kQueryBeefBoneRecord,//查询牛骨奖励、使用记录
    kShowBeefBoneAward,//查询是否展示奖励牛骨的提示页面
}BeefBoneRequestType;

typedef enum : NSUInteger{
    kRewardToAgentRequest,
    kEditRemarkNameRequest,
    kNoticeListRequest,
    kNoticeDetailRequest,
    kVoiceInternalRequest,
}ContactsRequestType;


typedef enum : NSUInteger {
    kThemeTodayChanceRequest,        //主题今日机会
    kThemeRecentHotRequest,          //主题近期热点
    kThemeInformationTrackingRequest,//主题资讯跟踪
    kThemeBreakingPointRequest,      //主题下个爆点
}ThemeRequestType;

//好友列表from
typedef enum NavigationFrom
{
    Defaults,
    SettingAutoReward
}NavigationFrom;

typedef enum :NSInteger{
    urlType = 1,//跳转链接
    H5Type,//跳转自己做的H5
    shakeType//抖动
    
    
}GoType;

//我的服务
typedef enum : NSUInteger{
    kMsIntro,       //组合+内参+独家+聊股简介
    kMsComposition, //组合详情
    kMsInsider,     //内参或独家详情
    kMsUloginTheme, //未登录的相关主题
    kMsDychg,       //未登录的广告–调研出好股
    kMsLoginTheme,  //已登录的相关主题
    kMsBannerClickNum, //banner点击率
    kMsWealthContent,   //财富管理
    kMsCustomFirstNews, //定制消息最新一条
    kMsSearchBeef,    //寻牛诀服务
    
}MSRequestType;

//开户
typedef enum : NSUInteger{
    kSmsVerifyCode,//短信验证码发送
    kSmsVCCheck,//验证短信验证码
    
    kQueryUserStatus,//查询用户状态
    kOpenAccApply,//开户申请
    kOpenResultQuery,//开户结果查询
    kSetEntrustType,//设置用户委托方式
    kQueryClientInfo,//查询用户信息
    
    kProtocolList,//协议列表
    kProtocolContent,//协议内容
    
    kQueryDic,//数据字典查询
    
    kCheckCanOpenAcc,//检查是否可开户
    
    kUploadPersonIdImg,//上传身份证图片
    kUploadPersonMsg,//上传个人信息
    
    kQueryBranchCommission,//查询营业部佣金
    kSetTradePassWord,//设置交易 资金密码
    
    kOpenStockAcc,//申请开通证券账号
    kOpenFundAcc,//申请开通基金账号
    kCheckCanTransCYB,//创业板登记检查
    kSecondConnectModify,//第二联系人信息修改
    kTransCYBAcc,//申请创业板转签登记
    
    kGetBankList,//获取银行卡列表
    kVerifyBankCodeWithBankType,//判断银行卡号是否与所选银行匹配
    kBindingBankCard,//绑定银行卡
    
    kRiskTestPaper,//风险测评试卷
    kRiskTestCommit,//风险测评提交
    kRiskTestQuery,//风险测评查询
    kReturnVisitPaper,//回访问卷
    kReturnVisitCommit,//回访问卷提交
    kRiskResultConfirm,//风险测评结果确认
    kRiskSpecialResultSave,//保存风险测用户特殊情况
    kRiskMatchCheck,//适当性匹配检查
    
    
    kProtocolQuery,//协议签署查询
    kCACertQuery,//中登CA证书查询
    kProtocolSign,//协议签署
    
    kBeginVideoRequest,//发起视频请求
    kUserVedioStatusInfoQuery,//用户视频状态信息获取
    kRemoveUser,//视频见证资源释放
    kSingleTrackVideoTask,//单向视频任务
    kVideoServiceQuery,//视频客服查询
    
}CRHRequestType;

#endif
