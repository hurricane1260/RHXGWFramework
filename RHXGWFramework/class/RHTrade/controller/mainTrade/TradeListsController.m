//
//  TradeListsController.m
//  stockscontest
//
//  Created by rxhui on 15/12/22.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import "TradeListsController.h"
#import "TradeItemizeListView.h"

@interface TradeListsController ()<TradeItemizeListViewDelegate>

@property (nonatomic,strong) TradeItemizeListView *itemizeView;//明细

@end

@implementation TradeListsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.itemizeView = [[TradeItemizeListView alloc]init];
    [self.view addSubview:self.itemizeView];
    self.itemizeView.backgroundColor = color18_other_xgw;
    self.itemizeView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.itemizeView.width = self.view.width;
    self.itemizeView.height = self.view.height;
}

- (void)navigationToDealDetailListWithTitle:(NSString *)titleString {
    if ([self.delegate respondsToSelector:@selector(navigationToDealDetailListWithTitle:)]) {
        [self.delegate navigationToDealDetailListWithTitle:titleString];
    }
}

- (void)navigationToFAQControllerWithTabNum:(NSInteger)tabNum
{
    if ([self.delegate respondsToSelector:@selector(navigationToFAQControllerWithTabNum:)]) {
        [self.delegate navigationToFAQControllerWithTabNum:tabNum];
    }
}

@end
