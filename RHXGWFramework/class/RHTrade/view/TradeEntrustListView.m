//
//  TradeEntrustListView.m
//  stockscontest
//
//  Created by rxhui on 15/6/10.
//  Programed by Tiger.Yin from 15/6/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeEntrustListView.h"
#import "TradeEntrustTableViewCell.h"
#import "EntrustListVO.h"
#import "TradeListHeadView.h"
#import "TradeNoneDataView.h"

@interface TradeEntrustListView ()<CMAlertDelegate>

//@property (nonatomic, assign) BOOL nibsRegistered;

@property (nonatomic, strong) TradeListHeadView *listHeadView;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) TradeNoneDataView *noneDataView;

@end

@implementation TradeEntrustListView

static NSString * const kTradeEntrustCellIdentifier = @"tradeEntrustCellIdentifier";

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubveiws];
    }
    return self;
}

- (void)initSubveiws {
    _listHeadView = [[TradeListHeadView alloc]init];
    if (_viewType == TradeControllerTypeSimulate) {
        _listHeadView.titleList = @[@"委托时间",@"委托价格",@"委托数量"];
    }
    else {
        _listHeadView.titleList = @[@"委托时间",@"委托价格",@"委托/成交",@"状态"];
    }
    _listHeadView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_listHeadView];
    
    _tradeEntrustListView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_tradeEntrustListView];
    _tradeEntrustListView.delegate = self;
    _tradeEntrustListView.dataSource = self;
    _tradeEntrustListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tradeEntrustListView.backgroundColor = [UIColor whiteColor];
    [_tradeEntrustListView registerClass:[TradeEntrustTableViewCell class] forCellReuseIdentifier:kTradeEntrustCellIdentifier];
    [_tradeEntrustListView addPullRefreshView];
    
    _noneDataView = [[TradeNoneDataView alloc]init];
    _noneDataView.titleLabel.text = @"暂无数据";
    [self addSubview:_noneDataView];
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    [self setNeedsLayout];
}

-(void)dealloc {
    self.dataList = nil;
    [self.tradeEntrustListView removePullRefreshView];
    self.tradeEntrustListView = nil;
    self.listHeadView = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.listHeadView.size = CGSizeMake(self.width, 27.0f);
    self.tradeEntrustListView.tableHeaderView = self.listHeadView;
    self.tradeEntrustListView.frame = CGRectMake(0, 0, self.width, self.height);
    self.noneDataView.frame = CGRectMake(0, 0, self.width, self.height - TabBarHeight);
    
    if (!_isSecondTrade) {
        self.tradeEntrustListView.height = self.height - TabBarHeight;
    }
}

//-(void)stopRefreshTableView {
//    [self.tradeEntrustListView stopRefresh];
//}

- (void)setDataList:(NSArray *)aList {
    if (_dataList) {
        _dataList = nil;
    }
    _dataList = aList.copy;
    [self.tradeEntrustListView stopRefresh];
    [self onGetEntrustWithdrawListResult];
}

#pragma mark -- tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.nibsRegistered) {
//        self.nibsRegistered = YES;
//        [self.tradeEntrustListView addPullRefreshView];
//        [self.tradeEntrustListView registerClass:[TradeEntrustTableViewCell class] forCellReuseIdentifier:kTradeEntrustCellIdentifier];
//    }
    
    TradeEntrustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTradeEntrustCellIdentifier];
    EntrustListVO *item = [_dataList objectAtIndex:indexPath.row];
    cell.itemVO = item;
    cell.viewType = self.viewType;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    NSArray *titleList = @[@"取消",@"确定"];
    [CMAlert show:@"确定撤掉这笔委托？" superView:nil titleList:titleList andDelegate:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark -- 网络访问处理

-(void)sendWithDrawRequestWithVO:(EntrustListVO *)itemVO {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.viewType == TradeControllerTypeReal) {
        [param setValue:itemVO.exchangeType forKey:@"exchangeType"];
        [param setValue:itemVO.entrustNo forKey:@"entrustNo"];
    }
    else {
        [param setValue:itemVO.entrustNo forKey:@"id"];
    }
    if ([self.delegate respondsToSelector:@selector(sendEntrustWithdrawWithParam:)]) {
        [self.delegate sendEntrustWithdrawWithParam:param];
    }
}

-(void)requestViewEntrustList {
    if ([self.delegate respondsToSelector:@selector(requestEntrustList)]) {
        [self.delegate requestEntrustList];
    }
}

-(void)requestViewEntrustListNextPage {
    if ([self.delegate respondsToSelector:@selector(requestEntrustListNextPage)]) {
        [self.delegate requestEntrustListNextPage];
    }
}

-(void)onGetEntrustWithdrawListResult
{
//    if (self.viewType == TradeControllerTypeReal) {
        //"0"未报,"1"待报,"2"已报,"7"部成,"C"正报（港股），只留下可以撤销的
        NSMutableArray *tempArray = [NSMutableArray array];
        for (EntrustListVO *item in _dataList) {
            if (item.showWithdrawButton) {
                [tempArray addObject:item];
            }
        }
        _dataList = tempArray.copy;
//    }
    
    if(_dataList == nil || _dataList.count <= 0)
    {
        self.noneDataView.hidden = NO;
        self.tradeEntrustListView.hidden = YES;
    }
    else
    {
        self.noneDataView.hidden = YES;
        self.tradeEntrustListView.hidden = NO;
//        self.listHeadView.size = CGSizeMake(self.width, 27.0f);
        self.tradeEntrustListView.tableHeaderView = self.listHeadView;
    }
    
    [_tradeEntrustListView reloadData];
}

#pragma mark -- 对话框按钮响应,响应撤单操作
-(void)cancleButtonTouchHandler {
    NSLog(@"取消了");
}
-(void)comitButtonTouchHandler {
    [self onRedrawTradeEntrustFor:[self.dataList objectAtIndex:self.selectIndex]];
}

-(void)onRedrawTradeEntrustFor:(EntrustListVO *)entrust
{
    if (![entrust isKindOfClass:[EntrustListVO class]]) {
        return;
    }
    [_tradeEntrustListView stopRefresh];
    [_tradeEntrustListView reloadData];
    
    [self sendWithDrawRequestWithVO:entrust];
}

#pragma mark -- 下拉刷新和加载下一页

-(void)pullRefreshData{
    NSLog(@"pullRefreshData");
    [self requestViewEntrustList];
//    [self.tradeController requestEntrustListViewData];
}

/**
 *  停止滚动时加载下一页数据
 *
 *  @param scrollView 列表TableView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![scrollView isKindOfClass:[UITableView class]]){
        return;
    }
    UITableView *aTableView = (UITableView *)scrollView;
    NSArray *currCells = aTableView.visibleCells;
    if(!currCells || currCells.count == 0){
        return;
    }
    
    UITableViewCell *lastCell = [currCells objectAtIndex:(currCells.count - 1)];
    
    NSIndexPath *indexPath = [aTableView indexPathForCell:lastCell];
    if(indexPath.row != (self.dataList.count - 1)){
        return;
    }
    NSLog(@"Next page request...");
    [self requestViewEntrustListNextPage];
}

@end
