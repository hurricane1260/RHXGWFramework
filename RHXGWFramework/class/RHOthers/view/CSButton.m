//
//  CSButton.m
//  iphone-tool-kit
//
//  Created by 方海龙 on 13-11-5.
//  Copyright (c) 2013年 com.rxhui. All rights reserved.
//

#import "CSButton.h"
#import <QuartzCore/QuartzCore.h>

#define default_title_font_size 20.0f
#define default_title_title_color [UIColor blackColor]
#define default_gap 5.0f
#define default_margin 5.0f

@interface CSButton(){
    CGFloat _stretchableTop;
    CGFloat _stretchableLeft;
    CGFloat _stretchableBottom;
    CGFloat _stretchableRight;
    BOOL _selectedState;
    CALayer *_backgroundLayer;
}

@property (nonatomic, readonly) CGSize titleSize;

@property (nonatomic, assign) CGRect titleFrame;

@property (nonatomic, readonly) CGSize flagSize;

@property (nonatomic, assign) CGRect flagFrame;

@property (nonatomic, readonly) CALayer *flagImageLayer;

@end

@implementation CSButton

@synthesize gap = _gap;

@synthesize margin = _margin;

@synthesize normalImageName = _normalImageName;

@synthesize highlightImageName = _highlightImageName;

@synthesize disableImageName = _disableImageName;

@synthesize flagNormalImageName = _flagNormalImageName;

@synthesize flagHighlightImageName = _flagHighlightImageName;

@synthesize titleText = _titleText;

@synthesize titleFrame = _titleFrame;

@synthesize flagFrame = _flagFrame;

@synthesize titleFontSize = _titleFontSize;

@synthesize highlightTitleColor = _highlightTitleColor;

@synthesize normalTitleColor = _normalTitleColor;

@synthesize disableTitleColor = _disableTitleColor;

@synthesize autoSizeEnable = _autoSizeEnable;

@synthesize flagImageLayer = _flagImageLayer;

- (id)init
{
    self = [super init];
    if (self) {
        [self configureProperties];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self configureProperties];
    }
    return self;
}

-(void)configureProperties{
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    _titleFontSize = default_title_font_size;
    _normalTitleColor = default_title_title_color;
    _highlightTitleColor = default_title_title_color;
    _signImageAlignment = CSButtonSignImageAlignmentLeft;
    _autoSizeEnable = YES;
    _gap = default_gap;
    _margin = default_margin;
    
    [self addTarget:self action:@selector(touchDownHandler:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUpHandler:) forControlEvents:UIControlEventTouchUpOutside];
}

-(void)touchDownHandler:(id)sender{
    if(!_selectedState && !self.selected){
        _selectedState = YES;
        self.selected = YES;
    }
    [self setNeedsDisplay];
}

-(void)touchUpHandler:(id)sender{
    if(_selectedState && self.selected){
        _selectedState = NO;
        self.selected = NO;
    }
    [self setNeedsDisplay];
}

-(void)stretchableWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right{
    _stretchableTop = top;
    _stretchableLeft = left;
    _stretchableBottom = bottom;
    _stretchableRight = right;
    [self setNeedsLayout];
}

#pragma mark --Getters And Setters--

-(CALayer *)flagImageLayer{
    if(!_flagImageLayer){
        _flagImageLayer = [CALayer layer];
        [self.layer addSublayer:_flagImageLayer];
    }
    return _flagImageLayer;
}

@synthesize flagSize = _flagSize;

-(CGSize)flagSize{
    _flagSize = CGSizeZero;
    if(_flagNormalImageName && _flagNormalImageName.length > 0){
        _flagSize = [UIImage imageNamed:_flagNormalImageName].size;
    }
    return _flagSize;
}

@synthesize titleSize = _titleSize;

-(CGSize)titleSize{
    _titleSize = CGSizeZero;
    if(_titleText && _titleText.length > 0){
        UIFont *font = [UIFont systemFontOfSize:_titleFontSize];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setValue:font forKey:NSFontAttributeName];
        CGSize tempSize = [_titleText sizeWithAttributes:attributes];
        _titleSize = CGSizeMake(tempSize.width, tempSize.height);
    }
    return _titleSize;
}

-(void)calculateAutoSize{

    if(!CGSizeEqualToSize(self.flagSize, CGSizeZero) && CGSizeEqualToSize(self.titleSize, CGSizeZero)){
        self.width = self.flagSize.width + _margin * 2.0f;
        self.height = self.flagSize.height + _margin * 2.0f;
    }
    
    if(CGSizeEqualToSize(self.flagSize, CGSizeZero) && !CGSizeEqualToSize(self.titleSize, CGSizeZero)){
        self.width = self.titleSize.width + _margin * 2.0f;
        self.height = self.titleSize.height + _margin * 2.0f;
    }
    
    if(!CGSizeEqualToSize(self.flagSize, CGSizeZero) && !CGSizeEqualToSize(self.titleSize, CGSizeZero)){
        switch (_signImageAlignment) {
            case CSButtonSignImageAlignmentLeft:
            case CSButtonSignImageAlignmentRight:
                self.width = self.flagSize.width + self.titleSize.width + _gap + _margin * 2.0f;
                self.height = MAX(self.flagSize.height, self.titleSize.height) + _margin * 2.0f;
                break;
            case CSButtonSignImageAlignmentTop:
            case CSButtonSignImageAlignmentBottom:
                self.width = MAX(self.flagSize.width, self.titleSize.width) + _margin * 2.0f;
                self.height = self.flagSize.height + self.titleSize.height + _gap + _margin * 2.0f;
                break;
            default:
                break;
        }
    }
}

-(void)didSetupImageAndTitle{
    CGFloat tartetX = 0.0f;
    CGFloat targetY = 0.0f;
    CGFloat targetWidth = 0.0f;
    CGFloat targetHeight = 0.0f;
    if(!CGSizeEqualToSize(self.flagSize, CGSizeZero) && CGSizeEqualToSize(self.titleSize, CGSizeZero)){
        targetWidth = MIN(self.flagSize.width, self.width - _margin);
        targetHeight = MIN(self.flagSize.height, self.height -  _margin);
        tartetX = (self.width - targetWidth) * 0.5f;
        targetY = (self.height - targetHeight) * 0.5f;
        self.flagFrame = CGRectMake(tartetX, targetY, targetWidth, targetHeight);
    }
    
    if(CGSizeEqualToSize(self.flagSize, CGSizeZero) && !CGSizeEqualToSize(self.titleSize, CGSizeZero)){
        targetWidth = MIN(self.titleSize.width, self.width - _margin);
        targetHeight = MIN(self.titleSize.height, self.height - _margin);
        tartetX = (self.width - targetWidth) * 0.5f;
        targetY = (self.height - targetHeight) * 0.5f;
        self.titleFrame = CGRectMake(tartetX, targetY, targetWidth, targetHeight);
    }
    
    if(!CGSizeEqualToSize(self.flagSize, CGSizeZero) && !CGSizeEqualToSize(self.titleSize, CGSizeZero)){

        CGFloat startX = 0.0f;
        CGFloat startY = 0.0f;
        
        switch (_signImageAlignment) {
            case CSButtonSignImageAlignmentLeft:{
                if(self.width <= self.flagSize.width){
                    targetWidth = MIN(self.flagSize.width, self.width);
                    targetHeight = MIN(self.flagSize.height, self.height);
                    self.flagFrame = CGRectMake((self.width - targetWidth) * 0.5f, (self.height - targetHeight) * 0.5f, targetWidth, targetHeight);
                    self.titleFrame = CGRectZero;
                    break;
                }
                
                targetWidth = MIN(self.width, self.flagSize.width + self.titleSize.width + _gap);
                targetHeight = MIN(self.height, self.flagSize.height);
                startX = (self.width - targetWidth) * 0.5f;
                startY = (self.height - targetHeight) * 0.5f;
                self.flagFrame = CGRectMake(startX, startY, self.flagSize.width, targetHeight);
                
                targetHeight = MIN(self.height, self.titleSize.height);
                startX += self.flagSize.width + _gap;
                startY = (self.height - self.titleSize.height) * 0.5f;
                self.titleFrame = CGRectMake(startX, startY, self.titleSize.width, self.titleSize.height);
                break;
            }
            case CSButtonSignImageAlignmentRight:{
                targetWidth = MIN(self.width, self.flagSize.width + self.titleSize.width + _gap);
                startX = (self.width - targetWidth) * 0.5f;
                startY = (self.height - self.titleSize.height) * 0.5f;
                self.titleFrame = CGRectMake(startX, startY, self.titleSize.width, self.titleSize.height);

                targetHeight = MIN(self.height, self.flagSize.height);
                startX += self.titleSize.width + _gap;
                startY = (self.height - targetHeight) * 0.5f;
                self.flagFrame = CGRectMake(startX, startY, self.flagSize.width, targetHeight);
                break;
            }
            case CSButtonSignImageAlignmentTop:{
                if(self.height <= self.flagSize.height){
                    targetWidth = MIN(self.flagSize.width, self.width);
                    targetHeight = MIN(self.flagSize.height, self.height);
                    self.flagFrame = CGRectMake((self.width - targetWidth) * 0.5f, (self.height - targetHeight) * 0.5f, targetWidth, targetHeight);
                    self.titleFrame = CGRectZero;
                    break;
                }
                
                targetWidth = MIN(self.width, self.flagSize.width);
                startX = (self.width - targetWidth) * 0.5f;
                startY = (self.height - self.flagSize.height - self.titleSize.height - _gap) * 0.5f;
                self.flagFrame = CGRectMake(startX, startY, targetWidth, self.flagSize.height);
                
                targetWidth = MIN(self.width, self.titleSize.width);
                startX = (self.width - targetWidth) * 0.5f;
                startY += self.flagSize.height + _gap;
                self.titleFrame = CGRectMake(startX, startY, targetWidth, self.titleSize.height);
                break;
            }
            case CSButtonSignImageAlignmentBottom:{
                if(self.height <= self.titleSize.height){
                    targetWidth = MIN(self.titleSize.width, self.width);
                    targetHeight = MIN(self.titleSize.height, self.height);
                    self.titleFrame = CGRectMake((self.width - targetWidth) * 0.5f, (self.height - targetHeight) * 0.5f, targetWidth, targetHeight);
                    self.flagFrame = CGRectZero;
                    break;
                }
                targetWidth = MIN(self.width, self.titleSize.width);
                startX = (self.width - targetWidth) * 0.5f;
                startY = (self.height - self.flagSize.height - self.titleSize.height - _gap) * 0.5f;
                self.titleFrame = CGRectMake(startX, startY, targetWidth, self.titleSize.height);
                
                targetWidth = MIN(self.width, self.flagSize.width);
                startX = (self.width - targetWidth) * 0.5f;
                startY += self.titleSize.height + _gap;
                self.flagFrame = CGRectMake(startX, startY, targetWidth, self.flagSize.height);
                break;
            }
            default:
                break;
        }
    }
}

-(void)setFlagNormalImageName:(NSString *)imageName{
    _flagNormalImageName = imageName;
    if(_autoSizeEnable){
        [self calculateAutoSize];
    }
}

-(void)setSignImageAlignment:(CSButtonSignImageAlignment)alignment{
    _signImageAlignment = alignment;
    if(_autoSizeEnable){
        [self calculateAutoSize];
    }
}

-(void)setTitleText:(NSString *)text{
    _titleText = text;
    if(_autoSizeEnable){
        [self calculateAutoSize];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)setNormalImageName:(NSString *)imageName{
    _normalImageName = imageName;
    if(_autoSizeEnable){
        [self calculateAutoSize];
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self setNeedsLayout];
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    if(self.width == 0 || self.height == 0){
        return;
    }
    [self didSetupImageAndTitle];
}

@synthesize normalBackgroundColor = _normalBackgroundColor;

@synthesize highlightBackgroundColor = _highlightBackgroundColor;

-(void)drawRect:(CGRect)rect{
    if(self.width == 0 || self.height == 0){
        return;
    }
    
    NSString *backgroundImageName = self.enabled?(self.selected?_highlightImageName:_normalImageName):_disableImageName;
    if(backgroundImageName.length > 0){
        [self drawBackgroundImage:backgroundImageName];
    }else{
        UIColor *bgColor = self.enabled?(self.selected?_highlightBackgroundColor:_normalBackgroundColor):[UIColor clearColor];
        [self drawBackgroundColor:bgColor];
    }
    
    if(self.selected){
        [self drawHighlightState];
    }else{
        [self drawNormalState];
    }
    
    if (!self.enabled) {
        [self drawDisabledState];
    }
}

-(void)drawNormalState{
    if(_flagNormalImageName && _flagNormalImageName.length > 0){
        UIImage *image = [UIImage imageNamed:_flagNormalImageName];
        self.flagImageLayer.frame = self.flagFrame;
        self.flagImageLayer.contents = (id)image.CGImage;
    }
    
    if(_titleText && _titleText.length > 0){
        [self.normalTitleColor set];
        UIFont *font = [UIFont systemFontOfSize:self.titleFontSize];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setValue:font forKey:NSFontAttributeName];
        [attributes setValue:self.normalTitleColor forKey:NSForegroundColorAttributeName];
        [_titleText drawInRect:self.titleFrame withAttributes:attributes];
    }
}

-(void)drawHighlightState{
    if(_flagHighlightImageName && _flagHighlightImageName.length > 0){
        UIImage *image = [UIImage imageNamed:_flagHighlightImageName];
        self.flagImageLayer.frame = self.flagFrame;
        self.flagImageLayer.contents = (id)image.CGImage;
    }
    else {
        self.flagImageLayer.frame = CGRectZero;
    }
    
    if(_titleText && _titleText.length > 0){
        [self.highlightTitleColor set];
        UIFont *font = [UIFont systemFontOfSize:self.titleFontSize];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setValue:font forKey:NSFontAttributeName];
        [attributes setValue:self.highlightTitleColor forKey:NSForegroundColorAttributeName];
        [_titleText drawInRect:self.titleFrame withAttributes:attributes];
    }
}

-(void)drawDisabledState{
    if(_flagHighlightImageName && _flagHighlightImageName.length > 0){
        UIImage *image = [UIImage imageNamed:_flagHighlightImageName];
        self.flagImageLayer.frame = self.flagFrame;
        self.flagImageLayer.contents = (id)image.CGImage;
    }
    
    if(_titleText && _titleText.length > 0){
        [self.disableTitleColor set];
        UIFont *font = [UIFont systemFontOfSize:self.titleFontSize];
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setValue:font forKey:NSFontAttributeName];
        [attributes setValue:self.disableTitleColor forKey:NSForegroundColorAttributeName];
        [_titleText drawInRect:self.titleFrame withAttributes:attributes];
    }
}

-(void)drawBackgroundColor:(UIColor *)bgColor{
    if(!bgColor){
        bgColor = [UIColor clearColor];
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
    CGContextFillRect(ctx, self.bounds);
}

-(void)drawBackgroundImage:(NSString *)imageNmae{
    if(!imageNmae && imageNmae.length == 0){
        return;
    }
    UIImage *image = [UIImage imageNamed:imageNmae];
    
    if(!_backgroundLayer){
        _backgroundLayer = [CALayer layer];
    }
    _backgroundLayer.frame = self.bounds;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    _backgroundLayer.contents = (id)image.CGImage;
    _backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    _backgroundLayer.contentsCenter = CGRectMake(1.0/3, 1.0/3, 1.0/3, 1.0/3);
    [_backgroundLayer renderInContext:ctx];
}

@end
