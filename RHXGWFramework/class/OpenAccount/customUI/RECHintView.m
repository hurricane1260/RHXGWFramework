//
//  RECHintView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/29.
//
//

#import "RECHintView.h"
#import "RECMicAndCamView.h"
#import "IdBankWifiView.h"

@interface RECHintView ()

kRhPStrong UILabel * titleLabel;

kRhPStrong UIImageView * cameraImgView;

kRhPStrong RECMicAndCamView * micView;

kRhPStrong RECMicAndCamView * camView;

kRhPStrong IdBankWifiView * lightView;

kRhPStrong IdBankWifiView * faceView;

kRhPStrong IdBankWifiView * quietView;

kRhPStrong UIView * sepView;

@end

@implementation RECHintView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;

    self.titleLabel = [UILabel didBuildLabelWithText:@"您将和华创证券客服人员进行视频通话，客服人员将对您进行身份确认" font:font3_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.cameraImgView = [[UIImageView alloc] initWithImage:img_open_camera];
    [self addSubview:self.cameraImgView];
    
    self.micView = [[RECMicAndCamView alloc] initWithImg:img_open_microphone withTitle:@"麦克风"];
    self.micView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.micView.height = [[param objectForKey:@"height"] floatValue];
            [welf setNeedsLayout];
        }
        if ([param objectForKey:@"width"]) {
            welf.micView.width = [[param objectForKey:@"width"] floatValue];
            [welf setNeedsLayout];
        }
    };

    [self addSubview:self.micView];
    
    self.camView = [[RECMicAndCamView alloc] initWithImg:img_open_photo withTitle:@"相机"];
    self.camView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.camView.height = [[param objectForKey:@"height"] floatValue];
            [welf setNeedsLayout];
        }
//        if ([param objectForKey:@"width"]) {
//            welf.camView.width = [[param objectForKey:@"width"] floatValue];
//            [welf setNeedsLayout];
//        }
    };
    [self addSubview:self.camView];
    
    NSArray * imgA = @[img_open_light,img_open_face,img_open_volume];
    NSArray * titleA = @[@"光线明亮",@"勿遮挡面部",@"周围安静"];
    self.lightView = [[IdBankWifiView alloc] initWithImgArr:imgA withTitleArr:titleA];
    [self addSubview:self.lightView];
    
    self.sepView = [self.lightView addAutoLineViewWithColor:color16_other_xgw];
    
    [self.lightView addAutoLineViewWithColor:color16_other_xgw];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [self.titleLabel sizeToFit];
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.width - 48.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font3_common_xgw} context:nil].size;
    self.titleLabel.frame = CGRectMake(24.0f, 0, size.width, size.height);
    
    self.cameraImgView.frame = CGRectMake((self.width - self.cameraImgView.width)/2.0f, CGRectGetMaxY(self.titleLabel.frame) + 33.0f, self.cameraImgView.width, self.cameraImgView.height);
    
    self.micView.frame = CGRectMake((self.width - self.micView.width)/2.0f, CGRectGetMaxY(self.cameraImgView.frame) + 24.0f, self.micView.width, self.micView.height);
    
    self.camView.frame = CGRectMake(self.micView.x, CGRectGetMaxY(self.micView.frame) + 14.0f, self.camView.width, self.camView.height);
    
    self.lightView.frame = CGRectMake(0, CGRectGetMaxY(self.camView.frame) + 24.0f, self.width, 50.0f);
    
    self.sepView.frame = CGRectMake(self.width / 3.0f, 0, 0.5f ,self.lightView.height);
    
    self.lightView.autoLine.frame = CGRectMake(self.width * 2.0f / 3.0f, 0, 0.5f ,self.lightView.height);
    
    if (self.heightCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.lightView.frame)] forKey:@"height"];
        self.heightCallBack(param);
    }
}

@end
