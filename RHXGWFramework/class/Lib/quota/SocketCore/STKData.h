//
//  STKRequest.h
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKData : NSObject

@property (nonatomic,assign) UInt16 type;
@property (nonatomic,assign) UInt16 rid;
@property (nonatomic,assign) NSInteger dataLength;
@property (nonatomic,retain) NSMutableData *params;

- (id)initWithRequestType:(UInt16)requestType  params:(NSData *)params;

- (NSData *)getReqeustBytes;

- (id)initFromData:(NSData *)data;


@end
