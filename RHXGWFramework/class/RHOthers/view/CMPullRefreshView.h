//
//  CMPullRefreshView.h
//  iphone-pay
//
//  Created by 方海龙 on 13-11-17.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PullRefreshState) {
    PullRefreshStateHidden = 0,
    PullRefreshStateStateVisible = 1,
    PullRefreshStateTriggerRefresh = 2,
    PullRefreshStateRefreshing = 3
};

@interface CMPullRefreshView : UIView

//初始化，将该组件添加到对应的scrollview中
- (id)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic, readwrite) PullRefreshState state;

@end
