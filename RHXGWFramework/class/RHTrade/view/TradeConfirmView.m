//
//  TradeConfirmView.m
//  stockscontest
//
//  Created by 吴紫月 on 15/10/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeConfirmView.h"

@interface TradeConfirmView ()

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *cancleButton;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation TradeConfirmView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.wrapperView = [[UIView alloc]init];
    [self addSubview:self.wrapperView];
    self.wrapperView.backgroundColor = [UIColor whiteColor];
    self.wrapperView.layer.cornerRadius = 10.0f;
    
}

- (void)layoutSubviews {
    
}
@end
