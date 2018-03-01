//
//  TradeIPOWeekTableViewCell.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/13.
//
//

#import <UIKit/UIKit.h>
#import "ITableCellItemView.h"

//@protocol TradeIPOWeekTableViewCellDelegate <NSObject>
//
//- (void)applyNumDidChanged:(NSNumber *)applyNum;
//
//@end

@interface TradeIPOWeekTableViewCell : UITableViewCell<ITableCellItemView>

//kRhPAssign id<TradeIPOWeekTableViewCellDelegate>delegate;

kRhPCopy ButtonCallBackWithParams applyCallBack;

@end
