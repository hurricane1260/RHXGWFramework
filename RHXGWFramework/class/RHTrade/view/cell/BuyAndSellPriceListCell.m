//
//  BuyAndSellPriceListCell.m
//  stockscontest
//
//  Created by rxhui on 15/6/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "BuyAndSellPriceListCell.h"
#import "BuyAndSellPriceVO.h"

@interface BuyAndSellPriceListCell ()

@property (nonatomic,strong) UIView *subContentView;

@property (nonatomic,strong) UILabel *buyerOrSalorLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *countLabel;

@end

@implementation BuyAndSellPriceListCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews {
    self.subContentView = [[UIView alloc]init];
    [self.contentView addSubview:self.subContentView];
    self.subContentView.backgroundColor = [UIColor whiteColor];
    
    self.buyerOrSalorLabel = [[UILabel alloc]init];
    [self.subContentView addSubview:self.buyerOrSalorLabel];
    self.buyerOrSalorLabel.font = font1_number_xgw;
    self.buyerOrSalorLabel.textColor = color2_text_xgw;
    
    self.priceLabel = [[UILabel alloc]init];
    [self.subContentView addSubview:self.priceLabel];
    self.priceLabel.font = font1_number_xgw;
    self.priceLabel.backgroundColor = [UIColor whiteColor];
//    self.priceLabel.textColor = color4_text_xgw;
//    self.priceLabel.layer.borderColor = color6_text_xgw.CGColor;
//    self.priceLabel.layer.borderWidth = 0.5f;
//    self.priceLabel.layer.masksToBounds = YES;
    
    self.countLabel = [[UILabel alloc]init];
    [self.subContentView addSubview:self.countLabel];
    self.countLabel.font = font1_number_xgw;
    self.countLabel.textColor = color2_text_xgw;
}

-(void)setCellData:(id)aData {
    if (_cellData) {
        _cellData = nil;
    }
    _cellData = aData;
    if (![_cellData isKindOfClass:[BuyAndSellPriceVO class]]) {
        return;
    }
    [self applyData];
}

-(void)applyData {
    BuyAndSellPriceVO *itemVO = (BuyAndSellPriceVO *)self.cellData;
    self.buyerOrSalorLabel.text = itemVO.buyerOrSalor;
    if (self.isStock) {
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f",itemVO.price.floatValue];
    }
    else {
        self.priceLabel.text = [NSString stringWithFormat:@"%.3f",itemVO.price.floatValue];
    }
    
    if (itemVO.price.floatValue > - 0.00001f && itemVO.price.floatValue < 0.00001f) {
        self.priceLabel.text = @"--";
    }
    
    if ([self.priceLabel.text isEqualToString:@"--"]) {
        self.priceLabel.textColor = color4_text_xgw;
    }
    else if (itemVO.price.floatValue > itemVO.openPrice.floatValue) {
        self.priceLabel.textColor = color6_text_xgw;
    }
    else if (itemVO.price.floatValue < itemVO.openPrice.floatValue){
        self.priceLabel.textColor = color7_text_xgw;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%@",itemVO.amount];
    [self setNeedsLayout];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.subContentView.frame = self.contentView.bounds;
    
    [self.buyerOrSalorLabel sizeToFit];
    self.buyerOrSalorLabel.y = (self.height - self.buyerOrSalorLabel.height) / 2.0f;
    
    [self.priceLabel sizeToFit];
    self.priceLabel.x = self.buyerOrSalorLabel.x + self.buyerOrSalorLabel.width + 12.5f;
    self.priceLabel.y = (self.height - self.priceLabel.height) / 2.0f;
    
    [self.countLabel sizeToFit];
    self.countLabel.x = self.width - self.countLabel.width;
    self.countLabel.y = (self.height - self.countLabel.height) / 2.0f;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    UIColor *tempColor = self.priceLabel.backgroundColor;
//    self.priceLabel.backgroundColor = self.priceLabel.textColor;
//    self.priceLabel.textColor = tempColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    UIColor *tempColor = self.priceLabel.backgroundColor;
//    self.priceLabel.backgroundColor = self.priceLabel.textColor;
//    self.priceLabel.textColor = tempColor;
}


@end
