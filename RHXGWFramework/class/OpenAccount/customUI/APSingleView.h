//
//  APSingleView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import <UIKit/UIKit.h>

@interface APSingleView : UIView

kRhPStrong UITextField * textField;

kRhPCopy NSString * placeholder;

- (instancetype)initWithTitle:(NSString * )title withPlaceholder:(NSString *)placeholder;

kRhPAssign CGFloat offsetX;

kRhPStrong NSNumber * limitNum;

kRhPCopy ButtonCommonCallBack endEditCallBack;

kRhPCopy ButtonCommonCallBack editingCallBack;
@end
