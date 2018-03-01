//
//  CMHeaderBar.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-29.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CMHeaderBarDelegate <NSObject>

@optional

-(void)didBarItemSelected:(id)selectedData;


@end

@interface CMHeaderBar : UIView

-(id)initWithTitleList:(NSDictionary *)titleToOrderFieldMap titleList:(NSArray *)aList titleColor:(UIColor *)aColor highlightedColor:(UIColor *)bColor titleFontSize:(CGFloat)aSize delegate:(id<CMHeaderBarDelegate>)aDelegate;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIColor *titleHighlightedColor;

@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSDictionary * titleAttributeFont;

-(void)didBuildBarItems;

@end
