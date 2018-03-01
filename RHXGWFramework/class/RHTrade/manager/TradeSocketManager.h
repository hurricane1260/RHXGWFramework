//
//  TradeSocketManager.h
//  stockscontest
//
//  Created by rxhui on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TradeSocketManagerDelegate <NSObject>

- (void)getStockMarketPriceSuccess:(id)resultData;

- (void)getStockMarketPriceFail;

- (void)getStockRealtimePriceSuccess:(id)resultData;

- (void)getStockRealtimePriceFail;

@end

@interface TradeSocketManager : NSObject

@property (nonatomic, weak) id <TradeSocketManagerDelegate> delegate;

/**
 *  根据股票代码查询五档详情
 *
 *  @param param 股票代码、exchangeType
 *   object 请求返回后，会做出反应的对象
 *   successHandler 请求成功后，该对象执行的方法
 *   failHandler 请求失败后，该对象执行的方法
 */
-(void)requestStockMarketPriceWithParam:(NSDictionary *)param;

/**
 *  根据股票代码订阅，自动推送
 *
 *  @param param 股票代码、exchangeType
 *   object 请求返回后，会做出反应的对象
 *   successHandler 请求成功后，该对象执行的方法
 *   failHandler 请求失败后，该对象执行的方法
 */
-(void)requestStockRealtimePriceWithParam:(NSDictionary *)param;

/**
 *  取消订阅
 *
 *  @param param 入参，股票代码、exchangeType
 */
- (void)cancelStockMarketPriceWithParam:(NSDictionary *)param;


@end
