//
//  SingleBankView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/20.
//
//

#import "SingleBankView.h"

typedef enum :NSInteger{
    vertical,
    horizontal,

}DirectionType;

@interface SingleBankView ()

kRhPStrong UIImageView * picImgView;

kRhPStrong UIImage * img;

kRhPCopy NSString * bank;

kRhPAssign DirectionType  dirType;

@end

@implementation SingleBankView

- (instancetype)initHorizontalWithImg:(UIImage *) imgName withTitle:(NSString *)bankName{
    if (self = [super init]) {
        
        self.img = imgName;
        self.bank = bankName;
        self.dirType = horizontal;
        [self initSubview];
    }
    return self;
}

- (instancetype)initVerticalWithImg:(UIImage *) imgName withTitle:(NSString *)bankName{
    if (self = [super init]) {
        
        self.img = imgName;
        self.bank = bankName;
        self.dirType = vertical;

        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    self.picImgView = [[UIImageView alloc] initWithImage:self.img];
    [self addSubview:self.picImgView];
    
    self.nameLabel = [UILabel didBuildLabelWithText:self.bank font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self addSubview:self.nameLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    switch (self.dirType) {
        case horizontal:{
            self.picImgView.frame = CGRectMake(0, (self.height - self.picImgView.height)/2.0f, self.picImgView.width, self.picImgView.height);
            
            [self.nameLabel sizeToFit];
            self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.picImgView.frame) + 7.0f, (self.height - self.nameLabel.height )/2.0f, self.nameLabel.width, self.nameLabel.height);
        }break;
        
        case vertical:{
            self.picImgView.frame = CGRectMake((self.width - self.picImgView.width)/2.0f, 0, self.picImgView.width, self.picImgView.height);
            
            [self.nameLabel sizeToFit];
            self.nameLabel.frame = CGRectMake((self.width - self.nameLabel.width)/2.0f, CGRectGetMaxY(self.picImgView.frame) + 8.0f, self.nameLabel.width, self.nameLabel.height);
            
//            if (self.heightCallBack) {
//                NSMutableDictionary * param = [NSMutableDictionary dictionary];
//                [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.nameLabel.frame)] forKey:@"height"];
//                self.heightCallBack(param);
//            }
        }break;
            
        default:
            break;
    }
    

}

@end
