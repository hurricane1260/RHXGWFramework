//
//  SKRankListVO.m
//  iphone-stock
//
//  Created by ztian on 14-2-27.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKRankListVO.h"
#import "SKRankItemVO.h"

@implementation SKRankListVO

- (id)initWithNSData:(NSData *)response
{
    self = [super init];
    if (self) {
        self.type = [response readString];
        [response readCompressedInt];
        [response readCompressedInt];
        self.start = [response readCompressedInt];
        int length = [response readCompressedInt];
        int pageCount = [response readCompressedInt];
        [response readCompressedInt];
        [response readCompressedInt];
        [response readCompressedInt];
        int count = [response readCompressedInt];
        self.currentPage = self.start/length;
        self.totalCount = length;
        self.totalPage = pageCount;
        for (int i = 0 ; i < count ; i++) {
            [self addItem:[[SKRankItemVO alloc] initWithNSData:response]];
        }
    }
    return self;
    
}




@end
