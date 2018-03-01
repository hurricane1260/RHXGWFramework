//
//  STKSocket.h
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "AsyncSocket.h"
#import "STKAddress.h"
#import "STKRequestContext.h"

// 超时时间
#define SOCKET_TIME_OUT 5000
// 请求类型基数
#define DEF_STKDATA_BASE 10000
// 登陆
#define DEF_MO_LOGIN_RQ (DEF_STKDATA_BASE + 75)

@interface STKSocket : AsyncSocket <AsyncSocketDelegate>

@property (nonatomic,retain) STKAddress *config;

/// 连接socket
- (void)connect;

/// 发送请求
- (void)request:(STKRequestContext *)context;

/// 配置服务地址
- (id)initWithAddress:(STKAddress *)address;

/// 清除缓存数据
- (void)clearByteCache;

/// 断开连接
- (void)cutOffSocket;

@end
