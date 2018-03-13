//
//  JHJRServerTime.h
//  stockscontest
//
//  Created by rxhui on 16/2/29.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHJRServerTime : NSObject

+ (void)startSynchronize;

+ (NSString *)currentServerTime;

+ (NSString *)getJHJRAppKey;

+ (NSString *)getJHJRAppSecret;

@end
