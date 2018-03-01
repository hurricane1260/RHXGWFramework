//
//  RightTableCell.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/20.
//
//

#import "RightTableCell.h"
//#import "DealHistoryListVO.h"
#import "HistoryTreadVO.h"


@interface RightTableCell ()
/**成交价*/
@property (nonatomic, strong) UILabel *priceLabel;
/**成交额*/
@property (nonatomic, strong) UILabel *buySellAmountLabel;
/**成交量*/
@property (nonatomic, strong) UILabel *tradeAmountLabel;
/**佣金*/
@property (nonatomic ,strong) UILabel * poundageLabel;
/**印花税*/
@property (nonatomic,strong) UILabel * stampDutyLabel;
/**过户费*/
@property (nonatomic,strong) UILabel * clearingFeeLabel;
/**备注*/
@property (nonatomic,strong)UILabel *  remarkLabel;

//@property (nonatomic, strong) DealHistoryListVO *historyVO;
@property (nonatomic, strong) HistoryTreadListVO *historyVO;

@end


@implementation RightTableCell
+(NSString *)reuseIdentifier{
    return @"RightTableCell";
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    self.priceLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    
     self.buySellAmountLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.buySellAmountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.buySellAmountLabel];
    
    self.tradeAmountLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.tradeAmountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.tradeAmountLabel];
    
    self.poundageLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.poundageLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.poundageLabel];
    
    self.stampDutyLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.stampDutyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.stampDutyLabel];
    
    self.clearingFeeLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.clearingFeeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.clearingFeeLabel];
    
    self.remarkLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    self.remarkLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.remarkLabel];
    
    [self.contentView addAutoLineWithColor:color16_other_xgw];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger width = 90;
    
    /**成交价*/
    self.priceLabel.frame = CGRectMake(0, 0, width, self.contentView.size.height);
    
    /**成交量*/
    self.tradeAmountLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame), 0, width, self.contentView.size.height);
    /**成交额*/
    self.buySellAmountLabel.frame = CGRectMake(CGRectGetMaxX(self.tradeAmountLabel.frame), 0, width, self.contentView.size.height);
    
    
    /**手续费*/
    self.poundageLabel.frame = CGRectMake(CGRectGetMaxX(self.buySellAmountLabel.frame), 0, width, self.contentView.size.height);
    /**印花税*/
    self.stampDutyLabel.frame = CGRectMake(CGRectGetMaxX(self.poundageLabel.frame), 0, width, self.contentView.size.height);
    /**结算费*/
    self.clearingFeeLabel.frame = CGRectMake(CGRectGetMaxX(self.stampDutyLabel.frame), 0, width, self.contentView.size.height);
    /**备注*/
    self.remarkLabel.frame = CGRectMake(CGRectGetMaxX(self.clearingFeeLabel.frame), 0, 120, self.contentView.size.height);
    
    self.contentView.autoLine.frame = CGRectMake(0, self.contentView.size.height-0.5, self.contentView.size.width, 0.5);
}

-(void)setCellData:(id)cellData{
    
    if (![cellData isKindOfClass:[HistoryTreadListVO class]]) {
        return;
    }
    if (self.historyVO) {
        self.historyVO = nil;
    }
    self.historyVO = cellData;
    [self clearData];
    [self applyHistoryData];
    [self setNeedsLayout];
}

-(void)clearData{
    self.priceLabel.text = nil;
    self.buySellAmountLabel.text = nil;
    self.tradeAmountLabel.text = nil;
    self.poundageLabel.text = nil;
    self.stampDutyLabel.text = nil;
    self.clearingFeeLabel.text = nil;
    self.remarkLabel.text = nil;
    
}
-(void)applyHistoryData{
      UIColor *textColor = [self.historyVO.mark isEqualToString:@"买"]?color6_text_xgw:color8_text_xgw;
    
    self.priceLabel.textColor = textColor;
    self.buySellAmountLabel.textColor = textColor;
    self.tradeAmountLabel.textColor = textColor;
    self.poundageLabel.textColor = textColor;
    self.stampDutyLabel.textColor = textColor;
    self.clearingFeeLabel.textColor = textColor;
    self.remarkLabel.textColor = textColor;
    
    
     self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.historyVO.businessPrice.doubleValue];
    self.buySellAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.historyVO.businessBalance.doubleValue];
    self.tradeAmountLabel.text = self.historyVO.businessAmount.stringValue;
    self.remarkLabel.text = [NSString stringWithFormat:@"%@",self.historyVO.name];
    self.poundageLabel.text = [NSString stringWithFormat:@"%@",self.historyVO.fare0];
    self.stampDutyLabel.text = [NSString stringWithFormat:@"%@",self.historyVO.fare1];
    self.clearingFeeLabel.text = [NSString stringWithFormat:@"%@",self.historyVO.fare2];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
