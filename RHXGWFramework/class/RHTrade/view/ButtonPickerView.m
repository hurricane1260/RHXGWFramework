//
//  CMSinglePickerView.m
//  stockscontest
//
//  Created by rxhui on 15/6/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "ButtonPickerView.h"

static float kItemHeight = 40.0f;

#pragma mark -----------------------------------------------点击的view---------------------------------------------------

typedef enum :NSInteger{
    
    leftType = 1,//仓位
    rightType,//委托 市价
    
    
}ItemType;

@interface ButtonPickerItemView : UIControl

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIImageView *markView;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,copy)NSString *titleString;

@property (nonatomic,assign)BOOL hasImage;

@property (nonatomic,assign)NSUInteger index;//item的编号
@property (nonatomic,assign)ItemType itemType;
@end

@implementation ButtonPickerItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.borderColor = color2_text_xgw.CGColor;
//        self.layer.borderWidth = 1.0f;
//        self.layer.masksToBounds = YES;
        [self initSubviews];
        self.hasImage = NO;
    }
    return self;
}

-(void)setTitleString:(NSString *)aString {
    if (_titleString) {
        _titleString = nil;
    }
    _titleString = aString;
    self.titleLabel.text = aString;
    [self setNeedsLayout];
}

-(void)setHasImage:(BOOL)aBool {
    _hasImage = aBool;
    if (_hasImage) {
        [self addSubview:self.markView];
    }
    else {
        [self.markView removeFromSuperview];
    }
}

-(void)initSubviews {
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = font3_common_xgw;
    self.titleLabel.textColor = color2_text_xgw;
    
    self.markView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_mrmc_sjx"]];
    
    self.line = [[UIView alloc]init];
    [self addSubview:self.line];
    self.line.backgroundColor = color16_other_xgw;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    CGFloat layoutX = 0.0f;
    if (self.hasImage) {
        self.markView.size = self.markView.image.size;

        if (_itemType == rightType) {
            self.markView.x = self.width - self.markView.width;
            self.markView.y = (self.height - self.markView.height)/2;
            layoutX = self.markView.x - 5.0f;
            self.titleLabel.x = layoutX - self.titleLabel.width;
            self.titleLabel.y = (self.height - self.titleLabel.height)/2;

        }else if (_itemType ==leftType){
            self.titleLabel.x = 0;
            self.titleLabel.y = (self.height - self.titleLabel.height)/2;
            layoutX =self.titleLabel.width;
            self.markView.x = layoutX+5.0f;
            self.markView.y = (self.height - self.markView.height)/2;
            

            
        }
        
            }
    else {
        self.titleLabel.x = layoutX;
        self.titleLabel.y = (self.height - self.titleLabel.height)/2;
        self.line.origin = CGPointMake(0.0f, self.height - 0.5f);
        self.line.size = CGSizeMake(self.width*2, 0.5f);
    }
}

@end


@interface ButtonPickerView () {
    NSString *_firstTitle;
}

@property (nonatomic, strong) ButtonPickerItemView *firstItem;
@property (nonatomic, strong) ButtonPickerItemView * leftItem;

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, strong) NSArray *itemList;
@property (nonatomic,strong) NSArray  *tempTitleList;

@property (nonatomic, assign)BOOL isLeftItem;
@property (nonatomic, assign)BOOL isRightItem;

//@property (nonatomic, strong) UIControl *maskView;

//@property (nonatomic, strong) ButtonPickerItemView *secondItem;

//@property (nonatomic, assign) BOOL isHidden;//

@end

@implementation ButtonPickerView

- (instancetype)initWithTitleList:(NSArray *)aList
{
    self = [super init];
    if (self) {
        self.titleList = aList;
        _isHideImage = YES;
        [self initSubview];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setTitleList:(NSArray *)aList {
    if (_titleList) {
        _titleList = nil;
    }
    _titleList = aList;
    if (self.buttonPickerType == marketPriceType) {
        self.firstItem.titleString = [_titleList firstObject];
    }
    
//    self.secondItem.titleString = [_titleList lastObject];
    [self clear];
    [self buildItemListView];
    [self setNeedsLayout];
}
-(void)setHoldingList:(NSArray *)holdingList{
    
    if (_holdingList) {
        _holdingList = nil;
    }
    _holdingList = holdingList;
    [self clear];
    [self buildItemListView];
    [self setNeedsLayout];
    
}
-(void)setLeftTitle:(NSString *)leftTitle{
    _leftTitle = leftTitle;
    self.leftItem.titleString = leftTitle;

}
- (void)setIsHideImage:(BOOL)isHideImage{
    
    self.leftItem.hasImage = isHideImage;
    _isHideImage = isHideImage;
    [self setNeedsLayout];

}
-(NSString *)firstTitle {
    return _firstTitle;
}

-(void)clear {
    for (ButtonPickerItemView *item in self.itemList) {
        [item removeFromSuperview];
    }
//    [self.wrapperView removeFromSuperview];
//    self.wrapperView = nil;
    self.itemList = nil;
}

-(void)buildItemListView {
    
   
    
   
    NSMutableArray *tempList = [NSMutableArray array];
//    NSMutableArray * tempTitleList = [NSMutableArray array];
    
    
    if (self.buttonPickerType  == HoldingType) {
        self.tempTitleList = [_holdingList mutableCopy];
    }else if (self.buttonPickerType == marketPriceType){
        
        self.tempTitleList= [_titleList mutableCopy];
    }
    
    
    for (int i = 0; i < _tempTitleList.count; i++) {
        ButtonPickerItemView *item = [[ButtonPickerItemView alloc]init];
        
        
        if (self.buttonPickerType == HoldingType) {
            [self.leftWrapperView addSubview:item];
        }else if (self.buttonPickerType == marketPriceType){
            [self.wrapperView addSubview:item];
        }
        [tempList addObject:item];
        item.hasImage = NO;
        item.titleString = [_tempTitleList objectAtIndex:i];
        item.index = i;
        [item addTarget:self action:@selector(secondItemTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.itemList = [tempList copy];
}

-(void)initSubview {
    
    self.wrapperView = [[UIView alloc]init];
    [self addSubview:self.wrapperView];
    self.wrapperView.hidden = YES;
    self.wrapperView.backgroundColor = [UIColor whiteColor];
    self.wrapperView.layer.borderColor = color16_other_xgw.CGColor;
    self.wrapperView.layer.borderWidth = 0.5f;
    self.wrapperView.layer.masksToBounds = YES;
    
    
    self.leftWrapperView = [[UIView alloc]init];
    [self addSubview:self.leftWrapperView];
    self.leftWrapperView.hidden = YES;
    self.leftWrapperView.backgroundColor = [UIColor whiteColor];
    self.leftWrapperView.layer.borderColor = color16_other_xgw.CGColor;
    self.leftWrapperView.layer.borderWidth = 0.5f;
    self.leftWrapperView.layer.masksToBounds = YES;
    
    
    
    
    self.firstItem = [[ButtonPickerItemView alloc]init];
    [self addSubview:self.firstItem];
    self.firstItem.hasImage = YES;
    self.firstItem.itemType = rightType;
    self.firstItem.titleLabel.font = font1_common_xgw;
    self.firstItem.titleString = [self.titleList firstObject];
    _firstTitle = self.firstItem.titleString;
    self.firstItem.backgroundColor = [UIColor whiteColor];
    [self.firstItem addTarget:self action:@selector(firstItemTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.leftItem = [[ButtonPickerItemView alloc]init];
    [self addSubview:self.leftItem];
    self.leftItem.hasImage = YES;
    self.leftItem.itemType = leftType;

    self.leftItem.titleLabel.font = font1_common_xgw;
    self.leftItem.titleString = [_holdingList firstObject];
    self.leftItem.backgroundColor = [UIColor whiteColor];
    [self.leftItem addTarget:self action:@selector(leftItemTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    self.maskView = [[UIControl alloc]init];
//    [self addSubview:self.maskView];
//    self.maskView.hidden = YES;
//    self.maskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
//    [self.maskView addTarget:self action:@selector(maskViewTouchHandler) forControlEvents:UIControlEventTouchUpInside];
}

-(void)firstItemTouchHandler {
    
    _isRightItem = !_isRightItem;
    
   

    self.buttonPickerType = marketPriceType;

    if (self.pickerBlock) {
        self.pickerBlock(marketPriceType);
    }
    
    
    if (self.wrapperView.hidden ==YES) {
        self.wrapperView.hidden = NO;
        self.leftWrapperView.hidden = YES;

        
    }else{
        self.wrapperView.hidden = YES;
        
    }

   // if (self.wrapperView.hidden == YES) {
       // self.wrapperView.hidden = NO;
//        self.maskView.hidden = NO;
//        [UIView animateWithDuration:0.35f animations:^{
//            self.firstItem.markView.transform = CGAffineTransformRotate(self.firstItem.markView.transform, M_PI);
//        }];
//        NSLog(@"---%@",[NSValue valueWithCGRect:self.frame]);
    //}
   // else {
       // [self hideButtonList];
//        [UIView animateWithDuration:0.35f animations:^{
//            self.firstItem.markView.transform = CGAffineTransformRotate(self.firstItem.markView.transform, M_PI);
//        }];
    //}
    

    
  
}
-(void)transformMarkView{
    
//    [UIView animateWithDuration:0.35f animations:^{
//        
//        if (self.buttonPickerType == HoldingType) {
//            self.leftItem.markView.transform = CGAffineTransformRotate(self.leftItem.markView.transform, M_PI * (-1));
//        }else if (self.buttonPickerType == marketPriceType){
//            self.firstItem.markView.transform = CGAffineTransformRotate(self.firstItem.markView.transform, M_PI * (-1));
//        }
//        
//        
//    }];
    
}
-(void)leftItemTouchHandler{
    
    if (!_isHideImage) {
        return;
    }
    
    _isLeftItem = !_isLeftItem;
    
    self.buttonPickerType = HoldingType;
    if (self.pickerBlock) {
        self.pickerBlock(HoldingType);
    }
    
    if (self.leftWrapperView.hidden == YES) {
        self.wrapperView.hidden = YES;
        self.leftWrapperView.hidden = NO;
 
    }else{
        self.leftWrapperView.hidden = YES;

    }
    
    //if (self.wrapperView.hidden == YES) {
//        self.wrapperView.hidden = NO;
//        [UIView animateWithDuration:0.35f animations:^{
//            self.leftItem.markView.transform = CGAffineTransformRotate(self.leftItem.markView.transform, M_PI);
//        }];
        
   // }
   // else {
     //   [self hideButtonList];
//        [UIView animateWithDuration:0.35f animations:^{
//            self.leftItem.markView.transform = CGAffineTransformRotate(self.leftItem.markView.transform, -M_PI);
//        }];
          // }
//    

    
  
}

-(void)secondItemTouchHandler:(ButtonPickerItemView *)sendButton {
    [self hideButtonList];
    //[self transformMarkView];
    
    NSString * titleText = [_tempTitleList objectAtIndex:sendButton.index];


    if (self.buttonPickerType == marketPriceType) {
        _firstTitle = [_tempTitleList objectAtIndex:sendButton.index];
        if ([_firstTitle hasPrefix:@"限价"]) {
            self.firstItem.titleString = @"限价委托";
        }
        else {
            self.firstItem.titleString = @"市价委托";
        }
    }
        
        if (![self.delegate respondsToSelector:@selector(didSelectedItemWithTitle:)]) {
            return;
        }
        [self.delegate didSelectedItemWithTitle:titleText];

    
}

-(void)maskViewTouchHandler {
    [self hideButtonList];
    [self transformMarkView];
    
}

-(void)hideButtonList {
    if (self.buttonPickerType == HoldingType) {
        self.leftWrapperView.hidden = YES;
    }else if (self.buttonPickerType == marketPriceType){
        self.wrapperView.hidden = YES;
    }
    
   
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.firstItem.width = self.width/2;
    self.firstItem.height = 24.0f;
    self.firstItem.origin = CGPointMake(self.width/2, 0);
    
    self.leftItem.width = self.width/2;
    self.leftItem.height = 24.0f;
    self.leftItem.origin = CGPointMake(0, 0);
    
  
    
    self.wrapperView.width = self.width;
    self.wrapperView.height = kItemHeight * _titleList.count;
    self.wrapperView.y = self.firstItem.y + self.firstItem.height;
    
    
    self.leftWrapperView.width = self.width;
    self.leftWrapperView.height = kItemHeight * _holdingList.count;
    self.leftWrapperView.y = self.firstItem.y + self.firstItem.height;

    
    
    if (self.buttonPickerType  == HoldingType) {
        _tempTitleList = [_holdingList mutableCopy];
    }else if (self.buttonPickerType == marketPriceType){
        
        _tempTitleList = [_titleList mutableCopy];
    }
    for (int i = 0; i < _tempTitleList.count; i++) {
        ButtonPickerItemView *item = [_itemList objectAtIndex:i];
        item.width = self.width;
        item.height = kItemHeight;
        item.y = kItemHeight * i;
    }
    
//    self.maskView.width = self.width;
//    self.maskView.y = self.wrapperView.y + self.wrapperView.height;
//    self.maskView.height = self.height - self.maskView.y;
    
//    self.height = keyAppWindow.height;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView * wView;
    if (self.buttonPickerType == HoldingType) {
       wView= self.leftWrapperView;
    }else if (self.buttonPickerType == marketPriceType){
       wView= self.wrapperView;
    }else{
        wView = self.leftWrapperView;
    }
    
    
    if (wView.hidden == YES) {
        if (point.y > 24.0f || point.y < 0.0f) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        if (point.y > 0.0f && point.y < self.height) {
            return YES;
        }
//        else if (point.y > self.titleList.count * 44.0f + 44.0f){
//            if (self.wrapperView.hidden == NO) {//点在遮罩层上
//                self.wrapperView.hidden = YES;
////                self.maskView.hidden = YES;
//                [UIView animateWithDuration:0.35f animations:^{
//                    self.firstItem.markView.transform = CGAffineTransformRotate(self.firstItem.markView.transform, M_PI * (-1));
//                }];
//                return YES;
//            }
//            return NO;
//        }
        else {
            return NO;
        }
    }
//    return NO;
}

@end
