//
//  TradeItemizeListView.h
//  stockscontest
//
//  Created by rxhui on 15/9/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  明细

#import <UIKit/UIKit.h>

@protocol TradeItemizeListViewDelegate <NSObject>

- (void)navigationToDealDetailListWithTitle:(NSString *)titleString;

- (void)navigationToFAQControllerWithTabNum:(NSInteger)tabNum;

@end

@interface TradeItemizeListView : UIView

@property (nonatomic, weak) id <TradeItemizeListViewDelegate> delegate;

@end
