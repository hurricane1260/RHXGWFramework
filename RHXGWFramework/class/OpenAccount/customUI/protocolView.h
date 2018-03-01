//
//  protocolView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/20.
//
//

#import <UIKit/UIKit.h>

@interface protocolView : UIView

kRhPCopy ButtonCallBackWithParams selectCallBack;

kRhPCopy ButtonCommonCallBack protocolCallBack;

kRhPCopy ButtonCommonCallBack nextCallBack;

kRhPCopy NSString * protocolName;

kRhPAssign BOOL bottomProtocol;

kRhPStrong UILabel * agreeLabel;

kRhPAssign BOOL enable;

kRhPAssign BOOL isSelected;

@end
