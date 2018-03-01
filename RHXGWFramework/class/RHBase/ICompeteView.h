//
//  ICompeteView.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-21.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICompeteView <NSObject>

@optional

//投顾大赛状态查询回调
-(void)getInvestDealStateDataResult:(id)resultData success:(BOOL)success;

-(void)requestListSuccessHandler:(id)resultData;

-(void)requestChartListSuccessHandler:(id)resultData;

-(void)requestListFailureHandler;

/**
 *  请求评论列表数据成功返回
 *
 *  @param resultData 返回的成功数据
 */
-(void)requestCommentListlSuccessHandler:(id)resultData;

/**
 *  查看是否关联华创账号成功回调
 *
 *  @param resultData 返回的成功数据
 */
-(void)checkHCZFAssociatedSuccessHandler:(id)resultData;

/**
 *  绑定华创资金账户成功回调
 *
 *  @param resultData 返回的成功数据
 */
-(void)requestBindHCSuccessHandler:(id)resultData;

/**
 *  参赛报名成功回调
 *
 *  @param resultData 返回的成功数据
 */
-(void)enterNameSuccessHandler:(id)resultData;

/**
 *  查询广告列表返回
 *
 *  @param resultList 广告列表
 *  @param success    是否成功
 */
-(void)requestAdvertisementListResultHandler:(NSArray *)resultList success:(BOOL)success;

@end
