//
//  CMStepper.m
//  stockscontest
//
//  Created by rxhui on 15/6/11.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "CMStepper.h"
#import "UIImageUtils.h"

static float kButtonWidth = 35.0f;
static float kButtonHeight = 40.0f;


@interface CMStepper ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIButton *leftButton;

@property (nonatomic,strong) UITextField *valueTextField;

@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) UIView *textBackView;

@property (nonatomic,strong) UILabel *leftLabel;

@property (nonatomic,strong) UILabel *rightLabel;

@property (nonatomic,strong) UILongPressGestureRecognizer *longpressGR;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSDecimalNumber *tempStep;

@property (nonatomic,assign) BOOL buttonTouched;

@end

@implementation CMStepper

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.step = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.minValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.maxValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.currentValue = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.isInteger = NO;
        self.buttonTouched = NO;
        [self initSubviews];
    }
    return self;
}

@synthesize currentValue = _currentValue;
-(void)setCurrentValue:(NSDecimalNumber *)aValue {
    if (_currentValue) {
        _currentValue = nil;
    }
    _currentValue = aValue;
    self.valueTextField.text = [NSString stringWithFormat:@"%@",aValue.stringValue];
//    NSLog(@"-- %@ ----- %@ ",_currentValue,_minValue);
    NSComparisonResult result = [aValue compare: self.minValue];
    if ( result == NSOrderedDescending) {
        self.leftButton.enabled = YES;
    }
    result = [aValue compare: self.maxValue];
    if ( result == NSOrderedAscending) {
        self.rightButton.enabled = YES;
    }
    [self setNeedsDisplay];
    if (self.delegate) {
        [self.delegate valueChangestepper:self];
    }
}

-(NSDecimalNumber *)currentValue {
    if (self.valueTextField.text.length == 0) {
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    else {
        return [NSDecimalNumber decimalNumberWithString:self.valueTextField.text];
    }
}

- (void)setSkinColor:(UIColor *)aColor {
    if (_skinColor) {
        _skinColor = nil;
    }
    _skinColor = aColor;
    [self.leftButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:_skinColor andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted & UIControlStateDisabled];
    [self.rightButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:_skinColor andFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted & UIControlStateDisabled];
    self.valueTextField.layer.borderColor = _skinColor.CGColor;
}

-(void)initSubviews {
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
    [self addSubview:self.leftButton];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton setTitle:@"-" forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    
    self.valueTextField = [[UITextField alloc]init];
    [self addSubview:self.valueTextField];
    self.valueTextField.delegate = self;
    self.valueTextField.textColor = color2_text_xgw;
    self.valueTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.valueTextField.font = font3_number_xgw;
    self.valueTextField.layer.borderWidth = 1.0f;
    self.valueTextField.layer.masksToBounds = YES;
    self.valueTextField.textAlignment = NSTextAlignmentCenter;
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
    [self addSubview:self.rightButton];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitle:@"+" forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    
    self.longpressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGestureRecognize:)];
    [self addGestureRecognizer:self.longpressGR];
    self.longpressGR.delegate = self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat layoutX = kButtonWidth;
    [self.valueTextField sizeToFit];
    self.valueTextField.x = layoutX;
    self.valueTextField.width = self.width - kButtonWidth * 2;
    self.valueTextField.height = self.height;
    
    layoutX += self.valueTextField.width;
    self.rightButton.x = layoutX;
}

-(void)longpressGestureRecognize:(UILongPressGestureRecognizer *)longGR {
    self.buttonTouched = YES;
    CGPoint point = [longGR locationInView:self];
    if (point.x < kButtonWidth && point.y < kButtonHeight && point.x > 0.01f && point.y > 0.01f) {//长按左边的按钮
        self.tempStep =  [[NSDecimalNumber decimalNumberWithString:@"0"] decimalNumberBySubtracting:self.step];
    }
    else if (point.x > self.width - kButtonWidth && point.x < self.width && point.y > 0.01f && point.y < kButtonHeight) {
        self.tempStep = self.step;
    }
    else {
        return;
    }
    if (longGR.state == UIGestureRecognizerStateBegan) {
        if (self.timer.isValid) {
            return;
        }
        else {
            [self.timer invalidate];
            self.timer = nil;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(repeatChangeValue) userInfo:nil repeats:YES];
        }
    }
    else if (longGR.state == UIGestureRecognizerStateCancelled || longGR.state == UIGestureRecognizerStateChanged || longGR.state == UIGestureRecognizerStateEnded){
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)repeatChangeValue {
    if ([self.tempStep compare:[NSDecimalNumber decimalNumberWithString:@"0"]] == NSOrderedDescending) {//正数
        [self rightAdding];
    }
    else {
        [self leftAdding];
    }
    if ([self.currentValue compare: self.minValue] != NSOrderedDescending || [self.currentValue compare: self.maxValue] != NSOrderedAscending) {
        [self.timer invalidate];
        self.timer = nil;
    }
//    self.currentValue += self.tempStep;
}

-(void)leftAdding {
    if ([self.currentValue compare: self.minValue] != NSOrderedDescending) {
        self.leftButton.enabled = NO;
        return;
    }
    
    self.currentValue = [self.currentValue decimalNumberBySubtracting:self.step];
    if ([self.currentValue compare: self.minValue] != NSOrderedDescending) {
        self.leftButton.enabled = NO;
    }
    
    if ([self.currentValue compare: self.maxValue] != NSOrderedDescending) {
        self.rightButton.enabled = YES;//数量减少了，最高价以下，右侧按钮可点
    }
}

-(void)rightAdding {
    if ([self.currentValue compare: self.maxValue] != NSOrderedAscending) {
        self.rightButton.enabled = NO;
        return;
    }
    
    self.currentValue = [self.currentValue decimalNumberByAdding: self.step];
    if ([self.currentValue compare: self.maxValue] != NSOrderedAscending) {
        self.rightButton.enabled = NO;
    }
    
    if ([self.currentValue compare: self.minValue] != NSOrderedAscending) {
        self.leftButton.enabled = YES;
    }
}

-(void)leftButtonClick {
    self.buttonTouched = YES;
    [self leftAdding];
//    if (self.currentValue <= self.minValue) {
//        self.leftButton.enabled = NO;
//        return;
//    }
//    
//    self.currentValue -= self.step;
//    if (self.currentValue <= self.minValue) {
//        self.leftButton.enabled = NO;
//    }
//    
//    if (self.currentValue <= self.maxValue) {
//        self.rightButton.enabled = YES;//数量减少了，最高价以下，右侧按钮可点
//    }
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)rightButtonClick {
    self.buttonTouched = YES;
    [self rightAdding];
//    if (self.currentValue >= self.maxValue) {
//        self.rightButton.enabled = NO;
//        return;
//    }
//    
//    self.currentValue += self.step;
//    if (self.currentValue >= self.maxValue) {
//        self.rightButton.enabled = NO;
//    }
//    
//    if (self.currentValue >= self.minValue) {
//        self.leftButton.enabled = YES;
//    }
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)hideKeyboard {
    [self.valueTextField resignFirstResponder];
}

-(BOOL)isFirstResponder {
    [super isFirstResponder];
    if ([self.valueTextField isFirstResponder] || self.buttonTouched) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)resetStepper {
    self.leftButton.enabled = YES;
    self.rightButton.enabled = YES;
    self.buttonTouched = NO;
}

#pragma mark --------------------------------delegate--------------------------------

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(valueErrorStepper:andLeftError:andRightError:)]) {
        return;
    }
    if ([[NSDecimalNumber decimalNumberWithString:textField.text] compare:self.maxValue] == NSOrderedDescending) {
        [self.delegate valueErrorStepper:self andLeftError:NO andRightError:YES];
    }
    if ([[NSDecimalNumber decimalNumberWithString:textField.text] compare:self.minValue] == NSOrderedAscending) {
        [self.delegate valueErrorStepper:self andLeftError:YES andRightError:NO];
    }
    if (textField.text.length == 0) {
        self.currentValue = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    else {
        self.currentValue = [NSDecimalNumber decimalNumberWithString:textField.text];
    }
}

@end
