//
//  CMComponent.h
//  JinHuiXuanGuWang
//
//  Created by Zzbei on 2016/11/23.
//
//

#import <UIKit/UIKit.h>

typedef void (^RepeatButtonBlock)(void);

@interface CMComponent : UIView
/**通用组件***/
+ (void)showLoadingViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame;

+ (void)showNoDataWithSuperView:(UIView *)superView andFrame:(CGRect)frame;

+ (void)showRequestFailViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame andTouchRepeatTouch:(RepeatButtonBlock)block;

+ (void)showServiceDownViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame andTouchRepeatTouch:(RepeatButtonBlock)block;

+ (void)showNoDataViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame andTouchRepeatTouch:(RepeatButtonBlock)block andLabelText:(NSString *)labelText andButtonText:(NSString *)buttonText;

+ (void)removeComponentViewWithSuperView;
/**主题下一级 特殊处理组件***/

+ (void)subThemeNoDataWithSuperView:(UIView *)superView andFrame:(CGRect)frame;

@end
