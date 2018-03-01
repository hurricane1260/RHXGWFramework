//
//  CRHRiskTableViewCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/27.
//
//

#import "CRHRiskTableViewCell.h"
#import "CRHTestSelectView.h"
#import "CRHRiskTestVo.h"
#import "CRHSelContentVo.h"

#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+RHJX_Inc.h"

@interface CRHRiskTableViewCell ()

kRhPStrong TTTAttributedLabel * titleLabel;



@end

@implementation CRHRiskTableViewCell

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.titleLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
 
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:self.titleLabel.attributedText withConstraints:CGSizeMake(self.width - 20.0f, MAXFLOAT) limitedToNumberOfLines:0];
    self.titleLabel.frame = CGRectMake(10.0f, 10.0f, size.width, size.height);
    

}


- (void)setItemData:(id)itemData{
    if (!itemData || ![itemData isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    CRHRiskTestVo * vo = itemData;
    self.titleLabel.text = vo.question_content;
    NSArray * arr = vo.answer_content;
    for (int i = 0; i < arr.count; i++) {
        NSDictionary * dic = arr[i];
        CRHSelContentVo * answerVo = [[CRHSelContentVo alloc] init];
        
    }

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
