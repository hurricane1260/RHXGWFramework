//
//  NSData+RHJX_Inc_.h
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RHJX_Inc_)

- (int)readInt;

- (short)readShort;

- (float)readFloat;

- (NSString *)readString;

- (NSString *)readStringByLength:(int)length;

- (uint)getCursor;

- (int)readCompressedInt;

- (float)readCompressedFloat;

- (float)readCompressedFloatWithRatio:(int)ratio;

/**
 *	@brief	连续读取count个压缩整数
 *
 */
- (void)readMultiCompressedInt:(int)count;


/**
 *	@brief	连续读取count个非压缩证书
 *
 */
- (void)readMultiInt:(int)count;


@property (nonatomic, retain) NSNumber *cursor;

@property (nonatomic,readonly) uint bytesAvailable;


@end
