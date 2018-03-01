//
//  STKRequestQueue.h
//  iphone-stock
//
//  Created by ztian on 14-3-7.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "STKRequestContext.h"

@interface STKRequestQueue : NSObject


/**
 *	@brief	出列
 *
 *	@return	队列中第一个元素
 */
- (STKRequestContext *)deQueue;


/**
 *	@brief	入列
 *
 *	@param 	request 	请求
 *
 *  @see    STKRequestContext
 */
- (void)enQueue:(STKRequestContext *)request;


/**
 *	@brief	存储请求id对应的请求
 *
 *	@param 	context     请求id对应的请求对象
 *	@param 	rid         请求id
 */
- (void)setContext:(STKRequestContext *)context byId:(int)rid;


/**
 *	@brief	返回请求id对应的请求对象
 *
 *	@param 	rid 	请求id
 *
 *	@return	请求id对应的请求对象
 */
- (STKRequestContext *)getContextById:(int)rid;


/**
 *	@brief	移除请求id对应的请求对象
 *
 *	@param 	rid 	请求id
 */
- (void)removeContextById:(int)rid;



@end
