//
//  CMTabBarItem.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-8.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMTabBarItem : UIControl

@property CGFloat itemHeight;

@property (nonatomic, copy) NSString *title;

@property (nonatomic) UIOffset titlePositionAdjustment;

@property (copy) NSDictionary *unselectedTitleAttributes;

@property (copy) NSDictionary *selectedTitleAttributes;

@property (nonatomic) UIOffset imagePositionAdjustment;

- (UIImage *)finishedSelectedImage;

- (UIImage *)finishedUnselectedImage;

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

- (UIImage *)backgroundSelectedImage;

- (UIImage *)backgroundUnselectedImage;

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

@property (nonatomic, copy) NSString *badgeValue;

@property (strong) UIImage *badgeBackgroundImage;

@property (strong) UIColor *badgeBackgroundColor;

@property (strong) UIColor *badgeTextColor;

@property (nonatomic) UIOffset badgePositionAdjustment;

@property (nonatomic, copy) UIFont *badgeTextFont;

@end
