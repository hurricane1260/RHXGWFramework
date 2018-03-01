//
//  TradeListsController.h
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//  明细

@protocol TradeListsDelegate <NSObject>

- (void)navigationToDealDetailListWithTitle:(NSString *)titleString;

- (void)navigationToFAQControllerWithTabNum:(NSInteger)tabNum;

@end

@interface TradeListsController : BaseViewController

@property (nonatomic, weak) id <TradeListsDelegate> delegate;

@property (nonatomic, assign) TradeControllerType viewType;

@end
