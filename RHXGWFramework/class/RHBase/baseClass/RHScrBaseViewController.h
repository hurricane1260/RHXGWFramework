//
//  RHScrBaseViewController.h
//  TZYJ_IPhone
//
//  Created by liyan on 16/4/26.
//
//

#import "BaseViewController.h"
#import "RHStockDetailHeaderBar.h"

@interface RHScrBaseViewController : BaseViewController

@property (nonatomic,strong) UIScrollView * bottomScrollView;

@property (nonatomic,strong) NSArray * headerBarList;//公开 文字项显示

@property (nonatomic,strong) RHStockDetailHeaderBar  * headerBar;

@property (nonatomic,strong) UIScrollView * horScrollView;

@property (nonatomic,strong) NSArray * vcArray;

@property (nonatomic,strong) NSMutableArray * vcMutArray;

kRhPStrong NSNumber * selectIndex;
/**
 *  是否添加下拉刷新控件（默认隐藏，需要时加刷新控件）
 *
 *  @param hidden 是否隐藏
 */
- (void)setRefreshViewHidden:(BOOL)hidden;

///**
// *  上拉刷新
// */
//- (void)pullRefreshing;

///**
// *  点击headBar触发VC里的操作方法（比如加载页面）
// */
- (void)didBarSelectedVCLoadData:(id)selectedData;

- (void)didBarItemSelected:(id)selectedData;

@end
