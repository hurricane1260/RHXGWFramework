//
//  IPOFiltDateView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/15.
//
//

#import "IPOFiltDateView.h"

@interface IPOFiltDateView ()

kRhPStrong UILabel * startDateLabel;

kRhPStrong UILabel * startDateValue;

kRhPStrong UILabel * endDateLabel;

kRhPStrong UILabel * endDateValue;

kRhPStrong UIButton * queryBtn;

kRhPAssign NSTimeInterval maxDate;

kRhPAssign NSTimeInterval minDate;
@end

@implementation IPOFiltDateView

#pragma mark ---------初始化
- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
        self.backgroundColor = color1_text_xgw;

    }
    return self;
}

- (void)initSubviews{
    
    _startDateLabel = [UILabel didBuildLabelWithText:@"起始日期" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:_startDateLabel];
    
    _endDateLabel = [UILabel didBuildLabelWithText:@"截止日期" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:_endDateLabel];
    
    _startDateValue = [UILabel didBuildLabelWithText:@"" font:font3_number_xgw textColor:color8_text_xgw wordWrap:NO];
    _startDateValue.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startClick)];
    [_startDateValue addGestureRecognizer:tap1];
    [self addSubview:_startDateValue];
    
    
    _endDateValue = [UILabel didBuildLabelWithText:@"" font:font3_number_xgw textColor:color8_text_xgw wordWrap:NO];
    _endDateValue.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endClick)];
    [_endDateValue addGestureRecognizer:tap2];
    [self addSubview:_endDateValue];
    
    _queryBtn = [UIButton didBuildB7_1ButtonWithTitle:@"查询"];
    [_queryBtn addTarget:self action:@selector(queryIPO) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_queryBtn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_startDateLabel sizeToFit];
    [_endDateLabel sizeToFit];
    [_startDateValue sizeToFit];
    [_endDateValue sizeToFit];
    
    _startDateLabel.frame = CGRectMake(margin_12, (self.height - _startDateLabel.height - _startDateValue.height )/2.0f, _startDateLabel.width, _startDateLabel.height);
    
     _endDateLabel.frame = CGRectMake(CGRectGetMaxX(_startDateLabel.frame) + 50.0f, _startDateLabel.y, _endDateLabel.width, _endDateLabel.height);

    _startDateValue.frame = CGRectMake(_startDateLabel.x, CGRectGetMaxY(_startDateLabel.frame), _startDateValue.width, _startDateValue.height);
    
    _endDateValue.frame = CGRectMake(_endDateLabel.x, _startDateValue.y, _endDateValue.width, _endDateValue.height);
    
    _queryBtn.x = self.width - margin_12 - _queryBtn.width;
    _queryBtn.y = (self.height - _queryBtn.height)/2.0f;
    
}


#pragma mark ------刷新
- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    _startDateValue.text = [_startDate yyyy_MM_ddFormat];
    [self setNeedsLayout];

}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    _endDateValue.text = [_endDate yyyy_MM_ddFormat];
    [self setNeedsLayout];

}

#pragma mark -----交互
- (void)startClick{
    if (self.startCallBack) {
        self.startCallBack();
    }
}

- (void)endClick{
    if (self.endCallBack) {
        self.endCallBack();
    }
}

//查询
- (void)queryIPO{
    if (self.queryBtnCallBack) {
        self.queryBtnCallBack();
    }
}


@end
