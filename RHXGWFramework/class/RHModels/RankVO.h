//
//  RankPositionVO.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-21.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  排行榜对象

#import <Foundation/Foundation.h>

@interface RankVO : NSObject

/**
 *  近三个月卖出次数
 */
@property (nonatomic, copy) NSString *sellTimes;

/**
 *  近三个月盈利
 */
@property (nonatomic, copy) NSString *sellWinTimes;

/**
 *  近三个月胜率
 */
@property (nonatomic, copy) NSString *sellWinRate;

/**
 *  人物图标地址
 */
@property (nonatomic, copy) NSString *profileImageUrl;

/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *userID;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;


@property (nonatomic, copy) NSString *name;

/**
 *  是否为认证用户1：认证用户、0：不是认证用户
 */
@property (nonatomic, copy) NSNumber *verified;

/**
 *  总收益率
 */
@property (nonatomic, copy) NSNumber *totalEarningsRate;

/**
 *  月收益率
 */
@property (nonatomic, copy) NSNumber *monthEarningsRate;

/**
 *  周收益率
 */
@property (nonatomic, copy) NSNumber *weekEarningsRate;

/**
 *  日收益率
 */
@property (nonatomic, copy) NSNumber *dayEarningsRate;

/**
 *  总跟单数
 */
@property (nonatomic, copy) NSNumber *totalFollowsNumber;

/**
 *  月跟单数
 */
@property (nonatomic, copy) NSNumber *monthFollowsNumber;


/**
 *  周跟单数
 */
@property (nonatomic, copy) NSNumber *weekFollowsNumber;

/**
 *  日跟单数
 */
@property (nonatomic, copy) NSNumber *dayFollowsNumber;

/**
 *  周名次浮动
 */
@property (nonatomic, copy) NSNumber *weekRankingFloat;

/**
 *  日名次浮动
 */
@property (nonatomic, copy) NSString *dayRankingFloat;

/**
 *  交易笔数
 */
@property (nonatomic, copy) NSNumber *dealNumber;

/**
 *  粉丝数
 */
@property (nonatomic, copy) NSNumber *fansNumber;

/**
 *  持仓股票数
 */
@property (nonatomic, copy) NSNumber *stockNumber;

/**
 *  名次
 */
@property (nonatomic, copy) NSString *ranking;


@property (nonatomic, copy) NSNumber *createTime;

/**
 *  赛季
 */
@property (nonatomic, copy) NSString *season;
/**
 *  持仓数量
 */
@property (nonatomic, strong) NSArray * positions;

/**
 *  账号类别
 */
@property (nonatomic, copy) NSString *accountPro;

/**
 *  资产级别
 */
@property (nonatomic, copy) NSString *level;

/**
 *  最大回撤
 */
@property (nonatomic, copy) NSNumber *maxDrawDown;

/**
 *  持仓占比
 */
@property (nonatomic, strong)NSNumber * positionsRate;

/**
 *  综合收益率
 */
@property (nonatomic, copy) NSNumber *rankValue;

/**
 *  @brief 投资风格，跟单用,1.超短线;2.短线;3.中长线
 */
//@property (nonatomic, copy) NSString *invStyle;

/**
 *  @brief 总数（一键跟单）
 */
@property (nonatomic, copy) NSNumber *totalAutoFollowsNumber;

/**
 *  @brief 当前在跟数（一键跟单）
 */
@property (nonatomic, copy) NSNumber *currentAutoFollowsNumber;

/**
 *  @brief 月均交易
 */
@property (nonatomic, strong) NSNumber * averageMonthlyDeal;

/**
 *  @brief 参赛总数
 */
@property (nonatomic, strong) NSNumber * totalGame;

+ (id)generateWithDict:(NSDictionary *)dic;

- (id)initWithDic:(NSDictionary *)dic;

@end
