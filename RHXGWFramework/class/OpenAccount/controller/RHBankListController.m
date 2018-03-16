//
//  RHBankListController.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/31.
//
//

#import "RHBankListController.h"
#import "RHCustomTableView.h"

#import "CRHBankListVo.h"

#import "OARequestManager.h"
#import "BankListDataSource.h"

@interface RHBankListController ()<RHBaseTableViewDelegate>

kRhPStrong RHCustomTableView * tableView;

kRhPStrong BankListDataSource * dataSource;

kRhPStrong NSArray * bankList;

kRhPStrong OARequestManager * oAManager;
@end

@implementation RHBankListController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"选择银行卡";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initSubviews];
    
    if (!self.bankList.count || !self.bankList) {
        [self requestToBankList];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.oAManager cancelAllDelegate];

}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam || ![universalParam isKindOfClass:[NSArray class]]) {
        return;
    }
    self.bankList = universalParam;
}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;
    self.tableView = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tabDataSource = self.dataSource;
    [self.tableView loadSettingWithDataList:self.bankList withHeight:43.0f withGapHeight:0.5f withCellName:@"CRHBankListTableViewCell" withCellID:@"bankCellId"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.tableView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    self.tableView.customDelegate = self;
    [self.view addSubview:self.tableView];
}

- (BankListDataSource *)dataSource{
    __weak typeof(self) welf = self;

    if (!_dataSource) {
        _dataSource = [[BankListDataSource alloc] init];

    }
    return _dataSource;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.contentSize = CGSizeMake(self.tableView.width, self.tableView.height);
    self.tableView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);

}

- (void)didSelectWithData:(id)data{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kBankSelectNoti" object:data];
    [self.navigationController popViewControllerAnimated:YES];
}

- (OARequestManager *)oAManager{
    if (!_oAManager) {
        _oAManager = [[OARequestManager alloc] init];
    }
    return _oAManager;
}

- (void)requestToBankList{
    [CMProgress showBeginProgressWithMessage:@"加载中..." superView:self.view];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    __weak typeof (self) welf = self;
    [self.oAManager sendCommonRequestWithParam:param withRequestType:kGetBankList withUrlString:@"crhDepositBankQuery" withCompletion:^(BOOL success, id resultData) {
        [CMProgress hiddenWithAnimation:NO];
        
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[NSArray class]]) {
                NSLog(@"银行列表获取失败");
                return;
            }
            NSArray * arr = resultData;
            if (arr.count) {
                welf.bankList = resultData;
                [welf.tableView reloadDataWithData:@[welf.bankList]];
                [welf.view setNeedsLayout];
            }
        }
        else{
            [CMProgress showEndProgressWithTitle:nil message:@"获取银行列表失败" endImage:nil duration:2];
            
        }
    }];
    
    
}


@end
