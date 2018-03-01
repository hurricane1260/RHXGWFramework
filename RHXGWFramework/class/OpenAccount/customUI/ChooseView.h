//
//  ChooseView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/4.
//
//

#import <UIKit/UIKit.h>


@interface ChooseView : UIView

kRhPCopy ButtonCallBackWithParams heightCallBack;

- (instancetype)initWithContent:(NSString * )str;

kRhPCopy ButtonCallBackWithParams selectCallBack;
kRhPAssign BOOL isSelected;
@end
