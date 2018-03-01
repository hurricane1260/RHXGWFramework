//
//  TradeNoneDataView.m
//  stockscontest
//
//  Created by rxhui on 15/9/23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeNoneDataView.h"

@interface TradeNoneDataView ()

@property (nonatomic, strong) UIImageView *noneDataImage;

@end

@implementation TradeNoneDataView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.noneDataImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_sorryNoData"]];
    [self addSubview:self.noneDataImage];
    
//    self.titleLabel = [UILabel didBuildLabelWithText:@"暂无持仓！" fontSize:16.0f textColor:color4_text_xgw wordWrap:NO];
    self.titleLabel = [UILabel didBuildLabelWithText:@"暂无持仓" font:font3_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.noneDataImage.size = self.noneDataImage.image.size;
    
    self.noneDataImage.x = (self.width - self.noneDataImage.width) * 0.5f;
    self.noneDataImage.y = (self.height - self.noneDataImage.height - self.titleLabel.height - 10.0f) * 0.5f;
    
    self.titleLabel.x = (self.width - self.titleLabel.width) * 0.5f;
    self.titleLabel.y = self.noneDataImage.y + self.noneDataImage.height + 10.0f;
}

@end
