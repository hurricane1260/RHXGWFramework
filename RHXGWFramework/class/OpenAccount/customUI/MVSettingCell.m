//
//  MVSettingCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/21.
//
//

#import "MVSettingCell.h"
#import "MVSettingVo.h"

@interface MVSettingCell ()

kRhPStrong UIImageView * imgView;

kRhPStrong UILabel * titleLabel;

@end

@implementation MVSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)  reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    self.imgView = [[UIImageView alloc] initWithImage:img_open_trash];
    [self.contentView addSubview:self.imgView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addAutoLineWithColor:color16_other_xgw];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imgView.frame = CGRectMake(10, (self.height - self.imgView.height )/2.0f, self.imgView.width, self.imgView.height);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + 8.0f,(self.height - self.titleLabel.height )/2.0f , self.titleLabel.width, self.titleLabel.height);
    
    self.contentView.autoLine.frame = CGRectMake(0, self.height - 0.5f, self.width, 0.5f);
    
}

- (void)loadDataWithModel:(id)model{
    if (!model || ![model isKindOfClass:[MVSettingVo class]]) {
        return;
    }
    MVSettingVo * vo = model;
    [self.imgView setImage:vo.img];
    self.titleLabel.text = vo.title;
    [self setNeedsLayout];
}

@end
