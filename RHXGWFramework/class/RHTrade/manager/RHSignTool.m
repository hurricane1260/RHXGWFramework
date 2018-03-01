//
//  RHSignTool.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/26.
//
//

#import "RHSignTool.h"
#import "TradeSessionManager.h"
#import<CommonCrypto/CommonDigest.h>

#define appKey @"652035571F489A357385AEFAEDACF9C1"
@interface RHSignTool ()
@property (nonatomic,strong)NSMutableDictionary * muDic;


@end


@implementation RHSignTool


+(NSString *)signStrWithParam:(NSDictionary *)param andAccountId:(NSString *)accountId{
    
//    RHSignTool * singTool = [[RHSignTool alloc]init];
    /**资金账号的倒序*/
    NSString * keystr = [self rankStr:accountId];
    
   // NSString * keystr = [singTool rankStr:@"65502706"];

    /**排序前的key 数组*/
    NSArray * oldArray = param.allKeys;
    /**排序后的key 数组 */
    NSArray * newArray = [oldArray sortedArrayUsingSelector:@selector(compare:)];
    /**拼接字符串*/
    NSMutableString * urlStr = [NSMutableString string];
    for (NSString * key in newArray) {
        [urlStr appendFormat:@"%@=%@&",key,param[key]];
    }
    NSLog(@"%@",urlStr);
    NSString * newUrlStr = [NSString stringWithFormat:@"%@%@=%@&%@=%@",urlStr,@"appKey",appKey,@"key",keystr];
    
    return [self md5:newUrlStr];
    
}

+ (NSString *)activityTokenWithAccountId:(NSString *)accountId
{
    if (accountId == nil) {
        return nil;
    }
    
    NSString * newAccountId = [NSString stringWithFormat:@"hd.hczq.com-%@|2017",accountId];
    
    return [self md5:newAccountId];
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)rankStr:(NSString *)str{
    
    
    NSMutableString * reverseString = [NSMutableString string];
    for(int i = 0 ; i < str.length; i ++){
        //倒序读取字符并且存到可变数组数组中
        unichar c = [str characterAtIndex:str.length- i -1];
        [reverseString appendFormat:@"%c",c];
    }
    
    return reverseString;
}
@end
