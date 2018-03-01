//
//  SKAppointmentDelegate.m
//  stockscontest
//
//  Created by Zzbei on 15/8/3.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "SKAppointmentDelegate.h"
#import "STKCallbackInfo.h"
#import "SKReportVO.h"
#import "SKFiveReportVO.h"
#import "STKManager.h"

@interface SKAppointmentDelegate ()

@end

@implementation SKAppointmentDelegate

#pragma mark -
#pragma mark 推送数据
/// https://trac.gemantic.com/wiki/desktop/StkData2#a25.预约

- (void)getAppointmentBySymbol:(id)param
                        target:(id)target
                 resultHandler:(SEL)resultHandler
                   failHandler:(SEL)failHandler
{
    [self theAppointmentBySymbol:param type:1 target:target resultHandler:resultHandler failHandler:failHandler];
}

- (void)delAppointmentBySymbol:(id)param
                        target:(id)target
                 resultHandler:(SEL)resultHandler
                   failHandler:(SEL)failHandler
{
    [self theAppointmentBySymbol:param type:0 target:target resultHandler:resultHandler failHandler:failHandler];
}

- (int)theAppointmentBySymbol:(id)symbol
                         type:(int)type
                       target:(id)target
                resultHandler:(SEL)resultHandler
                  failHandler:(SEL)failHandler
{
    NSMutableData *param = [[NSMutableData alloc] init];
    [param appendStringWith0:symbol];
    [param appendInt:type];
            
    STKCallbackInfo *appointmentCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:target
                        resultHandler:resultHandler
                          failHandler:failHandler
                          requestType:DEF_SUBSCRIPTION_RQ_Ex
                               params:param];
    
    [self addCallbackInfo:appointmentCallback byRequestId:0];
    
    return rid;
}

@end

