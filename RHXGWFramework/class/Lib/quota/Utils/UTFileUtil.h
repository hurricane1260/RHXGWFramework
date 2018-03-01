//
//  UTFileUtil.h
//  iphone-stock
//
//  Created by yguo on 14-3-10.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTFileUtil : NSObject
// 返回应用程序沙盒 Documents绝对路径
+ (NSString *) documentPath;
// 返回应用程序沙盒 Documents目录下的某个文件的路径
+ (NSString *) pathInDocumentDirectory:(NSString *)fileName;
@end
