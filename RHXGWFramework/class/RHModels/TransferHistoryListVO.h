//
//  TransferHistoryListVO.h
//  stockscontest
//
//  Created by rxhui on 15/7/29.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferHistoryListVO : NSObject


/**
 *  日期
 */
@property (nonatomic, copy) NSString *entrustDate;

/**
 *  委托时间
 */
@property (nonatomic, copy) NSString *entrustTime;

/**
 *  操作类型
 */
@property (nonatomic, copy) NSString *businessType;

/**
 *  发生金额
 */
@property (nonatomic, copy) NSString *occurBalance;

/**
 *  @brief 状态,0未报，1已报，2成功，P正报 3失败
 */
@property (nonatomic, copy) NSString *entrustStatus;

+(NSArray *)parseTransferHistoryListWithData:(id)resultData;

kRhPCopy NSString * bankErrorInfo;
@end
