//
//  IPOQueryBaseController.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/16.
//
//

#import "BaseViewController.h"
#import "IPOFiltDateView.h"
#import "IPOTransAccView.h"
#import "TradeIPOManager.h"
#import "RHDataSource.h"
#import "PlaceholderView.h"

@interface IPOQueryBaseController : BaseViewController

kRhPStrong TradeIPOManager * IPOManager;

kRhPStrong IPOFiltDateView * dateView;

kRhPStrong UITableView * queryTableView;

kRhPStrong IPOTransAccView * transView;

kRhPStrong RHDataSource * dataSource;

kRhPStrong NSDate * startDate;

kRhPStrong NSDate * endDate;

kRhPStrong UIView * dateBackView;

kRhPStrong PlaceholderView * noDataView;

- (void)setNoDataViewHidden:(BOOL)hidden;
@end
