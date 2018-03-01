//
//  STKUtils.h
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 rxhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKData.h"

#define STK_HEAD_NAME @"stk"
#define STK_VERION 1
#define STK_DATA_HEAD_LEN 10
#define STK_HEAD_LEN 10
#define STK_TAIL_LEN 7

@interface STKUtils : NSObject

+ (NSData *)getRequestDataWithSTKRequest:(STKData *)request;

+ (NSData *)getPackageWithNSData:(NSData *)requestData;

+ (NSData *)getDataHeadWithRequestType:(UInt16)dataType dataLen:(uint)len requestId:(UInt16)dataId;

@end
