//
//  RHStepper.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/19.
//
//

#import <UIKit/UIKit.h>

@interface RHStepper : UIView

/** 最小值, default is 1 */
kRhPAssign NSInteger minValue;

/** 最大值 */
kRhPAssign NSInteger maxValue;

/** 步进 */
kRhPAssign NSInteger step;

/** 当前值 */
kRhPAssign NSInteger currentNumber;

kRhPCopy ButtonCallBackWithParams applyNumCallBack;

- (void)setButtonEnable:(BOOL)enable;

@end
