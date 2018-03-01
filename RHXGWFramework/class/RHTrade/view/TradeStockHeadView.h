//
//  TradeStockHeadView.h
//  stockscontest
//
//  Created by rxhui on 15/9/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TradeStockHeadViewDelegte <NSObject>

- (void)navigationToTransferController;

@end


@interface TradeStockHeadView : UIView

@property (nonatomic, assign) TradeControllerType viewType;

@property (nonatomic, weak) id <TradeStockHeadViewDelegte> delegate;

@property (nonatomic, strong) NSDictionary *receivedData;

@property (nonatomic, strong) NSDecimalNumber *totalBenifit;

//- (void)changeViewForSimulate;

@end


