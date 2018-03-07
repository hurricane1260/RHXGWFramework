//
//  CRHBankListTableViewCell.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/31.
//
//

#import <UIKit/UIKit.h>
#import "ITableCellItemView.h"

@interface CRHBankListTableViewCell : UITableViewCell<ITableCellItemView>

kRhPCopy ButtonCallBackWithParams heightCallBack;

- (void)loadDataWithModel:(id)model;

@end
