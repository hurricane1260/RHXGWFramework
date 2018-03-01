//
//  StockListSocketManager.h
//  stockscontest
//
//  Created by rxhui on 15/8/14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StockListSocketDelegate <NSObject>

/**
 *  @brief 获得主动请求的股票详情
 *
 *  @param requestData 返回的数据，SKFiveReportVO类型
 */
-(void)getRequestStockData:(id)requestData;

@optional
/**
 *  @brief 获得推送的股票详情
 *
 *  @param reportData 返回的数据，SKFiveReportVO类型
 */
-(void)getStockReportData:(id)reportData;

@end

@interface StockListSocketManager : NSObject

@property (nonatomic, weak) id <StockListSocketDelegate> delegate;

/**
 *  根据股票代码查询五档详情
 *
 *  @param param 股票代码、exchangeType
 */
-(void)requestStockMarketPriceWithParam:(NSDictionary *)param;

/**
 *  根据股票代码订阅，自动推送
 *
 *  @param param sha_60xxxx
 */
-(void)requestStockRealtimePriceWithParam:(NSDictionary *)param;

/**
 *  取消订阅
 *
 *  @param param sha_60xxxx
 */
- (void)cancelStockMarketPriceWithParam:(NSDictionary *)param;

@end
