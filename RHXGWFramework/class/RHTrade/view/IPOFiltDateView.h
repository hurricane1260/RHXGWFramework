//
//  IPOFiltDateView.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/15.
//
//

#import <UIKit/UIKit.h>

@interface IPOFiltDateView : UIView

kRhPStrong NSDate * startDate;

kRhPStrong NSDate * endDate;

kRhPCopy ButtonCommonCallBack startCallBack;

kRhPCopy ButtonCommonCallBack endCallBack;

kRhPCopy ButtonCommonCallBack queryBtnCallBack;

@end
