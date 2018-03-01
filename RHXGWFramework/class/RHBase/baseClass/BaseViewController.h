//
//  BaseViewController.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  基类Controller
//  该基类设置默认的导航栏返回按钮，用户可以使用接口自行设置导航栏返回按钮和右侧按钮
//  该基类提供默认的键盘控制，在有键盘出现的时候，在键盘外点击，可使键盘消失
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
//     UIView *_navigationBar;
}
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIView * navigationBar;
/**
 *  设置导航栏是否隐藏
 */
@property (nonatomic, assign) BOOL navigationBarHidden;

/**
 *  当行栏颜色
 */
@property (nonatomic, strong) UIColor *navigationBarColor;

/**
 *  布局起始Y坐标，因为是自己定义的导航栏，没有使用naviagtionBar
 */
@property (nonatomic, readonly) CGFloat layoutStartY;

/**
 *  设置隐藏返回按钮
 */
@property (nonatomic, assign) BOOL backButtonHidden;

/**
 *  右侧按钮
 */
@property (nonatomic, strong) UIView *rightButtonView;

/**
 *  左侧按钮
 */
@property (nonatomic, strong) UIView *leftButtonView;

/**
 *  记录当前栈的controller数量
 */
@property (nonatomic, assign) NSNumber *curentStackCount;

/**
 *  是否是push进栈里
 */
@property (nonatomic, assign) BOOL isPushView;

/**
 *  是否有网
 */
@property (nonatomic, assign) BOOL isNetWorkReachable;

/**
 *  准备传入的参数
 */
@property (nonatomic, strong) id universalParam;

/**
 *  返回按钮点击动作，子类可以覆盖该方法，实现自己的动作逻辑
 */
-(void)backButtonTouchHandler:(id)sender;


@end
