//
//  SingleBankView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/20.
//
//

#import <UIKit/UIKit.h>

@interface SingleBankView : UIView

kRhPStrong UILabel * nameLabel;

kRhPCopy ButtonCallBackWithParams heightCallBack;


- (instancetype)initHorizontalWithImg:(UIImage *) imgName withTitle:(NSString *)bankName;

- (instancetype)initVerticalWithImg:(UIImage *) imgName withTitle:(NSString *)bankName;
@end
