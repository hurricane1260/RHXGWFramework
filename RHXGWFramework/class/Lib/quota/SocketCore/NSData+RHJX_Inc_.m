
//  NSData+RHJX_Inc_.m
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "NSData+RHJX_Inc_.h"

#import <objc/runtime.h>

static const void *cursorKey = &cursorKey;

@implementation NSData (RHJX_Inc_)

@dynamic cursor;

- (NSNumber *)cursor {
    return objc_getAssociatedObject(self, cursorKey);
}

- (void)setCursor:(NSNumber *)aCursor
{
    objc_setAssociatedObject(self, cursorKey, aCursor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)readFloat
{
    float temp;
    [self getBytes:&temp range:NSMakeRange([self getCursor], 4 )];
    [self addCursorByInt:4];
    return temp;
}

- (int)readInt
{
    int temp;
    [self getBytes:&temp range:NSMakeRange([self getCursor], 4 )];
    [self addCursorByInt:4];
    return temp;
}

- (uint)getCursor
{
    return self.cursor.intValue;
}
- (void)addCursorByInt:(int)value
{
    self.cursor = [NSNumber numberWithInt:(self.cursor.intValue + value)];
}


- (short)readShort
{
    short temp;
    [self getBytes:&temp range:NSMakeRange([self getCursor], 2 )];
    [self addCursorByInt:2];
    return temp;
}

- (SignedByte)readByte
{
    SignedByte temp;
    [self getBytes:&temp range:NSMakeRange([self getCursor], 1)];
    [self addCursorByInt:1];
    return temp;
}

- (NSString *)readString
{
    uint start = [self getCursor];
    while ([self readByte]);
    uint end = [self getCursor];
    NSData *stringData = [self subdataWithRange:NSMakeRange(start, end - start - 1)];
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (NSString *)readStringByLength:(int)length;
{
    uint start = [self getCursor];
    NSData *stringData = [self subdataWithRange:NSMakeRange(start, length)];
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (int)readCompressedInt
{
    int first = [self readByte];
    int sign = first >= 0 ? 1 : -1;
    int len = (first >> 4) & 7 ;
    int value = first & 15;
    while ( len > 0 ) {
        int temp = [self readUByte];
        value = value << 8;
        value += temp;
        len--;
    }
    return value*sign;
}

- (float)readCompressedFloat
{
    return [self readCompressedFloatWithRatio:1000];
}

- (float)readCompressedFloatWithRatio:(int)ratio
{
    int first = [self readByte];
    int sign = first >= 0 ? 1 : -1;
    int len = (first >> 4) & 7 ;
    float value = first & 15;
    while (len > 0) {
        int temp = [self readUByte];
        value = value *256;
        value += temp;
        len--;
    }
    return value * sign / ratio;
}



- (int)readUByte
{
    int temp = [self readByte];
    if ( temp >= 0 ) {
        return temp;
    }
    return temp + 256;
}

- (uint)bytesAvailable
{
    return (unsigned int)(self.length - self.cursor.intValue);
}

- (void)readMultiCompressedInt:(int)count
{
    for (int i = 0 ; i < count ; i++) {
        [self readCompressedInt];
    }
}

- (void)readMultiInt:(int)count
{
    for (int i = 0 ; i < count ; i++) {
        [self readInt];
    }
}

@end
