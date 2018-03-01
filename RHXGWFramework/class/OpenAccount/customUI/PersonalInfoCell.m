//
//  PersonalInfoCell.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/11.
//
//

#import "PersonalInfoCell.h"
#import "PersonInfoVo.h"

@interface PersonalInfoCell ()

kRhPStrong UILabel * titleLabel;

@end

@implementation PersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.titleLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.titleLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(20.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);

}

- (void)loadDataWithModel:(id)model{
    if (!model || ![model isKindOfClass:[PersonInfoVo class]]) {
        return;
    }
    PersonInfoVo * vo = model;
    self.titleLabel.text = vo.dict_prompt;
    [self setNeedsLayout];
}

@end
