//
//  STKRequest.m
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKData.h"
#import "STKUtils.h"

@implementation STKData

- (id)initWithRequestType:(UInt16)requestType params:(NSData *)params
{
    self = [super init];
    if (self) {
        self.type = requestType;
        self.rid = [STKData generateRequestId];
        self.params = [params mutableCopy];
        self.dataLength = params.length;
    }
    return self;
}


// 获取解析好的数据包
- (NSData *)getReqeustBytes
{
    NSData *dataHead = [STKUtils getDataHeadWithRequestType:self.type dataLen:(uint)self.params.length requestId:self.rid];
    NSMutableData *requestData = [[NSMutableData alloc] init];
    [requestData appendData:dataHead];
    [requestData appendData:self.params];
    return requestData;
}

// 从数据包解析数据
- (id)initFromData:(NSData *)dataPart
{
    self = [super init];
    if (self) {
        self.type = [dataPart readShort];
        self.dataLength = [dataPart readInt];
        self.rid = [dataPart readShort];
        [dataPart readShort];
        self.params = [[dataPart subdataWithRange:NSMakeRange(STK_DATA_HEAD_LEN, dataPart.length - STK_DATA_HEAD_LEN)] mutableCopy];
    }
    return self;
}


static UInt16 _requestId ;
+ (UInt16)generateRequestId
{
//    NSLog(@"第%d次请求",_requestId);
    return ++_requestId;
}
@end
