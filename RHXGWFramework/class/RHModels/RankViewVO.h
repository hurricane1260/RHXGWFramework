//
//  RankViewVO.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankVO.h"

@interface RankViewVO : NSObject

/**
 *
 */
@property (nonatomic, copy) NSString *rankNumber;

/**
 *  用户ID
 */
@property (nonatomic, copy) NSString *userID;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  要显示收益率
 */
@property (nonatomic, copy) NSString *visibleRate;

/**
 *  收益率颜色
 */
@property (nonatomic, copy) UIColor *profitColor;

/**
 *  持仓描述
 */
@property (nonatomic, copy) NSString *positionDesc;

/**
 *  要显示收益率的颜色
 */
@property (nonatomic, copy) UIColor *positionColor;

/**
 *  用户类型
 */
@property (nonatomic, copy) NSString *accountPro;

/**
 *  @brief 粉丝数
 */
@property (nonatomic, copy) NSNumber *fansNumber;

/**
 *  @brief 总数（一键跟单）
 */
@property (nonatomic, copy) NSNumber *totalAutoFollowsNumber;

/**
 *  @brief 当前在跟数（一键跟单）
 */
@property (nonatomic, copy) NSNumber *currentAutoFollowsNumber;

/**
 *  投顾ID
 */
@property (nonatomic, copy) NSString *accountId;



+(NSArray *)parsePojoEntityListToViewEntityList:(NSArray *)pojoEntityList withOrderFieldName:(NSString *)orderFieldName;

+(RankViewVO *)parsePojoEntityToViewEntity:(RankVO *)rankvo withOrderFieldName:(NSString *)orderFieldName;

+(RankViewVO *)parseSimulateCombinationVOWith:(NSDictionary *)itemVO index:(NSInteger)index;

@end
