//
//  protocolCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/5.
//
//

#import "protocolCell.h"
#import "CRHProtocolListVo.h"

@interface protocolCell ()

kRhPStrong UILabel * protocolNameLabel;

kRhPStrong UIImageView * imgView;

@end

@implementation protocolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)  reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.protocolNameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.protocolNameLabel];
    
    self.imgView = [[UIImageView alloc] initWithImage:img_open_rightArrow];
    [self.contentView addSubview:self.imgView];
 
    [self.contentView addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.protocolNameLabel sizeToFit];
    self.protocolNameLabel.frame = CGRectMake(24.0f, (self.height - self.protocolNameLabel.height)/2.0f,self.protocolNameLabel.width, self.protocolNameLabel.height);
    
    self.imgView.frame = CGRectMake(self.width - self.imgView.width - 24.0f, (self.height - self.imgView.height) / 2.0f, self.imgView.width, self.imgView.height);
    
    self.contentView.autoLine.frame = CGRectMake(24.0f, self.height - 0.5, self.width - 24.0f, 0.5f);
}

- (void)loadDataWithModel:(id)model{
    if (!model || ![model isKindOfClass:[CRHProtocolListVo class]]) {
        return;
    }
    
    CRHProtocolListVo * vo = model;
    self.protocolNameLabel.text = vo.econtract_name;
    
    [self setNeedsLayout];
}

@end
