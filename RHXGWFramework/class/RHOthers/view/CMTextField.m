//
//  CMTextField.m
//  iphone-pay
//
//  Created by 方海龙 on 14-8-11.
//  Copyright (c) 2014年 RHJX Inc. All rights reserved.
//

#import "CMTextField.h"

@interface CMTextField(){
}

@end

@implementation CMTextField


- (id)init
{
    self = [super init];
    if (self) {
        [self configureSubviews];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureSubviews];
    }
    return self;
}

-(void)configureSubviews{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.masksToBounds = YES;
    self.textFont = font2_common_xgw;
    self.margin = 10.0f;
    self.font = self.textFont;
}

@synthesize corRadius = _corRadius;

-(void)setCorRadius:(CGFloat)aRadius{
    _corRadius = aRadius;
    self.layer.cornerRadius = _corRadius;
}

@synthesize leftImage = _leftImage;

-(void)setLeftImage:(UIImage *)aImage{
    _leftImage = aImage;
    if(_leftImage){
        UIButton *leftBtn = [self didBuildButtonWithImage:_leftImage];
        leftBtn.size = _leftImage.size;
        self.leftView = leftBtn;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
}

@synthesize rightImage = _rightImage;

-(void)setRightImage:(UIImage *)aImage{
    _rightImage = aImage;
    if(_rightImage){
        UIButton *rightBtn = [self didBuildButtonWithImage:_rightImage];
        rightBtn.size = _rightImage.size;
        self.rightView = rightBtn;
        [rightBtn addTarget:self action:@selector(rightTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(UIButton *)didBuildButtonWithImage:(UIImage *)aImage{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:aImage forState:UIControlStateNormal];
    [button setImage:aImage forState:UIControlStateHighlighted];
    [button setImage:aImage forState:UIControlStateSelected];
    return button;
}

-(void)rightTouchHandler:(id)sender{
    self.text = @"";
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

-(BOOL)becomeFirstResponder{
    BOOL ret = YES ;
    if ([super canBecomeFirstResponder]) {
        ret = [super becomeFirstResponder] ;
        if(ret){
            self.rightViewMode = UITextFieldViewModeAlways ;
        }
    }
    return ret;
}

-(BOOL)resignFirstResponder
{
    BOOL ret = YES ;
    
    ret = [super resignFirstResponder] ;
    
    if( ret){
        self.rightViewMode = UITextFieldViewModeWhileEditing ;
    }
    
    return ret ;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = CGRectMake(self.margin, (self.bounds.size.height - self.leftView.size.height) * 0.5f, self.leftView.size.width, self.leftView.size.height);
    return leftRect;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightRect = CGRectMake(self.width - self.margin - self.rightView.size.width, (self.bounds.size.height - self.rightView.size.height) * 0.5f, self.rightView.size.width, self.rightView.size.height);
    
    return rightRect;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect pRect = CGRectMake(bounds.origin.x + self.margin + self.leftView.bounds.size.width + self.leftView.frame.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return pRect;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGRect pRect = CGRectMake(bounds.origin.x + self.margin + self.leftView.bounds.size.width + self.leftView.frame.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return pRect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect pRect = CGRectMake(bounds.origin.x + self.margin + self.leftView.frame.size.width + self.leftView.frame.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    return pRect;
}

@end;
