//
//  ClearnStockDetailController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/25.
//
//

#import "ClearnStockDetailController.h"
#import "CleanStockDetailHeadView.h"
#import "CleanStockDetilCell.h"
#import "XgwSevenManager.h"
#import "TradeSessionManager.h"
#import "CleanStocksTreadVO.h"
#import "MJRefresh.h"


@interface ClearnStockDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)CleanStockDetailHeadView * headView;
@property (nonatomic,strong)XgwSevenManager * requestManger;
@property (nonatomic,strong)NSMutableDictionary * headViewData;
@property (nonatomic,strong) MJRefreshAutoNormalFooter * footer;
@property (nonatomic,strong)UIView * bgTitleView;
@property (nonatomic,strong)UILabel * navTitleLb;
@property (nonatomic,strong)UILabel * navStockCode;
@property (nonatomic,copy)NSString * stockCode;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL hasNextPage;
@property (nonatomic,copy)NSString * interBegin;
@property (nonatomic,copy)NSString * interEnd;

@end

@implementation ClearnStockDetailController

-(instancetype)init{
    if (self = [super init] ) {
      self.view.backgroundColor = color1_text_xgw;
        _requestManger = [[XgwSevenManager alloc]init];
        self.page = 1;
        [self initSubViews];
    }
    return self;
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
-(NSMutableDictionary *)headViewData{
    if (!_headViewData) {
        _headViewData = [NSMutableDictionary dictionary];
    }
    return _headViewData;
    
}
@synthesize universalParam = _universalParam;
- (void)setUniversalParam:(id)universalParam{
    _universalParam = universalParam;
    self.headViewData = universalParam;
    self.headView.viewData = self.headViewData;
    self.stockCode = [self.headViewData objectForKey:@"stockCode"];
    self.navTitleLb.text = [self.headViewData objectForKey:@"stockName"];
    self.navStockCode.text = [self.headViewData objectForKey:@"stockCode"];
    self.interBegin = [self.headViewData objectForKey:@"interBegin"];
    self.interEnd = [self.headViewData objectForKey:@"interEnd"];
    
}
-(void)initSubViews{
    
    self.bgTitleView = [[UIView alloc]init];
    [self.navigationBar addSubview:self.bgTitleView];
    
    self.navTitleLb = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color1_text_xgw wordWrap:NO];
    [self.bgTitleView addSubview:self.navTitleLb];
    
    self.navStockCode = [UILabel didBuildLabelWithText:@"" font:font0_common_xgw textColor:color1_text_xgw wordWrap:NO];
    [self.bgTitleView addSubview:self.navStockCode];
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
   // [self.tableView addPullRefreshView];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.footer setTitle:@"" forState:MJRefreshStateIdle];

    self.tableView.mj_footer =  self.footer;
    
    
    [self.tableView registerClass:[CleanStockDetilCell class] forCellReuseIdentifier:@"CleanStockDetilCell"];
    
    self.headView = [[CleanStockDetailHeadView alloc]initWithTitleLabelList:@[@"操作",@"成交价",@"成交量",@"成交额"]];
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bgTitleView.frame = CGRectMake(75, StatusBarHeight, self.navigationBar.size.width-150, self.navigationBar.size.height);
    [self.navTitleLb sizeToFit];
    self.navTitleLb.origin = CGPointMake((self.bgTitleView.size.width - self.navTitleLb.size.width)/2, 10);
    [self.navStockCode sizeToFit];
    self.navStockCode.origin = CGPointMake((self.bgTitleView.size.width-self.navStockCode.size.width)/2, CGRectGetMaxY(self.navTitleLb.frame));
    
    self.tableView.frame = CGRectMake(0, self.layoutStartY, kDeviceWidth, kDeviceHeight-self.layoutStartY);
    self.headView.frame = CGRectMake(0, 0, kDeviceWidth, 225);
    self.tableView.tableHeaderView = self.headView;

    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:@"jy_clear_stock_detail_list"];

    [self requestCleanStocksLists];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.requestManger cancelAllDelegate];
}
#pragma mark-- 请求清仓列表
-(void)requestCleanStocksLists{
    [CMComponent removeComponentViewWithSuperView];

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[TradeSessionManager shareInstance].onLineAccount forKey:@"fundAccount"];
    //[param setObject:@"65502706" forKey:@"fundAccount"];
    [param setObject:self.stockCode forKey:@"stockCode"];
    [param setObject:self.interBegin forKey:@"interBegin"];
    [param setObject:self.interEnd forKey:@"interEnd"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:@"cp"];
    [param setObject:@"" forKey:@"ps"];
    [CMComponent showLoadingViewWithSuperView:self.view andFrame:CGRectMake(0, self.layoutStartY, self.view.size.width, self.view.size.height-self.layoutStartY)];
        
       [self.requestManger requestCleanStocksTradeWithParam:param completion:^(BOOL isSuccess, id resultData) {
           [CMComponent removeComponentViewWithSuperView];

           if (isSuccess) {
               CleanStocksTreadVO * VO = resultData;
               self.hasNextPage = VO.hasNextPage;
               self.page = [VO.currentPage integerValue];
                [self.dataArray addObjectsFromArray:VO.data];
                [self.tableView reloadData];
               [self.tableView. mj_footer endRefreshing];
               if (VO.data!= nil && ![VO.data isKindOfClass:[NSNull class]] && VO.data.count != 0){
               }else{
                   //数据源数据为空
                   [CMComponent showNoDataWithSuperView:self.tableView andFrame:CGRectMake(0, 225, self.view.width, self.view.size.height-225)];
               }
               
               
               //判断是否有下一页对下方加载提示文字的显示不同状态
               if (self.page ==1) {
                   if (!self.hasNextPage) {
                       self.tableView.mj_footer.hidden = YES;
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
           
       }];
        
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CleanStockDetilCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CleanStockDetilCell"];
    
    if (!cell) {
        cell = [[CleanStockDetilCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CleanStockDetilCell"];
    }
    if (self.dataArray.count!=0) {
        cell.cellData = self.dataArray[indexPath.row];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
