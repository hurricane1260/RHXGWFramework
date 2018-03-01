//
//  UIView+CurrentController.h
//  stockscontest
//
//  Created by liyan on 16/7/8.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CurrentController)

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController;

//获取Window当前显示的ViewController
+(UIViewController *)getTopViewController;

@end
