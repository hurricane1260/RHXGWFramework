//
//  UIScrollView+PullRefresh.h
//  iphone-pay
//
//  Created by 方海龙 on 13-11-17.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPullRefreshView.h"

@interface UIScrollView (PullRefresh)

//刷新组件
@property(nonatomic, retain) CMPullRefreshView *refreshView;

-(void)addPullRefreshView;

-(void)stopRefresh;

-(void)removePullRefreshView;

@end
