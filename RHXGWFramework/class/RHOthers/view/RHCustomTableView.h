//
//  RHCustomTableView.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/9.
//
//

#import <UIKit/UIKit.h>
#import "RHBaseTabDataSource.h"

@protocol RHBaseTableViewDelegate <NSObject>

- (void)changeTabViewHeight:(CGFloat)height;

- (void)didSelectWithData:(id)data;

@end

@interface RHCustomTableView : UITableView

kRhPStrong RHBaseTabDataSource * tabDataSource;

kRhPWeak id<RHBaseTableViewDelegate>customDelegate;

kRhPStrong NSArray * dataList;

kRhPStrong NSArray * headerList;

kRhPAssign CGFloat headerHeight;

kRhPAssign CGFloat tabHeaderHeight;

kRhPAssign BOOL isShowHeaderView;

kRhPCopy ButtonCallBackWithParams heightCallBack;

kRhPStrong UIView * hintView;

kRhPStrong NSString * hintText;
- (void)loadSettingWithDataList:(NSArray *)dataList withHeight:(CGFloat)height withGapHeight:(CGFloat)gapHeight  withCellName:(NSString *)cellName withCellID:(NSString *)cellID;

- (void)setTabHeaderViewWithHeaderList:(NSArray *)headerList withHeight:(CGFloat)height withHeaderViewName:(NSString *)headerName withHeadId:(NSString *)headerId;

- (void)reloadDataWithData:(id)data;

- (void)setHintViewHidden:(BOOL)hidden;
@end
