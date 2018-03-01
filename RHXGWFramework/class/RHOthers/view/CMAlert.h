//
//  CMAlert.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-13.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  弹出提示框
//

#import <Foundation/Foundation.h>

//static const NSTimeInterval kAlertTimerInterval = 1.5f;
static const CGFloat kModalAlpha = 1.0f;
static const CGFloat kAlertFontSize = 15.0f;
static const CGFloat kAlertButtonFontSize = 18.0f;
static const CGFloat kAlertMargin = 10.0f;
static const CGFloat kAlertMaxWidth = 200.0f;
static const CGFloat kAlertMinHeight = 129.0f;

@protocol CMAlertDelegate <NSObject>

@optional
/**
 *  @brief 点击弹出框的取消按钮触发事件
 */
-(void)cancleButtonTouchHandler;

@required
/**
 *  @brief 点击弹出框的确认按钮触发事件
 */
-(void)comitButtonTouchHandler;

@end

@interface CMAlert : NSObject <CMAlertDelegate>

@property (nonatomic, weak) id <CMAlertDelegate> delegate;

/**
 *  @brief 不带标题的弹出提示框，默认提供一个确认按钮
 *  @superView 弹出框将要放置的父视图，如果为nil，则默认放置在window上
 */
+(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate;

/**
 *  @brief 带标题的弹出提示框，默认提供一个确认按钮
 *  @param title 标题
 *  @param message 详细信息
 *  @param superView 弹出框将要放置的父视图，如果为nil，则默认放置在window上
 *  @param titles 按钮的标题列表
 *  @param delegate 确认按钮的代理
 */
+(void)show:(NSString *)title message:(NSString *)message superView:(UIView *)superView buttonTitleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate;

/**
 *  @brief 带标题的弹出提示框，默认提供一个确认按钮
 *  @param message 详细信息
 *  @param sView 弹出框将要放置的父视图，如果为nil，则默认放置在window上
 *  @param titles 按钮的标题列表
 *  @param delegate 确认按钮的代理
 *  @param hidden 点击按钮后是否隐藏
 */
+(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate andHidden:(BOOL)hidden;

/**
 *  弹出提示框
 *  @param sCompleteCallback 显示完毕回调方法
 *  @param hCompleteCallback 隐藏完毕回调方法
 */
//+(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles showCompletion:(void (^)(void))sCompleteCallback hiddenCompletion:(void (^)(void))hCompleteCallback;

/**
 *  按照提供的持续时间显示提示框
 */
//+(void)show:(NSString *)message superView:(UIView *)sView duration:(NSTimeInterval)aDuration;

@end


@interface CMAlertView : UIView

/*! @brief 代理，传递点击事件 */
@property (nonatomic, weak) id <CMAlertDelegate> delegate;

/*! @brief 需要显示的消息标题 */
@property (nonatomic, strong) NSString *title;

/*! @brief 需要显示的消息 */
@property (nonatomic, strong) NSString *message;

/*! @brief 按钮标题数组 */
@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, readonly ,assign) CGFloat measureHeight;

@end
