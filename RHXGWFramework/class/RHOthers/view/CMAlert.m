//
//  CMAlert.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-13.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "CMAlert.h"

@interface CMAlert(){
    UIView *_maskView;
}

@property (nonatomic, weak) UIView *alertSuperView;

@property (nonatomic, strong) CMAlertView *alertView;

@property (nonatomic,assign) BOOL hidden;

@end

@implementation CMAlert

static CMAlert *instance = nil;

+(CMAlert *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[CMAlert alloc] init];
    });
    return instance;
}

-(CMAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[CMAlertView alloc]init];
        _alertView.delegate = self;
    }
    return _alertView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, keyAppWindow.width, keyAppWindow.height)];
        _maskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
        _hidden = YES;
    }
    return self;
}

-(void)dealloc{
    _maskView = nil;
    self.alertSuperView = nil;
    self.alertView = nil;
}

+(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate {
    CMAlert *aInstance = [CMAlert shareInstance];
    [aInstance show:message superView:sView titleList:titles andDelegate:delegate andHidden:YES];
}

+(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate andHidden:(BOOL)hidden{
    CMAlert *aInstance = [CMAlert shareInstance];
    [aInstance show:message superView:sView titleList:titles andDelegate:delegate andHidden:NO];
}

-(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate andHidden:(BOOL)hidden{
    self.delegate = delegate;
    self.alertView.message = message;
    self.alertView.titleList = titles;
    if(sView){
        self.alertSuperView = sView;
    }else{
        self.alertSuperView = keyAppWindow;
    }
    
    [_maskView addSubview:self.alertView];
    _maskView.frame = self.alertSuperView.bounds;
    [self.alertSuperView addSubview:_maskView];
    
    self.hidden = hidden;
    [self showWithAnimate];
}

+ (void)show:(NSString *)title message:(NSString *)message superView:(UIView *)superView buttonTitleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate {
    CMAlert *aInstance = [CMAlert shareInstance];
    [aInstance show:title message:message superView:superView buttonTitleList:titles andDelegate:delegate];
    
}

- (void)show:(NSString *)title message:(NSString *)message superView:(UIView *)superView buttonTitleList:(NSArray *)titles andDelegate:(id<CMAlertDelegate>)delegate {
    self.delegate = delegate;
    self.alertView.title = title;
    self.alertView.message = message;
    self.alertView.titleList = titles;
    if (superView) {
        self.alertSuperView = superView;
    }
    else {
        self.alertSuperView = keyAppWindow;
    }
    
    [_maskView addSubview:self.alertView];
    _maskView.frame = self.alertSuperView.bounds;
    [self.alertSuperView addSubview:_maskView];
    
    [self showWithAnimate];
}

-(void)cancleButtonTouchHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleButtonTouchHandler)]) {
        [self.delegate cancleButtonTouchHandler];
    }

    if (_hidden) {
        [self hidden];
    }
}

-(void)comitButtonTouchHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comitButtonTouchHandler)]) {
        [self.delegate comitButtonTouchHandler];
    }
    
    if (_hidden) {
        [self hidden];
    }
}


//+(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles showCompletion:(void (^)(void))sCompleteCallback hiddenCompletion:(void (^)(void))hCompleteCallback {
//    CMAlert *aInstance = [CMAlert shareInstance];
//    [aInstance show:message superView:sView titleList:titles showCompletion:^{
//        
//    } hiddenCompletion:^{
//        
//    }];
//}

//-(void)show:(NSString *)message superView:(UIView *)sView titleList:(NSArray *)titles showCompletion:(void (^)(void))sCompleteCallback hiddenCompletion:(void (^)(void))hCompleteCallback {
//    
//}

//+(void)show:(NSString *)message superView:(UIView *)sView{
//    CMAlert *aInstance = [CMAlert shareInstance];
//    [aInstance show:message superView:sView];
//}
//
//-(void)show:(NSString *)message superView:(UIView *)sView{
//    self.alertView = [[CMAlertView alloc] init];
//    self.alertView.message = message;
//    if(sView){
//        self.alertSuperView = sView;
//    }else{
//        self.alertSuperView = keyAppWindow;
//    }
//    
//    [_maskView addSubview:self.alertView];
//    _maskView.frame = self.alertSuperView.bounds;
//    [self.alertSuperView addSubview:_maskView];
//    
//    [self showWithAnimate];
//    
//}

-(void)showWithAnimate{
    CGFloat targetWidth = _maskView.width - 88.0f;
    CGFloat targetHeight = self.alertView.measureHeight;
    CGFloat targetX = 44.0f;
    CGFloat targetY = (_maskView.height - targetHeight) * 0.5f;
    
    self.alertView.alpha = 0.0f;
    self.alertView.frame = CGRectMake(targetX, targetY, targetWidth, targetHeight);
    
    __block CMAlertView *weakAlert = self.alertView;
//    __block __typeof(self) welf = self;
    
    [UIView animateWithDuration:kAnimationTimerInterval animations:^{
        weakAlert.alpha = kModalAlpha;
    } completion:^(BOOL finished) {
//        [welf performSelector:@selector(hidden) withObject:nil afterDelay:kAlertTimerInterval];
    }];
}

-(void)hidden{
    __block CMAlertView *weakAlert = self.alertView;
    __block CMAlert *welf = self;
    [UIView animateWithDuration:kAnimationTimerInterval animations:^{
        weakAlert.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [welf clear];
    }];
}

-(void)clear{
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    self.alertSuperView = nil;
    [_maskView removeFromSuperview];
}

@end

#pragma mark --------------------------------------------------------------------------------------------------------------

@interface CMAlertView(){
    UILabel *_titleLabel;
    UILabel *_messageTextView;
    UIButton *_comitButton;
    UIButton *_cancleButton;
    UIView * _lineView;
}
@end

@implementation CMAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews{
    self.backgroundColor = color17_other_xgw;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;

    _titleLabel = [[UILabel alloc]init];
    [self addSubview:_titleLabel];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = color16_other_xgw;
    _titleLabel.textColor = color2_text_xgw;
    _titleLabel.font = [UIFont boldSystemFontOfSize:kAlertFontSize + 2];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.hidden = YES;
    
    _messageTextView = [[UILabel alloc] init];
    _messageTextView.textAlignment = NSTextAlignmentCenter;
    _messageTextView.backgroundColor = color17_other_xgw;
    _messageTextView.textColor = color2_text_xgw;
    _messageTextView.font = [UIFont systemFontOfSize:kAlertFontSize];
    _messageTextView.lineBreakMode = NSLineBreakByWordWrapping;
    _messageTextView.numberOfLines = 0;
    [self addSubview:_messageTextView];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = color16_other_xgw;
    [self addSubview:_lineView];
    
    _comitButton = [[UIButton alloc]init];
    [self addSubview:_comitButton];
    _comitButton.backgroundColor = color17_other_xgw;
    [_comitButton addTarget:self action:@selector(comitButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_comitButton setTitleColor:color2_text_xgw forState:UIControlStateNormal];
    _comitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    _cancleButton = [[UIButton alloc]init];
    [self addSubview:_cancleButton];
    _cancleButton.backgroundColor = color17_other_xgw;
    [_cancleButton addTarget:self action:@selector(cancleButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [_cancleButton setTitleColor:color6_text_xgw forState:UIControlStateNormal];
    _cancleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
}

-(void)setTitleList:(NSArray *)aList {
    if (_titleList) {
        _titleList = nil;
    }
    _titleList = aList;
    if (_titleList.count == 0) {
        return;
    }
    else if (_titleList.count == 1) {
        [_comitButton setTitle:[_titleList firstObject] forState:UIControlStateNormal];
    }
    else if (_titleList.count == 2) {
        [_cancleButton setTitle:[_titleList firstObject] forState:UIControlStateNormal];
        [_comitButton setTitle:[_titleList lastObject] forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)aString {
    if (_title) {
        _title = nil;
    }
    _title = aString;
    _titleLabel.hidden = NO;
    _titleLabel.text = _title;
    [self setNeedsLayout];
}

-(void)comitButtonTouch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(comitButtonTouchHandler)]) {
        [self.delegate comitButtonTouchHandler];
    }
}

-(void)cancleButtonTouch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleButtonTouchHandler)]) {
        [self.delegate cancleButtonTouchHandler];
    }
}

-(void)setMessage:(NSString *)aMess{
    _message = aMess;
    
    _messageTextView.text = _message;
    
    [self didLayoutTextView];
}

- (CGFloat)measureHeight {
    CGFloat h = 0.0f;
    if (_titleLabel.hidden) {
        h = 0.0f;
    }
    else {
        h = 44.0f;
    }
    [_messageTextView sizeToFit];
    if (_messageTextView.height < 85.0f) {
        _messageTextView.height = 85.0f;
    }
    h += _messageTextView.height;
    h += 44.0f;
    return h;
}

-(void)didLayoutTextView{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setValue:_messageTextView.font forKey:NSFontAttributeName];
    CGSize size = [self.message sizeWithAttributes:attributes];
    CGFloat singleWidth = size.width / self.message.length;
    
    CGFloat tempWidth = size.width + kAlertMargin * 2.0f;
    
    if(tempWidth <= kAlertMaxWidth){
        self.width = tempWidth;
        self.height = size.height + kAlertMargin * 2.0f;
    }else{
        self.width = kAlertMaxWidth;
        int singleRowCount = (kAlertMaxWidth - kAlertMargin * 2) / singleWidth;
        int rowCount = floor(self.message.length / singleRowCount);
        int temp = fmod(self.message.length, singleRowCount);
        if(temp > 0){
            rowCount++;
        }
        self.height = rowCount * size.height + kAlertMargin * 2.0f;
    }
    
    if(self.height < kAlertMinHeight){
        self.height = kAlertMinHeight;
    }
    
    _messageTextView.width = self.width;
    _messageTextView.height = self.height;
    [_messageTextView sizeToFit];
    _messageTextView.x = 0.0f;
    _messageTextView.y = (self.height - _messageTextView.height) * 0.5f;
    
    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.frame].CGPath;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    CGFloat layoutY = 5.0f;

    if (!_titleLabel.hidden) {//有标题
        _titleLabel.x = 0.0f;
        _titleLabel.y = layoutY;
        _titleLabel.width = self.width;
        _titleLabel.height = kAlertFontSize + 12.0f;
        layoutY = 44.0f;
        _messageTextView.textAlignment = NSTextAlignmentLeft;
    }
    
    [_messageTextView sizeToFit];
    _messageTextView.y = layoutY;
    _messageTextView.x =0;
    _messageTextView.width = self.width;
    if (_messageTextView.height < 85.0f) {
        _messageTextView.height = 85.0f;
    }
    _lineView.frame = CGRectMake(0, CGRectGetMaxY(_messageTextView.frame), self.width, 1);
    if (self.titleList.count == 1) {
        _cancleButton.width = 0.0f;
        _comitButton.x = 0.0f;
    }
    else if (self.titleList.count == 2) {
        _cancleButton.width = self.width / 2.0f;
        _comitButton.x = _cancleButton.x + _cancleButton.width + 0.5f;
    }
    _cancleButton.y = _messageTextView.y + _messageTextView.height + 0.5f;
    _cancleButton.height = 44.0f;
    
    _comitButton.y = _cancleButton.y;
    _comitButton.width = self.width - _cancleButton.width;
    _comitButton.height = _cancleButton.height;
    
    self.height = _comitButton.y + _comitButton.height;
}

@end
