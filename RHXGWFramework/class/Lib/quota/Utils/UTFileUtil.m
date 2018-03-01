//
//  UTFileUtil.m
//  iphone-stock
//
//  Created by yguo on 14-3-10.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "UTFileUtil.h"

@implementation UTFileUtil

+ (NSString *) documentPath
{
    NSArray *_docuemntPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_docuemntPaths objectAtIndex:0];
    return _documentPath;
}

+ (NSString *) pathInDocumentDirectory:(NSString *)aFileName
{
    return [[UTFileUtil documentPath] stringByAppendingPathComponent:aFileName];
}
@end
