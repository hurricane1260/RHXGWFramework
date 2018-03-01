//
//  AccountVO.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountVO : NSObject<NSCoding>

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *profileImageUrl;

@property (nonatomic, copy) NSString *userCode;

@property (nonatomic, copy) NSString *isOnline;

@property (nonatomic, readonly) BOOL isCompleteInformation;

@property (nonatomic, copy) NSString *update;

/**
 *  是否报名，如果是则为字符串@"YES", 否则为字符串@"NO"
 */
@property (nonatomic, copy) NSString *inGame;


@property (nonatomic, copy) NSString *hcAccount;

/**
 *  是否开过户，如果是则为字符串@"YES", 否则为字符串@"NO"
 */

@property (nonatomic, copy) NSString *openAccount;

@property (nonatomic, copy) NSString *wealthID;

/**
 *  是否关联账户，如果关联则为字符串@"YES", 否则为字符串@"NO"
 */
@property (nonatomic, copy) NSString *relation;

/*! 理财用户id */
@property (nonatomic, copy) NSString *wealthUserId;

/*! 理财用户token */
@property (nonatomic, copy) NSString *wealthToken;

/*! 理财是否开户绑卡 */
@property (nonatomic, copy) NSNumber *isOpenAccount;

/*! 被跟单用户ID */
@property (nonatomic, copy) NSString *followedUserId;

/*! 理财账号 */
@property (nonatomic, copy) NSString *fundAccount;

/*! 手机号 */
@property (nonatomic, copy) NSString *mobilePhone;

/**
 *  @brief 用户GUID，用于自选股列表
 */
@property (nonatomic, copy) NSString *guid;


/*! 安全性token*/
@property (nonatomic, copy) NSString *accessToken;

/*! 自选股tabId*/
@property (nonatomic, copy) NSNumber *tabId;

/*! 自选股tabId名*/
@property (nonatomic, copy) NSString *tabName;

/*! 用户类型  1-大B，2-小B，3-C客户*/
@property (nonatomic, strong) NSNumber *userType;

/*! im用户id(加密后)*/
@property (nonatomic,copy) NSString *imId;

/*! im用户密码(加密后)*/
@property (nonatomic,copy) NSString *imPassWord;

/*! im好友数量*/
@property (nonatomic,strong) NSNumber *friendCount;

/*! 牛骨*/
@property (nonatomic,strong) NSNumber * beefBoneNum;
/*! 渠道号*/
@property (nonatomic,copy) NSString * channelCode;

@property (nonatomic,strong) NSNumber * accountState;


+ (id)generateWithDict:(NSDictionary *)dic;

@end
