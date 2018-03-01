//
//  CSButton.h
//  iphone-tool-kit
//
//  Created by hlfang on 13-11-5.
//  Copyright (c) 2013年 com.rxhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CSButtonSignImageAlignment){
    CSButtonSignImageAlignmentTop = 0,
    CSButtonSignImageAlignmentLeft = 1,
    CSButtonSignImageAlignmentBottom = 2,
    CSButtonSignImageAlignmentRight = 3
};

@interface CSButton : UIControl

@property (nonatomic, assign) BOOL autoSizeEnable;

//按钮文字
@property (nonatomic, copy) NSString *titleText;

//文字颜色

@property (nonatomic, retain) UIColor *normalTitleColor;

@property (nonatomic, retain) UIColor *highlightTitleColor;

@property (nonatomic, retain) UIColor *disableTitleColor;

@property (nonatomic, assign) CGFloat titleFontSize;


@property (nonatomic, retain) UIColor *highlightBackgroundColor;

@property (nonatomic, retain) UIColor *normalBackgroundColor;

@property (nonatomic, copy) NSString *normalImageName;

@property (nonatomic, copy) NSString *highlightImageName;

@property (nonatomic, copy) NSString *disableImageName;

@property (nonatomic, copy) NSString *flagNormalImageName;

@property (nonatomic, copy) NSString *flagHighlightImageName;

@property (nonatomic, assign) CGFloat gap;

@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CSButtonSignImageAlignment signImageAlignment;

-(void)stretchableWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end
