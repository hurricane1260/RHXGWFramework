//
//  PersonInfoPickView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import "PersonInfoPickView.h"
#import "PersonInfoVo.h"

@interface PersonInfoPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

kRhPStrong UIView * bottomView;

kRhPStrong UIPickerView * pickerView;

kRhPStrong UIButton * selectButton;

kRhPStrong UIButton * cancelButton;

@end

@implementation PersonInfoPickView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = color_black_alpha;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = color1_text_xgw;
    [self addSubview:self.bottomView];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator=YES;
    [self.bottomView addSubview:self.pickerView];
    
    self.selectButton = [UIButton didBuildButtonWithTitle:@"完成" normalTitleColor:color6_text_xgw highlightTitleColor:color6_text_xgw disabledTitleColor:color6_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    self.selectButton.titleLabel.font = font2_common_xgw;
    [self.selectButton addTarget:self action:@selector(surePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.selectButton];
    
    self.cancelButton = [UIButton didBuildButtonWithTitle:@"取消" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    self.cancelButton.titleLabel.font = font2_common_xgw;
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.cancelButton];
    
    [self.bottomView addAutoLineWithColor:color16_other_xgw];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat topHeight = 43.0f;
    
    self.bottomView.frame = CGRectMake(0 , self.height - 259.0f, self.width, 259.0f);
    
    self.cancelButton.frame = CGRectMake(24.0, (topHeight - self.cancelButton.height)/2.0f, 50.0f, 30.0f);
    
    self.selectButton.frame = CGRectMake(self.width - 24.0f - self.selectButton.width, self.cancelButton.y, 50.0f, 30.0f);

    self.bottomView.autoLine.frame = CGRectMake(0, topHeight - 0.5f, self.bottomView.width, 0.5f);
    
    self.pickerView.frame = CGRectMake(0 , CGRectGetMaxY(self.bottomView.autoLine.frame), self.width, 216.0f);
    
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.pickerView reloadAllComponents];
    [self setNeedsLayout];

}


#pragma  mark -------delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArr.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PersonInfoVo * vo = [self.dataArr objectAtIndex:row];
    return vo.dict_prompt;
}

- (void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:                               (NSInteger)component{
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
        pickerLabel.minimumFontSize = 8.;
        pickerLabel.minimumScaleFactor = 1.5;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    [pickerLabel sizeToFit];
    return pickerLabel;
}

- (void)surePressed:(id)sender
{
    NSInteger row =[self.pickerView selectedRowInComponent:0];
    PersonInfoVo * vo = [self.dataArr objectAtIndex:row];
    
    if (self.selectCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:vo forKey:@"select"];
        self.selectCallBack(param);
    }
}

- (void)cancelPressed:(id)sender{
    if (self.selectCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        self.selectCallBack(param);
    }
}

@end
