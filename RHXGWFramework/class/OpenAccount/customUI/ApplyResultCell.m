//
//  ApplyResultCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/4.
//
//

#import "ApplyResultCell.h"
#import "CRHAccVo.h"

@interface ApplyResultCell ()

kRhPStrong UILabel * titleLabel;

kRhPStrong UILabel * detailLabel;

@end

@implementation ApplyResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)  reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.titleLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.detailLabel];
 
    [self.contentView addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.detailLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(24.0f, (self.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    self.detailLabel.frame = CGRectMake(self.width - 24.0f - self.detailLabel.width, (self.height - self.detailLabel.height)/2.0f, self.detailLabel.width, self.detailLabel.height);
    
    self.contentView.autoLine.frame = CGRectMake(0, 0, self.width, 0.5f);
}

- (void)loadDataWithModel:(id)model{
    if (!model || ![model isKindOfClass:[CRHAccVo class]]) {
        return;
    }
    CRHAccVo * vo = model;
    self.titleLabel.text = vo.title;
    self.detailLabel.text = vo.subTitle;
    
    [self setNeedsLayout];
}


@end
