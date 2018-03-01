//
//  OAProtocolListController.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/5.
//
//

#import "OAProtocolListController.h"

#import "RHCustomTableView.h"
#import "MNNavigationManager.h"

@interface OAProtocolListController ()<RHBaseTableViewDelegate>

kRhPStrong RHCustomTableView * tableView;

kRhPStrong NSArray * dataArr;


@end

@implementation OAProtocolListController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"开户协议";
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;

    self.tableView = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView loadSettingWithDataList:self.dataArr withHeight:50.0f withGapHeight:0 withCellName:@"protocolCell" withCellID:@"protocolCellId"];
    self.tableView.customDelegate = self;
    self.tableView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.tableView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.tableView.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadDataWithData:@[self.dataArr]];
}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam || ![universalParam isKindOfClass:[NSArray class]]) {
        return;
    }
    self.dataArr = universalParam;
}

- (void)didSelectWithData:(id)data{
    if (!data) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:data forKey:@"protocol"];
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAProtocolController" withParam:param];

}

@end
