//
//  CQCXItemVO.m
//  iphone-stock
//
//  Created by ztian on 14-3-7.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "CQCXSymbolVO.h"

@implementation CQCXItemVO

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.day = [data readInt];
        self.sg = [data readCompressedFloatWithRatio:10000];
        self.zzg = [data readCompressedFloatWithRatio:10000];
        self.px = [data readCompressedFloatWithRatio:10000];
        self.pg = [data readCompressedFloatWithRatio:10000];
        self.pgj = [data readCompressedFloatWithRatio:10000];
    }
    return self;
}

@end

@implementation CQCXSymbolVO

- (id)initWithNSData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.symbol = [data readString];
        [data readMultiCompressedInt:3];
        int count = [data readCompressedInt];
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        
        float fWLHFQXS = 1;
        float fWLHFQCS = 0;
        
        CQCXItemVO *item = [[CQCXItemVO alloc] init];
        item.day = 0;
        item.sg = 0;
        item.zzg = 0;
        item.px = 0;
        item.pg = 0;
        item.pgj = 0;
        item.wlqfqcs = 0;
        item.wlqfqxs = 1;
        item.wlhfqcs = 0;
        item.wlhfqxs = 1;
        [tempList addObject:item];
        
        for( int i = 0 ; i < count ; i++ )
        {
            CQCXItemVO *item = [[CQCXItemVO alloc] initWithNSData:data];
            float fKG = item.sg + item.zzg + item.pg;//扩股
            float QFQXS = 10 / ( 10 + fKG);
            float QFQCS = (item.pgj*item.pg - item.px) * QFQXS * 100;
            
            for( int j = 0 ; j <= i; j++ )
            {
                CQCXItemVO *p1 = (CQCXItemVO *)tempList[j];
                p1.wlqfqcs *= QFQXS;
                p1.wlqfqxs *= QFQXS;
                p1.wlqfqcs += QFQCS;
            }
			
            float fHFQXS = (10 + fKG) / 10;
            float fHFQCS = (item.px - item.pgj*item.pg) * 100;
            fWLHFQXS *= fHFQXS;
            fWLHFQCS += fHFQCS * fWLHFQXS;
            item.wlhfqxs = fWLHFQXS;
            item.wlhfqcs = fWLHFQCS;
            item.wlqfqcs = 0;
            item.wlqfqxs = 1;
            
            [tempList addObject:item];
        }
        self.items = tempList;
    }
    return self;
}


@end
