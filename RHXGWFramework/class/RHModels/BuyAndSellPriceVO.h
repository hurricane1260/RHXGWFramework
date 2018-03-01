//
//  BuyAndSellPriceVO.h
//  stockscontest
//
//  Created by rxhui on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyAndSellPriceVO : NSObject

@property (nonatomic,copy) NSString *buyerOrSalor;

@property (nonatomic,copy) NSString *price;

@property (nonatomic,copy) NSString *amount;

@property (nonatomic,copy) NSString *openPrice;//开盘时的市价，用来对比涨跌

@end
