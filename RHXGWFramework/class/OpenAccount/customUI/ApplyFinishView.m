//
//  ApplyFinishView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/3.
//
//

#import "ApplyFinishView.h"

#import "RHCustomTableView.h"

@interface ApplyFinishView ()

kRhPStrong UIImageView * tagImgView;

kRhPStrong UILabel * resultLabel;

kRhPStrong UILabel * subStateLabel;

kRhPStrong UILabel * hintLabel;

kRhPStrong RHCustomTableView * tableView;

kRhPAssign TagType type;

kRhPStrong NSArray * dataArr;

kRhPStrong id resultData;
@end

@implementation ApplyFinishView

- (instancetype)initWithType:(TagType) type withData:(id)resultData{
    if (self = [super init]) {
        
        self.type = type;
        self.resultData = resultData;
//        switch (self.type) {
//            case applyingType:
//                [self initApplyingSubviews];
//
//                break;
//            case failType:
//                [self initFailSubviews];
//
//                break;
//            case successType:
//                [self initSuccessSubviews];
//
//                break;
//            default:
//                break;
//        }
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;

    switch (self.type) {
        case applyingType:
            self.tagImgView = [[UIImageView alloc] initWithImage:img_open_sucSubmit];

            break;
        case failType:
            self.tagImgView = [[UIImageView alloc] initWithImage:img_open_failPass];
            break;
        case successType:
            self.tagImgView = [[UIImageView alloc] initWithImage:img_open_sucPass];
            break;
        default:
            break;
    }
        [self addSubview:self.tagImgView];
    
    self.resultLabel = [UILabel didBuildLabelWithText:@"" font:font4_common_xgw textColor:color_rec_orange wordWrap:YES];
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.resultLabel];
    
    if (self.type == applyingType || self.type == failType) {
        self.subStateLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:YES];
        self.subStateLabel.numberOfLines = 0;
        [self addSubview: self.subStateLabel];
    }
    else if (self.type == successType){
        self.dataArr = self.resultData;
        self.tableView = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView loadSettingWithDataList:self.dataArr withHeight:50.0f withGapHeight:0.0f withCellName:@"ApplyResultCell" withCellID:@"applyCellId"];
        self.tableView.heightCallBack = ^(NSDictionary * param){
            if ([param objectForKey:@"height"]) {
                welf.tableView.height = [[param objectForKey:@"height"] floatValue];
                [welf setNeedsLayout];
            }
        };

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    
    }
    
    switch (self.type) {
        case applyingType:
            self.resultLabel.text = @"恭喜您\n您的开户申请已全部提交！";
            self.subStateLabel.text = @"我们将尽快完成申请资料的审核，审核后您将受到手机短信提示，请保持手机畅通。";
            break;
        case failType:{
            self.resultLabel.text = @"很抱歉\n您的开户申请未通过！";
            NSMutableString * subState = [NSMutableString string];
            if (self.resultData && [self.resultData isKindOfClass:[NSArray class]]) {
                NSArray * arr = self.resultData;
//                open_status状态位：证件照上传、基本资料提交、视频见证完成、协议已签署、账户设置、存管设置、暂未定义、风险问卷、回访设置、密码设置
                for (NSNumber * num in arr) {
                    switch ([num integerValue]) {
                        case 0:
                            [subState appendString:@"身份证照片不清晰 "];
                            break;
                        case 1:
                            [subState appendString:@"基本资料有误或营业部选择有误 "];
                            break;
                        case 2:
                            [subState appendString:@"视频不合格 "];
                            break;
//                        case 3:
//                            [subState appendString:@""];
//                            break;
                        case 4:
                            [subState appendString:@"账户选择错误，需要重新选择 "];
                            break;
                        case 5:
                            [subState appendString:@"三方存管有误 "];
                            break;
//                        case 6:
//                            [subState appendString:@""];
//                            break;
                        case 7:
                            [subState appendString:@"风险测评结果不合格 "];
                            break;
                        case 8:
                            [subState appendString:@"问卷回访不通过 "];
                            break;
                        case 9:
                            [subState appendString:@"密码格式不正确 "];
                            break;
                        default:
                            break;
                    }
                }
            }
            self.subStateLabel.text = [NSString stringWithFormat:@"原因如下：%@",subState];
    }break;
        case successType:
            self.resultLabel.text = @"恭喜您\n恭喜您已开户成功！";
            [self.tableView reloadData];
            [self.tableView reloadDataWithData:@[self.dataArr]];
            break;
        default:
            break;
    }
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"温馨提示：我公司收取的佣金在交易所规定的标准范围内，如需调整佣金或办理销户业务，请本人携带身份证到开户营业部办理！" font:font1_common_xgw textColor:color4_text_xgw wordWrap:YES];
    self.hintLabel.numberOfLines = 0;
    [self addSubview:self.hintLabel];
    
    [self addAutoLineWithColor:color16_other_xgw];
    
}

- (void)setErrorReason:(NSString *)errorReason{
    if (!errorReason || !errorReason.length) {
        return;
    }
    self.subStateLabel.text = errorReason;
    [self setNeedsLayout];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tagImgView.frame = CGRectMake((self.width - self.tagImgView.width)/2.0f, 40.0f, self.tagImgView.width, self.tagImgView.height);
    
    
    CGSize size = [self.resultLabel.text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font4_common_xgw} context:nil].size;
    self.resultLabel.frame = CGRectMake((self.width - size.width)/2.0f, CGRectGetMaxY(self.tagImgView.frame) + 14.0f, size.width, size.height);
    
    CGSize size1 = [self.subStateLabel.text boundingRectWithSize:CGSizeMake(self.width - 48.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1_common_xgw} context:nil].size;
    
    self.subStateLabel.frame = CGRectMake((self.width - size1.width)/2.0f, CGRectGetMaxY(self.resultLabel.frame) + 14.0f, size1.width, size1.height);
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.resultLabel.frame) + 40.0f, self.width, 250.0);
    
    CGFloat offsetY = 0;
    if (self.type == applyingType || self.type == failType) {
        offsetY = CGRectGetMaxY(self.subStateLabel.frame) + 40.0f;
    }
    else if(self.type == successType){
        offsetY = CGRectGetMaxY(self.tableView.frame);
    
    }
    
    self.autoLine.frame = CGRectMake(0, offsetY , self.width, 0.5f);
    
    CGSize size2 = [self.hintLabel.text boundingRectWithSize:CGSizeMake(self.width - 48.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1_common_xgw} context:nil].size;
    self.hintLabel.frame = CGRectMake(24.0f, CGRectGetMaxY(self.autoLine.frame) + 20.0f, size2.width, size2.height);
    
    if (self.heightCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.hintLabel.frame) + 20.0f] forKey:@"height"];
        self.heightCallBack(param);
    }
    
}
    


@end

