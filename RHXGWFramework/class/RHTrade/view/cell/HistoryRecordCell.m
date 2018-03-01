//
//  HistoryRecordCell.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/27.
//
//

#import "HistoryRecordCell.h"
#import "HistoryRecordVO.h"
@interface HistoryRecordCell ()
/**转账类型Lb*/
@property (nonatomic,strong)UILabel *  flagNameLb;
/**转账时间*/
@property (nonatomic,strong)UILabel *  transferTimeLb;
/**转账金额*/
@property (nonatomic,strong)UILabel * clearBalanceLb;
/**成功 文本*/
@property (nonatomic,strong)UILabel *  resultLb;
@property (nonatomic,strong) HistoryRecordListVO * VO;


@end

@implementation HistoryRecordCell

+(NSString *)cellReuseIdentifier{
    
    return @"HistoryRecordCell";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubViews];
    }
    
    return self;
}
-(void)initSubViews{
    
    self.flagNameLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.flagNameLb];
    
    self.transferTimeLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.transferTimeLb];
    
    self.clearBalanceLb = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.clearBalanceLb];
    
    self.resultLb = [UILabel didBuildLabelWithText:@"成功" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.resultLb];
    
    [self.contentView addAutoLineWithColor:color16_other_xgw];
    
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.flagNameLb sizeToFit];
    self.flagNameLb.origin = CGPointMake(20, self.contentView.size.height/2-2-self.flagNameLb.size.height);
    [self.transferTimeLb sizeToFit];
    self.transferTimeLb.origin = CGPointMake(self.flagNameLb.origin.x, self.contentView.size.height/2+2);
    [self.clearBalanceLb sizeToFit];
    self.clearBalanceLb.origin = CGPointMake(self.contentView.size.width-20-self.clearBalanceLb.size.width, self.flagNameLb.origin.y);
    [self.resultLb sizeToFit];
    self.resultLb.origin = CGPointMake(self.contentView.size.width-20-self.resultLb.size.width, self.transferTimeLb.origin.y);
    
    self.contentView.autoLine.frame = CGRectMake(0, self.contentView.size.height-0.5, self.contentView.size.width, 0.5);
    
    
}
-(void)setCellData:(id)cellData{
    
    if (![cellData isKindOfClass:[HistoryRecordListVO class]]) {
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
    self. flagNameLb.text = nil;
    self.transferTimeLb.text = nil;
    self.clearBalanceLb.text= nil;
    self.resultLb.text= nil;
    
}
-(void)applyHistoryData{
    
    self. flagNameLb.text = self.VO.flagName;
    self.transferTimeLb.text =[self tradeTime:[NSString stringWithFormat:@"%@",self.VO.tradeDate]];
    self.clearBalanceLb.text = [NSString stringWithFormat:@"%@",self.VO.clearBalance];
    self.resultLb.text = @"成功";
    
}
-(NSString *)tradeTime:(NSString *)str{
   // 20170102
    if (str.length<8||[NSString isBlankString:str]) {
        return @"--";
    }
    
    NSString * a = [str substringWithRange:NSMakeRange(0,4)];
    NSString * b = [str substringWithRange:NSMakeRange(4, 2)];
    NSString * c = [str substringWithRange:NSMakeRange(6, 2)];
    NSString * dateTime = [NSString stringWithFormat:@"%@-%@-%@",a,b,c];


    return dateTime;
    
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
