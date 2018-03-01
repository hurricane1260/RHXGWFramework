//
//  SKUtils.m
//  iphone-stock
//
//  Created by ztian on 14-3-3.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKUtils.h"

@implementation SKUtils

+ (NSString *)fixSymbol:(NSString *)symbol
{
    NSRange range = [symbol rangeOfString:@"_"];
    if ( range.length > 0 ) {
        return symbol;
    }
    NSString *type;
    if ( [symbol hasPrefix:@"600"] || [symbol hasPrefix:@"601"] || [symbol hasPrefix:@"603"] ) {
        type = STOCK_TYPE_SHA;
    }
    else if([symbol hasPrefix:@"999"] )
    {
        type = STOCK_TYPE_HC;
    }
    else if([symbol hasPrefix:@"000"] || [symbol hasPrefix:@"002"] || [symbol hasPrefix:@"300"] ||[symbol hasPrefix:@"399"]){
        type = STOCK_TYPE_SZA;
    }
    else if([symbol hasPrefix:@"00"] || [symbol hasPrefix:@"30"])
    {
        type = STOCK_TYPE_SHA;
    }
    return [NSString stringWithFormat:@"%@_%@",type,symbol];
}

+ (NSString *)getTypeBySymbol:(NSString *)symbol
{
    NSArray *array = [symbol componentsSeparatedByString:@"_"];
    if ( array.count == 2 ) {
        NSString *prefix = [array objectAtIndex:0];
        NSString *code = [array objectAtIndex:1];
        return [self getTypeByPrefix:prefix code:code];
    }
    return TYPE_UNUSED;
}
+ (NSString *)getCodeBySymbol:(NSString *)symbol
{
    NSString *result;
    if(symbol != nil)
    {
        NSArray *list = [symbol componentsSeparatedByString:@"_"];
        NSInteger myIndex = list.count-1;
        result = [list objectAtIndex:myIndex];
    }
    return result;
}

+ (NSString *)getTypeByPrefix:(NSString *)prefix code:(NSString *)code{
    if ( [code hasPrefix:@"00"] && [prefix isEqualToString:@"sha"]) {
        return TYPE_INDEX_SHA;
    }else if ([code hasPrefix:@"399"] && [prefix isEqualToString:@"sza"]){
        return TYPE_INDEX_SZA;
    }else if ([code hasPrefix:@"60"] && [prefix isEqualToString:@"sha"]){
        return TYPE_STOCK_SHA;
    }else if ( ([code hasPrefix:@"00"] || [code hasPrefix:@"30"]) && ([prefix isEqualToString:@"sza"] || [prefix isEqualToString:@"zxb"] || [prefix isEqualToString:@"cyb"]) ){
        return TYPE_STOCK_SZA;
    }else if ([prefix isEqualToString:@"sw"] ){
        return TYPE_BLOCK_SW;
    }else if ( [code hasPrefix:@"9999"] && [prefix isEqualToString:@"hc"]){
        return TYPE_BLOCK_DY;
    }else if( ([code hasPrefix:@"9991"] || [code hasPrefix:@"9990"]) && [prefix isEqualToString:@"hc"] ){
        return TYPE_BLOCK_GN;
    }else if( [code hasPrefix:@"90"] && [prefix isEqualToString:@"shb"]){
        return TYPE_STOCK_SHB;
    }else if( [code hasPrefix:@"20"] && [prefix isEqualToString:@"szb"]){
        return TYPE_STOCK_SZB;
    }
    return 0;
}


+ (BOOL)isIndexBySymbol:(NSString *)symbol
{
    NSString *type = [self getTypeBySymbol:symbol];
    return [type rangeOfString:@"index"].length > 0;
}
+ (BOOL)isBlockBySymbol:(NSString *)symbol;
{
    NSString *type = [self getTypeBySymbol:symbol];
    return [type rangeOfString:@"block"].length > 0;
}
+ (BOOL)isStockBySymbol:(NSString *)symbol
{
    NSString *type = [self getTypeBySymbol:symbol];
    return [type rangeOfString:@"stock"].length > 0;
}
+ (BOOL)isAStockBySymbol:(NSString *)symbol
{
    NSString *type = [self getTypeBySymbol:symbol];
    return [type isEqualToString:TYPE_STOCK_SHA] || [type isEqualToString:TYPE_STOCK_SZA];
}
+ (BOOL)isBStockBySymbol:(NSString *)symbol
{
    NSString *type = [self getTypeBySymbol:symbol];
    return [type isEqualToString:TYPE_STOCK_SHB] || [type isEqualToString:TYPE_STOCK_SZB];
}

@end
