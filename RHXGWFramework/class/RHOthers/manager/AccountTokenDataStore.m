//
//  AccountTokenDataStore.m
//  stockscontest
//
//  Created by rxhui on 15/10/27.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "AccountTokenDataStore.h"
#import <Foundation/NSFileManager.h>

@implementation AccountTokenDataStore

/**
 *  @brief NSUUID生成的唯一token，第一次生成存在沙盒document中，以后从沙盒取
 */

+ (NSString *)getAccountToken {
    //1.path
    NSArray *docuemntPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [docuemntPaths objectAtIndex:0];
    NSString *storePath = [documentPath stringByAppendingPathComponent:@"UserToken.data"];
    
    //2.file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager contentsAtPath:storePath];
    
    //3.先取userDefaults
    NSString *defaultToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accountToken"];
    if (defaultToken) {
        return defaultToken;
    }
    //如果没有，从文件读
    NSString *accountToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (accountToken) {//并保存到userDefaults
        [[NSUserDefaults standardUserDefaults]setObject:accountToken forKey:@"accountToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return accountToken;
        //NSLog(@"--%s-%@",__func__,data);
    }
    else {//如果文件中读不到，重新生成，并保存到userDefaults
        NSUUID *tokenID = [NSUUID UUID];
        accountToken = tokenID.UUIDString;
        NSData *tempData = [NSKeyedArchiver archivedDataWithRootObject:accountToken];
        [fileManager createFileAtPath:storePath contents:tempData attributes:nil];//存文件
        
        [[NSUserDefaults standardUserDefaults]setObject:accountToken forKey:@"accountToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return accountToken;
    }
}
/*
 + (NSString *)getAccountToken {
 NSString *accountToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accountToken"];
 if (accountToken) {
 return accountToken;
 }
 
 NSUUID *tokenID = [NSUUID UUID];
 [[NSUserDefaults standardUserDefaults]setObject:tokenID.UUIDString forKey:@"accountToken"];
 [[NSUserDefaults standardUserDefaults]synchronize];
 return tokenID.UUIDString;
 }
 */
@end
