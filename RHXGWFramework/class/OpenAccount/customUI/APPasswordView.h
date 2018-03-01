//
//  APPasswordView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import <UIKit/UIKit.h>
#import "APSingleView.h"

@interface APPasswordView : UIView

kRhPStrong APSingleView * tradeView;

kRhPStrong APSingleView * reTradeView;

kRhPStrong APSingleView * moneyView;

kRhPStrong APSingleView * reMoneyView;

kRhPAssign BOOL isSame;

kRhPCopy ButtonCallBackWithParams heightCallBack;

kRhPCopy ButtonCallBackWithParams enableCallBack;

- (void)hiddenKeyBoards;
@end
