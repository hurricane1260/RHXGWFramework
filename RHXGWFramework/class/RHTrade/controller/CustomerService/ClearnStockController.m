//
//  ClearnStockController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/29.
//
//

#import "ClearnStockController.h"
#import "XgwSevenManager.h"
#import "MJRefresh.h"
#import "TradeListHeadView.h"
#import "CleanStockCell.h"
#import "CleanStockVO.h"
#import "MNNavigationManager.h"
#import "TradeSessionManager.h"

@interface ClearnStockController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)XgwSevenManager * requestManger;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL hasNextPage;
@property (nonatomic,strong) MJRefreshAutoNormalFooter * footer;
@property (nonatomic,strong) TradeListHeadView *listHeadView;
@property (nonatomic,strong) UITableView * tableView;


@end

@implementation ClearnStockController
-(instancetype)init{
    if (self = [super init]) {
        self.title= @"已清仓股票";
        self.view.backgroundColor = color1_text_xgw;
        self.requestManger = [[XgwSevenManager alloc]init];
        self.page = 1;
        [self initSubViews];
    }
    return self;
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    return _dataArray;
}
- (TradeListHeadView *)listHeadView {
    if (!_listHeadView) {
        _listHeadView = [[TradeListHeadView alloc]init];
        _listHeadView.backgroundColor = [UIColor whiteColor];
    }
    return _listHeadView;
}

-(void)initSubViews{
    self.listHeadView.titleList = @[@"建仓日期",@"持股天数",@"盈亏额",@"收益率"];
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView addPullRefreshView];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.footer setTitle:@"" forState:MJRefreshStateIdle];

    self.tableView.mj_footer =  self.footer;


 
    [self.tableView registerClass:[CleanStockCell class] forCellReuseIdentifier:[CleanStockCell cellReuseIdentifier]];

}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.listHeadView.frame = CGRectMake(0, 0, kDeviceWidth, 27);

    self.tableView.frame = CGRectMake(0,self.layoutStartY, self.view.self.width, kDeviceHeight-self.layoutStartY);
    self.tableView.tableHeaderView = self.listHeadView;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillBecomeForeground) name:@"appEnterForeground" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"jy_clear_stock_list"];

    if (self.dataArray.count==0) {
        [self requestCleanStocksLists];
    }
}
//程序回到前台
-(void)appWillBecomeForeground {
    if ([[TradeSessionManager shareInstance] onLine]) {//在线
        [[TradeSessionManager shareInstance]cancelLogout];//取消退出登录
        [self requestCleanStocksLists];
    }
    else {//不在线
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"-dealListController-viewWillDisappear-");
    [self.requestManger cancelAllDelegate];
}
-(void)dealloc {
    [self.tableView removePullRefreshView];
    self.tableView.delegate = nil;
    self.tableView = nil;

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"appEnterForeground" object:nil];
}
#pragma mark-- 请求清仓列表
-(void)requestCleanStocksLists{
    [CMComponent removeComponentViewWithSuperView];

    [CMComponent showLoadingViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY, self.view.size.width, self.view.size.height-self.layoutStartY)];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
     [param setObject:[TradeSessionManager shareInstance].onLineAccount forKey:@"fundAccount"];
    //[param setObject:@"65502706" forKey:@"fundAccount"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:@"cp"];
    [param setObject:@"" forKey:@"ps"];
    
    [self.requestManger requestCleanStocksListWithParam:param completion:^(BOOL isSuccess, id resultData) {
        [self.tableView stopRefresh];

        [CMComponent removeComponentViewWithSuperView];
        if (isSuccess) {
            
            CleanStocksListVO * listVO = resultData;
            self.hasNextPage = listVO.hasNextPage;
            self.page = [listVO.currentPage integerValue];
          
            
            if (listVO.data!= nil && ![listVO.data isKindOfClass:[NSNull class]] && listVO.data.count != 0){
            }else{
                //数据源数据为空
                [CMComponent showNoDataWithSuperView:self.tableView andFrame:CGRectMake(0, 0, self.view.width, self.tableView.size.height)];
            }
            [self.dataArray addObjectsFromArray:listVO.data];
            [self.tableView reloadData];
            [self.tableView. mj_footer endRefreshing];
            

            //判断是否有下一页对下方加载提示文字的显示不同状态
            if (self.page ==1) {
                if (!self.hasNextPage) {
                    
                    if (self.dataArray.count*60+self.layoutStartY>kDeviceHeight) {
                        self.tableView.mj_footer.hidden = NO;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        self.tableView.mj_footer.hidden = YES;
                        
                    }
                }else{
                    self.tableView.mj_footer.hidden = NO;
                    
                }
                
            }else{
                if (!self.hasNextPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
   
        }else{
            //请求失败
            [CMComponent showRequestFailViewWithSuperView:self.tableView andFrame:CGRectMake(0, 0, self.view.width, self.tableView.size.height ) andTouchRepeatTouch:^{
                [self requestCleanStocksLists];
            }];
            
        }
        [self.view setNeedsLayout];

    }];
    
    

    
}
#pragma mark -- 下拉刷新和加载下一页

-(void)pullRefreshData{
    if (self.dataArray) {
        [self.dataArray removeAllObjects];
    }
    self.page = 1;
    [self requestCleanStocksLists];
}

#pragma 清仓股票的上拉刷新
-(void)loadMoreData{
    
    if (self.hasNextPage) {
        self.page++;
        
        [self requestCleanStocksLists];
        
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}



#pragma mark--tableView delegte
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        CleanStockCell * cell  = [tableView dequeueReusableCellWithIdentifier:[CleanStockCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count!=0) {
            cell.cellData = self.dataArray[indexPath.row];
        }
        
        return cell;
        
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count==0) {
        return;
    }
    
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        CleanStockVO * VO = self.dataArray[indexPath.row];
        [param setObject:[NSString ifStringisNull:VO.stockCode] forKey:@"stockCode"];
        [param setObject:[NSString ifStringisNull:VO.stockName] forKey:@"stockName"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.profit]] forKey:@"profit"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.profitYld]]  forKey:@"profitYld"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.totalBalan1]]   forKey:@"totalBalan1"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.totalBalan2]]  forKey:@"totalBalan2"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.fare]]   forKey:@"fare"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.holdTime]]  forKey:@"holdTime"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.interBegin]] forKey:@"interBegin"];
        [param setObject:[NSString ifStringisNull:[NSString stringWithFormat:@"%@",VO.interEnd]] forKey:@"interEnd"];
    
        [MNNavigationManager navigationToUniversalVC:self withClassName:@"ClearnStockDetailController" withParam:param];
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
