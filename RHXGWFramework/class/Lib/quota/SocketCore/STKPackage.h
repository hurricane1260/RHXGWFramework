//
//  STKPackage.h
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STKUtils.h"

@interface STKPackage : NSObject

- (id)initWithNSData:(NSData *)data;

- (id)initWithDataPart:(NSData *)data;

@property (nonatomic,assign) NSInteger dataLength;

@property (nonatomic,retain) NSMutableData *data;

@property (nonatomic,assign) BOOL isDataReceiveComplete;

- (void)appendData:(NSData *)data;

- (NSData *)getBytes;


@end
