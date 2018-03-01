//
//  RHTabBarItem.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/1/3.
//
//

#import <UIKit/UIKit.h>


@interface RHTabBarItem : UIControl

kRhPCopy NSString * title;

kRhPStrong UIImage * norImg;

kRhPStrong UIImage * selectedImg;

+ (RHTabBarItem *)buildTabBarItemWithTitle:(NSString *)title withNorColor:(UIColor *)norColor withSelectedColor:(UIColor *)selectedColor withNorImg:(UIImage *)norImg withSelectedImg:(UIImage *)selectedImg;
@end
