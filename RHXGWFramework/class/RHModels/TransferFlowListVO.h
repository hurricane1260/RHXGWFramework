//
//  TransferFlowListVO.h
//  stockscontest
//
//  Created by rxhui on 15/7/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferFlowListVO : NSObject

/**
*  交易日期,initDate
*/
//@property (nonatomic, copy) NSString *date;

/**
 *  委托时间
 */
@property (nonatomic, copy) NSString *entrustTime;

/**
 *  操作类型
 */
@property (nonatomic, copy) NSString *transName;

/**
 *  发生金额
 */
@property (nonatomic, copy) NSString *occurBalance;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *remark;

/**
 *  @brief 状态,0未报，1已报，2成功，P正报
 */
@property (nonatomic, copy) NSString *entrustStatus;

+(NSArray *)parseTransferFlowListWithData:(id)resultData;

@end
