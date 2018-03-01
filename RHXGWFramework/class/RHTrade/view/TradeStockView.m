//
//  TradeStockView.m
//  stockscontest
//
//  Created by rxhui on 15/6/10.
//  Programed by Tiger.Yin on 15/6/11
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeStockView.h"
#import "TradeStockTableViewCell.h"
#import "StockListVO.h"
#import "TradeController.h"
#import "TradeStockHeadView.h"
#import "TradeNoneDataView.h"

static NSString * const kStockListCellReuseId = @"stockListCell";

@interface TradeStockView ()<TradeStockHeadViewDelegte>

@property (nonatomic, assign) NSInteger currentSelectedIndex; // 用来记录最后一次被选中的行编号

@property (nonatomic, strong) TradeStockHeadView *headView;

@property (nonatomic, strong) TradeNoneDataView *noneDataView;

@end

@implementation TradeStockView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentSelectedIndex = -1; 
        
        _headView = [[TradeStockHeadView alloc]init];
        _headView.delegate = self;
        
        _tradeStockTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_tradeStockTableView];
        _tradeStockTableView.delegate = self;
        _tradeStockTableView.dataSource = self;
        _tradeStockTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tradeStockTableView.backgroundColor = [UIColor whiteColor];
        [_tradeStockTableView registerClass:[TradeStockTableViewCell class] forCellReuseIdentifier:kStockListCellReuseId];
        [_tradeStockTableView addPullRefreshView];
        
    }
    return self;
}

- (void)dealloc {
    self.stockList = nil;
    self.dataDic = nil;
    [self.tradeStockTableView removePullRefreshView];
    self.headView = nil;
    self.noneDataView = nil;
}

- (void)setViewType:(TradeControllerType)aType {
    _viewType = aType;
    self.headView.viewType = aType;
}

- (void)setIsSecondTrade:(BOOL)aBool {
    _isSecondTrade = aBool;
    [self setNeedsLayout];
}

- (TradeNoneDataView *)noneDataView {
    if (!_noneDataView) {
        _noneDataView = [[TradeNoneDataView alloc]init];
        [self addSubview:_noneDataView];
    }
    return _noneDataView;
}

- (void)setStockList:(NSArray *)aList {
    if (_stockList) {
        _stockList = nil;
    }
    _stockList = aList.copy;
    [self onGetHoldPositionListResult];
}

- (void)setDataDic:(NSDictionary *)aDic {
    if (_dataDic) {
        _dataDic = nil;
    }
    _dataDic = aDic.copy;
    [self onGetDetailFundResult];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.noneDataView.y = 167.0f;
    self.noneDataView.width = self.width;
    self.noneDataView.height = self.height - 167.0f - TabBarHeight;
    
    self.headView.frame = CGRectMake(0.0f, 0.0f, self.width, 167.0f);
    
    self.tradeStockTableView.frame = CGRectMake(0, 0, self.width, self.height);
    self.tradeStockTableView.tableHeaderView = self.headView;
    
    if (!_isSecondTrade) {
        self.tradeStockTableView.height = self.height - TabBarHeight;
    }
}

#pragma mark --------------------------------------------------------- 持仓股票列表处理 ---------------------------------------------------------

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _currentSelectedIndex)
    {
        return 95;
    }
    else {
        return 60;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stockList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TradeStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStockListCellReuseId];
    cell.stockVO = [_stockList objectAtIndex:indexPath.row];
    cell.delegate = self.tradeControllerDelegate;
    cell.cellType = self.viewType;
    
    if(_currentSelectedIndex == indexPath.row)
    {
        [cell setSelected:NO];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        cell.actionView.hidden = NO;
    }
    else {
        cell.actionView.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentSelectedIndex = indexPath.row;
    [_tradeStockTableView reloadData];
}

#pragma mark ----------------------------------------------------------- 交互 -----------------------------------------------------------

- (void)navigationToTransferController {
    if (!self.tradeControllerDelegate) {
        NSLog(@"-TradeStockView-未设置代理");
        return;
    }
    if (![self.tradeControllerDelegate respondsToSelector:@selector(navigateToBankTransferController)]) {
        NSLog(@"-TradeStockView-未实现方法");
        return;
    }
    [self.tradeControllerDelegate navigateToBankTransferController];
}

#pragma mark -------------------------------------------- 所属视图控制器得到访问结果后的调用方法-----------------------------------------------

-(void)onGetDetailFundResult
{
    self.headView.receivedData = self.dataDic;
}

-(void)onGetHoldPositionListResult
{
    [self.tradeStockTableView stopRefresh];
    if (![_stockList isKindOfClass:[NSArray class]]) {
        return;
    }
    
    double profitLoss = 0.0;
    if (_stockList.count == 0) {
        _noneDataView.hidden = NO;
        self.headView.totalBenifit = (NSDecimalNumber *)[NSNumber numberWithDouble:profitLoss];
        [self.tradeStockTableView reloadData];
        return;
    }
    
    _noneDataView.hidden = YES;;
    for(StockListVO *object in _stockList){
        profitLoss = profitLoss + object.incomeBalance.doubleValue;
    }
    if (self.viewType == TradeControllerTypeReal) {
        self.headView.totalBenifit = (NSDecimalNumber *)[NSNumber numberWithDouble:profitLoss];
    }
    [self.tradeStockTableView reloadData];
}

#pragma mark ----------------------------------------------------------- 下拉刷新和加载下一页 -----------------------------------------------------------

-(void)pullRefreshData{
    NSLog(@"pullRefreshData");
    
    _currentSelectedIndex = -1; // 清除选中状态，等待新的结果
    if ([self.tradeControllerDelegate respondsToSelector:@selector(refreshStockView)]) {
        [self.tradeControllerDelegate refreshStockView];
    }
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
    if(indexPath.row != (self.stockList.count - 1)){
        return;
    }
    NSLog(@"Next page request...");
    if ([self.tradeControllerDelegate respondsToSelector:@selector(stockViewNextPage)]) {
        [self.tradeControllerDelegate stockViewNextPage];
    }
}

@end
