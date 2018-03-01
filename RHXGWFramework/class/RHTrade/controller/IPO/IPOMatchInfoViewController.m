//
//  IPOMatchInfoViewController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/14.
//
//

#import "IPOMatchInfoViewController.h"
#import "TradeIPOManager.h"
#import "IPOFiltDateView.h"
#import "RHCustomTableView.h"

@interface IPOMatchInfoViewController ()

kRhPStrong NSMutableArray * matchIPOArray;

@end

@implementation IPOMatchInfoViewController

#pragma mark -------初始化 生命周期
- (instancetype)init{
    if (self = [super init]) {
        _matchIPOArray = [NSMutableArray array];
    }
    return self;
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.transView.hidden = YES;
   self.dateView.frame = CGRectMake(0, 0, self.view.width, 50.0f);
    
    self.queryTableView.frame = CGRectMake(0, CGRectGetMaxY(self.dateView.frame) + 0.5f, self.view.width,self.view.height - self.queryTableView.y);
    self.noDataView.frame = CGRectMake(0, 0, self.view.width, self.queryTableView.height);

}

#pragma mark ---------配号查询
- (void)startLoadingData{
    //配号查询
    [_matchIPOArray removeAllObjects];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[self.startDate stringWithyyyyMMddFormat] forKey:@"startDate"];
    [param setObject:[self.endDate stringWithyyyyMMddFormat] forKey:@"endDate"];
    __weak typeof (self) welf = self;
    [CMComponent showLoadingViewWithSuperView:self.view andFrame:self.view.frame];
    [self.IPOManager requestForIPOMatchInfo:param withModeId:kIPOMatch completion:^(BOOL success, id resultData) {
        [self setNoDataViewHidden:YES];
        [CMComponent removeComponentViewWithSuperView];
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                [welf setNoDataViewHidden:NO];
                [CMProgress showWarningProgressWithTitle:@"暂无记录" message:nil warningImage:nil duration:1];
                [welf.view setNeedsLayout];
                return;
            }
            [_matchIPOArray addObjectsFromArray:resultData];
            welf.dataSource.dataList = _matchIPOArray;
            [welf.queryTableView reloadData];
            [welf.view setNeedsLayout];
        }
        else{
            [CMComponent showRequestFailViewWithSuperView:welf.queryTableView andFrame:CGRectMake(0, 0, welf.queryTableView.width, welf.queryTableView.height) andTouchRepeatTouch:^{
                [welf startLoadingData];
            }];
        }
    }];
}


@end
