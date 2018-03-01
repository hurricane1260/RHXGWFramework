//
//  STKPackage.m
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014�? RHJX Inc. All rights reserved.
//

#import "STKPackage.h"

@implementation STKPackage

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        self.isDataReceiveComplete = NO;
        data.cursor = [NSNumber numberWithInt:3];
        if (data.length >= data.cursor.intValue + 4) {
            self.dataLength = [data readInt];
        }
        if ( self.dataLength + STK_HEAD_LEN + STK_TAIL_LEN  <= data.length ) {
            self.isDataReceiveComplete = YES;
            self.data = [[data subdataWithRange:NSMakeRange(STK_HEAD_LEN, self.dataLength)] mutableCopy];
            data.cursor = [NSNumber numberWithLong:(self.dataLength + STK_HEAD_LEN + STK_TAIL_LEN)];
        }else{
            self.isDataReceiveComplete = NO;
            if (data.length > STK_HEAD_LEN) {
                if ((data.length - STK_HEAD_LEN) > self.dataLength) {
                    self.data = [[data subdataWithRange:NSMakeRange(STK_HEAD_LEN, self.dataLength)] mutableCopy];
                    data.cursor = [NSNumber numberWithLong:(self.dataLength + STK_HEAD_LEN)];
                } else {
                    self.data = [[data subdataWithRange:NSMakeRange(STK_HEAD_LEN, data.length - STK_HEAD_LEN)] mutableCopy];
                    data.cursor = [NSNumber numberWithInteger:(data.length)];
                }
            } else {
                data.cursor = [NSNumber numberWithInteger:(data.length)];
            }
        }
        
        if (self.data.length > self.dataLength) {
            NSLog(@"--------------error");
        }
    }
    return self;
}

- (id)initWithDataPart:(NSData *)dataPart;
{
    self = [super init];
    if (self) {
        self.data = [dataPart mutableCopy];
    }
    return self;
}

- (void)appendData:(NSData *)data
{
    NSInteger needLength = self.dataLength - self.data.length + STK_TAIL_LEN;
    
    if (needLength < STK_TAIL_LEN) {
//        NSLog(@"???�?�?appendData???range??�度为�??�?");
    }
    if (data.length >= needLength && needLength >= STK_TAIL_LEN) {
        // ??�度�?�????�??????�度
        [self.data appendData:[data subdataWithRange:NSMakeRange(0, needLength - STK_TAIL_LEN )]];
        data.cursor = [NSNumber numberWithInteger:needLength];
    }else{
        [self.data appendData:data];
        data.cursor = [NSNumber numberWithInteger:data.length];
    }
    
    if ( self.dataLength == self.data.length  ) {
        self.isDataReceiveComplete = YES;
    }
    
    if (self.data.length > self.dataLength) {
        NSLog(@"--------------error");
    }


}


// ??��?????�?�???��?��??
- (NSData *)getBytes;
{
    return [STKUtils getPackageWithNSData:self.data];
}

@end
