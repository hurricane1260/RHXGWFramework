//
//  RHSysTableViewCell.m
//  TZYJ_IPhone
//
//  Created by liyan on 16/4/28.
//
//

#import "RHSysTableViewCell.h"
#import "RHPushMessageVO.h"
#import "TimeUtils.h"

@interface RHSysTableViewCell()

@property (nonatomic,strong) UILabel * titleLabel;

//@property (nonatomic,strong) UILabel * contentLabel;

@property (nonatomic,strong) UILabel * markLabel;

@property (nonatomic,strong) UILabel * dateLabel;

@end

@implementation RHSysTableViewCell
#pragma mark------初始化及布局------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
//    self.titleLabel = [UILabel didBuildLabelWithText:@"" fontSize:16.0f textColor:color2_text_xgw wordWrap:NO];
    self.titleLabel = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
//    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
//    
//    self.contentLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
//    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.contentLabel.numberOfLines = 1;
//    [self.contentView addSubview:self.contentLabel];
    
//    self.markLabel = [UILabel didBuildLabelWithText:@"" fontSize:9 textColor:color6_text_xgw wordWrap:NO];
    self.markLabel = [UILabel didBuildLabelWithText:@"" font:[UIFont systemFontOfSize:9.0f] textColor:color6_text_xgw wordWrap:NO];
    self.markLabel.textAlignment = NSTextAlignmentCenter;
    self.markLabel.layer.borderColor = [color6_text_xgw CGColor];
    self.markLabel.layer.borderWidth = 1.0f;
    [self.contentView addSubview:self.markLabel];
    
//    self.dateLabel = [UILabel didBuildLabelWithText:@"" fontSize:10.0f textColor:color4_text_xgw wordWrap:NO];
    self.dateLabel = [UILabel didBuildLabelWithText:@"" font:font0_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.dateLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self.titleLabel sizeToFit];
//    [self.contentLabel sizeToFit];
    [self.markLabel sizeToFit];
    [self.dateLabel sizeToFit];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font3_common_xgw,NSFontAttributeName, nil];
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.width - 20.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    self.titleLabel.frame = CGRectMake(10.0f, 15.0f, size.width, size.height);
//    self.contentLabel.frame = CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame) + 5.0f, self.width - 20.0f, self.contentLabel.height);
    self.dateLabel.frame = CGRectMake(self.width - 10.0f - self.dateLabel.width, CGRectGetMaxY(self.titleLabel.frame) + 10.0f, self.dateLabel.width, self.dateLabel.height);

    self.markLabel.frame = CGRectMake(self.dateLabel.x - 25.0f - 6.0f, CGRectGetMaxY(self.titleLabel.frame), 25.0f, 14.0f);
    self.markLabel.center = CGPointMake(self.markLabel.center.x, self.dateLabel.center.y);
    
}

- (void)dealloc{
    self.titleLabel = nil;
    self.dateLabel = nil;
    
}

#pragma mark------刷新数据------
- (void)loadDataWithModel:(id)model{
    
    if (![model isKindOfClass:[RHPushMessageVO class]]) {
        return;
    }
    RHPushMessageVO * messVO = (RHPushMessageVO *)model;
    self.titleLabel.text = messVO.contentTitle;
    if (messVO.type != nil) {
        switch ([messVO.type integerValue]) {
            case 3:
                self.markLabel.text = @"活动";
                break;
            case 4:
                self.markLabel.text = @"通知";
            default:
                break;
        }
    }
    
    if ([messVO.time boolValue] != 0) {
        self.dateLabel.text = [TimeUtils getTimeStringWithNumber:messVO.time formatString:@"MM-dd HH:mm"];
    }
    [self setNeedsLayout];

}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
