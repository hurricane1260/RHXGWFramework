//
//  CRHReVisitTableViewCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/27.
//
//

#import "CRHReVisitTableViewCell.h"
#import "CRHTestSelectView.h"

@interface CRHReVisitTableViewCell ()

kRhPStrong UILabel * titleLabel;



@end

@implementation CRHReVisitTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    

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
