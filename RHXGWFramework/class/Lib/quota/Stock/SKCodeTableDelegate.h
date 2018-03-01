//
//  SKCodeTableDelegate.h
//  iphone-stock
//
//  Created by ztian on 14-3-6.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "SKBaseDelegate.h"
#import "SKCodeItemVO.h"
#import "SKCodeTable.h"

/// 代码表
#define DEF_getCodeTable_RQ (DEF_STKDATA_BASE + 65)
#define DEF_DiffCodeTable_RQ (DEF_STKDATA_BASE + 79)
/// 板块成分表
#define DEF_BLOCK2_RQ (DEF_STKDATA_BASE + 43)

/// 封装代码表和股票关系表请求
@interface SKCodeTableDelegate : SKBaseDelegate

/**
 *	@brief	远程请求代码表
 *
 *	@param 	target  目标
 *	@param 	resultHandler 	回调函数，参数为NSArray，数组元素为SKCodeItemVO
 *	@param 	failHandler     失败回调
 *
 *	@return	请求id
 */
- (int)getCodeTableWithTarget:(id)target stamp:(NSString *)stam resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler;

/**
 *	@brief	远程请求股票关系表
 *
 *	@param 	target  目标
 *	@param 	resultHandler   回调函数，参数为
 *	@param 	failHandler     失败回调
 *
 *	@return	请求id
 */
- (int)getBlockStockMapWithTarget:(id)target resultHandler:(SEL)resultHandler failHandler:(SEL)failHandler;



@end
