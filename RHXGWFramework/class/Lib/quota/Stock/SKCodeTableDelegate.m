//
//  SKCodeTableDelegate.m
//  iphone-stock
//
//  Created by ztian on 14-3-6.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKCodeTableDelegate.h"
#import "zlib.h"

@implementation SKCodeTableDelegate

#pragma mark -
#pragma mark 代码表

- (int)getCodeTableWithTarget:(id)target stamp:(NSString *)stamp resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler;
{
    NSMutableData *param = [[NSMutableData alloc] init];
    
    [param appendInt:0];
//    [param appendInt:(int)[stamp integerValue]];
    [param appendInt:0];
    [param appendInt:0];
    
    STKCallbackInfo *getCodeTableCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:self resultHandler:@selector(getCodeTableResultHandler:) failHandler:@selector(getCodeTableFailHandler:) requestType:DEF_DiffCodeTable_RQ params:param];
    [self addCallbackInfo:getCodeTableCallback byRequestId:rid];
    return rid;
}

- (void)getCodeTableResultHandler:(STKData *)data
{
    NSData *response = data.params;
    //代码表版本
    int stamp = [response readCompressedInt];
    //预留
    [response readMultiCompressedInt:2];
    // 压缩前长度
    int length = [response readCompressedInt];
    // 压缩后长度
    int zlength = [response readCompressedInt];
    // 字节流当前位置
    int start = [response getCursor];
    // 压缩后的数据
    NSData *compressedData = [response subdataWithRange:NSMakeRange(start,zlength)];
    // 压缩前的数据
    NSData *uncompressedData = [self uncompressZippedData:compressedData];
    
    // 字节流转换成字符串,"\r\n"换行
    NSString *codetable = [uncompressedData readStringByLength:length];
    NSArray *codes = [codetable componentsSeparatedByString:@"\r\n"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:codes];
    if (tempArray.count > 0) {
        [tempArray removeLastObject];
    }
    codes = tempArray;
    NSMutableDictionary *codeItemDict = [[NSMutableDictionary alloc] init];
    for (NSString *codeItemStr in codes) {
        SKCodeItemVO *item = (SKCodeItemVO *)[[SKCodeItemVO alloc] initWithNSString:codeItemStr];
        if (![item.type isEqualToString:TYPE_UNUSED]) {
            [codeItemDict setObject:item forKey:item.symbol];
//            NSLog(@"%@%@%@",item.symbol,item.name,item.flag);
        }
    }
    NSLog(@"从服务器接收%ld条数据",(unsigned long)codes.count);
    STKCallbackInfo *callbackInfo = [self  getCallbackInfoByRequestId:data.rid];
    [callbackInfo performResultHandlerWithObject:codeItemDict];
}

- (void)getCodeTableFailHandler:(STKData *)data
{
    NSLog(@"从服务器获取股票增量数据失败");
}


#pragma mark -
#pragma mark  板块关系表

- (int)getBlockStockMapWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler
{
    NSMutableData *param = [[NSMutableData alloc] init];
    [param appendInt:0];
    
    
    STKCallbackInfo *getMapCallback = [[STKCallbackInfo alloc] initWithTarget:target resultHandler:resultHandler failHandler:failHandler];
    
    int rid = [self requestWithTarget:self resultHandler:@selector(getMapResultHandler:) failHandler:@selector(getMapFailHandler:) requestType:DEF_BLOCK2_RQ params:param];
    [self addCallbackInfo:getMapCallback byRequestId:rid];
    return rid;
}

- (void)getMapResultHandler:(STKData *)data
{
    NSData *response = [data params];
    STKCallbackInfo *callbackInfo = [self  getCallbackInfoByRequestId:data.rid];
    [callbackInfo performResultHandlerWithObject:response];
}


- (void)getMapFailHandler:(STKData *)data
{
    
}



#pragma mark -
#pragma mark 解压缩zlib
-(NSData *)uncompressZippedData:(NSData *)compressedData
{
    if ([compressedData length] == 0) return compressedData;
    unsigned long full_length = [compressedData length];
    unsigned long half_length = [compressedData length] / 2;
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = (unsigned int)[compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([decompressed length] - strm.total_out);
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}


@end
