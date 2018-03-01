//
//  NSStringUtilFor@.h
//  stockscontest
//
//  Created by rxhui on 15-1-22.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtilFor_ : NSObject
/**
 *传入字符串，返回@xx的匹配结果
 */
+(NSMutableArray *)getCheckingResultsWithString:(NSString *)string andNamesAndUserIdsDic:(NSMutableDictionary *)dictionary;

/**
 *传入字符串，返回@xx的范围
 */
+(NSMutableArray *)getRangesOfTouchableWithString:(NSString *)string andNamesAndUserIdsDic:(NSMutableDictionary *)dictionary;

/**
 *传入字符串，返回nickName和userID的键值对
 */
+(NSMutableDictionary *)getNickNamesAndUserIdsFromString:(NSString *)string;

/**
 *传入字符串，返回@ ## $$ href的键值对
 */
+(NSMutableDictionary *)getInfoDictionaryFromString:(NSString *)string;

/**
 *传入字符串，返回删去超链接的字符串
 */
+(NSString *)getSubStringWithoutHref:(NSString *)string;

/**
 *传入字符串，返回删去“回复@xx:”的字符串
 */
+(NSString *)getSubStringWithoutRecomment:(NSString *)string;

/**
 *传入字符串，返回增加超链接的字符串
 */
+(NSString *)addHrefForAtWithString:(NSString *)string andUserId:(NSString *)userId;

/**
 *传入字符串，返回#ff#$ff$的匹配结果
 */
+(NSMutableArray *)getRangesOfBlueAreaWithString:(NSString *)string;
@end
