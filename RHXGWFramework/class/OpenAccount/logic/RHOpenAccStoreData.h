//
//  RHOpenAccStoreData.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/17.
//
//

#import <Foundation/Foundation.h>

@interface RHOpenAccStoreData : NSObject

+ (void)saveOpenAccountData:(id)data withPath:(NSString *)path;

+ (id)loadOpenAccountDataWithPath:(NSString *)path;

+ (void)storeOpenAccCachUserInfo:(id)value withKey:(NSString *)key;

+ (id)getOpenAccCachUserInfoWithKey:(NSString *)key;

+ (void)clearOpenAccCachUserInfo;

+ (void)clearOpenAccCachWithKey:(NSString *)key;

+ (void)requestUserStatus:(UIViewController *)currentVC;

+ (void)cancelRequestStatus;
@end
