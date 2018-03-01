//
//  CertFileUtil.h
//  crh-sjkh
//
//  Created by milo on 14-4-10.
//  Copyright (c) 2014年 com.cairh. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@interface CertFileUtil : NSObject

/**
 * 获得documents下的/cert目录，如果已经存在则返回，如果没有则先创建再返回。
 *
 */
+ (NSString*) getCertFileDir;
/**
 * 保存用户pass到文件中，文件名为SN编码。此文件也可以用来判断用户本地是否有证书，因为此文件是在保存证书的时候同时保存的。
 *
 */
+ (BOOL) saveSnPassFile:(NSString *)sn pass:(NSString *) pass;
/**
 * 从sn文件中读取pass
 *
 */
+ (NSString *) readSnPassFile:(NSString *) sn;


/***
 * 通过文件path，文件内容 写文件
 *
 */
+ (void) writeFileWithNSStrng:(NSString *)filePath fileContent:(NSString *) content;

/***
 * 通过文件path，文件内容 写文件
 *
 */
+ (void) writeFileWithNSData:(NSString *)filePath fileContent:(NSData *) Filedata;

@end
