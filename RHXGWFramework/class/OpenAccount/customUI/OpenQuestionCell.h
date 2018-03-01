//
//  OpenQuestionCell.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/22.
//
//

#import <UIKit/UIKit.h>

#import "ITableCellItemView.h"

@interface OpenQuestionCell : UITableViewCell<ITableCellItemView>

kRhPCopy ButtonCallBackWithParams showCallBack;

kRhPCopy ButtonCallBackWithParams changeCallBack;

kRhPAssign BOOL isShow;
@end
