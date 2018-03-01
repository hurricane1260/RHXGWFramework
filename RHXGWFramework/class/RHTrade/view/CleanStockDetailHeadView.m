//
//  CleanStockDetailHeadView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/25.
//
//

#import "CleanStockDetailHeadView.h"
#import "TradeListHeadView.h"
#import "CleanStockVO.h"



@interface CleanStockDetailHeadView ()
@property (nonatomic,strong)UIView * topView;
/**累计盈亏*/
@property (nonatomic,strong)UILabel * ProfitLossLb;
/**百分比*/
@property (nonatomic,strong)UILabel * ProfitLossScaleLb;
/**文本 累计盈亏*/
@property (nonatomic,strong)UILabel * ProfitLossText;
/**持股天数*/
@property  (nonatomic,strong)UILabel * holdStockDaysLb;
/**交易费用*/
@property (nonatomic,strong)UILabel * treadCostLb;
/**累计投入*/
@property (nonatomic,strong)UILabel * treadInvestmentLb;
/**累计收入*/
@property (nonatomic,strong)UILabel * treadIncomeLb;

@property (nonatomic,strong)UIView * lineView;

/**列表头*/
@property (nonatomic,strong)UIView * listHeadView;
@property (nonatomic, strong) NSMutableArray *titleLabelList;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@end

@implementation CleanStockDetailHeadView
-(instancetype)initWithTitleLabelList:(NSArray *)titleLlist{
    
    if (self = [super init]) {
        _titleLabelList = [NSMutableArray array];
         _titleList = titleLlist;
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    self.topView = [[UIView alloc]init];
    [self addSubview:self.topView];
    
    self.ProfitLossLb = [UILabel didBuildLabelWithText:@"" font:font6_boldCommon_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.ProfitLossLb];
    
    self.ProfitLossScaleLb = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.ProfitLossScaleLb];
    
    self.ProfitLossText = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.ProfitLossText];
    
    self.holdStockDaysLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.holdStockDaysLb];
    
    self.treadCostLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.treadCostLb];
    
    self.treadInvestmentLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.treadInvestmentLb];
    
    self.treadIncomeLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.treadIncomeLb];
    
    
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = color16_other_xgw;
    [self addSubview:self.lineView];
    
    self.listHeadView = [[UIView alloc]init];
    self.listHeadView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.listHeadView];

    if (self.titleLabelList.count > 0) {
        [self.titleLabelList removeAllObjects];
    }
    for (NSString *title in _titleList) {
        UILabel *titleLabel = [UILabel didBuildLabelWithText:title font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        [self.titleLabelList addObject:titleLabel];
        [self.listHeadView addSubview:titleLabel];
    }
    
    self.line1 = [[UIView alloc]init];
    [self.listHeadView addSubview:self.line1];
    self.line1.backgroundColor = color16_other_xgw;
    
    self.line2 = [[UIView alloc]init];
    [self.listHeadView addSubview:self.line2];
    self.line2.backgroundColor = color16_other_xgw;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.topView.frame = CGRectMake(0, 0, self.size.width, 190);
    
    /**累计盈亏*/
    [self.ProfitLossLb sizeToFit];
    self.ProfitLossLb.origin = CGPointMake((self.size.width-self.ProfitLossLb.size.width)/2, 30);
    
    /**百分比*/
    [self.ProfitLossScaleLb sizeToFit];
    self.ProfitLossScaleLb.origin = CGPointMake((self.size.width-self.ProfitLossScaleLb.size.width)/2, CGRectGetMaxY(self.ProfitLossLb.frame)+5);
    
    /**文本 累计盈亏*/
    [self.ProfitLossText sizeToFit];
    self.ProfitLossText.origin = CGPointMake((self.size.width-self.ProfitLossText.size.width)/2, CGRectGetMaxY(self.ProfitLossScaleLb.frame)+10);
    
    
    /**持股天数*/
    [self.holdStockDaysLb sizeToFit];
    self.holdStockDaysLb.origin = CGPointMake(36, CGRectGetMaxY(self.ProfitLossText.frame)+20);
    
    /**交易费用*/
    [self.treadCostLb sizeToFit];
    self.treadCostLb.origin = CGPointMake(self.holdStockDaysLb.origin.x, CGRectGetMaxY(self.holdStockDaysLb.frame)+12);
    
    
    /**累计投入*/
    [self.treadInvestmentLb sizeToFit];
    self.treadInvestmentLb.origin = CGPointMake(self.size.width/2+20, self.holdStockDaysLb.origin.y);
    
    
    /**累计收入*/
    [self.treadIncomeLb sizeToFit];
    self.treadIncomeLb.origin = CGPointMake(self.treadInvestmentLb.origin.x, self.treadCostLb.origin.y);
    
    
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.size.width, 8);
    self.listHeadView.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.size.width, 27);
    
    self.line1.size = CGSizeMake(self.width, 0.5f);
    
    CGFloat averWidth = self.width / self.titleLabelList.count;
    
            for (int i = 0; i < self.titleLabelList.count; i++) {
            UILabel *titleLabel  = [self.titleLabelList objectAtIndex:i];
            [titleLabel sizeToFit];
                if (i==0) {
                titleLabel.x = 20;

                }else if (i==3){
                    
                titleLabel.x = self.size.width-20-titleLabel.size.width;
 
                }else{
                    titleLabel.x = averWidth * i + (averWidth - titleLabel.width) * 0.5f;
  
                }
                
            titleLabel.y = (self.listHeadView.height - titleLabel.height) * 0.5f;
        }
    
    self.line2.y = self.listHeadView.height - 0.5f;
    self.line2.size = self.line1.size;
    
    
}
-(void)setViewData:(id)viewData{
    
    NSDictionary * dic = viewData;
    NSInteger profit = [[dic objectForKey:@"profit"] integerValue];
    UIColor *  textColor = profit >0 ?color6_text_xgw:color7_text_xgw;
    
    self.ProfitLossLb.textColor = textColor;
    self.ProfitLossScaleLb.textColor = textColor;
    self.ProfitLossText.text = @"累计盈亏";
    
    
    if ([NSString isBlankString:[dic objectForKey:@"profit"]]) {
        self.ProfitLossLb.text = @"--";

    }else{
        self.ProfitLossLb.text = [dic objectForKey:@"profit"];
 
    }
    
    if ([NSString isBlankString:[dic objectForKey:@"profitYld"]]) {
         self.ProfitLossScaleLb.text = @"--";
    }else{
        CGFloat value = [[dic objectForKey:@"profitYld"] floatValue];
        self.ProfitLossScaleLb.text = [NSString stringWithFormat:@"%.2f%%",value*100];
    }
    
    
    if ([NSString isBlankString:[dic objectForKey:@"holdTime"]]) {
        self.holdStockDaysLb.text = @"持股天数: --";
    }else{
        self.holdStockDaysLb.text = [NSString stringWithFormat:@"持股天数: %@天",[dic objectForKey:@"holdTime"]];
  
    }
    
    
    if ([NSString isBlankString:[dic objectForKey:@"fare"]]) {
      self.treadCostLb.text = @"交易费用: --";
    }else{
        self.treadCostLb.text =[NSString stringWithFormat:@"交易费用: %@",[dic objectForKey:@"fare"]];
 
    }
    
    if ([NSString isBlankString:[dic objectForKey:@"totalBalan2"]]) {
         self.treadInvestmentLb.text = @"累计投入: --";
    }else{
//         self.treadInvestmentLb.text = [NSString stringWithFormat:@"累计投入: %@",[dic objectForKey:@"totalBalan2"]];
        NSString * money =[NSString moneyTenThousandConvertWithString:[dic objectForKey:@"totalBalan2"]];
        
           self.treadInvestmentLb.text = [NSString stringWithFormat:@"累计投入: %@",money];
    }
    
  
    if ([NSString isBlankString:[dic objectForKey:@"totalBalan1"]]) {
       self.treadIncomeLb.text = @"累计收入: --";
    }else{
//        self.treadIncomeLb.text =[NSString stringWithFormat:@"累计收入: %@",[dic objectForKey:@"totalBalan1"]];
        NSString * money =[NSString moneyTenThousandConvertWithString:[dic objectForKey:@"totalBalan1"]];
        self.treadIncomeLb.text = [NSString stringWithFormat:@"累计收入: %@",money];
 
    }
    
    
    
}

@end
