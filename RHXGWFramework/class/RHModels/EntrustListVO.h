//
//  EntrustListVO.h
//  stockscontest
//
//  Created by rxhui on 15/6/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntrustListVO : NSObject

@property (nonatomic, copy) NSString *stockName;

/**
 *  委托方向,1买入,2卖出
 */
@property (nonatomic, copy) NSString *entrustBs;

@property (nonatomic, strong) NSNumber *entrustDateTime;//entrustTime

@property (nonatomic, strong) NSNumber *entrustPrice;

/**
 *  成交价
 */
@property (nonatomic, strong) NSNumber *businessPrice;

@property (nonatomic, strong) NSNumber *entrustAmount;

/**
 *  成交数量
 */
@property (nonatomic, strong) NSNumber *businessAmount;

/**
 *  委托状态：
 *  "0"未报,"1"待报,"2"已报,"7"部成,"C"正报（港股），是可以加到列表中的
 */
@property (nonatomic, copy) NSString *entrustStatus;

//定位串，翻页用
@property (nonatomic, copy) NSString *positionStr;

/**
 *  交易类型，撤单操作时需要传此参数
 */
@property (nonatomic, copy) NSString *exchangeType;

/**
 *  撤单编号，撤单操作时需要传此参数
 */
@property (nonatomic, strong) NSNumber *entrustNo;

@property (nonatomic, copy) NSString *entrustProp;

@property (nonatomic, assign) BOOL showWithdrawButton;

+ (void)changeStatusStringWithItem:(EntrustListVO *)item;

- (NSComparisonResult)compare:(EntrustListVO *)otherVO;

+ (NSArray *)parseSimulateEntrustListWithData:(id)resultData;

@end
