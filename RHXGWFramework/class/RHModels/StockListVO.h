//
//  StockListVO.h
//  stockscontest
//
//  Created by rxhui on 15/6/16.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockListVO : NSObject

@property (nonatomic, copy) NSString *stockName;

@property (nonatomic, copy) NSString *stockCode;

@property (nonatomic, strong) NSNumber *incomeBalance;

/**
 *  带颜色属性的字符串，直接赋值给label的attributedString
 */
@property (nonatomic, copy) NSAttributedString *incomeBalanceString;

@property (nonatomic, strong) NSNumber *lastPrice;

@property (nonatomic, strong) NSNumber *costPrice;

@property (nonatomic, strong) NSNumber *currentAmount;

//显示在“最大可卖”的数量
@property (nonatomic, strong) NSNumber *enableAmount;

@property (nonatomic, strong) NSNumber *marketValue;

@property (strong, nonatomic) NSString *positionStr;

@property (nonatomic, copy) NSString *exchangeType;

+ (StockListVO *)parseVOFromData:(id)data;

+ (NSMutableArray *)parseSimulateHoldStockFromData:(id)data;

@end
