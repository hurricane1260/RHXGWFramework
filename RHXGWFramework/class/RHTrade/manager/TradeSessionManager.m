//
//  TradeSessionManager.m
//  stockscontest
//
//  Created by rxhui on 15/6/10.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeSessionManager.h"
#import "CMHttpURLManager.h"
#import "HTTPRequestService.h"

@interface TradeSessionManager ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSTimer *timerForLogout;

@property (nonatomic,strong) HTTPRequestService *requestForCreate;

@property (nonatomic,strong) HTTPRequestService *requestForPing;

@property (nonatomic,strong) HTTPRequestService *requestForLogout;

@property (nonatomic,assign) BOOL needRecreateSessionId;

@end

@implementation TradeSessionManager

static TradeSessionManager *instance = nil;

+(TradeSessionManager *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[TradeSessionManager alloc] init];
        instance.onLine = NO;
        instance.needRecreateSessionId = NO;
        instance.requestForCreate = [[HTTPRequestService alloc]init];
        instance.requestForCreate.delegate = instance;
        instance.requestForPing = [[HTTPRequestService alloc]init];
        instance.requestForPing.delegate = instance;
        instance.requestForLogout = [[HTTPRequestService alloc]init];
        instance.requestForLogout.delegate = instance;
    });
    return instance;
}

-(void)setSessionID:(NSString *)aID {
    if (_sessionID) {
        _sessionID = nil;
    }
    _sessionID = aID;
    if (!_sessionID ) {
        [_timer invalidate];
        _timer = nil;
        _onLine = NO;
        if (_needRecreateSessionId) {
            [[TradeSessionManager shareInstance] createSessionWithBlock:^{
                [[TradeSessionManager shareInstance] startPing];
            }];
        }
    }
}

-(void)startPing{
    [[TradeSessionManager shareInstance].timer invalidate];
    [TradeSessionManager shareInstance].timer = nil;
    [TradeSessionManager shareInstance].timer = [NSTimer scheduledTimerWithTimeInterval:1200 target:self selector:@selector(ping) userInfo:nil repeats:YES];
//    [instance.timer fire];
}
 
-(void)stopPing{
    [[TradeSessionManager shareInstance].timer invalidate];
    [TradeSessionManager shareInstance].timer = nil;
}

-(void)ping {
    if (![TradeSessionManager shareInstance].sessionID) {
        [self stopPing];
        return;
    }
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:[TradeSessionManager shareInstance].sessionID forKey:@"sessionId"];
    [TradeSessionManager shareInstance].requestForPing.urlString = [CMHttpURLManager urlStringWithServID:@"sessionPing"];
    [TradeSessionManager shareInstance].requestForPing.requestMethod = HTTRequestGET;
    [TradeSessionManager shareInstance].requestForPing.requestType = HTTPRequestAsynchronous;
//    [TradeSessionManager shareInstance].requestForPing.reqParam = param;
    [[TradeSessionManager shareInstance].requestForPing cancelWithoutDelegate];
    [[TradeSessionManager shareInstance].requestForPing sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        id message = [data objectForKey:@"message"];
        NSNumber *code = [message objectForKey:@"code"];
        if (code.integerValue == 0) {
            NSLog(@"ping success");
        }
        else {
            NSLog(@"ping fail");
            [TradeSessionManager shareInstance].needRecreateSessionId = YES;
            [TradeSessionManager shareInstance].sessionID = nil;
        }
    } failureBlock:^(id data) {
        NSLog(@"ping fail－1");
        [TradeSessionManager shareInstance].needRecreateSessionId = YES;
        [TradeSessionManager shareInstance].sessionID = nil;
    }];
}

-(void)waitForLogout {
    if (![TradeSessionManager shareInstance].sessionID) {
        return;
    }
    [[TradeSessionManager shareInstance].timerForLogout invalidate];
    [TradeSessionManager shareInstance].timerForLogout = nil;
    [TradeSessionManager shareInstance].timerForLogout = [NSTimer scheduledTimerWithTimeInterval:60 * 120 target:self selector:@selector(destroySession) userInfo:nil repeats:NO];
}

-(void)cancelLogout {
    [[TradeSessionManager shareInstance].timerForLogout invalidate];
    [TradeSessionManager shareInstance].timerForLogout = nil;
//    [self stopPing];
}

-(void)destroySession {
    if (![TradeSessionManager shareInstance].sessionID) {
        return;
    }
    [TradeSessionManager shareInstance].requestForLogout.urlString = [CMHttpURLManager urlStringWithServID:@"sessionDestroy"];
    [TradeSessionManager shareInstance].requestForLogout.requestMethod = HTTRequestGET;
    [TradeSessionManager shareInstance].requestForLogout.requestType = HTTPRequestAsynchronous;
    [[TradeSessionManager shareInstance].requestForLogout cancelWithoutDelegate];
//    __block __typeof(self) welf = self;
    [[TradeSessionManager shareInstance].requestForLogout sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSLog(@"destroy success,%@",data);
        [TradeSessionManager shareInstance].needRecreateSessionId = NO;
        [TradeSessionManager shareInstance].sessionID = nil;
        [TradeSessionManager shareInstance].onLine = NO;
//        [[TradeSessionManager shareInstance] stopPing];
    } failureBlock:^(id data) {
        NSLog(@"destory fail");
    }];
}

- (void)destroySessionWithBlock:(void (^)(void))callback {
    [TradeSessionManager shareInstance].requestForLogout.urlString = [CMHttpURLManager urlStringWithServID:@"sessionDestroy"];
    [TradeSessionManager shareInstance].requestForLogout.requestMethod = HTTRequestGET;
    [TradeSessionManager shareInstance].requestForLogout.requestType = HTTPRequestAsynchronous;
    [[TradeSessionManager shareInstance].requestForLogout cancelWithoutDelegate];
    //    __block __typeof(self) welf = self;
    [[TradeSessionManager shareInstance].requestForLogout sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSLog(@"destroy success,%@",data);
        [TradeSessionManager shareInstance].needRecreateSessionId = NO;
        [TradeSessionManager shareInstance].sessionID = nil;
        [TradeSessionManager shareInstance].onLine = NO;
        //        [[TradeSessionManager shareInstance] stopPing];
        if (callback) {
            callback();
        }
    } failureBlock:^(id data) {
        NSLog(@"destory fail");
    }];
}

-(void)createSessionWithBlock:(void (^)(void))callback {
    [TradeSessionManager shareInstance].requestForCreate.urlString = [CMHttpURLManager urlStringWithServID:@"sessionCreate"];
    [TradeSessionManager shareInstance].requestForCreate.requestMethod = HTTRequestGET;
    [TradeSessionManager shareInstance].requestForCreate.requestType = HTTPRequestAsynchronous;
    [[TradeSessionManager shareInstance].requestForCreate cancelWithoutDelegate];
//    __block __typeof(self) welf = self;
    [[TradeSessionManager shareInstance].requestForCreate sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        [TradeSessionManager shareInstance].sessionID = [data objectForKey:@"sessionId"];
//        [TradeSessionManager shareInstance].onLine = YES;
        NSLog(@"create success,%@",[TradeSessionManager shareInstance].sessionID);
        if (callback) {
            callback();
        }
    } failureBlock:^(id data) {
        id message = [data objectForKey:@"message"];
        id code = [message objectForKey:@"code"];
        id messageString = [message objectForKey:@"message"];
        NSLog(@"create fail,%@:%@",code,messageString);
//        [CMProgress showWarningProgressWithTitle:nil message:messageString warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
    }];
}

@end
