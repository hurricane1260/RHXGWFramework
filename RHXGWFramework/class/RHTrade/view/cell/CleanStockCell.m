//
//  CleanStockCell.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/25.
//
//

#import "CleanStockCell.h"
#import "CleanStockVO.h"

@interface CleanStockCell ()
/**股票名称*/
@property (nonatomic,strong)UILabel * stockNameLabel;
/**持股时间*/
@property (nonatomic, strong) UILabel *tradeTimeLabel;
/**持股天数*/
@property (nonatomic, strong) UILabel * holdStockDays;
/**盈亏额*/
@property (nonatomic, strong) UILabel * ProfitLossAmount;
/**收益率*/
@property (nonatomic, strong) UILabel * ProfitLossScale;

@property (nonatomic, strong) CleanStockVO * cleanStockVO;

@end


@implementation CleanStockCell
+(NSString *)cellReuseIdentifier{
    return @"CleanStockCell";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubViews];
    }
    
    return self;
    
}
-(void)initSubViews{
    
    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.stockNameLabel];
    
    self.tradeTimeLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.tradeTimeLabel];
    
    self.holdStockDays = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.holdStockDays];

    
    self.ProfitLossAmount = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.ProfitLossAmount];
    
    self.ProfitLossScale = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.ProfitLossScale];
    
    [self.contentView addAutoLineWithColor:color16_other_xgw];
    
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.stockNameLabel sizeToFit];
    self.stockNameLabel.origin = CGPointMake(20, self.contentView.size.height/2-3-self.stockNameLabel.size.height);
    
    [self.tradeTimeLabel sizeToFit];
    self.tradeTimeLabel.origin = CGPointMake(self.stockNameLabel.origin.x, CGRectGetMaxY(self.stockNameLabel.frame)+6);
    
    [self.ProfitLossScale sizeToFit];
    self.ProfitLossScale.origin = CGPointMake(self.contentView.size.width-20-self.ProfitLossScale.size.width, (self.contentView.size.height-self.ProfitLossScale.size.height)/2);
    
    [self.holdStockDays sizeToFit];
    if (IS_IPHONE_6P) {
           self.holdStockDays.origin = CGPointMake(self.contentView.size.width/2-30-self.holdStockDays.size.width, (self.contentView.size.height-self.holdStockDays.size.height)/2);
    }else{
    
    self.holdStockDays.origin = CGPointMake(self.contentView.size.width/2-20-self.holdStockDays.size.width, (self.contentView.size.height-self.holdStockDays.size.height)/2);
    }
    
    
    [self.ProfitLossAmount sizeToFit];
    
    if (IS_IPHONE_5) {
        self.ProfitLossAmount.origin = CGPointMake(self.contentView.size.width/2+60-self.ProfitLossAmount.size.width, (self.contentView.size.height-self.holdStockDays.size.height)/2);
    }else{
    self.ProfitLossAmount.origin = CGPointMake(self.contentView.size.width/2+70-self.ProfitLossAmount.size.width, (self.contentView.size.height-self.holdStockDays.size.height)/2);
    }
    
    
    self.contentView.autoLine.frame = CGRectMake(0, self.contentView.size.height-0.5, self.contentView.size.width, 0.5);
    
}
-(void)setCellData:(id)cellData{
    
    if (![cellData isKindOfClass:[CleanStockVO class]]) {
        return;
    }
    
    if (self.cleanStockVO) {
        self.cleanStockVO = nil;
    }
    self.cleanStockVO = cellData;
    [self clearData];
    [self applyHistoryData];
    [self setNeedsLayout];
    
}
-(void)clearData{
    self.stockNameLabel.text = nil;
    self.tradeTimeLabel.text = nil;
    self.holdStockDays.text = nil;
    self.ProfitLossAmount.text = nil;
    self.ProfitLossScale.text = nil;
   
}
-(void)applyHistoryData{
   
    self.stockNameLabel.text = self.cleanStockVO.stockName;
   // self.tradeTimeLabel.text = [TimeUtils getTimeStringWithNumber:self.cleanStockVO.holdMinDate formatString:@"yyyy/MM/dd"];
    self.tradeTimeLabel.text =[self tradeTime:[NSString stringWithFormat:@"%@",self.cleanStockVO.holdMinDate ]] ;
    self.holdStockDays.text = [NSString stringWithFormat:@"%@天",self.cleanStockVO.holdTime];
    
     UIColor *textColor = [self.cleanStockVO.profit floatValue] > 0?color6_text_xgw:color8_text_xgw;
    self.ProfitLossAmount.textColor = textColor;
    self.ProfitLossScale.textColor = textColor;
    
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",self.cleanStockVO.profit]]) {
        self.ProfitLossAmount.text = @"--";
    }else{
        self.ProfitLossAmount.text = [NSString stringWithFormat:@"%@",self.cleanStockVO.profit];
 
    }
    
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",self.cleanStockVO.profitYld]]) {
        self.ProfitLossScale.text = @"--";
        
    }else{
        
        CGFloat profitValue = [self.cleanStockVO.profitYld floatValue];
        
        self.ProfitLossScale.text = [NSString stringWithFormat:@"%.2f%%",profitValue*100];
        
    }

 }
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(NSString *)tradeTime:(NSString *)str{
    
   // 20170201
    if (str.length<8||str==nil) {
        return @"--";
    }
    NSString * a =[str substringWithRange:NSMakeRange(2,6)];
    NSString * b = [a substringWithRange:NSMakeRange(0, 2)];
    NSString * c = [a substringWithRange:NSMakeRange(2, 2)];
    NSString * d = [a substringWithRange:NSMakeRange(4, 2)];
    NSString * dateTime = [NSString stringWithFormat:@"%@/%@/%@",b,c,d];
    
    return dateTime;
    
}

@end
