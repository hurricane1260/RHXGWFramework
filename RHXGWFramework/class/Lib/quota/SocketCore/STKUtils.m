
//  STKUtils.m
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 rxhui. All rights reserved.
//

#import "STKUtils.h"



@implementation STKUtils

static UInt16 _timeNo;

// 创建包头
+ (NSData *)getHead:(int)len
{
    NSMutableData *head = [[NSMutableData alloc] init];
    [head appendStringWithOut0:STK_HEAD_NAME];
    [head appendInt:len];
    [head appendByte:STK_VERION];
    [head appendShort:_timeNo++];
    return head;
}

// 创建包尾
+ (NSData *)getTail:(int)len
{
    NSMutableData *tail = [[NSMutableData alloc] init];
    [tail appendStringWithOut0:[STK_HEAD_NAME uppercaseString]];
    [tail appendInt:len];
    return tail;
}

// 创建数据头
+ (NSData *)getDataHeadWithRequestType:(UInt16)dataType dataLen:(uint)len requestId:(UInt16)dataId
{
    NSMutableData *dataHead = [[NSMutableData alloc] init];
    [dataHead appendShort:dataType];
    [dataHead appendInt:len];
    [dataHead appendShort:dataId];
    [dataHead appendShort:0];
    return dataHead;
}

+ (NSData *)getPackageWithNSData:(NSData *)requestData
{
    NSData *head = [self getHead:(int)(requestData.length)];
    NSData *tail = [self getTail:(int)(requestData.length)];
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:head];
    [data appendData:requestData];
    [data appendData:tail];
    return data;
}


// 创建请求的数据包
+ (NSData *)getRequestDataWithSTKRequest:(STKData *)request
{
    NSData *dataHead = [self getDataHeadWithRequestType:request.type dataLen:(uint)request.dataLength requestId:request.rid];
    NSData *head = [self getHead:(int)(STK_DATA_HEAD_LEN + request.dataLength)];
    NSData *tail = [self getTail:(int)(STK_DATA_HEAD_LEN + request.dataLength)];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendData:head];
    [data appendData:dataHead];
    [data appendData:request.params];
    [data appendData:tail];
    return data;
}

@end
