//
//  JHJRServerTime.m
//  stockscontest
//
//  Created by rxhui on 16/2/29.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "JHJRServerTime.h"
#import "HTTPRequestService.h"
#import "CMHttpURLManager.h"

@interface JHJRServerTime ()

@property (nonatomic, strong)HTTPRequestService *request;

@property (nonatomic, assign) long long serverInterval;

@property (nonatomic, readonly) NSString *keyStorePath;

@property (nonatomic, readonly) NSString *secretStorePath;

@end

@implementation JHJRServerTime

static JHJRServerTime *instance = nil;

+(JHJRServerTime *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[JHJRServerTime alloc] init];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@"IOS" forKey:@"client"];
        instance.request = [[HTTPRequestService alloc]initWithUrlString:[CMHttpURLManager urlStringWithServID:@"fundGetServerTime"] params:param requestMethod:HTTRequestGET requestType:HTTPRequestAsynchronous];
        instance.request.delegate = instance;
       // [NSKeyedArchiver archiveRootObject:@"ef0374fd25294140ac3e299dde77e9ba" toFile:instance.keyStorePath];
        //[NSKeyedArchiver archiveRootObject:@"jhe17d20459d6e8bcf" toFile:instance.secretStorePath];
        [NSKeyedArchiver archiveRootObject:@"jhe17d20459d6e8bcf" toFile:instance.keyStorePath];
        [NSKeyedArchiver archiveRootObject:@"ef0374fd25294140ac3e299dde77e9ba" toFile:instance.secretStorePath];

        
    });
    return instance;
}

+ (void)startSynchronize {
    JHJRServerTime *instance = [JHJRServerTime shareInstance];
    [instance.request sendRequestWithSuccessBlock:^(id data) {
        if (![data isKindOfClass:[NSDictionary class]]) {
            return;
        }
        id messageVO = [data objectForKey:@"message"];
        NSNumber *code = [messageVO objectForKey:@"code"];
        NSString *message = [messageVO objectForKey:@"message"];
        if (code.integerValue != 0) {
            NSLog(@"JHJR获取服务器时间失败,%@",message);
            return;
        }
        NSNumber *currentTime = [data objectForKey:@"currentTime"];
        NSTimeInterval local = [[NSDate date]timeIntervalSince1970];
        long long interval = currentTime.longLongValue - local * 1000;
        instance.serverInterval = interval;
        NSLog(@"%@",currentTime);
    } failureBlock:^(id data) {
        NSLog(@"JHJR获取服务器时间失败");
    }];
}

+ (NSString *)currentServerTime {
    JHJRServerTime *instance = [JHJRServerTime shareInstance];
    NSTimeInterval local = [[NSDate date]timeIntervalSince1970];
    long long total = local * 1000 + instance.serverInterval;
    return [NSNumber numberWithLongLong:total].stringValue;
}

+ (NSString *)getJHJRAppKey {
    JHJRServerTime *instance = [JHJRServerTime shareInstance];
    id token = [NSKeyedUnarchiver unarchiveObjectWithFile:instance.keyStorePath];
    if (!token) {//不存在，创建并保存
        NSLog(@"error!没有存appKey");
        [NSKeyedArchiver archiveRootObject:@"jhe17d20459d6e8bcf" toFile:instance.keyStorePath];

        return token;
    }
    else {//存在
        return token;
    }
}

+(NSString *)getJHJRAppSecret {
    JHJRServerTime *instance = [JHJRServerTime shareInstance];
    id token = [NSKeyedUnarchiver unarchiveObjectWithFile:instance.secretStorePath];
    if (!token) {//不存在，创建并保存
        NSLog(@"error!没有存appSecret");
        [NSKeyedArchiver archiveRootObject:@"ef0374fd25294140ac3e299dde77e9ba" toFile:instance.secretStorePath];
        return token;
    }
    else {//存在
        return token;
    }
}

@synthesize keyStorePath = _keyStorePath;

- (NSString *)keyStorePath{
    if (!_keyStorePath) {
        NSArray *docuemntPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [docuemntPaths objectAtIndex:0];
        _keyStorePath = [documentPath stringByAppendingPathComponent:@"JHJRAppKey.data"];
    }
    return _keyStorePath;
}

@synthesize secretStorePath = _secretStorePath;

- (NSString *)secretStorePath{
    if (!_secretStorePath) {
        NSArray *docuemntPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [docuemntPaths objectAtIndex:0];
        _secretStorePath = [documentPath stringByAppendingPathComponent:@"JHJRAppSecret.data"];
    }
    return _secretStorePath;
}

@end
