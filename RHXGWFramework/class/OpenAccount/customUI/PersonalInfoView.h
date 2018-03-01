//
//  PersonalInfoView.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/11.
//
//

#import <UIKit/UIKit.h>

@interface PersonalInfoView : UIView

kRhPCopy ButtonCallBackWithParams  expendClickCallBack;

kRhPStrong UIView * backView;

kRhPStrong UITextView * textView;

kRhPStrong UILabel * titleLabel;

kRhPCopy NSString * detail;

kRhPCopy NSString * title;

kRhPStrong id detailData;

kRhPAssign BOOL needHeightCal;

kRhPAssign BOOL showExpendView;

kRhPAssign BOOL needLimit;

- (instancetype)initWithTitle:(NSString *)title;

- (void)expandSelectItems;

kRhPCopy ButtonCallBackWithParams heightCallBack;

kRhPCopy ButtonCommonCallBack endEditCallBack;
@end
