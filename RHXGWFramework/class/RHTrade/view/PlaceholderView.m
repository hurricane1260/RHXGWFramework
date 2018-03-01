//
//  PlaceholderView.m
//  stockscontest
//
//  Created by liyan on 15/12/30.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "PlaceholderView.h"

@interface PlaceholderView ()

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, copy) NSString * subTit;

@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UIImageView *placeHolderImgView;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) UILabel *subTitLabel;

@end

@implementation PlaceholderView

- (instancetype)initPlaceHolderViewWithCGRect:(CGRect)rect WithImage:(UIImage*)image WithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
//        self.rect = rect;
        [self initSubviews];
    }
    return self;
}

- (instancetype)initPlaceHolderViewWithCGRect:(CGRect)rect WithImage:(UIImage*)image WithTitle:(NSString *)title withSubTitle:(NSString *)subTitle{
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
        self.subTit = subTitle;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{

//    CGFloat viewWidth = self.rect.size.width;
//    CGFloat viewHeight = self.rect.size.height;
    _placeHolderView = [[UIView alloc]init];
    _placeHolderView.backgroundColor = color1_text_xgw;
    [self addSubview:_placeHolderView];
    
    _placeHolderImgView = [[UIImageView alloc]initWithImage:self.image];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick)];
    [_placeHolderView addGestureRecognizer:tap];
    [_placeHolderView addSubview:_placeHolderImgView];
    
    _placeHolderLabel =[[UILabel alloc]init];
    _placeHolderLabel.textAlignment = NSTextAlignmentCenter;
    _placeHolderLabel.numberOfLines = 0;
    _placeHolderLabel.font = font1_common_xgw;
    if ([UIApplication sharedApplication].keyWindow.height < 570) {
        _placeHolderLabel.font = font1_common_xgw;
    }
    _placeHolderLabel.textColor = color4_text_xgw;
    _placeHolderLabel.text = self.title;

    [_placeHolderView addSubview:_placeHolderLabel];
    
    if (self.subTit && self.subTit.length > 0) {
//        _subTitLabel = [UILabel didBuildLabelWithText:self.subTit fontSize:12.0f textColor:color2_text_xgw wordWrap:NO];
        _subTitLabel = [UILabel didBuildLabelWithText:self.subTit font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        [_placeHolderView addSubview:_subTitLabel];
    }
}

- (void)layoutSubviews{
    CGFloat viewWidth = self.width;
    CGFloat viewHeight = self.height;
    
    _placeHolderView.width = viewWidth;
    _placeHolderView.height = viewHeight;
    
    _placeHolderImgView.center = CGPointMake(_placeHolderView.center.x, _placeHolderImgView.center.y);
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:_placeHolderLabel.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_placeHolderLabel.text length])];
    [_placeHolderLabel setAttributedText:attributedString];
    
    [_placeHolderLabel sizeToFit];
    [_subTitLabel sizeToFit];

    if (_placeHolderLabel.width > viewWidth * 2.0f/ 3.0f) {
        _placeHolderLabel.width = viewWidth * 2.0f/ 3.0f;
        _placeHolderLabel.height = viewHeight/ 4.0f;
    }
    
    //整体居中设置
    _placeHolderImgView.y = (_placeHolderView.height - _placeHolderImgView.height - _placeHolderLabel.height - _subTitLabel.height - 20.0f - 24.0f)/2.0f;
    
    _placeHolderLabel.frame = CGRectMake(viewWidth/6.0f, CGRectGetMaxY(_placeHolderImgView.frame)+20.0f, _placeHolderLabel.width, _placeHolderLabel.height);

    _placeHolderLabel.center = CGPointMake(_placeHolderView.center.x, _placeHolderLabel.center.y);
    _placeHolderImgView.center = CGPointMake(_placeHolderView.center.x, _placeHolderImgView.center.y);
    
    _subTitLabel.y = CGRectGetMaxY(_placeHolderLabel.frame) + 24.0f;
    _subTitLabel.center = CGPointMake(_placeHolderView.center.x, _subTitLabel.center.y);
    
    
}

-(void)dealloc{
    self.title = nil;
    self.image = nil;
    self.placeHolderView = nil;
    self.placeHolderImgView = nil;
    self.placeHolderLabel = nil;
    _subTitLabel = nil;
}

- (void)imgClick{
    if (self.btnCallBlock) {
        self.btnCallBlock();
    }

}


@end
