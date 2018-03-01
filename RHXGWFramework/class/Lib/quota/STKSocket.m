//
//  STKSocket.m
//  iphone-stock
//
//  Created by ztian on 14-3-1.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKSocket.h"
#import "STKPackage.h"
#import "STKData.h"
#import "STKRequestQueue.h"
//#import "NSMutableData+RHJX_Inc_.h"
//#import "NSData+RHJX_Inc_.h"
#import "SKReportVO.h"
#import "STKCallbackInfo.h"
#import "SKFiveReportVO.h"
#import "STKBaseDelegate.h"
#import "SKAppointmentDelegate.h"

@interface STKSocket()
{
    // 当前正在处理的package
    STKPackage *_currentPackage;
    // 正在连接
    BOOL _isConnecting;
    // 正在登陆
    BOOL _isLogining;
    // 已经登陆
    BOOL _isLogin;
    // 请求队列
    STKRequestQueue *_requestQueue;
    // 接收到的但还没来得及处理的字节缓存
    NSMutableData *byteCache;
}

@end

@implementation STKSocket

#pragma mark 初始化

- (id)initWithAddress:(STKAddress *)config
{
    self = [self init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _requestQueue = [[STKRequestQueue alloc] init];
        [self setDelegate:self];
    }
    return self;
}

#pragma mark 连接和登陆

- (void)connect
{
    //  正在连接，则等待
    if (_isConnecting) {
        return;
    }
    // 已经连接并登陆成功
    if ( self.isConnected && _isLogin) {
        return;
    }
    else if (self.isConnected) {
        // 连接成功，但未登陆成功
        [self login];
        return;
    }
    // 没有连接
    NSError *error = nil;
    [self connectToHost:self.config.host onPort:self.config.port error:&error];
    _isConnecting = YES;
}


- (void)login
{
    if ( !self.isConnected) {
        [self connect];
        return;
    }
    if ( _isLogining ) {
        return;
    }
    _isLogining = YES;
    NSMutableData *params = [[NSMutableData alloc] init];
    [params appendInt:0];
    [params appendStringWith0:@"username"];
    [params appendStringWith0:@"password"];
    
    STKData *request = [[STKData alloc] initWithRequestType:DEF_MO_LOGIN_RQ params:params];
    STKRequestContext *context = [[STKRequestContext alloc] initWithTarget:self resultHandler:@selector(loginResultHandler:) failHandler:@selector(loginFailHandler:) request:request];
    [self excuteRequest:context];
}

- (void)loginResultHandler:(NSData *)data
{
    NSLog(@"socket login success");
    _isLogining = NO;
    _isLogin = YES;
    [self sendReqeustIfQueueNotEmpty];

}

- (void)loginFailHandler:(id)data
{
    _isLogining = NO;
    _isLogin = NO;
}


#pragma mark -
#pragma mark 发送请求

- (void)sendReqeustIfQueueNotEmpty
{
    STKRequestContext *context = [_requestQueue deQueue];
    while ( context != nil) {
        [self request:context];
        context = [_requestQueue deQueue];
    }
}

/// 立即执行请求，内部调用
- (int)excuteRequest:(STKRequestContext *)context
{
    if ( !self.isConnected ) {
        // 没有连接
        [self connect];
    }else if( !_isLogin && context.request.type != DEF_MO_LOGIN_RQ ){
        // 没有登陆并且该请求类型不是登陆
        [self connect];
    }else{
        // 已经登陆或没有登陆但请求类型为登陆
        STKPackage *package = [[STKPackage alloc] initWithDataPart:[context.request getReqeustBytes]];
        [self writeData:[package getBytes] withTimeout:SOCKET_TIME_OUT tag:context.request.rid];
        [_requestQueue setContext:context byId:context.request.rid];
    }
    // 返回请求id
    return context.request.rid;
}

/// 将请求放入队列，主要外部调用
- (void)request:(STKRequestContext *)context
{
    if ( _isConnecting || _isLogining ) {
        [_requestQueue enQueue:context];
    }else{
        [self excuteRequest:context];
    }
}

#pragma mark -
#pragma mark 返回数据处理

- (void)handleData:(STKData *)response
{
    STKRequestContext *context = [_requestQueue getContextById:response.rid];
    
    //调用回调函数
    if ( context ) {
        SEL resultHandler = context.resultHandler;
        
        id target = context.target;
        if (target && resultHandler && response.rid != 0) {
                [target performSelector:resultHandler withObject:response];
                [_requestQueue removeContextById:response.rid];
        }
        if (target && resultHandler && response.rid == 0) {
            NSData *result = response.params;
            if (response.params.length > 4) {
                SKFiveReportVO *report = [[SKFiveReportVO alloc] initWithNSData:result];
                [target performSelector:resultHandler withObject:report];
            } else {
                NSLog(@"%@   %lu",result,(unsigned long)result.length);
            }
        }
    
    }
}

// 测试数据是否完整
- (BOOL)testDataIsComplete
{
    if ( _currentPackage.isDataReceiveComplete )
    {
        NSLog(@"接收到完整的socket数据包，长度%ld，全长为%ld",(long)_currentPackage.data.length,(long)_currentPackage.dataLength);
        // 数据完整
        [self handleData:[[STKData alloc] initFromData:_currentPackage.data]];
        _currentPackage = nil;
        return YES;
    } else {
        NSLog(@"接收到不完整的socket数据包，长度%ld，全长为%ld",(long)_currentPackage.data.length,(long)_currentPackage.dataLength);
    }
    return NO;
}

#pragma mark -
#pragma mark socket代理方法

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSLog(@"didReadData withTag:%ld",tag);
//    NSLog(@"didReadData length:%d",data.length);
    // 将数据放入字节缓存
    if ( byteCache == nil) {
        byteCache = [data mutableCopy];
    }else{
        [byteCache appendData:data];
    }
//    // 循环读取字节缓存数据
//    while ( byteCache != nil ) {
//        [self readPackageFromCache];
//    }
    
    while (byteCache.length >= 17) {
        [self readPackageFromCache];
    }
    
    // 继续读取数据
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)readPackageFromCache{
    if ( _currentPackage == nil ) {
        // 没有缓存数据，创建新的STKData对象
        _currentPackage = [[STKPackage alloc] initWithNSData:byteCache];
    }else{
        // 有缓存数据，往后追加
        [_currentPackage appendData:byteCache];
    }
    // 整理字节缓存，清除已读取数据
    if ( byteCache.cursor.intValue >= byteCache.length ) {
        // 当前索引超过字节流长度
        byteCache = nil;
    }else{
        // 将当前索引前面的字节流截掉，返回后面的字节流，并将当期那索引归零
        byteCache = [[byteCache subdataWithRange:NSMakeRange(byteCache.cursor.intValue, byteCache.length - byteCache.cursor.intValue)] mutableCopy];
    }
    // 测试数据是否完整
    [self testDataIsComplete];

}

// 清除状态变量，断开连接时调用
- (void)clear
{
    _isConnecting = NO;
    _isLogin = NO;
    _isLogining = NO;
    byteCache = nil;
}

// 清除接收到的但还没来得及处理的字节缓存,切换界面时调用
- (void)clearByteCache
{
    NSLog(@"清除前%ld",(unsigned long)byteCache.length);
    byteCache = nil;
    NSLog(@"清除后%ld",(unsigned long)byteCache.length);
}

// 切断socket
-(void)cutOffSocket{
    
    self.userData = 1;// 声明是由用户主动切断
    
    [self disconnect];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
//    NSLog(@"didReadPartialDataOfLength:%lu tag:%ld",(unsigned long)partialLength,tag);
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"didWriteDataWithTag:%ld",tag);
}

- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"didWritePartialDataOfLength:%lu tag:%ld",(unsigned long)partialLength,tag);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError,%@",[err description]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"onSocketDidDisconnect");
    [self clear];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost");
    [self login];
    [sock readDataWithTimeout:-1 tag:0];
    _isConnecting = NO;
}

- (void)onSocketDidSecure:(AsyncSocket *)sock
{
    NSLog(@"onSocketDidSecure");
}

@end
