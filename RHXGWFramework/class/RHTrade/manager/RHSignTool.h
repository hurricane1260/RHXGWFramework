//
//  RHSignTool.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/26.
//
//

#import <Foundation/Foundation.h>

@interface RHSignTool : NSObject
+(NSString *)signStrWithParam:(NSDictionary *)param andAccountId:(NSString *)accountId;

+(NSString *)activityTokenWithAccountId:(NSString *)accountId;
@end
