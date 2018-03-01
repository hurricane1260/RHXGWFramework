//
//  PresentModalManager.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-15.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  管理弹出视图
//

#import <Foundation/Foundation.h>

@interface PresentModalManager : NSObject

+(void)presentModalView:(UIView *)modalView animation:(BOOL)animation completion:(void (^)(void))completion;

+(void)dismissModalView:(UIView *)modalView animation:(BOOL)animation completion:(void (^)(void))completion;

@end
