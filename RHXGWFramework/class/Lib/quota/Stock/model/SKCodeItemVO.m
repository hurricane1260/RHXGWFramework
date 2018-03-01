//
//  SKCodeItemVO.m
//  iphone-stock
//
//  Created by ztian on 14-3-6.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKCodeItemVO.h"

@implementation SKCodeItemVO

@synthesize name = _name;

- (id)initWithNSString:(NSString *)value
{
    self = [super init];
    if (self) {
        self.level = 1;
        NSArray *values = [value componentsSeparatedByString:@","];
        if ( values.count >= 4 ) {
            self.flag = [values objectAtIndex:0];
            self.code = [values objectAtIndex:1];
            self.name = [values objectAtIndex:2];
            self.prefix = [values objectAtIndex:3];
            self.prefix = ([self.prefix isEqualToString:@"zxb"] || [self.prefix isEqualToString:@"cyb"]) ? @"sza" : self.prefix;
            self.pinyin = [values objectAtIndex:4];
        }
    }
    return self;
}

//- (NSString *)name
//{
//    // 申万行业名称，特殊处理
//    if ([@"sw" isEqualToString:self.prefix]) {
//        switch (self.level) {
//            case 1:
//                return [NSString stringWithFormat:@"%@Ⅰ",_name];
//                break;
//            case 2:
//                return [NSString stringWithFormat:@"%@Ⅱ",_name];
//                break;
//            case 3:
//                return [NSString stringWithFormat:@"%@Ⅲ",_name];
//                break;
//            default:
//                return _name;
//                break;
//        }
//    }
//    return _name;
//}

- (void)setName:(NSString *)aName
{
    _name = aName;
}

- (NSString *)symbol
{
    return [NSString stringWithFormat:@"%@_%@",self.prefix,self.code];
}

- (void)setSymbol:(NSString *)symbol
{
    NSRange range = [symbol rangeOfString:@"_"];
    if ( range.length > 0 ) {
        self.prefix = [symbol substringWithRange:NSMakeRange(0, range.location)];
        self.code = [symbol substringFromIndex:range.location + range.length];
    }
}

- (NSString *)type
{
    return [SKUtils getTypeByPrefix:self.prefix code:self.code];
}

- (BOOL)isIndex
{
    return [SKUtils isIndexBySymbol:self.symbol];
}
- (BOOL)isBlock;
{
    return [SKUtils isBlockBySymbol:self.symbol];
}
- (BOOL)isStock
{
    return [SKUtils isStockBySymbol:self.symbol];
}

- (BOOL)isAStock
{
    return [SKUtils isAStockBySymbol:self.symbol];
}

- (BOOL)isBStock
{
    return [SKUtils isBlockBySymbol:self.symbol];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.prefix = [aDecoder decodeObjectForKey:@"prefix"];
        self.pinyin = [aDecoder decodeObjectForKey:@"pinyin"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.level = [aDecoder decodeIntForKey:@"level"];
        self.subItems = [aDecoder decodeObjectForKey:@"subItems"];
        self.supItems = [aDecoder decodeObjectForKey:@"supItems"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aEncoder
{
    [aEncoder encodeObject:self.code    forKey:@"code"];
    [aEncoder encodeObject:self.prefix forKey:@"prefix"];
    [aEncoder encodeObject:self.pinyin forKey:@"pinyin"];
    [aEncoder encodeObject:self.name forKey:@"name"];
    [aEncoder encodeInt:self.level forKey:@"level"];
    [aEncoder encodeObject:self.subItems forKey:@"subItems"];
    [aEncoder encodeObject:self.supItems forKey:@"supItems"];
}


@end
