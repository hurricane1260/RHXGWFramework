//
//  NSMutableData+RHJX_Inc_.h
//  iphone-stock
//
//  Created by ztian on 14-2-25.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (RHJX_Inc_)

- (void)appendInt:(int)aInt;

- (void)appendStringWith0:(NSString *)aString;

- (void)appendShort:(short)aShort;

- (void)appendByte:(Byte)aByte;

- (void)appendWithLength:(uint)length;

- (void)appendStringWithOut0:(NSString *)aString;




@end
