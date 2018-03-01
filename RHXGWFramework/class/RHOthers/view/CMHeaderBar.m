//
//  CMHeaderBar.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-29.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "CMHeaderBar.h"
#import "CMTabBarItem.h"

@interface CMHeaderBar()

@property (nonatomic, strong) NSMutableArray *barItems;

@property (nonatomic, strong) NSMutableDictionary *separLineMap;

//@property (nonatomic, strong) NSArray *titleList;

@property (nonatomic, strong) NSDictionary *titleToOrderFieldMap;

@property (nonatomic, strong) UIColor *titleColor;


@property (nonatomic, assign) CGFloat titleFontSize;

//@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, weak) id<CMHeaderBarDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * widthArr;

@end

@implementation CMHeaderBar

static const CGFloat kRankBarColorLineHeight = 3.0f;

@synthesize selectedIndex = _selectedIndex;

-(void)setSelectedIndex:(NSUInteger)aIndex{
    CMTabBarItem *item = [self.barItems objectAtIndex:_selectedIndex];
    [item setSelected:NO];
    item = [self.barItems objectAtIndex:aIndex];
    [item setSelected:YES];
    if(_selectedIndex == aIndex){
        return;
    }
    _selectedIndex = aIndex;
    
    if([self.delegate respondsToSelector:@selector(didBarItemSelected:)]){
        NSString *title = [self.titleList objectAtIndex:_selectedIndex];
        id value = [self.titleToOrderFieldMap valueForKey:title];
        [self.delegate didBarItemSelected:value];
    }
    
    [self moveBottomLine];
}

-(void)moveBottomLine{
    CGFloat avgWidth = self.width / self.barItems.count;
    CGFloat targetX = avgWidth * _selectedIndex;
    CGFloat offsetX = 0.0f;
//    if (self.barItems.count < 4) {
//        offsetX = (avgWidth - 80.0f) * 0.5f;
//    }
    
    [UIView animateWithDuration:0.25f animations:^{
//        self.bottomLine.x = targetX + offsetX;
        self.bottomLine.width = [self.widthArr[_selectedIndex] floatValue];
        self.bottomLine.x = (avgWidth - self.bottomLine.width) * 0.5 + targetX;

    }];
    
}

-(void)barButtonTouchHandler:(id)sender{
    NSInteger index = [self.barItems indexOfObject:sender];
    if(index >= 0){
        self.selectedIndex = index;
    }
}

-(id)initWithTitleList:(NSDictionary *)titleToOrderFieldMap titleList:(NSArray *)aList titleColor:(UIColor *)aColor highlightedColor:(UIColor *)bColor titleFontSize:(CGFloat)aSize delegate:(id<CMHeaderBarDelegate>)aDelegate {
    self = [super init];
    
    if(self){
        self.titleToOrderFieldMap = titleToOrderFieldMap;
        self.titleList = aList;
        self.titleColor = aColor;
        self.titleHighlightedColor = bColor;
        self.titleFontSize = aSize;
        self.delegate = aDelegate;
        
        [self didBuildBarItems];
    }
    
    return self;
}

-(void)didBuildBarItems{
    self.barItems = [NSMutableArray arrayWithCapacity:self.titleList.count];
    self.widthArr = [NSMutableArray array];
    self.separLineMap = [NSMutableDictionary dictionary];
    
    for(NSUInteger i=0; i<self.titleList.count; i++){
        NSString *aTitle = [self.titleList objectAtIndex:i];
        
        CMTabBarItem *barItem = [[CMTabBarItem alloc]init];
        barItem.title = aTitle;
        barItem.unselectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:self.titleFontSize],
                                                       NSForegroundColorAttributeName: self.titleColor};
        barItem.selectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:self.titleFontSize],
                                                     NSForegroundColorAttributeName: self.titleHighlightedColor};
        self.titleAttributeFont = barItem.selectedTitleAttributes;
        
        UILabel * tLabel = [[UILabel alloc] init];
        tLabel.text = aTitle;
        tLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        [tLabel sizeToFit];
        [self addSubview:barItem];
        [self.barItems addObject:barItem];
        [self.widthArr addObject:[NSNumber numberWithFloat:18]];
        [barItem addTarget:self action:@selector(barButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == (self.titleList.count - 1)){
            continue;
        }
//        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = color16_other_xgw;
//        [self.separLineMap setValue:line forKey:aTitle];
//        [self addSubview:line];
    }
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = self.titleHighlightedColor;
    [self addSubview:self.bottomLine];
}

-(void)layoutSubviews{
    if(self.barItems.count == 0){
        return;
    }
    CGFloat avgWidth = self.width / self.barItems.count;
    CGFloat targetX = avgWidth * _selectedIndex;
    CGFloat offestX = 0.0f;
    CGFloat separLineHeight = self.height - kRankBarColorLineHeight - 24.0f;
//    if (self.barItems.count < 4) {
//        self.bottomLine.width = 80.0f;
//        self.bottomLine.x = (avgWidth - 80.0f) * 0.5f + targetX;
//    }
//    else {
//        self.bottomLine.width = avgWidth;
//    }
    
    self.bottomLine.width = [self.widthArr[_selectedIndex] floatValue];
    self.bottomLine.x = (avgWidth - self.bottomLine.width) * 0.5 + targetX;
    
    self.bottomLine.height = kRankBarColorLineHeight;
    self.bottomLine.y = self.height - self.bottomLine.height;
    
    for(CMTabBarItem *barItem in self.barItems){
        barItem.width = avgWidth;
        barItem.height = self.height - kRankBarColorLineHeight;
        barItem.x = offestX;
        
        offestX += avgWidth;
        
        NSString *title = barItem.title;
        UIView *line = [self.separLineMap valueForKey:title];
        
        if(line){
            line.width = 0.7f;
            line.height = separLineHeight;
            line.x = offestX;
            line.y = (self.height - kRankBarColorLineHeight - separLineHeight) * 0.5f;
            offestX += line.width;
        }
    }

}

@end
