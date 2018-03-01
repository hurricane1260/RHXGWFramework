//
//  RHTabBar.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/1/3.
//
//

#import "RHTabBar.h"
#import "RHTabBarItem.h"

@interface RHTabBar ()

@property (nonatomic, strong) RHTabBarItem *selectedBtn;

@end

@implementation RHTabBar

- (void)buildTabBarItemWithTitle:(NSString *)title withNorImg:(UIImage *)norImg withSelectImg:(UIImage *)selectedImg{

    RHTabBarItem * btn = [RHTabBarItem buildTabBarItemWithTitle:title withNorColor:color14_icon_xgw withSelectedColor:color6_text_xgw withNorImg:norImg withSelectedImg:selectedImg];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:btn];
    if (self.subviews.count == 1) {
        [self clickBtn:btn];
    }
}

- (void)changeTabBarItemWithIndex:(NSInteger)index WithTitle:(NSString *)title withNorImg:(UIImage *)norImg withSelectImg:(UIImage *)selectedImg{

    RHTabBarItem * btn = self.subviews[index];
    btn.norImg = norImg;
    btn.selectedImg = selectedImg;
    btn.title = title;
    btn.selected = btn.selected;
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        RHTabBarItem *btn = self.subviews[i];
        
        btn.tag = i + 300;
        
        CGFloat x = i * self.bounds.size.width / count;
        CGFloat y = 0;
        CGFloat width = self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        btn.frame = CGRectMake(x, y, width, height);
    }  
}

- (void)clickBtn:(RHTabBarItem *)btn {
    if (self.selectedBtn == btn) {
        return;
    }
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:btn.tag];
    }
    //self.selectedIndex = button.tag;
}

- (void)setSelectBtn:(NSInteger)index{
    RHTabBarItem *btn = self.subviews[index];
    [self clickBtn:btn];
}

@end
