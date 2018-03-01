//
//  TradeSessionManager.h
//  stockscontest
//
//  Created by rxhui on 15/6/10.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  1.定时ping
//  2.创建session

#import <Foundation/Foundation.h>

@interface TradeSessionManager : NSObject

@property (nonatomic,copy) NSString *sessionID;

@property (nonatomic,assign) BOOL onLine;

/*! @brief 已登录的账户号 */
@property (nonatomic,copy) NSString *onLineAccount;

+(TradeSessionManager *)shareInstance;

-(void)startPing;

-(void)stopPing;

-(void)createSessionWithBlock:(void (^)(void))callback;

-(void)destroySessionWithBlock:(void (^)(void))callback;

-(void)waitForLogout;

-(void)destroySession;

-(void)cancelLogout;

@end
