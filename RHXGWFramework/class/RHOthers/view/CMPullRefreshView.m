//
//  CMPullRefreshView.m
//  iphone-pay
//
//  Created by 方海龙 on 13-11-17.
//  Copyright (c) 2013年 RHJX Inc. All rights reserved.
//

#import "CMPullRefreshView.h"
#import <QuartzCore/QuartzCore.h>

#define PROPERTY_CHANGE_CONTENTOFFSET @"contentOffset"
#define PROPERTY_CHANGE_FRAME @"frame"
#define DEFAULT_VIEW_HEIGHT 60

@interface CMPullRefreshView(){
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_messageLabel;
    UIScrollView *_scrollView;
    UIImageView *_arrow;
}

@end

@implementation CMPullRefreshView

-(id)initWithScrollView:(UIScrollView *)scrollView{
    self = [super initWithFrame:CGRectZero];
    if(self){
        _scrollView = scrollView;
        [_scrollView addSubview:self];

        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_sxpic"]];
        _arrow.frame = CGRectMake(0, 6, 20, 20);
        _arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:_arrow];

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        [self addSubview:_activityIndicator];

        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _scrollView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
            _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
        }
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"释放刷新";
        _messageLabel.font = font2_common_xgw;
        _messageLabel.textColor = [UIColor grayColor];
        [self addSubview:_messageLabel];
        //监听scrollview的contentOffset属性变化
        [_scrollView addObserver:self forKeyPath:PROPERTY_CHANGE_CONTENTOFFSET options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:PROPERTY_CHANGE_FRAME options:NSKeyValueObservingOptionNew context:nil];
        self.state = PullRefreshStateHidden;
        self.frame = CGRectMake(0, DEFAULT_VIEW_HEIGHT * -1, _scrollView.bounds.size.width, DEFAULT_VIEW_HEIGHT);
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat startX = 0.0f;
    [_messageLabel sizeToFit];
    
    if(self.state == PullRefreshStateHidden || self.state == PullRefreshStateTriggerRefresh){
        startX = (self.width - _arrow.width - _messageLabel.width) * 0.5f;
        _arrow.x = startX;
        _arrow.y = (self.height - _arrow.height) * 0.5f;
        startX += _arrow.width;
    }else{
        startX = (self.width - _activityIndicator.width - _messageLabel.width) * 0.5f;
        _activityIndicator.x = startX;
        _activityIndicator.y = (self.height - _activityIndicator.height) * 0.5f;
        startX += _activityIndicator.width;
    }
    _messageLabel.x = startX;
    _messageLabel.y = (self.height - _messageLabel.height) * 0.5f;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:PROPERTY_CHANGE_CONTENTOFFSET] && self.state != PullRefreshStateRefreshing){
        if(_scrollView.dragging && self.state == PullRefreshStateHidden){
            _arrow.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            self.state = PullRefreshStateStateVisible;
        }
        if(_scrollView.dragging && _scrollView.contentOffset.y * -1 >= DEFAULT_VIEW_HEIGHT && self.state == PullRefreshStateStateVisible){
            self.state = PullRefreshStateTriggerRefresh;
        }
        if(!_scrollView.dragging && self.state == PullRefreshStateTriggerRefresh){
            self.state = PullRefreshStateRefreshing;
        }
    }else if([keyPath isEqualToString:PROPERTY_CHANGE_FRAME]){
        self.frame = CGRectMake(0, DEFAULT_VIEW_HEIGHT * -1, _scrollView.bounds.size.width, DEFAULT_VIEW_HEIGHT);
        [self layoutSubviews];
    }
}

@synthesize state = _state;

- (void)setState:(PullRefreshState)newState{
    _state = newState;
    switch (_state) {
        case PullRefreshStateHidden:{
            [_activityIndicator stopAnimating];
            _activityIndicator.hidden = YES;
            _messageLabel.text = @"刷新完毕";
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
            [self setScrollViewContentInset:insets];
            break;
        }
        case PullRefreshStateStateVisible:{
            _messageLabel.text = @"下拉刷新";
            _arrow.hidden = NO;
            [self rotateArrow:0 hide:NO];
            break;
        }
        case PullRefreshStateTriggerRefresh:{
            _messageLabel.text = @"释放刷新";
            [_messageLabel sizeToFit];
            [self rotateArrow:M_PI hide:NO];
            break;
        }
        case PullRefreshStateRefreshing:{
            _arrow.hidden = YES;
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
            _messageLabel.text = @"正在刷新数据...";
            //先修改_scrollView.contentInset 再执行刷新数据操作 防止刷新数据操作中直接返回停止刷新，导致先停止刷新再修改成正在刷新数据的情况
            UIEdgeInsets insets = UIEdgeInsetsMake(DEFAULT_VIEW_HEIGHT, 0.0f, 0.0f, 0.0f);
            [self setScrollViewContentInset:insets];
            if(_scrollView.delegate && [_scrollView.delegate respondsToSelector:@selector(pullRefreshData)]){
                [_scrollView.delegate performSelector:@selector(pullRefreshData)];
            }
           
            break;
        }
        default:
            break;
    }
    [self setNeedsLayout];
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self->_arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self->_arrow.layer.opacity = !hide;
    } completion:NULL];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self->_scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:PROPERTY_CHANGE_CONTENTOFFSET];
    [_scrollView removeObserver:self forKeyPath:PROPERTY_CHANGE_FRAME];
}

@end
