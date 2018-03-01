//
//  TradeItemizeListCell.m
//  stockscontest
//
//  Created by rxhui on 15/9/24.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeItemizeListCell.h"

@interface TradeItemizeListCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *accessoryImageView;

@property (nonatomic, strong) UIView *line;

@end

@implementation TradeItemizeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setTitleString:(NSString *)aString {
    if (_titleString) {
        _titleString = nil;
    }
    _titleString = aString.copy;
    self.titleLabel.text = nil;
    self.titleLabel.text = _titleString;
    [self setNeedsLayout];
}

- (void)initSubviews {
//    self.titleLabel = [UILabel didBuildLabelWithText:@"" fontSize:16.0f textColor:color2_text_xgw wordWrap:NO];
    self.titleLabel = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:self.titleLabel];
    
    self.accessoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_wsy_jt_nor"]];
    [self.contentView addSubview:self.accessoryImageView];
    
    self.line = [[UIView alloc]init];
    [self.contentView addSubview:self.line];
    self.line.backgroundColor = color16_other_xgw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.x = 15.0f;
    self.titleLabel.y = (self.height - self.titleLabel.height) * 0.5f;
    
    self.accessoryImageView.size = self.accessoryImageView.image.size;
    self.accessoryImageView.x = self.width - self.accessoryImageView.width - 15.0f;
    self.accessoryImageView.y = (self.height - self.accessoryImageView.height) * 0.5f;
    
    self.line.size = CGSizeMake(self.width, 0.5f);
    self.line.y = self.height - 0.5f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
