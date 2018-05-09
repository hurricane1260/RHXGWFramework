//
//  RHCustomTableView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/9.
//
//

#import "RHCustomTableView.h"
//#import "RHBaseTabDataSource.h"

@interface RHCustomTableView ()<ITableVisible>


//@property (nonatomic, strong) RHBaseTabDataSource * tabDataSource;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) UITableViewStyle tabStyle;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat gapHeight;

@property (nonatomic, strong) UIView * headView;

kRhPStrong UIImageView * imgView;

kRhPStrong UILabel * hintLabel;

@end

@implementation RHCustomTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
//        _tabDataSource = [[RHBaseTabDataSource alloc] init];
//        _tabDataSource.delegate = self;
//        self.dataSource = _tabDataSource;
//        self.delegate = _tabDataSource;
        self.tabStyle = style;
        
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        [self addSubview:self.hintView];
    }
    return self;
}

@synthesize tabDataSource = _tabDataSource;
- (void)setTabDataSource:(RHBaseTabDataSource *)tabDataSource{
    _tabDataSource = tabDataSource;
}

- (RHBaseTabDataSource *)tabDataSource{
    if (!_tabDataSource) {
        _tabDataSource = [[RHBaseTabDataSource alloc] init];
    }
    return _tabDataSource;
}


- (UIView *)hintView{
    if (_hintView) {
        return _hintView;
    }
    _hintView = [[UIView alloc] init];
    [self addSubview:_hintView];
    
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_prompt_transaction"]];
    [_hintView addSubview:_imgView];
    
    _hintLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];;
    
    [_hintView addSubview:_hintLabel];
    
    _hintView.hidden = YES;
    return _hintView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }

    self.hintView.frame = CGRectMake(0, 27.0f, self.width, 90.0f);
    [self.hintLabel sizeToFit];
    self.imgView.frame = CGRectMake((self.width - self.imgView.width - self.hintLabel.width)/2.0f, (self.hintView.height - self.imgView.height)/2.0f, self.imgView.width, self.imgView.height);
    self.hintLabel.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + 4.0f, (self.hintView.height - self.hintLabel.height)/2.0f, self.hintLabel.width, self.hintLabel.height);
    
}

- (void)setTabHeaderHeight:(CGFloat)tabHeaderHeight{
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, tabHeaderHeight)];
    //    _tabDataSource
}

//- (void)setHeaderHeight:(CGFloat)headerHeight{
//     self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, headerHeight)];
//    _tabDataSource.headerHeight = headerHeight;
//}

- (void)loadSettingWithDataList:(NSArray *)dataList withHeight:(CGFloat)height withGapHeight:(CGFloat)gapHeight  withCellName:(NSString *)cellName withCellID:(NSString *)cellID{
    
    //    self.tabDataSource = [[RHBaseTabDataSource alloc] init];
    self.tabDataSource.delegate = self;
    self.dataSource = self.tabDataSource;
    self.delegate = self.tabDataSource;
    
    _tabDataSource.dataList = dataList;
    _tabDataSource.itemViewClassName = cellName;
    _tabDataSource.cellHeight = height;
    _tabDataSource.cellIndentifier = cellID;
    _tabDataSource.cellGap = gapHeight;
    _tabDataSource.style = self.tabStyle;
    
    //    [self reloadDataWithData:_dataList];
    
    if (!_isShowHeaderView) {
        [self reloadDataWithData:_dataList];
    }
}

- (void)setTabHeaderViewWithHeaderList:(NSArray *)headerList withHeight:(CGFloat)height withHeaderViewName:(NSString *)headerName withHeadId:(NSString *)headerId{
    _tabDataSource.headerHeight = height;
    _headerHeight = height;
    _tabDataSource.headerList = headerList;
    _headerList = headerList;
    _tabDataSource.itemheaderViewName = headerName;
    _tabDataSource.headerIndentifier = headerId;
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:_dataList,_headerList, nil];
    [self reloadDataWithData:arr];
}

- (void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [self computeTableViewHeight];
    
}

- (void)reloadDataWithData:(id)data{
    self.hintView.hidden = YES;
    //    if (![data isKindOfClass:[NSArray class]] || data == nil) {
    //        return;
    //    }
    //
    //    _dataList = (NSArray *)data;
    //    [self computeTableViewHeight];
    //    _tabDataSource.dataList = _dataList;
    //    [self reloadData];
    //    [self setNeedsLayout];
    
    
    //group
    if (![data isKindOfClass:[NSArray class]] || data == nil) {
        _dataList = nil;
        [self reloadData];
        return;
    }
    
    NSArray * arr = (NSArray *)data;
    if (arr.count == 1) {
        _dataList = arr[0];
        [self computeTableViewHeight];
        _tabDataSource.dataList = _dataList;
        
    }
    else if(arr.count == 2){
        switch (self.tabStyle) {
            case UITableViewStylePlain:
                _dataList = arr[0];
                _headerList = arr[1];
                break;
            case UITableViewStyleGrouped:
                _dataList = arr[0];
                _headerList = arr[1];
                break;
            default:
                break;
        }
        
        [self computeTableViewHeight];
        _tabDataSource.dataList = _dataList;
        _tabDataSource.headerList = _headerList;
    }
    
    [self reloadData];
    [self setNeedsLayout];
    
}


- (void)computeTableViewHeight{
    
    //    if (_tabStyle == UITableViewStylePlain) {
    //        _height = _dataList.count * _tabDataSource.cellHeight;
    //    }
    //    else if (_tabStyle == UITableViewStyleGrouped){
    //        _count = 0;
    //        for (NSArray * subArr in _dataList) {
    //            _count += subArr.count;
    //        }
    //        _height = _count * _tabDataSource.cellHeight + (_dataList.count) * _tabDataSource.cellGap;
    //    }
    //
    //    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(changeTabViewHeight:)]) {
    //        [self.customDelegate changeTabViewHeight:_height];
    //    }
    
    //group
    if (_tabStyle == UITableViewStylePlain) {
        _height = _dataList.count * _tabDataSource.cellHeight;
        if (_isShowHeaderView) {
            //            for (int i = 0; i < _dataList.count; i++) {
            //                NSArray * arr = _dataList[i];
            //                _height += arr.count * _tabDataSource.cellHeight + _headerHeight;
            //            }
            _height += _headerHeight;
        }
    }
    else if (_tabStyle == UITableViewStyleGrouped){
        _count = 0;
        for (NSArray * subArr in _dataList) {
            _count += subArr.count;
        }
        _height = _count * _tabDataSource.cellHeight + (_dataList.count) * _tabDataSource.cellGap;
        
        if (_isShowHeaderView) {
            _height += _headerHeight * _headerList.count;
        }
    }
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(changeTabViewHeight:)]) {
        [self.customDelegate changeTabViewHeight:_height];
    }
    
    if (self.heightCallBack) {
        //多个使用
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:_height] forKey:@"height"];
        self.heightCallBack(param);
    }
    
}

//- (void)setHintViewHidden:(BOOL)hidden{
//    self.hintView.hidden = hidden;
//    [self setNeedsLayout];
//}

- (void)setHintText:(NSString *)hintText{
    self.hintLabel.text = hintText;
    self.hintView.hidden = NO;
    [self setNeedsLayout];

}

- (void)tableCellDidSelectedWithData:(id)data{
    if (data == nil) {
        return;
    }
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(didSelectWithData:)]) {
        [self.customDelegate didSelectWithData:data];
    }
}

- (void)tableCellDidSelectedWithIndexPath:(id)data{
    if (data == nil) {
        return;
    }
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(didSelectWithIndexPath:)]) {
        [self.customDelegate didSelectWithIndexPath:data];
    }
}

- (void)loadNextPageDataHandler{
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(loadNextPage)]) {
        [self.customDelegate loadNextPage];
    }
}

//- (void)tableViewDidScroll:(UIScrollView *)tableView{
//    if (tableView.contentOffset.y < 0.1) {
//        tableView.scrollEnabled = NO;
//    }
//}
@end
