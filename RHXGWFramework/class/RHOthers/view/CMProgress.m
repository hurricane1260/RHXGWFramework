//
//  CMProgress.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "CMProgress.h"

@interface CMProgress()

@property (nonatomic, strong) UIView *parentView;
/**
 *  具体显示进度的组件
 */
@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *currentFlagView;

/**
 *  显示次数，如果一个页面有多次请求数据，则每一次请求数据时都会调用一次显示进度的方法
 *  每一次显示进度的方法都会个showCount计数加一，当调用结束进度的方法时候，会先给showCount
 *  减一，如果showCount为零的时候才会使进度组件消失
 */
@property (nonatomic, assign) NSUInteger showCount;

@end

@implementation CMProgress

static const CGFloat kProgressMaxWidth = 220.0f;
static const CGFloat kProgressMinHeight = 80.0f;
static const CGFloat kProgressMargin = 15.0f;
static const CGFloat kProgressTitleFontSize = 18.0f;
static const CGFloat kProgressMessageFontSize = 16.0f;
static const CGFloat kProgressCornerRadius = 10.0f;
static const NSTimeInterval kProgressDuration = 3.0f;

static CMProgress *instance = nil;

+(CMProgress *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[CMProgress alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.progressView = [[UIView alloc] init];
        self.progressView.backgroundColor = [UIColor blackColor];
        self.progressView.alpha = 0.8f;
        self.progressView.layer.cornerRadius = kProgressCornerRadius;
        [self addSubview:self.progressView];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.hidesWhenStopped = YES;
        
//        self.titleLabel = [UILabel didBuildLabelWithText:nil fontSize:kProgressTitleFontSize textColor:[UIColor whiteColor] wordWrap:NO];
        self.titleLabel = [UILabel didBuildLabelWithText:nil font:font4_common_xgw textColor:[UIColor whiteColor] wordWrap:NO];
        
//        self.messageLabel = [UILabel didBuildLabelWithText:nil fontSize:kProgressMessageFontSize textColor:[UIColor whiteColor] wordWrap:YES];
        self.messageLabel = [UILabel didBuildLabelWithText:nil font:font3_common_xgw textColor:[UIColor whiteColor] wordWrap:YES];
    }
    return self;
}

-(void)clear{
    self.titleLabel.text = nil;
    self.messageLabel.text = nil;
    [self.messageLabel removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.currentFlagView removeFromSuperview];
}

-(void)dealloc{
    [self clear];
    self.progressView = nil;
    self.activityIndicator = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.currentFlagView = nil;
}


-(void)layoutSubviews{
    
    self.progressView.bounds = CGRectMake(0.0f, 0.0f, kProgressMaxWidth, kProgressMinHeight);
    
    CGFloat offestX = 0.0f;
    CGFloat offestY = 0.0f;

    CGFloat labelVisibleWidth = kProgressMaxWidth - self.currentFlagView.bounds.size.width - kProgressMargin;
    CGFloat labelVisibleHeight = self.progressView.bounds.size.height - kProgressMargin * 2.0f;
    
    self.messageLabel.bounds = CGRectMake(0.0f, 0.0f, labelVisibleWidth - kProgressMargin * 2.0f, 0.0f);
    [self.messageLabel sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat labelFactHeight = self.titleLabel.bounds.size.height + self.messageLabel.bounds.size.height + 5.0f;

    CGSize progressSize = CGSizeZero;
    
    if(labelFactHeight > labelVisibleHeight){
        progressSize = CGSizeMake(kProgressMaxWidth, labelFactHeight + kProgressMargin * 2.0f);
    }else{
        progressSize = CGSizeMake(kProgressMaxWidth, kProgressMinHeight);
    }
    
    self.progressView.frame = CGRectMake((self.bounds.size.width - progressSize.width) * 0.5f, (self.bounds.size.height - progressSize.height) * 0.5f, progressSize.width, progressSize.height);
    
    BOOL isContainFlagView = [self.progressView.subviews containsObject:self.currentFlagView];
    if(isContainFlagView){
        self.currentFlagView.frame = CGRectMake(kProgressMargin, (self.progressView.frame.size.height - self.currentFlagView.bounds.size.height) * 0.5f, self.currentFlagView.bounds.size.width, self.currentFlagView.bounds.size.height);
        offestX += self.currentFlagView.frame.origin.x + self.currentFlagView.frame.size.width;
    }

    BOOL isContainTitleLable = [self.progressView.subviews containsObject:self.titleLabel];
    BOOL isContainMessageLabel = [self.progressView.subviews containsObject:self.messageLabel];
    
    if(isContainTitleLable && !isContainMessageLabel){
        self.titleLabel.frame = CGRectMake(offestX + (labelVisibleWidth - self.titleLabel.bounds.size.width) * 0.5f, (self.progressView.frame.size.height - self.titleLabel.bounds.size.height) * 0.5f, self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height);
    }else if(!isContainTitleLable && isContainMessageLabel){
        self.messageLabel.frame = CGRectMake(offestX + (labelVisibleWidth - self.messageLabel.bounds.size.width) * 0.5f, (self.progressView.bounds.size.height - self.messageLabel.bounds.size.height) * 0.5f, self.messageLabel.bounds.size.width, self.messageLabel.bounds.size.height);
    }else if(isContainTitleLable && isContainMessageLabel){
        CGFloat totalHeight = self.titleLabel.bounds.size.height + self.messageLabel.bounds.size.height;
        offestY = (self.progressView.bounds.size.height - totalHeight) * 0.5f;
        
        self.titleLabel.frame = CGRectMake(offestX + (labelVisibleWidth - self.titleLabel.bounds.size.width) * 0.5f, offestY, self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height);
        offestY += self.titleLabel.bounds.size.height + 5.0f;
        
        self.messageLabel.frame = CGRectMake(offestX + (labelVisibleWidth - self.messageLabel.bounds.size.width) * 0.5f, offestY, self.messageLabel.bounds.size.width, self.messageLabel.bounds.size.height);
    }
}


+(void)showBeginProgressWithMessage:(NSString *)message superView:(UIView *)sView{
    CMProgress *aProgress = [CMProgress shareInstance];
    [aProgress showBeginProgressWithMessage:message superView:sView];
}

+(void)showEndProgressWithTitle:(NSString *)aTitle message:(NSString *)aMess endImage:(UIImage *)eImage duration:(NSTimeInterval)duration{
    CMProgress *aProgress = [CMProgress shareInstance];
    [aProgress showEndProgressWithTitle:aTitle message:aMess endImage:eImage duration:duration];
}

@synthesize currentFlagView = _currentFlagView;

-(void)setCurrentFlagView:(UIView *)flagView{
    [_currentFlagView removeFromSuperview];
    if(flagView){
        flagView.alpha = 0.0f;
        [self.progressView addSubview:flagView];
        __block UIView *weakView = flagView;
        [UIView animateWithDuration:0.25f animations:^{
            weakView.alpha = 1.0f;
        }];
    }
    _currentFlagView = flagView;
}

-(void)showBeginProgressWithMessage:(NSString *)message superView:(UIView *)sView{
    [self clear];
    if(sView){
        [sView addSubview:self];
        self.frame = sView.bounds;
    }else{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.frame = window.bounds;
    }
    
    [self.activityIndicator startAnimating];
    self.currentFlagView = self.activityIndicator;
    
    self.messageLabel.text = message;
    [self.progressView addSubview:self.messageLabel];
    
    [self setNeedsLayout];
}

-(void)showEndProgressWithTitle:(NSString *)aTitle message:(NSString *)aMess endImage:(UIImage *)eImage duration:(NSTimeInterval)duration{
    [self clear];
    if(aTitle.length > 0){
        self.titleLabel.text = aTitle;
        [self.progressView addSubview:self.titleLabel];
    }
    if(aMess.length > 0){
        self.messageLabel.text = aMess;
        [self.progressView addSubview:self.messageLabel];
    }
    if(eImage){
        self.currentFlagView = [[UIImageView alloc] initWithImage:eImage];
        self.currentFlagView.bounds = CGRectMake(0.0f, 0.0f, eImage.size.width, eImage.size.height);
    }else{
        self.currentFlagView = nil;
    }
    
    [self setNeedsLayout];
    
    NSTimeInterval durTimerInterval = duration;
    if(durTimerInterval <= 0){
        durTimerInterval = kProgressDuration;
    }
    
    [self performSelector:@selector(hiddenProgress) withObject:nil afterDelay:durTimerInterval];
}

-(void)hiddenProgress{
    __block CMProgress *welf = self;
//    __block __typeof(self) welf = self;
    [UIView animateWithDuration:0.35f animations:^{
        welf.progressView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [welf removeFromSuperview];
        [welf clear];
        welf.progressView.alpha = 1.0f;
    }];
}

+(void)showWarningProgressWithTitle:(NSString *)aTitle message:(NSString *)aMess warningImage:(UIImage *)wImage duration:(NSTimeInterval)duration{
    CMProgress *aProgress = [CMProgress shareInstance];
    [aProgress showWarningProgressWithTitle:aTitle message:aMess warningImage:wImage duration:duration];
}

-(void)showWarningProgressWithTitle:(NSString *)aTitle message:(NSString *)aMess warningImage:(UIImage *)wImage duration:(NSTimeInterval)duration{
    [self clear];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = window.bounds;

    if(aTitle.length > 0){
        self.titleLabel.text = aTitle;
        [self.progressView addSubview:self.titleLabel];
    }
    if(aMess.length > 0){
        self.messageLabel.text = aMess;
        [self.progressView addSubview:self.messageLabel];
    }
    if(wImage){
        self.currentFlagView = [[UIImageView alloc] initWithImage:wImage];
        self.currentFlagView.bounds = CGRectMake(0.0f, 0.0f, wImage.size.width, wImage.size.height);
    }else{
        self.currentFlagView = nil;
    }
    
    [self setNeedsLayout];
    
    NSTimeInterval durTimerInterval = duration;
    if(durTimerInterval <= 0){
        durTimerInterval = kProgressDuration;
    }
    
    [self performSelector:@selector(hiddenProgress) withObject:nil afterDelay:durTimerInterval];
}

+(void)hiddenWithAnimation:(BOOL)animation{
    CMProgress *aInstance = [CMProgress shareInstance];
    [aInstance hiddenWithAnimation:animation];
}

-(void)hiddenWithAnimation:(BOOL)animation{
    if(animation){
        [self hiddenProgress];
    }else{
        [self hiddenWithoutAnimation];
    }
}

-(void)hiddenWithoutAnimation{
    [self removeFromSuperview];
    [self clear];
}

@end
