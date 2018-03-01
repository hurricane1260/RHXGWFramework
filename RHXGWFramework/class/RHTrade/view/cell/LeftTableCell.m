//
//  LeftTableCell.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/20.
//
//

#import "LeftTableCell.h"
#import "HistoryTreadVO.h"

@interface LeftTableCell ()
@property (nonatomic, strong) UIImageView *buySellImage;
/** 股票名称*/
@property (nonatomic, strong) UILabel *stockNameLabel;
/** 交易时间*/
@property (nonatomic, strong) UILabel *tradeTimeLabel;
//@property (nonatomic, strong) DealHistoryListVO *historyVO;
@property (nonatomic, strong)HistoryTreadListVO * historyVO;


@end

@implementation LeftTableCell

+(NSString *)reuseIdentifier{
    return @"LeftTableCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


-(void)initSubviews{
    
    
    self.buySellImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.buySellImage];
    
    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.stockNameLabel];
    
    self.tradeTimeLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.tradeTimeLabel];
    
    [self.contentView addAutoLineWithColor:color16_other_xgw];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.buySellImage.size = self.buySellImage.image.size;
    self.buySellImage.x = 12.0f;
    self.buySellImage.y = (self.height - self.buySellImage.height) * 0.5f;
    
    [self.stockNameLabel sizeToFit];
    self.stockNameLabel.x = self.buySellImage.x + self.buySellImage.width + 5.0f;
    self.stockNameLabel.y = self.height/2 - self.stockNameLabel.height +2;
    
    [self.tradeTimeLabel sizeToFit];
    self.tradeTimeLabel.x = self.stockNameLabel.x;
    self.tradeTimeLabel.y = self.stockNameLabel.y + self.stockNameLabel.height+2;
    
    self.contentView.autoLine.frame = CGRectMake(0, self.contentView.size.height-0.5, self.contentView.size.width, 0.5);
    
}
-(void)setCellData:(id)cellData{
    
    if (![cellData isKindOfClass:[HistoryTreadListVO class]]) {
        return;
    }
    if (_historyVO) {
        _historyVO = nil;
    }
    self.historyVO = cellData;

    [self clearData];
    [self applyHistoryData];
    [self setNeedsLayout];
    
    
}
- (void)applyHistoryData {
    UIColor *textColor = [self.historyVO.mark isEqualToString:@"买"]?color6_text_xgw:color8_text_xgw;
    self.stockNameLabel.textColor = textColor;
    self.tradeTimeLabel.textColor = textColor;
  
    
    self.buySellImage.image = [self.historyVO.mark isEqualToString:@"买"]?[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_buy"]:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_sell"];
    
    self.stockNameLabel.text = self.historyVO.stockName;
   
    
    if (self.viewType == TradeControllerTypeReal) {
        self.tradeTimeLabel.text = [self getDateStringBy:self.historyVO.tradeDate];
        
    }
    else {
        self.tradeTimeLabel.text = [TimeUtils getTimeStringWithNumber:self.historyVO.tradeDate formatString:@"yyyy/MM/dd"];
    }
}

-(NSString *)getDateStringBy:(NSNumber *)date
{
    NSInteger y, m, d;
    y = (date.integerValue / 10000) % 100;
    m = (date.integerValue % 10000) / 100;
    d = date.integerValue % 100;
    NSString *result = [NSString stringWithFormat:@"%02ld/%02ld/%02ld", (long)y, (long)m, (long)d];
    return result;
}

- (void)clearData {
    self.buySellImage.image = nil;
    self.stockNameLabel.text = nil;
    self.tradeTimeLabel.text = nil;
   
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
