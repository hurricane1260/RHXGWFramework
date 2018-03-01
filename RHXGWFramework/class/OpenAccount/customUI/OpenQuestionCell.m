//
//  OpenQuestionCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/22.
//
//

#import "OpenQuestionCell.h"

#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+RHJX_Inc.h"
#import "MVOpenQuestionVo.h"
#import "RHLabelAttributeTool.h"

@interface OpenQuestionCell ()

kRhPStrong UIView * headView;

kRhPStrong TTTAttributedLabel * questionLabel;

kRhPStrong UIButton * showBtn;

kRhPStrong UIView * bottomView;

kRhPStrong TTTAttributedLabel * answerLabel;

kRhPStrong RHLabelAttributeTool * tool;



kRhPAssign NSInteger row;

kRhPAssign CGFloat bHeight;
@end

@implementation OpenQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)  reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.tool = [[RHLabelAttributeTool alloc] init];
        self.isShow = NO;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.headView = [[UIView alloc] init];
    [self.contentView addSubview:self.headView];
    
    self.questionLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.questionLabel.numberOfLines = 0;
    [self.headView addSubview:self.questionLabel];
    
    self.showBtn = [UIButton didBuildButtonWithNormalImage:img_open_down highlightImage:img_open_down];
    [self.showBtn addTarget:self action:@selector(showAnswer) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:self.showBtn];
    
    [self.headView addAutoLineWithColor:color16_other_xgw];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.hidden = YES;
    [self.contentView addSubview:self.bottomView];
    
    self.answerLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.answerLabel.numberOfLines = 0;
    [self.bottomView addSubview:self.answerLabel];
    
    [self.bottomView addAutoLineWithColor:color16_other_xgw];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetX = 12.0f;
    CGFloat topHeight = 50.0f;
    
    self.headView.frame = CGRectMake(0, 0, self.width, topHeight);
    
    NSAttributedString * attStr = [self.tool getAttribute:self.questionLabel.text withParagraphStyleSpace:[NSNumber numberWithFloat:7.0f] withFont:font2_common_xgw];
    
    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:attStr withConstraints:CGSizeMake(self.width - offsetX - topHeight, MAXFLOAT) limitedToNumberOfLines:0];
    
    if (size.height + 28.0f > self.headView.height) {
        self.headView.height = size.height + 28.0f;
        self.questionLabel.frame = CGRectMake(offsetX, 14.0f, size.width, size.height);
        self.showBtn.frame = CGRectMake(self.width - topHeight, (self.headView.height - self.showBtn.height)/2.0f, topHeight, topHeight);
    }
    else{
        self.questionLabel.frame = CGRectMake(offsetX, (self.headView.height - size.height)/2.0f, size.width, size.height);
        self.showBtn.frame = CGRectMake(self.width - topHeight, 0, topHeight, topHeight);
    }
    
    self.headView.autoLine.frame = CGRectMake(24.0f, self.headView.height - 0.5f, self.headView.width - 48.0f, 0.5f);
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame), self.width, 50.0f);
    
    NSAttributedString * attStr1 = [self.tool getAttribute:self.answerLabel.text withParagraphStyleSpace:[NSNumber numberWithFloat:8.0f] withFont:font1_common_xgw];
    CGSize size1 = [TTTAttributedLabel sizeThatFitsAttributedString:attStr1 withConstraints:CGSizeMake(self.width - offsetX * 2.0f, MAXFLOAT) limitedToNumberOfLines:0];
    self.answerLabel.frame = CGRectMake(offsetX, 14.0f, size1.width, size1.height);
    self.bottomView.height = CGRectGetMaxY(self.answerLabel.frame) + 14.0f;
    
    self.bottomView.autoLine.frame = CGRectMake(0, self.bottomView.height - 0.5f, self.bottomView.width, 0.5f);
    
}

- (void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row{
    if (!model || ![model isKindOfClass:[MVOpenQuestionVo class]]) {
        return;
    }
    self.questionLabel.attributedText = nil;
    self.answerLabel.attributedText = nil;

    self.row = row;
    MVOpenQuestionVo * vo = model;
    NSAttributedString * attStr = [self.tool getAttribute:vo.question withParagraphStyleSpace:[NSNumber numberWithFloat:7.0f] withFont:font2_common_xgw];
    self.questionLabel.attributedText = attStr;
    
     CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:attStr withConstraints:CGSizeMake(MAIN_SCREEN_WIDTH - 12.0f - 50.0f, MAXFLOAT) limitedToNumberOfLines:0];
    
    
    NSAttributedString * attStr1 = [self.tool getAttribute:vo.answer withParagraphStyleSpace:[NSNumber numberWithFloat:8.0f] withFont:font1_common_xgw];
    self.answerLabel.attributedText = attStr1;

    [self setNeedsLayout];
    
    if (size.height + 28.0f > self.headView.height) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:size.height + 28.0f] forKey:@"height"];
        [param setObject:[NSNumber numberWithInteger:row] forKey:@"row"];

        self.showCallBack(param);
    }

}

- (void)showAnswer{
    self.isShow = !self.isShow;
    
    if (self.bottomView.height != 0) {
        self.bHeight = self.bottomView.height;
    }
    if (!self.isShow) {
        self.bottomView.height = 0;
    }
    else{
        self.bottomView.height = self.bHeight;
    }

    
    self.bottomView.hidden = !self.isShow;
    [UIView animateWithDuration:0.35 animations:^{
        self.showBtn.imageView.transform = CGAffineTransformRotate(self.showBtn.imageView.transform, M_PI);
    }];
    NSLog(@"-------------bottom hidden %d",!self.isShow);
    [self setNeedsLayout];
    
   
    
    if (self.showCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if (self.isShow) {
            [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.bottomView.frame)] forKey:@"height"];
        }
        else{
            [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.headView.frame)] forKey:@"height"];
        }
        [param setObject:[NSNumber numberWithInteger:self.row] forKey:@"row"];
        self.showCallBack(param);
    }

}

@end
