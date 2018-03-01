//
//  BuyViewStockListCellTableViewCell.m
//  stockscontest
//
//  Created by rxhui on 15/6/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BuyViewStockListCell.h"
#import "StockListVO.h"
#import "SKCodeItemVO.h"

@interface BuyViewStockListCell ()

/*! @brief 股票名称 股票代码*/
@property (nonatomic,strong) UILabel *stockNameLabel;

/*! @brief 股票代码*/
@property (nonatomic,strong) UILabel *stockCodeLabel;

/*! @brief 对勾的图标*/
@property (nonatomic,strong) UIImageView *markView;

@property (nonatomic,strong) UIView *line;

@end

@implementation BuyViewStockListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)setCellData:(id)aData {
    if (_cellData) {
        _cellData = nil;
    }
    _cellData = aData;
    if ([_cellData isKindOfClass:[SKCodeItemVO class]]) {
        [self applyCellData];
    }
    if ([_cellData isKindOfClass:[StockListVO class]]) {
        [self applyHoldData];
    }
}

- (void)applyHoldData {
    StockListVO *itemVO = (StockListVO *)self.cellData;
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@",itemVO.stockName];
    self.stockCodeLabel.text = [NSString stringWithFormat:@"%@",itemVO.stockCode];
    self.stockString = [NSString stringWithFormat:@"%@ %@",itemVO.stockCode,itemVO.stockName];
    [self setNeedsLayout];
}

-(void)applyCellData {
    SKCodeItemVO *itemVO = (SKCodeItemVO *)self.cellData;
    self.stockNameLabel.text = [NSString stringWithFormat:@"%@",itemVO.name];
    self.stockCodeLabel.text = [NSString stringWithFormat:@"%@",itemVO.code];
    self.stockString = [NSString stringWithFormat:@"%@ %@",itemVO.code,itemVO.name];
    [self setNeedsLayout];
}

-(void)initSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    self.stockNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.stockNameLabel];
    self.stockNameLabel.font = font3_common_xgw;
    self.stockNameLabel.textColor = color2_text_xgw;
    
    self.stockCodeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.stockCodeLabel];
    self.stockCodeLabel.font = font3_number_xgw;
    self.stockCodeLabel.textColor = color2_text_xgw;
    
    self.markView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_bsbd_xz"]];
    [self.contentView addSubview:self.markView];
    self.markView.hidden = YES;
    
    self.line = [[UIView alloc]init];
    [self.contentView addSubview:self.line];
    self.line.backgroundColor = color16_other_xgw;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.stockNameLabel sizeToFit];
    self.stockNameLabel.x = 100.0f;
    self.stockNameLabel.y = (self.height - self.stockNameLabel.height) / 2.0f;
    
    [self.stockCodeLabel sizeToFit];
    self.stockCodeLabel.x = 20.0f;
    self.stockCodeLabel.y = self.stockNameLabel.y;
    
    self.markView.size = self.markView.image.size;
    self.markView.x = self.width - 37.0f - self.markView.width;
    self.markView.y = (self.height - self.markView.height) / 2.0f;
    
    self.line.y = self.height - 0.5f;
    self.line.width = self.width;
    self.line.height = 0.5f;
}

-(void)applyStringColorWithQueryString:(NSString *)queryString {
    if (!queryString) {
        return;
    }
    
    UIColor *selectedColor = color8_text_xgw;
    
    NSRange range = [self.stockCodeLabel.text rangeOfString:queryString];
    if (range.location == NSNotFound) {
        range = [self.stockNameLabel.text rangeOfString:queryString];
        if (range.location == NSNotFound) {
            return;
        }
        NSMutableAttributedString *mutaAttString = [[NSMutableAttributedString alloc]initWithString:self.stockNameLabel.text];
        [mutaAttString addAttribute:NSForegroundColorAttributeName value:selectedColor range:range];
        self.stockNameLabel.attributedText = mutaAttString;
    }
    else {
        NSMutableAttributedString *mutaAttString = [[NSMutableAttributedString alloc]initWithString:self.stockCodeLabel.text];
        [mutaAttString addAttribute:NSForegroundColorAttributeName value:selectedColor range:range];
        self.stockCodeLabel.attributedText = mutaAttString;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.stockNameLabel.textColor = color8_text_xgw;
        self.markView.hidden = NO;
    }
    else {
        self.stockNameLabel.textColor = color2_text_xgw;
        self.markView.hidden = YES;
    }
}

@end
