//
//  CleanStockDetilCell.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/25.
//
//

#import "CleanStockDetilCell.h"
#import "CleanStocksTreadVO.h"

@interface CleanStockDetilCell ()
/**清仓 建仓*/
@property (nonatomic,strong)UILabel * holdingTypeLb;
/**清仓建仓的时间*/
@property (nonatomic,strong)UILabel * holdingTimeLb;
/**成交价*/
@property (nonatomic,strong)UILabel * treadPriceLb;
/**成交量*/
@property (nonatomic,strong)UILabel * tradeAmountLabel;
/**成交额*/
@property (nonatomic,strong)UILabel * buySellAmountLabel;
@property (nonatomic,strong)CleanStocksTreadListVO * VO;

@end

@implementation CleanStockDetilCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
    
}
-(void)initSubViews{
    self.holdingTypeLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.holdingTypeLb];
    
    self.holdingTimeLb = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.holdingTimeLb];
    
    self.treadPriceLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.treadPriceLb];
    
    
    self.tradeAmountLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.tradeAmountLabel];
    
    self.buySellAmountLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.buySellAmountLabel];
    
    [self.contentView addAutoLineWithColor:color16_other_xgw];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.holdingTypeLb sizeToFit];
    self.holdingTypeLb.origin = CGPointMake(20, self.contentView.size.height/2-self.holdingTypeLb.size.height-2);
    
    [self.holdingTimeLb sizeToFit];
    self.holdingTimeLb.origin = CGPointMake(self.holdingTypeLb.origin.x, CGRectGetMaxY(self.holdingTypeLb.frame)+4);
    
    [self.buySellAmountLabel sizeToFit];
    self.buySellAmountLabel.origin = CGPointMake(self.contentView.size.width-20-self.buySellAmountLabel.size.width, (self.contentView.size.height-self.buySellAmountLabel.size.height)/2);
    
    [self.treadPriceLb sizeToFit];
    if (IS_IPHONE_6P) {
        self.treadPriceLb.origin = CGPointMake(self.contentView.size.width/2-33-self.treadPriceLb.size.width, (self.contentView.size.height-self.treadPriceLb.size.height)/2);
    }else if(IS_IPHONE_6){
        
        self.treadPriceLb.origin = CGPointMake(self.contentView.size.width/2-30-self.treadPriceLb.size.width, (self.contentView.size.height-self.treadPriceLb.size.height)/2);
    }else if (IS_IPHONE_5){
        
                self.treadPriceLb.origin = CGPointMake(self.contentView.size.width/2-25-self.treadPriceLb.size.width, (self.contentView.size.height-self.treadPriceLb.size.height)/2);
    }else{
        
        self.treadPriceLb.origin = CGPointMake(self.contentView.size.width/2-33-self.treadPriceLb.size.width, (self.contentView.size.height-self.treadPriceLb.size.height)/2);
        
    }
    
    
    [self.tradeAmountLabel sizeToFit];
    
    if (IS_IPHONE_5) {
        self.tradeAmountLabel.origin = CGPointMake(self.contentView.size.width/2+55-self.tradeAmountLabel.size.width, (self.contentView.size.height-self.tradeAmountLabel.size.height)/2);
    }else if (IS_IPHONE_6){
        
        self.tradeAmountLabel.origin = CGPointMake(self.contentView.size.width/2+63-self.tradeAmountLabel.size.width, (self.contentView.size.height-self.tradeAmountLabel.size.height)/2);
        
    }
    else{
        self.tradeAmountLabel.origin = CGPointMake(self.contentView.size.width/2+70-self.tradeAmountLabel.size.width, (self.contentView.size.height-self.tradeAmountLabel.size.height)/2);
    }
    
    
    self.contentView.autoLine.frame = CGRectMake(0, self.contentView.size.height-0.5, self.contentView.size.width, 0.5);
}

- (void)setCellData:(id)cellData{
    
    if (![cellData isKindOfClass:[CleanStocksTreadListVO class]]) {
        return;
    }
    
    if (self.VO) {
        self.VO = nil;
    }
    self.VO = cellData;
    [self clearData];
    [self applyHistoryData];
    [self setNeedsLayout];
    
}

-(void)clearData{
   self. holdingTypeLb.text = nil;
    self.holdingTimeLb.text = nil;
    self.treadPriceLb.text= nil;
    self.tradeAmountLabel.text= nil;
    self.buySellAmountLabel.text= nil;
    
}
-(void)applyHistoryData{
    
    self. holdingTypeLb.text = self.VO.operationType;
    self.holdingTimeLb.text = [self tradeTime:[NSString stringWithFormat:@"%@",self.VO.tradeDate]];
    self.treadPriceLb.text = [NSString stringWithFormat:@"%@",self.VO.businessPrice];
    if ([self.VO.operationType isEqualToString:@"建仓"]) {
        self.tradeAmountLabel.text =[NSString stringWithFormat:@"+%@",self.VO.businessAmount];

    }else{
        self.tradeAmountLabel.text =[NSString stringWithFormat:@"%@",self.VO.businessAmount];

    }
    self.buySellAmountLabel.text = [NSString stringWithFormat:@"%@",self.VO.businessBalance];
    
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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
