//
//  CMTabBar.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTabBar, CMTabBarItem;

@protocol CMTabBarDelegate <NSObject>

- (BOOL)tabBar:(CMTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

- (void)tabBar:(CMTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface CMTabBar : UIView

@property (nonatomic, weak) id <CMTabBarDelegate> delegate;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, weak) CMTabBarItem *selectedItem;

@property (nonatomic, readonly) UIView *backgroundView;

@property UIEdgeInsets contentEdgeInsets;

- (void)setHeight:(CGFloat)height;

- (CGFloat)minimumContentHeight;

@property (nonatomic, getter=isTranslucent) BOOL translucent;


@end
