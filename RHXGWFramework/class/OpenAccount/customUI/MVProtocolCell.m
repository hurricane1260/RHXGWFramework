//
//  MVProtocolCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/22.
//
//

#import "MVProtocolCell.h"

@interface MVProtocolCell ()



@end

@implementation MVProtocolCell

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
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
