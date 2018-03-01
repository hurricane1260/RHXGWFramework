//
//  BuyAndSellTitleView.m
//  stockscontest
//
//  Created by rxhui on 15/8/24.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BuyAndSellTitleView.h"

@interface BuyAndSellTitleView ()

/*! @brief 标题－股票名称 */
@property (nonatomic,strong) UILabel *stockNameTitleLabel;

/*! @brief 标题－价格 */
@property (nonatomic,strong) UILabel *priceTitleLabel;

/*! @brief 标题－涨幅 */
@property (nonatomic,strong) UILabel *increaseTitleLabel;

@end

@implementation BuyAndSellTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews {
    self.backgroundColor = color18_other_xgw;
    
    self.stockNameTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.stockNameTitleLabel];
    self.stockNameTitleLabel.font = font0_common_xgw;
    self.stockNameTitleLabel.textColor = color2_text_xgw;
    self.stockNameTitleLabel.text = @"名称代码";
    
    self.priceTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.priceTitleLabel];
    self.priceTitleLabel.font = font0_common_xgw;
    self.priceTitleLabel.textColor = color2_text_xgw;
    self.priceTitleLabel.text = @"最新";
    
    self.increaseTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.increaseTitleLabel];
    self.increaseTitleLabel.font = font0_common_xgw;
    self.increaseTitleLabel.textColor = color2_text_xgw;
    self.increaseTitleLabel.text = @"涨幅";
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat averageWidth = self.width * 0.25f;
    
    [self.stockNameTitleLabel sizeToFit];
    self.stockNameTitleLabel.x = (averageWidth * 2 - self.stockNameTitleLabel.width) / 2.0f;
    self.stockNameTitleLabel.y = (self.height - self.stockNameTitleLabel.height) / 2.0f;
    
    [self.priceTitleLabel sizeToFit];
    self.priceTitleLabel.x = averageWidth * 2 + (averageWidth - self.priceTitleLabel.width) / 2.0f;
    self.priceTitleLabel.y = (self.height - self.priceTitleLabel.height) / 2.0f;
    
    [self.increaseTitleLabel sizeToFit];
    self.increaseTitleLabel.x = averageWidth * 3 + (averageWidth - self.increaseTitleLabel.width) / 2.0f;
    self.increaseTitleLabel.y = (self.height - self.increaseTitleLabel.height) / 2.0f;
}

@end
