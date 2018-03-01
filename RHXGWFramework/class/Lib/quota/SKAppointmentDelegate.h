//
//  SKAppointmentDelegate.h
//  stockscontest
//
//  Created by Zzbei on 15/8/3.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "SKBaseDelegate.h"

@interface SKAppointmentDelegate : SKBaseDelegate

//订阅服务器推送的数据
#define DEF_SUBSCRIPTION_RQ_Ex (DEF_STKDATA_BASE +11)
#define DEF_SUBSCRIPTION_RS_Ex (DEF_STKDATA_BASE +12)

/**
*	@brief	根据symbol获取股票的报价
*
*	@param 	param 股票代码、exchangeType
*	@param 	target 请求返回后，会做出反应的对象
*	@param 	resultHandler 请求成功后，该对象执行的方法
*	@param 	failHandler 请求失败后，该对象执行的方法
*
*/

//添加订阅
- (void)getAppointmentBySymbol:(id)param
                        target:(id)target
                 resultHandler:(SEL)resultHandler
                   failHandler:(SEL)failHandler;

//删除订阅
- (void)delAppointmentBySymbol:(id)param
                        target:(id)target
                 resultHandler:(SEL)resultHandler
                   failHandler:(SEL)failHandler;

@end
