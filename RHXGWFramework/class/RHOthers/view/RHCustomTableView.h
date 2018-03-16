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

@optional
- (void)changeTabViewHeight:(CGFloat)height;

- (void)didSelectWithData:(id)data;

- (void)didSelectWithIndexPath:(id)data;

- (void)loadNextPage;
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

/*
 group 刷新方法 传入数组@[列表数组，head数组]
 **/
- (void)reloadDataWithData:(id)data;

- (void)setHintViewHidden:(BOOL)hidden;
@end
