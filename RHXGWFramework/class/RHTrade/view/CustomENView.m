//
//  CustomENView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/4/25.
//
//

#import "CustomENView.h"
#import "UserLogoView.h"
@interface CustomENView ()
@property (nonatomic,strong) UserLogoView * logoImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIImage * logoImage;
@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * workHours;

@end

@implementation CustomENView
-(instancetype)initWithImageName:(NSString *)imageName name:(NSString *)name workHours:(NSString *)workHours{
    if (self = [super init]) {
        [self initSubView];
        self.logoImage = [UIImage imageNamed:imageName];
        self.imageName = imageName;
        self.name = name;
        self.workHours = workHours;
    }
    return  self;
}
-(instancetype)init{
    if (self = [super init]) {
        [self initSubView];
    }
    return  self;

}
-(void)initSubView{
    self.logoImageView = [[UserLogoView alloc]init];
    self.logoImageView.roundLogo = NO;

    [self addSubview:self.logoImageView];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = color3_text_xgw;
    self.nameLabel.font = font3_common_xgw;
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = color4_text_xgw;
    self.timeLabel.font = font1_common_xgw;
    [self addSubview:self.timeLabel];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.logoImageView.size = CGSizeMake(self.logoImage.size.width, self.logoImage.size.height);
    self.logoImageView.center = CGPointMake(self.frame.size.width/2, 25+self.logoImage.size.height/2);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.center = CGPointMake(self.frame.size.width/2, CGRectGetMaxY(self.logoImageView.frame)+self.nameLabel.size.height/2+10);
    [self.timeLabel sizeToFit];
    self.timeLabel.center = CGPointMake(self.frame.size.width/2, CGRectGetMaxY(self.nameLabel.frame)+self.timeLabel.size.height/2);
    self.logoImageView.logoUrl = self.imageName;
    self.nameLabel.text = self.name;
    self.timeLabel.text = self.workHours;
}

@end
