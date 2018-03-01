//
//  RHTabBar.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/1/3.
//
//

#import <UIKit/UIKit.h>

@class RHTabBar;

@protocol RHTabBarDelegate <NSObject>

- (void)tabBar:(RHTabBar *)tabBar selectedFrom:(NSInteger)former to:(NSInteger)to;

@end

@interface RHTabBar : UIView

@property(nonatomic,weak) id<RHTabBarDelegate> delegate;

- (void)buildTabBarItemWithTitle:(NSString *)title withNorImg:(UIImage *)norImg withSelectImg:(UIImage *)selectedImg;

- (void)changeTabBarItemWithIndex:(NSInteger)index WithTitle:(NSString *)title withNorImg:(UIImage *)norImg withSelectImg:(UIImage *)selectedImg;

- (void)setSelectBtn:(NSInteger)index;
@end
