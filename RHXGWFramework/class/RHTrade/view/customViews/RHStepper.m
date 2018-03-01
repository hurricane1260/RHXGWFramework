//
//  RHStepper.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/19.
//
//

#import "RHStepper.h"

#define StepWidth 130.0f
#define BtnHeight 27.0f

@interface RHStepper ()

kRhPStrong UIButton * leftBtn;

kRhPStrong UITextField * textField;

kRhPStrong UILabel * valueLabel;

kRhPStrong UIButton * rightBtn;

@end

@implementation RHStepper

- (instancetype)init{
    if (self = [super init]) {
        self.layer.cornerRadius = 3.0f;
        self.clipsToBounds = YES;
        self.layer.borderColor = color5_text_xgw.CGColor;
        self.layer.borderWidth = 0.5f;
        self.size = CGSizeMake(StepWidth, BtnHeight);
        
        _minValue = 1;
        _maxValue = NSIntegerMax;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    _leftBtn = [UIButton didBuildButtonWithTitle:@"-" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color5_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
    _leftBtn.tag = 2001;
    [_leftBtn addTarget:self action:@selector(subtractClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.titleLabel.font = font1_common_xgw;
    [self addSubview:_leftBtn];
    
    _rightBtn = [UIButton didBuildButtonWithTitle:@"+" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color5_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
    _rightBtn.tag = 2002;
    [_rightBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = font1_common_xgw;
    [self addSubview:_rightBtn];
    
    _textField = [[UITextField alloc] init];
    _textField.textColor = color2_text_xgw;
    _textField.font = font1_common_xgw;
//    _textField.borderStyle = UITextBorderStyleLine;
    _textField.layer.borderColor = color5_text_xgw.CGColor;
    _textField.layer.borderWidth = self.layer.borderWidth;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.enabled = NO;
    [self addSubview:_textField];
    
    _valueLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:_valueLabel];

}

- (void)layoutSubviews{
    _leftBtn.frame = CGRectMake(0, 0, BtnHeight, BtnHeight);
    
    _textField.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame), 0, self.width - BtnHeight * 2.0f, self.height);
    
//    [_valueLabel sizeToFit];
//    _valueLabel.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame), 0, _valueLabel.width + 24.0f, self.height);
    
    _rightBtn.frame = CGRectMake(CGRectGetMaxX(_textField.frame), 0, _leftBtn.width, self.height);
    
}


- (void)setCurrentNumber:(NSInteger)currentNumber{
    _currentNumber = currentNumber;
    if (self.applyNumCallBack) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInteger:currentNumber] forKey:@"applyNum"];
        self.applyNumCallBack(dic);
    }
    self.textField.text = [NSString stringWithFormat:@"%ld",(long)_currentNumber];
    if (currentNumber == _maxValue) {
        _rightBtn.enabled = NO;
    }
    else if (currentNumber == _minValue){
        _leftBtn.enabled = NO;
    }
    if (currentNumber == 0) {
        _leftBtn.enabled = NO;
    }
    [self setNeedsLayout];
}

- (void)subtractClick:(UIButton *)btn{
    [self checkTextFieldNumberWithUpdate];
    NSInteger number = [_textField.text integerValue] - _step;
    if (number <= _minValue) {//防止出现负值
        number = _minValue;
    }
    
    if (number >= _minValue && number < _maxValue)
    {
         (number == _minValue) ? (_leftBtn.enabled = NO): (_leftBtn.enabled = YES);
       
        _rightBtn.enabled = YES;
        _textField.text = [NSString stringWithFormat:@"%ld", (long)number];
        self.currentNumber = number;
        [self setNeedsLayout];
    }
    else{
        _leftBtn.enabled = NO;
        [self setNeedsLayout];

    }

}


- (void)addClick:(UIButton *)btn{
    [self checkTextFieldNumberWithUpdate];
    NSInteger number = [_textField.text integerValue] + _step;
    if(number >= _maxValue){//防止超出最大值
        number = _maxValue;
    }
    if (number <= _maxValue && number >_minValue)
    {
        (number == _maxValue) ? (_rightBtn.enabled = NO): (_rightBtn.enabled = YES);
        _leftBtn.enabled = YES;
        _textField.text = [NSString stringWithFormat:@"%ld", (long)number];
        self.currentNumber = number;
        [self setNeedsLayout];
    }
    
    else{
        _rightBtn.enabled = NO;
        [self setNeedsLayout];

    }
}

- (void)checkTextFieldNumberWithUpdate
{
    NSString *minValueString = [NSString stringWithFormat:@"%ld",(long)_minValue];
    NSString *maxValueString = [NSString stringWithFormat:@"%ld",(long)_maxValue];
    
    if (_textField.text.integerValue < _minValue)
    {
        _textField.text = minValueString;
    }
    _textField.text.integerValue > _maxValue ? _textField.text = maxValueString : nil;
}

- (void)setButtonEnable:(BOOL)enable{
    _leftBtn.enabled = enable;
    _rightBtn.enabled = enable;
    [self setNeedsLayout];
}

@end
