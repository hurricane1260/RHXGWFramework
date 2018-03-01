//
//  SKCodeTable.m
//  iphone-stock
//
//  Created by ztian on 14-3-7.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKCodeTable.h"
#import "UTFileUtil.h"
#import "SKCodeTableDelegate.h"
#import "SKReportDelegate.h"
#import "pinyin.h"

#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define KEY_CODE_TABLE_UPDATE_DATE @"SKCodeTableUpdateDate"
#define FILE_CODE_TABLE @"codetable.data"

@interface SKCodeTable()
{
    NSDictionary *_codeTable;
}
@end

@implementation SKCodeTable

#pragma mark -
#pragma mark 代码表操作

- (SKCodeItemVO *)getCodeItemBySymbol:(NSString *)symbol{
    return [_codeTable objectForKey:symbol];
}

- (NSArray *)getCodeItemsBySymbols:(NSArray *)symbols
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *symbol in symbols) {
        SKCodeItemVO *codeItem = [self getCodeItemBySymbol:symbol];
        if (codeItem) {
            [result addObject:codeItem];
        }
    }
    return result;
}

- (NSArray *)getCodeItemListByKeyword:(NSString *)keyword type:(NSInteger)type
{
    // iphone 4s平均耗时40毫秒
    NSArray *keys = [_codeTable allKeys];
    NSLog(@"码表股票数量%ld",(unsigned long)keys.count);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *key in keys) {
        SKCodeItemVO *item = [_codeTable objectForKey:key];
        keyword = [keyword lowercaseString];
        
        if (type == allData) {
            if (([item.pinyin rangeOfString:keyword].location != NSNotFound || [item.code rangeOfString:keyword].location != NSNotFound || [item.name rangeOfString:keyword].location != NSNotFound) && ![item.prefix isEqualToString:@"hc"]) {
                [result addObject:item];
                if (result.count >= 20) {
                    break;
                }
            }
        }
        if (type == tradeData) {
            if (([item.pinyin rangeOfString:keyword].location != NSNotFound || [item.code rangeOfString:keyword].location != NSNotFound || [item.name rangeOfString:keyword].location != NSNotFound) && [self tradeYesOrNo:item]) {
                [result addObject:item];
                if (result.count >= 20) {
                    break;
                }
            }
        }
        if (type == adviserData) {
            if (([item.pinyin rangeOfString:keyword].location != NSNotFound || [item.code rangeOfString:keyword].location != NSNotFound || [item.name rangeOfString:keyword].location != NSNotFound) && [self adviserYesOrNo:item]) {
                [result addObject:item];
                if ( result.count >= 20 ) {
                    break;
                }
            }
        }
        if (type == searchData) {
            if (([item.pinyin rangeOfString:keyword].location != NSNotFound || [item.code rangeOfString:keyword].location != NSNotFound || [item.name rangeOfString:keyword].location != NSNotFound) && [self searchYesOrNo:item]) {
                [result addObject:item];
                if ( result.count >= 20 ) {
                    break;
                }
            }
        }
    }
    for (int i = 0; i < result.count; i++) {
        SKCodeItemVO * vo = result[i];
        if ([SKUtils isAStockBySymbol:vo.symbol]) {
            [result removeObjectAtIndex:i];
            [result insertObject:vo atIndex:0];
        }
    }
    return result;
}

- (BOOL)tradeYesOrNo:(SKCodeItemVO *)item
{
    NSArray * array = @[@00,@60,@30,@20,@90,@131,@150,@159,@160,@161,@162,@163,@164,@165,@168,@169,@184,@204,@500,@501,@502,@510,@511,@512,@513,@518,@519];
    if ([array containsObject:[NSNumber numberWithInteger:[item.code substringToIndex:2].integerValue]] || [array containsObject:[NSNumber numberWithInteger:[item.code substringToIndex:3].integerValue]]) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)adviserYesOrNo:(SKCodeItemVO *)item
{
    if ([[item.prefix substringToIndex:2] isEqualToString:@"sh"]) {
        if ([[item.code substringToIndex:2] isEqualToString:@"60"]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([[item.prefix substringToIndex:2] isEqualToString:@"sz"]) {
        if ([[item.code substringToIndex:2] isEqualToString:@"00"] || [[item.code substringToIndex:2] isEqualToString:@"30"]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)searchYesOrNo:(SKCodeItemVO *)item
{
    NSArray * array = @[@00,@60,@30,@20,@90,@131,@150,@159,@160,@161,@162,@163,@164,@165,@168,@169,@184,@204,@500,@501,@502,@510,@511,@512,@513,@518,@519];
    if ([array containsObject:[NSNumber numberWithInteger:[item.code substringToIndex:2].integerValue]] || [array containsObject:[NSNumber numberWithInteger:[item.code substringToIndex:3].integerValue]]) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)rangeInclude:(NSRange)range
{
    return range.length > 0 && range.location == 0;
}

#pragma mark -
#pragma mark 加载和缓存代码表

/// 将代码表缓存到本地硬盘
- (void)saveCodeTableToLocal
{
    [NSKeyedArchiver archiveRootObject:_codeTable toFile:[self codeTablePath]];
    int today = [[[NSDate alloc] init] yyyyMMddFormat];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithInt:today] forKey:KEY_CODE_TABLE_UPDATE_DATE];
    [userDefaults synchronize];
}

/// 从本地硬盘加载代码表
- (void)loadCodeTableFromLocal
{
    // 执行时间较长，需要几百毫秒，后台执行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_codeTable = [NSKeyedUnarchiver unarchiveObjectWithFile:[self codeTablePath]];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            [[SKCodeTable instance] createSearchableContent];
        }
    });
}

- (NSString *)codeTablePath{
    return [UTFileUtil pathInDocumentDirectory:FILE_CODE_TABLE];
}

/// 加载代码表和板块股票关系表
- (void)loadCodeTable
{
    // 本地加载
    [self loadCodeTableFromLocal];
    if ( [self needReloadCodeTableFromRemote] ) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * stamp = [userDefaults stringForKey:KEY_CODE_TABLE_UPDATE_DATE];
        // 远程加载
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            SKCodeTableDelegate *delegate = [[SKCodeTableDelegate alloc] init];
            [delegate getCodeTableWithTarget:self stamp:stamp resultHandler:@selector(loadCodeTableResultHandler:) failHandler:@selector(loadCodeTableFailHandler:)];
        });
        
    }
}

- (void)loadBlockStockMapResultHandler:(id)data
{
    NSData *response = (NSData *)data;
    int count = [response readCompressedInt];
    //  几秒的操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while ( count > [response getCursor]) {
            [self getCodeItemFromNSData:data withLevel:1];
        }
//        [[SKCodeTable instance] saveCodeTableToLocal];
    });
}

- (SKCodeItemVO *)getCodeItemFromNSData:(NSData *)data withLevel:(int)level
{
    BOOL isBlock = [data readCompressedInt] == 1 ? YES : NO;
    NSString *symbol = [data readString];
    SKCodeItemVO *result = [[SKCodeTable instance] getCodeItemBySymbol:symbol];
    int count = [data readCompressedInt];
    if ( isBlock && count > 0 ) {
        NSMutableArray *subItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++ ) {
            SKCodeItemVO *tempItem = [self getCodeItemFromNSData:data withLevel:level+1];
            if ( tempItem ) {
                [subItems addObject:tempItem.symbol];
            }
            if (tempItem.supItems == nil) {
                tempItem.supItems = [[NSMutableArray alloc] init];
            }
            if (result) {
                [tempItem.supItems addObject:result.symbol];
            }
        }
        result.subItems = subItems;
    }
    result.level = level;
    return result;
}

- (void)loadBlockStockMapFailHandler:(id)data
{
    
}

- (void)loadCodeTableResultHandler:(id)data
{
    NSDictionary *codeItems = (NSDictionary *)data;
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    _codeTable = nil;
//    if (_codeTable) {
//        [dic setDictionary:_codeTable];
//    } else {
//        [dic setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:[self codeTablePath]]];
//    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString * key in codeItems) {
            SKCodeItemVO * vo = [codeItems objectForKey:key];
            
            if ([vo.flag isEqualToString:@"+"] || [vo.flag isEqualToString:@"*"]) {
                [dic setObject:vo forKey:vo.symbol];
            } else if ([vo.flag isEqualToString:@"-"]) {
                [dic removeObjectForKey:vo.symbol];
            } else {
                NSLog(@"%@%@%@%@",vo.symbol,vo.name,vo.flag,vo.pinyin);
            }
            
            if ( [vo.pinyin isEqualToString:@""] ) {
                NSString * result = [NSMutableString string];
                for (int i = 0; i < vo.name.length; i++)
                {
                    if (([vo.name characterAtIndex:i] > 47 && [vo.name characterAtIndex:i] < 123)||[vo.name characterAtIndex:i] == 42) {
                        result = [NSString stringWithFormat:@"%@%c",result,[vo.name characterAtIndex:i]];
                    } else {
                        result = [NSString stringWithFormat:@"%@%c",result,pinyinFirstLetter([vo.name characterAtIndex:i])];
                    }
                }
                vo.pinyin = result;
            }
        }
        self->_codeTable = [NSDictionary dictionaryWithDictionary:dic];
        NSLog(@"读完了");
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat: @"yyyyMMdd"];
//        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//        NSString * stampStr = [dateFormatter stringFromDate:[NSDate date]];
//        [[NSUserDefaults standardUserDefaults] setObject:stampStr forKey:@"stamp"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SKCodeTable instance] saveCodeTableToLocal];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loadCodeTableSuccess"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
        
        if (@available(iOS 9.0, *)) {
            [[SKCodeTable instance] createSearchableContent];
        }
    });
    
    // 远程加载股票关系表
    //    SKCodeTableDelegate *delegate = [[SKCodeTableDelegate alloc] init];
    //    [delegate getBlockStockMapWithTarget:self resultHandler:@selector(loadBlockStockMapResultHandler:) failHandler:@selector(loadBlockStockMapFailHandler:)];
}



- (void)loadCodeTableFailHandler:(id)data
{
    
}

/// 是否需要重新加载代码表
- (BOOL)needReloadCodeTableFromRemote
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    int lastLoadDate = [[userDefaults valueForKey:KEY_CODE_TABLE_UPDATE_DATE] intValue];
//    int today = [[[NSDate alloc] init] yyyyMMddFormat];
//    if ( today > lastLoadDate ) {
//        return YES;
//    }
//    return NO;
    return YES;
}

#pragma mark -
#pragma mark 单例方法

static SKCodeTable *_instance;
+ (SKCodeTable *)instance
{
    if (!_instance) {
        _instance = [[SKCodeTable alloc] init];
    }
    return _instance;
}

- (void)createSearchableContent {
    NSMutableArray *searchableItems = [NSMutableArray array];
    NSDictionary *codeTable = [SKCodeTable instance]->_codeTable;
    
    NSArray *keys = codeTable.allKeys;
    NSArray *stockItems = [codeTable objectsForKeys:keys notFoundMarker:@"found stockitem fail"];
    
    for (SKCodeItemVO *stockItem in stockItems) {
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:(NSString *)kUTTypeText];
        attributeSet.title = stockItem.name;
        attributeSet.contentDescription = stockItem.code;
        
        NSMutableArray *keywords = [NSMutableArray array];
        [keywords addObject:stockItem.code];
        [keywords addObject:stockItem.name];
        attributeSet.keywords = keywords;
        
        CSSearchableItem *searchItem = [[CSSearchableItem alloc]initWithUniqueIdentifier:[NSString stringWithFormat:@"com_rxhui_stockContest_%@_%@",stockItem.symbol,stockItem.name] domainIdentifier:@"stocks" attributeSet:attributeSet];
        [searchableItems addObject:searchItem];
    }
    
    [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

@end
