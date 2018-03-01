//
//  UITabBar+RHJX_Inc_Badge.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/16.
//
//

#import "UITabBar+RHJX_Inc_Badge.h"
#import "RHTabBar.h"

#define TabbarItemNums 4.0    //tabbar的数量

@implementation UITabBar (RHJX_Inc_Badge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = color6_text_xgw;//颜色：红色
    CGRect tabFrame = self.frame;
    
    //原生tabBar使用
//    CGRect rect = [self getRectOfTabBarItemIndex:index];
    
    //自定义tabbar使用
    CGRect rect = CGRectMake(index/TabbarItemNums * tabFrame.size.width, 0, tabFrame.size.width / TabbarItemNums, tabFrame.size.height);
    
    //确定小红点的位置
    float percentX = (index + 0.6) / TabbarItemNums;
//    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    percentX = 0.6;
    CGFloat x = rect.origin.x + rect.size.width * percentX;
    badgeView.frame = CGRectMake(x, y, 8, 8);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

- (CGRect)getRectOfTabBarItemIndex:(NSInteger)index{
    
    NSArray * tabbarArr = self.subviews;
    
    for (UIView * view in tabbarArr) {
        if ([view isKindOfClass:[RHTabBar class]]) {
            UIView * tab = view.subviews[index];
            return tab.frame;
        }
    }
    
//    UIView * tab = tabbarArr[index + 1];
    return CGRectZero;

}


@end
