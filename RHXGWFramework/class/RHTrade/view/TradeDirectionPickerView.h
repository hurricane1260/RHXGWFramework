//
//  TradeDirectionPickerView.h
//  stockscontest
//
//  Created by rxhui on 15/7/16.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TradeDirectionPickerDelegate <NSObject>

-(void)didSelectItemWithTitle:(NSString *)titleString;

@end

@interface TradeDirectionPickerView : UIView

@property (nonatomic, weak) id <TradeDirectionPickerDelegate> delegate;

@property (nonatomic, strong) NSArray *titleList;

- (instancetype)initWithTitleList:(NSArray *)titleList;

@end
