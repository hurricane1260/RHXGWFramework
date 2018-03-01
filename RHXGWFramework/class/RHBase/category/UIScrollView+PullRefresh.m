//
//  UIScrollView+PullRefresh.m
//  iphone-pay
//
//  Created by 方海龙 on 13-11-17.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import "UIScrollView+PullRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (PullRefresh)

static char UIScrollViewPullRefreshView;

@dynamic refreshView;

-(void)addPullRefreshView{
    CMPullRefreshView *refView = [[CMPullRefreshView alloc] initWithScrollView:self];
    self.refreshView = refView;
}

-(void)removePullRefreshView {
    [self.refreshView removeFromSuperview];
    self.refreshView = nil;
}

-(void)setRefreshView:(CMPullRefreshView *)rv{
    [self willChangeValueForKey:@"refreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullRefreshView,
                             rv,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"refreshView"];
}

-(CMPullRefreshView *)refreshView{
    return objc_getAssociatedObject(self, &UIScrollViewPullRefreshView);
}

-(void)stopRefresh{
    self.refreshView.state = PullRefreshStateHidden;
}

@end
