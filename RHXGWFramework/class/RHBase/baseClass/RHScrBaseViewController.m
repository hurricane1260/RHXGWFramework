
//  RHScrBaseViewController.m
//  TZYJ_IPhone
//
//  Created by liyan on 16/4/26.

#import "RHScrBaseViewController.h"
//#import "MJRefresh.h"

@interface RHScrBaseViewController ()<CMHeaderBarDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIView * lineView;

@property (nonatomic,strong) UIViewController * tabVC;

@property (nonatomic,assign) CGPoint contentOffset;

@end

@implementation RHScrBaseViewController

#pragma mark------初始化及布局------
- (instancetype)init{
    if (self = [super init]) {
        _vcMutArray = [NSMutableArray array];
    }
    return self;
}
- (void)setHeaderBarList:(NSArray *)headerBarList{
    if (headerBarList.count == 0) {
        return;
    }
    _headerBarList = headerBarList;
    if (_vcArray.count == 0 || _headerBarList.count != _vcArray.count) {
        return;
    }
    [self initSubViews];
}
- (void)setVcArray:(NSArray *)vcArray{
    if (vcArray.count == 0) {
        return;
    }
    _vcArray = vcArray;
    if (_headerBarList.count == 0 || _headerBarList.count != _vcArray.count) {
        return;
    }
    [self initSubViews];
}
//默认隐藏 需要时加刷新控件
- (void)setRefreshViewHidden:(BOOL)hidden{
    if (hidden) {
        //移除刷新控件
        [self.bottomScrollView removePullRefreshView];
        [self.view setNeedsLayout];
        
    }else{
        
        //添加刷新控件
        [self.bottomScrollView addPullRefreshView];
        [self.view setNeedsLayout];
    }
}
- (void)initSubViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //底部滚动视图
    self.bottomScrollView = [[UIScrollView alloc] init];
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.bounces = YES;
    self.bottomScrollView.scrollEnabled = YES;
    [self.view addSubview:self.bottomScrollView];
//  [self.bottomScrollView addPullRefreshView];

//    MJRefreshHeader * header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshing)];
//    self.bottomScrollView.mj_header = header;
//    MJRefreshFooter * footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullLoading)];
//    self.bottomScrollView.mj_footer = footer;
    
    //用于切换的headbar
    NSMutableArray * valueListArray = [NSMutableArray array];
    for (int i = 0; i < _headerBarList.count; i++) {
        [valueListArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSDictionary * titleListDic = [NSDictionary  dictionaryWithObjects:valueListArray forKeys:_headerBarList];
    
    self.headerBar = [[RHStockDetailHeaderBar alloc] initWithTitleList:titleListDic titleList:_headerBarList titleColor:color2_text_xgw highlightedColor:color2_text_xgw titleFontSize:14.0f delegate:self];
    self.headerBar.bubType = pointBubble;
    self.headerBar.selectedIndex = 0;
    [self.bottomScrollView addSubview:self.headerBar];
    self.headerBar.backgroundColor = color1_text_xgw;
    
    self.lineView = [[UIView alloc]init];
    [self.headerBar addSubview:self.lineView];
    self.lineView.backgroundColor = color16_other_xgw;
    
    self.horScrollView = [[UIScrollView alloc] init];
    self.horScrollView.delegate = self;
    self.horScrollView.bounces = NO;
    self.horScrollView.pagingEnabled = YES;
    self.horScrollView.showsVerticalScrollIndicator = NO;
    self.horScrollView.showsHorizontalScrollIndicator = NO;
    [self.bottomScrollView addSubview:self.horScrollView];
    
    for (int i = 0; i < _vcArray.count; i++) {
        Class class = NSClassFromString(_vcArray[i]);
        UIViewController * vc = (UIViewController *)[[class alloc] init];
        [_vcMutArray addObject:vc];
        [self addChildViewController:vc];
        [self.horScrollView addSubview:vc.view];
    }
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGFloat offsetY = 0.0f;
    _bottomScrollView.frame = CGRectMake(0.0f,self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
//  _bottomScrollView.contentSize = CGSizeMake(self.view.width, self.view.height);

    _headerBar.frame = CGRectMake(0.0f,offsetY, self.view.width, 38.0f);
    offsetY += _headerBar.height;
    
    self.lineView.frame = CGRectMake(0.0f, self.headerBar.height - 1, self.headerBar.width, 1);
    
    _horScrollView.frame = CGRectMake(0.0f, offsetY, self.view.width,self.bottomScrollView.height - _headerBar.height);
    
    if (_vcMutArray.count > 0) {
        for (int i = 0; i < _vcMutArray.count; i++) {
            UIViewController * vc = _vcMutArray[i];
            vc.view.frame = CGRectMake(self.view.width * i, 0.0f, self.horScrollView.width, self.horScrollView.height);
        }
    }
    _bottomScrollView.contentSize = CGSizeMake(self.view.width, _headerBar.height + _horScrollView.height + 10.0f);
    _horScrollView.contentSize = CGSizeMake(self.view.width * _vcArray.count, self.horScrollView.height);
}
#pragma mark------生命周期------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color1_text_xgw;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIViewController * vc in self.vcMutArray) {
        if ([vc respondsToSelector:@selector(viewWillDisappear:)]) {
            [vc performSelector:@selector(viewWillDisappear:)];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for (UIViewController * vc in self.vcMutArray) {
        if ([vc respondsToSelector:@selector(viewDidDisappear:)]) {
            [vc performSelector:@selector(viewDidDisappear:)];
        }
    }
}

#pragma mark------代理------
- (void)didBarItemSelected:(id)selectedData{
    NSString * index = selectedData;
    self.contentOffset = CGPointMake(self.view.width * index.integerValue, 0.0f);
    _horScrollView.contentOffset = self.contentOffset;

    [self didBarSelectedVCLoadData:selectedData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _horScrollView) {
        return;
    }
    if (scrollView == _bottomScrollView) {
        NSLog(@"底部滑动");
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _bottomScrollView) {
        return;
    }
    int index = scrollView.contentOffset.x / self.view.width;
//    self.contentOffset = CGPointMake(self.view.width * index, 0.0f);
//    self.horScrollView.contentOffset = self.contentOffset;
    [self.headerBar setSelectedIndex:index];
}
#pragma mark------上拉刷新、下拉加载------
- (void)pullRefreshData{
    //让子页面进行下拉刷新操作
}
//点击headBar触发vc加载
- (void)didBarSelectedVCLoadData:(id)selectedData{
    NSString * index = selectedData;
    
    if (!self.selectIndex) {
        self.selectIndex = [NSNumber numberWithInteger:[index integerValue]];
    }
    else{
        if ([self.vcMutArray[self.selectIndex.integerValue] respondsToSelector:@selector(viewWillDisappear:)]) {
            [self.vcMutArray[self.selectIndex.integerValue] performSelector:@selector(viewWillDisappear:)];
        }
        self.selectIndex = [NSNumber numberWithInteger:[index integerValue]];
    }
    
    //让子vc执行要进行的操作 此方法不要写在viewWillAppear方法中 防止重复加载
    if ([self.vcMutArray[[index integerValue]] respondsToSelector:@selector(startLoadingData)]) {
        [self.vcMutArray[[index integerValue]] performSelector:@selector(startLoadingData)];
    }
    if ([self.vcMutArray[[index integerValue]] respondsToSelector:@selector(viewWillAppear:)]) {
        [self.vcMutArray[[index integerValue]] performSelector:@selector(viewWillAppear:)];
    }
    if ([self.vcMutArray[[index integerValue]] respondsToSelector:@selector(viewDidAppear:)]) {
        [self.vcMutArray[[index integerValue]] performSelector:@selector(viewDidAppear:)];
    }
    
}
@end
