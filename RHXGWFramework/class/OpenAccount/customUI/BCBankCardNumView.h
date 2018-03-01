//
//  BCBankCardNumView.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/9/18.
//
//

#import <UIKit/UIKit.h>

@interface BCBankCardNumView : UIView

kRhPStrong UITextField * textField;

kRhPCopy ButtonCommonCallBack photoCallBack;

kRhPCopy NSString * bankCode;

kRhPAssign CGFloat offsetX;

kRhPCopy ButtonCommonCallBack endEditCallBack;

kRhPCopy ButtonCommonCallBack editingCallBack;
@end
