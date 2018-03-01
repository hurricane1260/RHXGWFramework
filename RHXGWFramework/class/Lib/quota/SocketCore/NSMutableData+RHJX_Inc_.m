//
//  NSMutableData+RHJX_Inc_.m
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "NSMutableData+RHJX_Inc_.h"
#import <objc/runtime.h>


@implementation NSMutableData (RHJX_Inc_)


- (void)appendInt:(int)aInt
{
//    int temp = htonl(aInt);
    [self appendBytes:&aInt length:sizeof(aInt)];
}

- (void)appendStringWithOut0:(NSString *)aString
{
//    [self appendData:[aString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [[NSData alloc] initWithBytes:[aString UTF8String] length:[aString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:data];
}

- (void)appendStringWith0:(NSString *)aString
{
    [self appendStringWithOut0:aString];
    [self appendByte:0];
}

- (void)appendShort:(short)aShort
{
//    int temp = htons(aShort);
    [self appendBytes:&aShort length:sizeof(aShort)];
}


- (void)appendByte:(Byte)aByte{
    [self appendBytes:&aByte length:sizeof(aByte)];
}

- (void)appendWithLength:(uint)length
{
    [self appendBytes:malloc(length) length:length];
    //被创建出来的空间什么时候回收？？？？？？
}





@end
