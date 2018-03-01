//
//  TradeListHeadView.m
//  stockscontest
//
//  Created by rxhui on 15/9/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeListHeadView.h"

@interface TradeListHeadView ()

@property (nonatomic, strong) NSMutableArray *titleLabelList;

@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIView *line2;

@end

@implementation TradeListHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabelList = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)setTitleList:(NSArray *)aList {
    if (_titleList) {
        _titleList = nil;
    }
    _titleList = aList.copy;
    [self initLabels];
    [self setNeedsLayout];
}

- (void)initLabels {
    if (self.titleLabelList.count > 0) {
        [self.titleLabelList removeAllObjects];
    }
    for (NSString *title in _titleList) {
//        UILabel *titleLabel = [UILabel didBuildLabelWithText:title fontSize:12.0f textColor:color2_text_xgw wordWrap:NO];
        UILabel *titleLabel = [UILabel didBuildLabelWithText:title font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        [self.titleLabelList addObject:titleLabel];
        [self addSubview:titleLabel];
    }
}

- (void)initSubviews {
    self.line1 = [[UIView alloc]init];
    [self addSubview:self.line1];
    self.line1.backgroundColor = color16_other_xgw;
    
    self.line2 = [[UIView alloc]init];
    [self addSubview:self.line2];
    self.line2.backgroundColor = color16_other_xgw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.line1.size = CGSizeMake(self.width, 0.5f);
    CGFloat averWidth = self.width / self.titleList.count;
    
    NSString *title = [self.titleList lastObject];
    if ([title isEqualToString:@"状态"]) {//委托撤单 0.3 0.25 0.25 0.2
        CGFloat wide = self.width * 0.3f;
        CGFloat narrow = self.width * 0.2f;
        for (int i = 0; i < self.titleLabelList.count; i++) {
            UILabel *titleLabel  = [self.titleLabelList objectAtIndex:i];
            [titleLabel sizeToFit];
            if (i == 0) {
                titleLabel.x = (wide - titleLabel.width) * 0.5f;
            }
            else if (i == 3) {
                titleLabel.x = averWidth * 2 + wide + (narrow - titleLabel.width) * 0.5f;
            }
            else {
                titleLabel.x = wide + averWidth * (i - 1) + (averWidth - titleLabel.width) * 0.5f;
            }
            titleLabel.y = (self.height - titleLabel.height) * 0.5f;
        }
    }
    else if ([title isEqualToString:@"成交额"]) {//成交历史 0.4 0.15 0.15 0.3
        CGFloat wide = self.width * 0.4f;
        CGFloat narrow = self.width * 0.15f;
        for (int i = 0; i < self.titleLabelList.count; i++) {
            UILabel *titleLabel  = [self.titleLabelList objectAtIndex:i];
            [titleLabel sizeToFit];
            if (i == 0) {
                titleLabel.x = (wide - titleLabel.width) * 0.5f;
            }
            else if (i == 3) {
                titleLabel.x = narrow * 2 + wide + (self.width * 0.3f - titleLabel.width) * 0.5f;
            }
            else {
                titleLabel.x = wide + narrow * (i - 1) + (narrow - titleLabel.width) * 0.5f;
            }
            titleLabel.y = (self.height - titleLabel.height) * 0.5f;
        }
    }
    else {
        for (int i = 0; i < self.titleLabelList.count; i++) {
            UILabel *titleLabel  = [self.titleLabelList objectAtIndex:i];
            [titleLabel sizeToFit];
            titleLabel.x = averWidth * i + (averWidth - titleLabel.width) * 0.5f;
            titleLabel.y = (self.height - titleLabel.height) * 0.5f;
        }
    }

    self.line2.y = self.height - 0.5f;
    self.line2.size = self.line1.size;
}

@end
