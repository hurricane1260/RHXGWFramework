//
//  MobileVerifyView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/19.
//
//

#import <UIKit/UIKit.h>
#import "CMTextField.h"

@interface MobileVerifyView : UIView

kRhPStrong CMTextField *userNameTextField;

kRhPStrong CMTextField *verifyTextField;

kRhPCopy ButtonCommonCallBack verifyCodeCallBack;

kRhPStrong UILabel * smsVerifyLabel;

kRhPAssign NSInteger timeNum;

-(void)hideKeyboards;

kRhPCopy ButtonCallBackWithParams enableCallBack;

kRhPAssign BOOL isSelected;
@end
