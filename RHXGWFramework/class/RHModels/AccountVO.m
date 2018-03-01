//
//  AccountVO.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "AccountVO.h"

@implementation AccountVO

@synthesize nickName, userId, gender, profileImageUrl, isOnline, userCode, update, inGame, hcAccount, openAccount, wealthID, relation, wealthUserId, wealthToken, isOpenAccount, followedUserId, fundAccount, mobilePhone, guid, accessToken, tabId, tabName, userType, imId, imPassWord, accountState, friendCount,beefBoneNum,channelCode;

- (void)encodeWithCoder:(NSCoder *)aEncoder
{
    [aEncoder encodeObject:nickName forKey:@"nickName"];
    [aEncoder encodeObject:userId forKey:@"userId"];
    [aEncoder encodeObject:userCode forKey:@"userCode"];
    [aEncoder encodeObject:gender forKey:@"gender"];
    [aEncoder encodeObject:profileImageUrl forKey:@"profileImageUrl"];
    [aEncoder encodeObject:isOnline forKey:@"isOnline"];
    [aEncoder encodeObject:update forKey:@"update"];
    [aEncoder encodeObject:inGame forKey:@"inGame"];
    [aEncoder encodeObject:hcAccount forKey:@"hcAccount"];
    [aEncoder encodeObject:openAccount forKey:@"openAccount"];
    [aEncoder encodeObject:wealthID forKey:@"wealthID"];
    [aEncoder encodeObject:relation forKey:@"relation"];
    [aEncoder encodeObject:wealthToken forKey:@"wealthToken"];
    [aEncoder encodeObject:wealthUserId forKey:@"wealthUserId"];
    [aEncoder encodeObject:isOpenAccount forKey:@"isOpenAccount"];
    [aEncoder encodeObject:followedUserId forKey:@"followedUserId"];
    [aEncoder encodeObject:fundAccount forKey:@"fundAccount"];
    [aEncoder encodeObject:mobilePhone forKey:@"mobilePhone"];
    [aEncoder encodeObject:guid forKey:@"guid"];
    [aEncoder encodeObject:accessToken forKey:@"accessToken"];
    [aEncoder encodeObject:tabId forKey:@"tabId"];
    [aEncoder encodeObject:tabName forKey:@"tabName"];
    [aEncoder encodeObject:beefBoneNum forKey:@"beefBoneNum"];
    [aEncoder encodeObject:userType forKey:@"userType"];
    [aEncoder encodeObject:imId forKey:@"imId"];
    [aEncoder encodeObject:imPassWord forKey:@"imPassWord"];
    [aEncoder encodeObject:accountState forKey:@"accountState"];
    [aEncoder encodeObject:friendCount forKey:@"friendCount"];
    [aEncoder encodeObject:channelCode forKey:@"channelCode"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userCode = [aDecoder decodeObjectForKey:@"userCode"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.profileImageUrl = [[aDecoder decodeObjectForKey:@"profileImageUrl"] description];
        self.isOnline = [[aDecoder decodeObjectForKey:@"isOnline"] description];
        self.update = [[aDecoder decodeObjectForKey:@"update"] description];
        self.inGame = [[aDecoder decodeObjectForKey:@"inGame"] description];
        self.hcAccount = [[aDecoder decodeObjectForKey:@"hcAccount"] description];
        self.openAccount = [[aDecoder decodeObjectForKey:@"openAccount"] description];
        self.wealthID = [[aDecoder decodeObjectForKey:@"wealthID"] description];
        self.relation = [[aDecoder decodeObjectForKey:@"relation"] description];
        self.wealthToken = [aDecoder decodeObjectForKey:@"wealthToken"];
        self.wealthUserId = [aDecoder decodeObjectForKey:@"wealthUserId"];
        self.isOpenAccount = [aDecoder decodeObjectForKey:@"isOpenAccount"];
        self.followedUserId = [aDecoder decodeObjectForKey:@"followedUserId"];
        self.fundAccount = [aDecoder decodeObjectForKey:@"fundAccount"];
        self.mobilePhone = [aDecoder decodeObjectForKey:@"mobilePhone"];
        self.guid = [[aDecoder decodeObjectForKey:@"guid"] description];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.tabId = [aDecoder decodeObjectForKey:@"tabId"];
        self.tabName = [aDecoder decodeObjectForKey:@"tabName"];
        self.beefBoneNum = [aDecoder decodeObjectForKey:@"beefBoneNum"];
        self.friendCount = [aDecoder decodeObjectForKey:@"friendCount"];
        self.userType = [aDecoder decodeObjectForKey:@"userType"];
        self.imId = [aDecoder decodeObjectForKey:@"imId"];
        self.imPassWord = [aDecoder decodeObjectForKey:@"imPassWord"];
        self.channelCode = [aDecoder decodeObjectForKey:@"channelCode"];
        self.accountState = [aDecoder decodeObjectForKey:@"accountState"];
    
    }
    return self;
}

@synthesize isCompleteInformation = _isCompleteInformation;

-(BOOL)isCompleteInformation{
    if(self.nickName.length == 0 || self.gender.length == 0){
        return NO;
    }
    return YES;
}

+ (id)generateWithDict:(NSDictionary *)dic{
    AccountVO * account = [[AccountVO alloc] init];
    [account setValuesForKeysWithDictionary:dic];
    return account;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
