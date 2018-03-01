//
//  TradeItemizeListView.m
//  stockscontest
//
//  Created by rxhui on 15/9/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeItemizeListView.h"
#import "TradeItemizeListCell.h"

@interface TradeItemizeListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, strong) UIButton *FAQButton;

@end

@implementation TradeItemizeListView

static NSString * const kTradeItemizeListCellIdentifier = @"cellID";

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[TradeItemizeListCell class] forCellReuseIdentifier:kTradeItemizeListCellIdentifier];
    [self.tableView addPullRefreshView];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = color18_other_xgw;
    
    self.logoutButton = [UIButton didBuildButtonWithTitle:@"退出交易" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color9_text_xgw normalBGColor:color6_text_xgw highlightBGColor:color6_text_xgw disabledBGColor:color1_text_xgw];
    self.logoutButton.titleLabel.font = font2_common_xgw;
    [self.logoutButton addTarget:self action:@selector(touchLogoutButton) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.logoutButton];
    
    self.FAQButton = [[UIButton alloc] init];
    [self.FAQButton setTitle:@"常见问题" forState:UIControlStateNormal];
    self.FAQButton.titleLabel.font = font1_common_xgw;
    [self.FAQButton setTitleColor:color8_text_xgw forState:UIControlStateNormal];
    [self.FAQButton.titleLabel sizeToFit];
    [self.FAQButton addTarget:self action:@selector(touchFAQButton) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.FAQButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.logoutButton.frame = CGRectMake((self.width - self.logoutButton.width) / 2, 52 * 4 + 20 + 20, 312.0f, 44.0f);
    
    self.FAQButton.frame = CGRectMake((MAIN_SCREEN_WIDTH - self.FAQButton.titleLabel.width) / 2, self.tableView.height - self.FAQButton.titleLabel.height - 20 - 49, self.FAQButton.titleLabel.width, self.FAQButton.titleLabel.height);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.delegate) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(navigationToDealDetailListWithTitle:)]) {
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.delegate navigationToDealDetailListWithTitle:@"当日成交"];
        }
        else if (indexPath.row == 1) {
            [self.delegate navigationToDealDetailListWithTitle:@"当日委托"];
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [self.delegate navigationToDealDetailListWithTitle:@"历史成交"];
        }
        else if (indexPath.row == 1) {
            [self.delegate navigationToDealDetailListWithTitle:@"已清仓股票"];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc]init];
    sectionView.size = CGSizeMake(sectionView.width, 10.0f);
    sectionView.backgroundColor = color18_other_xgw;
    return sectionView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeItemizeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kTradeItemizeListCellIdentifier];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleString = @"当日成交";
        }
        else if (indexPath.row == 1) {
            cell.titleString = @"当日委托";
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row==0) {
            cell.titleString = @"历史成交";

        }
        else if (indexPath.row==1){
            cell.titleString = @"已清仓股票";

        }
        
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 2;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)touchLogoutButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutTradeNotificationName" object:nil];
}

- (void)touchFAQButton
{
    [self.delegate navigationToFAQControllerWithTabNum:0];
}

@end
