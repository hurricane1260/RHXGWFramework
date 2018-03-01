//
//  TradeIPOManager.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/12.
//
//

#import <Foundation/Foundation.h>
#import "RHBaseHttpRequest.h"


@interface TradeIPOManager : RHBaseHttpRequest

/**
 *  今日新股申购查询
 */
- (void)requestForIPOToday:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack;

/**
 *  新股申购配号查询
 */
- (void)requestForIPOMatchInfo:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack;

/**
 *  新股申购一周查询
 */
- (void)requestForIPOWeekWithModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack;

/**
 *  新股申购中签查询
 */
- (void)requestForIPOHisLucky:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack;

/**
 *  新股申购配号查询
 */
- (void)requestForIPOHisMatchInfo:(NSDictionary *)aParam withModeId:(PersonalMessageType)modeId completion:(RequestCompletionCallback)callBack;

@end
